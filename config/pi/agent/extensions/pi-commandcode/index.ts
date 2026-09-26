import type {
	ExtensionAPI,
	ProviderModelConfig,
} from "@earendil-works/pi-coding-agent";
import { metadata, type ModelMetadata } from "./metadata.ts";

const THINKING_LEVELS = [
	"minimal",
	"low",
	"medium",
	"high",
	"xhigh",
	"max",
] as const;
const BASE_URL = "https://api.commandcode.ai/provider";
const OPENAI_BASE_URL = `${BASE_URL}/v1`;
type CatalogModel = {
	id: string;
	name?: string;
	contextWindow: number;
};

type ThinkingLevelMap = NonNullable<ProviderModelConfig["thinkingLevelMap"]>;

function parseCatalogModel(value: unknown): CatalogModel {
	if (
		!value ||
		typeof value !== "object" ||
		!("id" in value) ||
		typeof value.id !== "string" ||
		!value.id.trim() ||
		!("context_length" in value) ||
		typeof value.context_length !== "number" ||
		!Number.isSafeInteger(value.context_length) ||
		value.context_length <= 0
	) {
		throw new Error("Command Code returned invalid model metadata");
	}

	return {
		id: value.id,
		name:
			"name" in value && typeof value.name === "string"
				? value.name
				: undefined,
		contextWindow: value.context_length,
	};
}

function parseCatalog(value: unknown): CatalogModel[] {
	if (
		!value ||
		typeof value !== "object" ||
		!("data" in value) ||
		!Array.isArray(value.data) ||
		value.data.length === 0
	) {
		throw new Error("Command Code returned an empty or invalid model catalog");
	}
	return value.data.map(parseCatalogModel);
}

async function discoverModels(): Promise<CatalogModel[]> {
	// The catalog is public: never send credentials during discovery.
	const response = await fetch(`${OPENAI_BASE_URL}/models`, {
		signal: AbortSignal.timeout(10_000),
	});
	if (!response.ok) {
		throw new Error(
			`Command Code model discovery failed: HTTP ${response.status}`,
		);
	}
	return parseCatalog(await response.json());
}

function getMetadata(modelId: string): ModelMetadata | undefined {
	const modelMetadata = Object.hasOwn(metadata, modelId)
		? metadata[modelId]
		: undefined;
	if (!modelMetadata) {
		console.warn(
			`Command Code: ${modelId} has no metadata snapshot; costs are unknown (shown as zero).`,
		);
	}
	return modelMetadata;
}

function buildThinkingLevelMap(
	modelMetadata: ModelMetadata | undefined,
): ThinkingLevelMap {
	const efforts = modelMetadata?.efforts ?? [];
	const thinkingLevelMap: ThinkingLevelMap = {
		off: null,
		...Object.fromEntries(
			THINKING_LEVELS.map((level) => [
				level,
				efforts.includes(level) ? level : null,
			]),
		),
	};
	// No published effort controls: expose only the server's default reasoning.
	if (modelMetadata?.reasoning && efforts.length === 0) {
		thinkingLevelMap.high = "default";
	}
	return thinkingLevelMap;
}

function usesAnthropicApi(modelId: string): boolean {
	return modelId.startsWith("claude-");
}

function isDeepSeek(modelId: string): boolean {
	return modelId.startsWith("deepseek/");
}

function buildCompatibility(
	modelId: string,
	modelMetadata: ModelMetadata | undefined,
): ProviderModelConfig["compat"] {
	const supportsReasoningEffort = (modelMetadata?.efforts.length ?? 0) > 0;
	if (usesAnthropicApi(modelId)) {
		return {
			supportsEagerToolInputStreaming: false,
			forceAdaptiveThinking: supportsReasoningEffort,
		};
	}
	return {
		supportsStore: false,
		supportsDeveloperRole: false,
		supportsReasoningEffort,
		thinkingFormat: isDeepSeek(modelId) ? "deepseek" : "openai",
		supportsStrictMode: false,
		// Usage is always emitted; no stream_options opt-in is required.
		supportsUsageInStreaming: false,
		maxTokensField: "max_tokens",
	};
}

function maxOutputTokens(modelId: string, contextWindow: number): number {
	// ponytail: output limits are unpublished; DeepSeek accepts 384k (range [1, 393216]),
	// every other model's lowest published cap is 64k. Reasoning shares this budget.
	const providerLimit = isDeepSeek(modelId) ? 384_000 : 64_000;
	return Math.min(providerLimit, contextWindow);
}

function buildProviderModel(model: CatalogModel): ProviderModelConfig {
	const modelMetadata = getMetadata(model.id);
	const anthropicApi = usesAnthropicApi(model.id);

	return {
		id: model.id,
		name: model.name ?? model.id,
		api: anthropicApi ? "anthropic-messages" : "openai-completions",
		// Anthropic's SDK appends /v1/messages; OpenAI appends /chat/completions.
		baseUrl: anthropicApi ? BASE_URL : OPENAI_BASE_URL,
		contextWindow: model.contextWindow,
		maxTokens: maxOutputTokens(model.id, model.contextWindow),
		reasoning: modelMetadata?.reasoning ?? false,
		thinkingLevelMap: buildThinkingLevelMap(modelMetadata),
		input: modelMetadata?.vision ? ["text", "image"] : ["text"],
		cost: modelMetadata?.cost ?? {
			input: 0,
			output: 0,
			cacheRead: 0,
			cacheWrite: 0,
		},
		compat: buildCompatibility(model.id, modelMetadata),
	};
}

export default async function commandCode(pi: ExtensionAPI): Promise<void> {
	pi.registerProvider("commandcode", {
		name: "Command Code",
		baseUrl: OPENAI_BASE_URL,
		apiKey: "$COMMANDCODE_API_KEY",
		api: "openai-completions",
		authHeader: true,
		models: (await discoverModels()).map(buildProviderModel),
	});
}
