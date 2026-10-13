// check.mjs — mock-based sanity check for the metadata snapshot and model building.
// Run from anywhere: `node check.mjs` (Node >= 23.6 strips the .ts imports natively).
// Uses mock discovery data; makes no network calls.
import { metadata } from "./metadata.ts";

const SNAPSHOT_COUNT = 90;
const entryCount = Object.keys(metadata).length;
assert(entryCount === SNAPSHOT_COUNT, `snapshot has ${entryCount} entries, expected ${SNAPSHOT_COUNT}`);

// Mock discovery: Claude model + prefixed OpenAI model + an ID missing from the snapshot.
const mockCatalog = {
	data: [
		{ id: "claude-haiku-5-5", name: "Claude Haiku 5.5", context_length: 1000000, supported_endpoints: ["/messages"] },
		{
			id: "stealth/glyph-cluster:free",
			name: "Glyph Cluster",
			context_length: 256000,
			supported_endpoints: ["/chat/completions", "/responses"],
		},
		{ id: "unknown/new-model", name: "Unknown", context_length: 128000, supported_endpoints: ["/chat/completions"] },
	],
};
const realFetch = globalThis.fetch;
globalThis.fetch = async () => ({ ok: true, json: async () => mockCatalog });
try {
	const { default: commandCode } = await import("./index.ts");
	const registered = [];
	await commandCode({ registerProvider: (name, config) => registered.push([name, config]) });
	const [, provider] = registered[0];
	assert(registered.length === 1 && registered[0][0] === "commandcode", "registers the commandcode provider");
	const models = Object.fromEntries(provider.models.map((m) => [m.id, m]));

	const haiku = models["claude-haiku-5-5"];
	assert(haiku.api === "anthropic-messages", "haiku 5.5 uses the Anthropic Messages API");
	assert(haiku.reasoning === true && haiku.input.includes("image"), "haiku 5.5 reasons and takes image input");
	assert(
		haiku.thinkingLevelMap.high === "high" && haiku.thinkingLevelMap.off === null,
		"haiku 5.5 publishes effort levels",
	);
	assert(
		haiku.cost.input === 0.1 && haiku.cost.output === 0.5 && haiku.cost.cacheWrite === 0.125,
		"haiku 5.5 standard-band cost",
	);
	assert(
		haiku.cost.tiers?.length === 1 &&
			haiku.cost.tiers[0].inputTokensAbove === 100000 &&
			haiku.cost.tiers[0].input === 0.5 &&
			haiku.cost.tiers[0].output === 2.5,
		"haiku 5.5 >100K long-context tier",
	);

	const glyph = models["stealth/glyph-cluster:free"];
	assert(glyph.api === "openai-completions", "glyph cluster uses OpenAI Chat Completions");
	assert(glyph.reasoning === true && glyph.input.includes("image") === false, "glyph cluster is text-only reasoning");
	assert(glyph.cost.input === 0 && glyph.cost.output === 0, "glyph cluster costs zero");
	assert(
		glyph.thinkingLevelMap.medium === "medium" && glyph.thinkingLevelMap.xhigh === "xhigh",
		"glyph cluster publishes low/medium/high/xhigh",
	);

	const unknown = models["unknown/new-model"];
	assert(unknown.cost.input === 0 && unknown.reasoning === false, "unknown ID falls back to zero cost, no thinking");

	console.log(`check.mjs passed: ${entryCount} snapshot entries, ${provider.models.length} mock models verified.`);
} finally {
	globalThis.fetch = realFetch;
}

function assert(condition, label) {
	if (!condition) {
		console.error(`FAIL: ${label}`);
		process.exitCode = 1;
		process.exit(1);
	}
}
