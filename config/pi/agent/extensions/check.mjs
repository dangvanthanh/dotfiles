// Run with Node 26 and Pi installed globally. No additional dependencies.
import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import { mkdtempSync, mkdirSync, readFileSync, realpathSync, rmSync, writeFileSync } from "node:fs";
import { registerHooks } from "node:module";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { pathToFileURL } from "node:url";
import { test } from "node:test";

const piEntry = realpathSync(execFileSync("which", ["pi"], { encoding: "utf8" }).trim());
registerHooks({
	resolve(specifier, context, next) {
		if (specifier.startsWith("@earendil-works/") || specifier === "typebox") {
			return next(specifier, { ...context, parentURL: pathToFileURL(piEntry).href });
		}
		return next(specifier, context);
	},
});
const { default: search } = await import("./pi-ripgrep-search/index.ts");
const { default: harness } = await import("./agent-harness/index.ts");
const { default: footer } = await import("./pi-footer/index.ts");
const { execCommand } = await import(pathToFileURL(join(dirname(piEntry), "../core/exec.js")));

function setup(t, extension) {
	const cwd = realpathSync(mkdtempSync(join(tmpdir(), "pi-extension-check-")));
	const handlers = new Map();
	const tools = new Map();
	const ctx = {
		cwd,
		mode: "tui",
		hasUI: true,
		isProjectTrusted: () => true,
		ui: { notify() {} },
	};
	extension({
		on(name, handler) {
			const list = handlers.get(name) ?? [];
			list.push(handler);
			handlers.set(name, list);
		},
		registerTool(tool) {
			tools.set(tool.name, tool);
		},
		getActiveTools: () => ["read", "bash", "ripgrep_search"],
		getThinkingLevel: () => "high",
		exec: (command, args, options) => execCommand(command, args, cwd, options),
	});
	const fire = async (name, event = {}) => {
		let result;
		for (const handler of handlers.get(name) ?? []) result = (await handler(event, ctx)) ?? result;
		return result;
	};
	t.after(async () => {
		await fire("session_shutdown");
		rmSync(cwd, { recursive: true, force: true });
	});
	return { cwd, ctx, handlers, fire, tools };
}

async function searchSetup(t, backend = "ripgrep") {
	const h = setup(t, search);
	mkdirSync(join(h.cwd, ".pi"));
	writeFileSync(
		join(h.cwd, ".pi/settings.json"),
		JSON.stringify({ search: { searchBackend: backend } }),
	);
	await h.fire("session_start");
	h.run = (query, options = {}, signal) =>
		h.tools
			.get("ripgrep_search")
			.execute("search", { query, ...options }, signal, undefined, h.ctx);
	return h;
}

for (const backend of ["ripgrep", "grep"]) {
	test(`${backend}: repeated searches reflect edits and changed limits`, async (t) => {
		const h = await searchSetup(t, backend);
		writeFileSync(join(h.cwd, "sample.txt"), "needle old\nneedle two\nneedle three\n");
		await h.run("needle", { max_count: 1 });
		const more = await h.run("needle", { max_count: 3 });
		assert.equal(more.details.total_returned, 3);
		writeFileSync(join(h.cwd, "sample.txt"), "replacement\n");
		assert.equal((await h.run("needle")).details.total_returned, 0);
	});

	test(`${backend}: undisplayed matches are recoverable`, async (t) => {
		const h = await searchSetup(t, backend);
		for (let n = 0; n < 12; n++) writeFileSync(join(h.cwd, `${n}.txt`), "needle\n");
		const result = await h.run("needle");
		assert.equal(result.details.truncated, true);
		assert.ok(result.details.fullOutputPath, "omitted matches need a readable output file");
		assert.equal(readFileSync(result.details.fullOutputPath, "utf8").trim().split("\n").length, 12);
	});
}

test("search accepts regex anchors and quantifiers", async (t) => {
	const h = await searchSetup(t);
	writeFileSync(join(h.cwd, "sample.txt"), "aaa\n");
	assert.equal((await h.run("^a{3}$")).details.total_returned, 1);
});

test("ripgrep returns one row per matching line, not per occurrence", async (t) => {
	const h = await searchSetup(t);
	writeFileSync(join(h.cwd, "sample.txt"), "needle needle needle\n");
	assert.equal((await h.run("needle")).details.total_returned, 1);
});

