import assert from "node:assert/strict";
import extension from "./index.ts";
import { metadata } from "./metadata.ts";

const originalFetch = globalThis.fetch;
let registered;
try {
	globalThis.fetch = async (url, options) => {
		assert.equal(url, "https://api.commandcode.ai/provider/v1/models");
		assert.ok(options.signal instanceof AbortSignal);
		assert.equal(options.headers, undefined);
		return Response.json({ data: [
			{ id: "claude-sonnet-4-6", name: "Claude Sonnet 4.6", context_length: 1000000 },
			{ id: "deepseek/deepseek-v4-flash", context_length: 1000000 },
		] });
	};
	await extension({ registerProvider(id, config) { registered = { id, ...config }; } });
	assert.equal(registered.id, "commandcode");
	assert.equal(registered.apiKey, "$COMMANDCODE_API_KEY");
	assert.equal(registered.models[0].api, "anthropic-messages");
	assert.equal(registered.models[0].baseUrl, "https://api.commandcode.ai/provider");
	assert.equal(registered.models[1].api, "openai-completions");
	assert.equal(registered.models[1].baseUrl, "https://api.commandcode.ai/provider/v1");
	assert.equal(registered.models[1].contextWindow, 1000000);
	assert.equal(registered.models[0].maxTokens, 64000);
	assert.equal(registered.models[1].maxTokens, 384000);
	assert.deepEqual(registered.models[0].input, ["text", "image"]);
	assert.equal(registered.models[0].compat.forceAdaptiveThinking, true);
	assert.equal(registered.models[0].cost.input, 3);
	assert.equal(registered.models[0].cost.cacheWrite, 3.75);
	assert.equal(registered.models[1].reasoning, true);
	assert.equal(registered.models[1].thinkingLevelMap.max, "max");
	assert.equal(registered.models[1].thinkingLevelMap.xhigh, null);
	assert.equal(registered.models[1].thinkingLevelMap.low, null);
	assert.equal(registered.models[1].compat.supportsReasoningEffort, true);
	assert.equal(registered.models[1].compat.thinkingFormat, "deepseek");
	assert.equal(registered.models[1].cost.input, 0.22);

	globalThis.fetch = async () => Response.json({ data: Object.keys(metadata).map(id => ({
		id, context_length: 1000000,
	})) });
	await extension({ registerProvider(id, config) { registered = { id, ...config }; } });
	assert.equal(registered.models.length, 77);
	for (const model of registered.models) {
		const info = metadata[model.id];
		assert.equal(model.reasoning, info.reasoning);
		assert.equal(model.input.includes("image"), info.vision);
		for (const level of ["minimal", "low", "medium", "high", "xhigh", "max"]) {
			const expected = info.efforts.includes(level) ? level :
				info.reasoning && !info.efforts.length && level === "high" ? "default" : null;
			assert.equal(model.thinkingLevelMap[level], expected, `${model.id}: ${level}`);
		}
		for (const rates of [model.cost, ...(model.cost.tiers ?? [])]) {
			for (const key of ["input", "output", "cacheRead", "cacheWrite"]) {
				assert.ok(Number.isFinite(rates[key]) && rates[key] >= 0, `${model.id}: ${key}`);
			}
		}
	}
	assert.equal(metadata["z-ai/glm-5.3-flashx"].cost.input, 0.37);
	assert.equal(metadata["MiniMaxAI/MiniMax-M3"].cost.input, 0.3);
	assert.equal(metadata["xiaomi/mimo-v2.5-pro"].cost.cacheRead, 0.0036);
	assert.equal(metadata["xiaomi/mimo-v2.6-pro-ultraspeed"].cost.output, 8.7);
	assert.equal(metadata["stepfun/step-5-preview"].cost.cacheRead, 0.05);
	assert.equal(metadata["xai/grok-4.7"].cost.input, 1.2);
	assert.equal(metadata["meituan/LongCat-2.0"].cost.output, 1.2);
	assert.equal(metadata["gpt-5.6-sol"].cost.tiers[0].inputTokensAbove, 272000);
	assert.equal(metadata["gpt-5.6-sol"].cost.tiers[0].input, 10);
	assert.equal(metadata["Qwen/Qwen3.7-Flash"].cost.tiers[0].inputTokensAbove, 32000);
	assert.equal(metadata["Qwen/Qwen3.7-Flash"].cost.tiers[1].inputTokensAbove, 256000);
	const originalWarn = console.warn;
	const warnings = [];
	try {
		console.warn = warning => warnings.push(warning);
		globalThis.fetch = async () => Response.json({ data: [{ id: "new-model", context_length: 10000 }] });
		await extension({ registerProvider(id, config) { registered = { id, ...config }; } });
		assert.equal(registered.models[0].reasoning, false);
		assert.deepEqual(registered.models[0].input, ["text"]);
		assert.equal(registered.models[0].cost.input, 0);
		assert.match(warnings[0], /new-model.*unknown/);
	} finally {
		console.warn = originalWarn;
	}
	for (const data of [[], [{}], [{ id: "x", context_length: -1 }]]) {
		globalThis.fetch = async () => Response.json({ data });
		await assert.rejects(() => extension({}), /catalog|metadata/);
	}
	globalThis.fetch = async () => new Response(null, { status: 503 });
	await assert.rejects(() => extension({}), /HTTP 503/);
	globalThis.fetch = async () => { throw new Error("timeout"); };
	await assert.rejects(() => extension({}), /timeout/);
	console.log("Command Code discovery, routing, pricing and effort checks passed (77 models)");
} finally {
	globalThis.fetch = originalFetch;
}
