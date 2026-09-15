/**
 * agent-harness — Runtime Tool Call Validation Extension
 *
 * Re-exports AgentHarness class from agent-harness.ts.
 * The default export registers pi event handlers using AgentHarness.
 *
 * @packageDocumentation
 */

import type { ExtensionAPI, ToolCallEventResult } from "@earendil-works/pi-coding-agent";
import { AgentHarness } from "./agent-harness.ts";
import { loadProjectConfig } from "./lib/load-config.ts";
export { AgentHarness, getBashSubKey } from "./agent-harness.ts";
export type { ToolCallResult } from "./agent-harness.ts";
export type { ResolvedHarnessRules } from "./agent-harness.ts";
export { loadProjectConfig } from "./lib/load-config.ts";

// ── Extension entry point ──

export default function agentHarness(pi: ExtensionAPI): void {
	let harness = new AgentHarness();

	// Session start: initialize fresh state and load project config
	pi.on("session_start", (_event, ctx) => {
		// Replace both state and rules before loading; failures cannot retain old overrides.
		harness = new AgentHarness();
		try {
			harness.setRules(loadProjectConfig(ctx, ctx.cwd));
		} catch (error) {
			const message = `agent-harness: using default rules — ${error instanceof Error ? error.message : String(error)}`;
			if (ctx.hasUI) ctx.ui.notify(message, "warning");
			else console.error(message);
		}
	});

	// Turn start: increment session turn, reset cascade counter, decay error tracker
	pi.on("turn_start", () => {
		harness.handleTurnStart();
	});

	pi.on("tool_execution_end", (event) => {
		harness.handleToolExecutionEnd(event);
	});

	// Old read output may no longer be in the active context.
	pi.on("session_compact", () => harness.reset());
	pi.on("session_tree", () => harness.reset());

	// Tool_call handler
	pi.on("tool_call", (event, ctx): ToolCallEventResult | void => {
		return harness.handleToolCall(event, ctx, pi.getActiveTools()) ?? undefined;
	});
}