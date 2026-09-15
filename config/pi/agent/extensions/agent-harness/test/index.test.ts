import assert from "node:assert/strict";
import { mkdtempSync, mkdirSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { test, type TestContext } from "node:test";
import type {
	ExtensionAPI,
	ExtensionContext,
	ToolCallEventResult,
} from "@earendil-works/pi-coding-agent";
import agentHarness from "../index.ts";
import { CASCADE_THRESHOLD } from "../lib/harness-rules.ts";

function setup(t: TestContext) {
	const cwd = mkdtempSync(join(tmpdir(), "harness-entry-"));
	t.after(() => rmSync(cwd, { recursive: true, force: true }));
	mkdirSync(join(cwd, ".pi"));
	const warnings: string[] = [];
	const ctx = {
		cwd,
		hasUI: true,
		isProjectTrusted: () => true,
		sessionManager: {
			getCwd: () => {
				throw new Error("Use ctx.cwd");
			},
		},
		ui: { notify: (message: string) => warnings.push(message) },
	} as unknown as ExtensionContext;
	type Handler = (event: any, ctx: ExtensionContext) => ToolCallEventResult | void;
	const handlers = new Map<string, Handler>();
	agentHarness({
		getActiveTools: () => ["read", "bash", "ripgrep_search"],
		on: (name: string, handler: Handler) => {
			assert.ok(!handlers.has(name), `Duplicate handler: ${name}`);
			handlers.set(name, handler);
		},
	} as unknown as ExtensionAPI);
	const fire = (name: string, event = {}) => {
		const handler = handlers.get(name);
		assert.ok(handler, `Missing handler: ${name}`);
		return handler(event, ctx);
	};
	return {
		ctx,
		warnings,
		handlers,
		fire,
		config: (raw: string) => writeFileSync(join(cwd, ".pi", "harness-config.json"), raw),
		call: (toolName = "custom", input: Record<string, unknown> = {}) =>
			fire("tool_call", { toolName, input }),
	};
}

function expectThreshold(call: () => ToolCallEventResult | void, threshold: number) {
	for (let i = 1; i < threshold; i++) assert.equal(call(), undefined, `Call ${i}`);
	assert.equal(call()?.block, true);
}

test("registers lifecycle handlers and forwards allow/block decisions", (t) => {
	const h = setup(t);
	assert.ok(h.handlers.has("tool_execution_end"));
	h.fire("session_start");
	assert.equal(h.call("bash", { command: "echo hello" }), undefined);
	assert.match(h.call("bash", { command: "grep foo" })?.reason ?? "", /ripgrep_search/);
	assert.deepEqual(h.warnings, []);
});

test("loads configuration from ctx.cwd, not sessionManager or process.cwd", (t) => {
	const h = setup(t);
	h.config('{"cascadeThreshold":2}');
	h.fire("session_start");
	expectThreshold(h.call, 2);
	assert.deepEqual(h.warnings, []);
});

for (const reason of ["startup", "reload", "new", "resume", "fork"]) {
	test(`${reason} clears counters and read markers`, (t) => {
		const h = setup(t);
		h.fire("session_start");
		expectThreshold(h.call, CASCADE_THRESHOLD);
		assert.equal(h.call("read", { path: "a.ts" }), undefined);
		h.fire("tool_execution_end", { toolName: "read", args: { path: "a.ts" }, isError: false });
		h.fire("turn_start");
		assert.equal(h.call("read", { path: "a.ts" })?.block, true);
		h.fire("session_start", { reason });
		assert.equal(h.call("read", { path: "a.ts" }), undefined);
		expectThreshold(h.call, CASCADE_THRESHOLD);
	});
}

test("turn_start resets cascades without losing configured rules", (t) => {
	const h = setup(t);
	h.config('{"cascadeThreshold":2}');
	h.fire("session_start");
	expectThreshold(h.call, 2);
	h.fire("turn_start");
	expectThreshold(h.call, 2);
});

test("malformed reload drops old rules and warns through the UI", (t) => {
	const h = setup(t);
	h.config('{"cascadeThreshold":2}');
	h.fire("session_start");
	expectThreshold(h.call, 2);
	h.config("invalid json");
	h.fire("session_start", { reason: "reload" });
	expectThreshold(h.call, CASCADE_THRESHOLD);
	assert.equal(h.warnings.length, 1);
	assert.match(h.warnings[0], /using default rules.*Failed to parse/);
});

test("headless configuration failures go to stderr, including non-Error throws", (t) => {
	const h = setup(t);
	h.config("{}");
	h.ctx.hasUI = false;
	h.ctx.isProjectTrusted = () => {
		throw "trust unavailable";
	};
	const stderr = t.mock.method(console, "error", () => {});
	h.fire("session_start");
	expectThreshold(h.call, CASCADE_THRESHOLD);
	assert.deepEqual(h.warnings, []);
	assert.equal(stderr.mock.callCount(), 1);
	assert.match(stderr.mock.calls[0].arguments[0], /using default rules.*trust unavailable/);
});

test("untrusted configuration cannot retain previous overrides", (t) => {
	const h = setup(t);
	h.config('{"cascadeThreshold":2}');
	h.fire("session_start");
	h.ctx.isProjectTrusted = () => false;
	h.fire("session_start");
	expectThreshold(h.call, CASCADE_THRESHOLD);
	assert.match(h.warnings[0], /not trusted/);
});

test("tool input mutation and hasUI reach the harness", (t) => {
	const h = setup(t);
	const input = { command: "grep foo", _harness: { force: true } };
	assert.equal(h.call("bash", input), undefined);
	assert.ok(!("_harness" in input));
	h.ctx.hasUI = false;
	assert.equal(h.call("bash", { command: "grep foo # bypass-harness" })?.block, true);
});