test("search backend prompt remains stable across user prompts", async (t) => {
	const h = await searchSetup(t);
	const event = {
		systemPrompt: "base",
		systemPromptOptions: { selectedTools: ["ripgrep_search"] },
	};
	assert.deepEqual(
		await h.fire("before_agent_start", event),
		await h.fire("before_agent_start", event),
	);
});

test("search fails rather than allocating unbounded output", async (t) => {
	const h = await searchSetup(t, "grep");
	writeFileSync(join(h.cwd, "large.txt"), "needle".repeat(600_000));
	await assert.rejects(h.run("needle"), /output.*limit|narrow|scope/i);
});

test("search respects cancellation before spawning", async (t) => {
	const h = await searchSetup(t);
	writeFileSync(join(h.cwd, "sample.txt"), "needle\n");
	await assert.rejects(h.run("needle", {}, AbortSignal.abort()), /abort|cancel/i);
});

test("search hyperlinks use the working directory, without doubling the search scope", async (t) => {
	const h = await searchSetup(t);
	mkdirSync(join(h.cwd, "src"));
	writeFileSync(join(h.cwd, "src/sample.txt"), "needle\n");
	const result = await h.run("needle", { directory: "src" });
	const theme = { fg: (_color, text) => text, bold: (text) => text };
	const component = h.tools
		.get("ripgrep_search")
		.renderResult(result, { expanded: true }, theme, {});
	assert.ok(
		component
			.render(500)
			.join("\n")
			.includes(pathToFileURL(join(h.cwd, "src/sample.txt")).href),
	);
});

test("failed reads do not block retries; completed reads are deduplicated", async (t) => {
	const h = setup(t, harness);
	await h.fire("session_start");
	const call = { toolName: "read", input: { path: "file.txt" }, toolCallId: "read1" };
	assert.equal(await h.fire("tool_call", call), undefined);
	await h.fire("tool_execution_end", { ...call, args: call.input, isError: true });
	await h.fire("turn_start");
	assert.equal(await h.fire("tool_call", call), undefined);
	await h.fire("tool_execution_end", { ...call, args: call.input, isError: false });
	await h.fire("turn_start");
	assert.equal((await h.fire("tool_call", call))?.block, true);
});

test("bypassed mutations and bash scripts invalidate read markers", async (t) => {
	const h = setup(t, harness);
	await h.fire("session_start");
	const read = { toolName: "read", input: { path: "file.txt" } };
	for (const mutation of [
		{ toolName: "write", input: { path: "file.txt", _harness: { force: true } } },
		{ toolName: "bash", input: { command: "python update.py" } },
	]) {
		await h.fire("tool_call", read);
		await h.fire("tool_execution_end", { toolName: "read", args: read.input, isError: false });
		await h.fire("turn_start");
		await h.fire("tool_call", mutation);
		await h.fire("tool_execution_end", {
			toolName: mutation.toolName,
			args: mutation.input,
			isError: false,
		});
		assert.equal(await h.fire("tool_call", read), undefined);
	}
});

test("footer redraws do not repeatedly traverse unchanged session history", async (t) => {
	const h = setup(t, footer);
	let scans = 0;
	let component;
	let leaf = "1";
	const usage = { input: 10, output: 20, cost: { total: 0.01 } };
	h.ctx.sessionManager = {
		getLeafId: () => leaf,
		getBranch: () => {
			scans++;
			return [
				{ type: "message", message: { role: "assistant", usage } },
				{
					type: "message",
					message: { role: "toolResult", usage: { input: 2, output: 3, cost: { total: 0.004 } } },
				},
				{ type: "compaction", usage: { input: 5, output: 7, cost: { total: 0.02 } } },
			];
		},
	};
	h.ctx.getContextUsage = () => undefined;
	h.ctx.ui.setFooter = (factory) => {
		component = factory(
			{ requestRender() {} },
			{ fg: (_color, text) => text },
			{ onBranchChange: () => () => {}, getGitBranch: () => "main" },
		);
	};
	await h.fire("session_start");
	for (let n = 0; n < 100; n++) component.render(160);
	assert.equal(scans, 1);
	assert.match(component.render(160).join(""), /↑17.*↓30.*\$0\.034/);
	leaf = "2";
	usage.input = 30;
	assert.match(component.render(160).join(""), /↑37/);
	assert.equal(scans, 2);
});

