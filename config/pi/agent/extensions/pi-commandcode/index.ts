import type { ExtensionAPI, ProviderModelConfig } from "@earendil-works/pi-coding-agent";
import { metadata } from "./metadata.ts";

const LEVELS = ["minimal", "low", "medium", "high", "xhigh", "max"] as const;

const BASE_URL = "https://api.commandcode.ai/provider";

export default async function (pi: ExtensionAPI) {
	// The catalog is public: never send credentials during discovery.
	const response = await fetch(`${BASE_URL}/v1/models`, {
		signal: AbortSignal.timeout(10_000),
	});
	if (!response.ok) {
		throw new Error(`Command Code model discovery failed: HTTP ${response.status}`);
	}
	const catalog = await response.json();
	if (!Array.isArray(catalog?.data) || catalog.data.length === 0) {
		throw new Error("Command Code returned an empty or invalid model catalog");
	}

	pi.registerProvider("commandcode", {
		name: "Command Code",
		baseUrl: `${BASE_URL}/v1`,
		apiKey: "$COMMANDCODE_API_KEY",
		api: "openai-completions",
		authHeader: true,
		models: catalog.data.map((model: unknown) => {
			if (
				!model ||
				typeof model !== "object" ||
				!("id" in model) ||
				typeof model.id !== "string" ||
				!model.id.trim() ||
				!("context_length" in model) ||
				typeof model.context_length !== "number" ||
				!Number.isSafeInteger(model.context_length) ||
				model.context_length <= 0
			) {
				throw new Error("Command Code returned invalid model metadata");
			}
			const claude = model.id.startsWith("claude-");
			const info = Object.hasOwn(metadata, model.id) ? metadata[model.id] : undefined;
			if (!info)
				console.warn(
					`Command Code: ${model.id} has no metadata snapshot; costs are unknown (shown as zero).`,
				);
			const efforts = info?.efforts ?? [];
			const thinkingLevelMap: ProviderModelConfig["thinkingLevelMap"] = {
				off: null,
				...Object.fromEntries(
					LEVELS.map((level) => [level, efforts.includes(level) ? level : null]),
				),
			};
			// No published effort controls: expose only the server's default reasoning.
			if (info?.reasoning && efforts.length === 0) {
				thinkingLevelMap.high = "default";
			}
			return {
				id: model.id,
				name: "name" in model && typeof model.name === "string" ? model.name : model.id,
				api: claude ? "anthropic-messages" : "openai-completions",
				// Anthropic's SDK appends /v1/messages; OpenAI appends /chat/completions.
				baseUrl: claude ? BASE_URL : `${BASE_URL}/v1`,
				contextWindow: model.context_length,
				// ponytail: output limits are unpublished; keep the conservative cap.
				maxTokens: Math.min(8192, model.context_length),
				reasoning: info?.reasoning ?? false,
				thinkingLevelMap,
				input: info?.vision ? ["text", "image"] : ["text"],
				cost: info?.cost ?? { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
				compat: claude
					? {
							supportsEagerToolInputStreaming: false,
							forceAdaptiveThinking: efforts.length > 0,
						}
					: {
							supportsStore: false,
							supportsDeveloperRole: false,
							supportsReasoningEffort: efforts.length > 0,
							thinkingFormat: model.id.startsWith("deepseek/") ? "deepseek" : "openai",
							supportsStrictMode: false,
							// Usage is always emitted; no stream_options opt-in is required.
							supportsUsageInStreaming: false,
							maxTokensField: "max_tokens",
						},
			};
		}),
	});
}