for (const event of ["session_compact", "session_tree"]) {
	test(`${event} permits reads whose prior output left the context`, async (t) => {
		const h = setup(t, harness);
		await h.fire("session_start");
		await h.fire("tool_execution_end", {
			toolName: "read",
			args: { path: "a.txt" },
			isError: false,
		});
		await h.fire("turn_start");
		await h.fire(event);
		assert.equal(
			await h.fire("tool_call", { toolName: "read", input: { path: "a.txt" } }),
			undefined,
		);
	});
}

test("harness does not redirect to an unavailable tool", async (t) => {
	const h = setup(t, (pi) => harness({ ...pi, getActiveTools: () => ["bash"] }));
	await h.fire("session_start");
	assert.equal(
		await h.fire("tool_call", { toolName: "bash", input: { command: "rg needle" } }),
		undefined,
	);
});

test("large summaries stay below the context limit and count all matched files", async (t) => {
	const h = await searchSetup(t, "grep");
	for (let n = 0; n < 510; n++)
		writeFileSync(join(h.cwd, `${n}.txt`), `needle ${"a".repeat(600)}\n`);
	const result = await h.run("needle", { max_count: 500 });
	assert.equal(result.details.total_returned, 510);
	assert.equal(result.details.unique_files, 510);
	assert.ok(Buffer.byteLength(result.content[0].text) <= 50 * 1024);
	assert.ok(result.details.fullOutputPath);
});

test("untrusted search settings cannot enable grep's broader scan", async (t) => {
	const h = await searchSetup(t, "grep");
	h.ctx.isProjectTrusted = () => false;
	await h.fire("session_start");
	writeFileSync(join(h.cwd, "sample.txt"), "needle\n");
	assert.equal((await h.run("needle")).details.searcher, "ripgrep");
});

test("search distinguishes missing binaries from no matches", async (t) => {
	const h = await searchSetup(t, "grep");
	const path = process.env.PATH;
	try {
		process.env.PATH = h.cwd;
		await assert.rejects(h.run("needle"), /ENOENT|not found|failed/i);
	} finally {
		process.env.PATH = path;
	}
});

test("grep fallback supports anchors/quantifiers and @-prefixed scopes", async (t) => {
	const h = await searchSetup(t, "grep");
	mkdirSync(join(h.cwd, "src"));
	writeFileSync(join(h.cwd, "src/sample.txt"), "aaa\n");
	assert.equal((await h.run("^a{3}$", { directory: "@src" })).details.total_returned, 1);
});

test("search preserves gitignore, hidden files, and argument separation", async (t) => {
	const h = await searchSetup(t);
	mkdirSync(join(h.cwd, ".git"));
	writeFileSync(join(h.cwd, ".gitignore"), "ignored.txt\n");
	writeFileSync(join(h.cwd, "ignored.txt"), "needle\n");
	writeFileSync(join(h.cwd, ".hidden.txt"), "needle\n");
	writeFileSync(join(h.cwd, ".git/private"), "needle\n");
	assert.equal((await h.run("needle")).details.total_returned, 1);
	mkdirSync(join(h.cwd, "-scope"));
	writeFileSync(join(h.cwd, "-scope/sample.txt"), "-needle\n");
	assert.equal((await h.run("-needle", { directory: "-scope" })).details.total_returned, 1);
	await assert.rejects(h.run("needle", { directory: ".." }), /outside project/);
	await assert.rejects(h.run("["), /regex|pattern/i);
});

test("harness read markers remain bounded during large audits", async (t) => {
	const h = setup(t, harness);
	await h.fire("session_start");
	for (let n = 0; n < 1000; n++) {
		await h.fire("tool_execution_end", {
			toolName: "read",
			args: { path: `${n}.txt` },
			isError: false,
		});
	}
	await h.fire("turn_start");
	assert.equal(
		await h.fire("tool_call", { toolName: "read", input: { path: "0.txt" } }),
		undefined,
	);
	assert.equal(
		(await h.fire("tool_call", { toolName: "read", input: { path: "999.txt" } }))?.block,
		true,
	);
});