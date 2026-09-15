/**
 * Footer - shows only what matters.
 *
 * Left: input | output | reason | cost | usage token | speed
 * Right: provider model (thinking) • git:branch
 */

import type { AssistantMessage } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const fmt = (n: number) => {
	if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`;
	if (n >= 1000) return `${(n / 1000).toFixed(1)}k`;
	return `${n}`;
};

const levelColors: Record<string, string> = {
	off: "thinkingOff",
	minimal: "thinkingMinimal",
	low: "thinkingLow",
	medium: "thinkingMedium",
	high: "thinkingHigh",
	xhigh: "thinkingXhigh",
	max: "thinkingMax",
};

export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		if (ctx.mode !== "tui") return;

		let requestRender = () => {};
		let thinkingLevel = ctx.thinkingLevel ?? pi.getThinkingLevel();

		pi.on("thinking_level_select", async (event) => {
			thinkingLevel = event.level;
			requestRender();
		});

		let lastSpeed: number | null = null;
		let assistantStartTime: number | null = null;

		pi.on("message_start", async (event) => {
			if (event.message.role === "assistant") {
				assistantStartTime = Date.now();
			}
		});

		pi.on("message_end", async (event) => {
			if (event.message.role === "assistant") {
				const m = event.message as AssistantMessage;
				const outputTokens = m.usage.output;
				const elapsed = assistantStartTime ? (Date.now() - assistantStartTime) / 1000 : 0;

				if (elapsed > 0.5 && outputTokens > 0) {
					lastSpeed = Math.round(outputTokens / elapsed);
				}
				assistantStartTime = null;
			}
		});

		ctx.ui.setFooter((tui, theme, footer) => {
			let usageLeaf: string | null | undefined;
			let input = 0,
				output = 0,
				cost = 0,
				reasoning = 0;
			requestRender = () => tui.requestRender();
			const unsub = footer.onBranchChange(requestRender);

			return {
				dispose: unsub,
				invalidate() {},
				render(width: number): string[] {
					const leaf = ctx.sessionManager.getLeafId();
					// Streaming redraws do not change persisted usage. Recompute on a
					// new entry or tree navigation, not on every token/keystroke.
					if (usageLeaf !== leaf) {
						usageLeaf = leaf;
						input = output = cost = reasoning = 0;
						for (const e of ctx.sessionManager.getBranch()) {
							const usage =
								e.type === "compaction" || e.type === "branch_summary"
									? e.usage
									: e.type === "message" &&
										  (e.message.role === "assistant" || e.message.role === "toolResult")
										? e.message.usage
										: undefined;
							if (!usage) continue;
							input += usage.input;
							output += usage.output;
							cost += usage.cost.total;
							reasoning += usage.reasoningTokens ?? 0;
						}
					}

					const sep = ` ${theme.fg("dim", "│")} `;

					const contextUsage = ctx.getContextUsage();
					const ctxLimit = contextUsage?.limit ?? ctx.model?.contextWindow ?? 0;
					const ctxTokens = contextUsage?.tokens ?? 0;
					let contextPct = "";
					if (ctxLimit > 0) {
						const pct = (ctxTokens / ctxLimit) * 100;
						const color = pct > 80 ? "error" : pct > 50 ? "warning" : "success";
						contextPct = `${theme.fg(color, `${pct.toFixed(1)}%`)}${theme.fg("dim", `/${fmt(ctxLimit)}`)}`;
					}

					const branch = footer.getGitBranch();

					const arrowUp = `${theme.fg("success", "↑")}${theme.fg("text", fmt(input))}`;
					const arrowDown = `${theme.fg("error", "↓")}${theme.fg("text", fmt(output))}`;
					const reasoningStr =
						reasoning > 0 ? `${theme.fg("accent", "R")}${theme.fg("text", fmt(reasoning))}` : "";
					const costStr = theme.fg("warning", `$${cost.toFixed(3)}`);
					const speedStr = lastSpeed !== null ? theme.fg("mdLink", `~${fmt(lastSpeed)} t/s`) : "";

					const model = ctx.model;
					const modelStr = theme.fg(
						"accent",
						model ? model.id.split("/").pop() || model.id : "no-model",
					);
					const providerStr = model?.provider ? theme.fg("muted", model.provider) : "";
					const levelColor = levelColors[thinkingLevel] || "accent";
					const levelStr = theme.fg(levelColor, `(${thinkingLevel})`);
					const gitStr = branch ? theme.fg("toolDiffAdded", ` ${branch}`) : "";

					const leftParts = [
						arrowUp,
						arrowDown,
						reasoningStr,
						costStr,
						contextPct,
						speedStr,
					].filter(Boolean);

					const rightParts = [
						providerStr ? `${providerStr} ${modelStr} ${levelStr}` : `${modelStr} ${levelStr}`,
						gitStr,
					].filter(Boolean);

					const right = rightParts.join(` ${theme.fg("dim", "•")} `);
					while (
						leftParts.length > 0 &&
						visibleWidth(leftParts.join(sep)) + visibleWidth(right) + 1 > width
					) {
						leftParts.pop();
					}
					const left = leftParts.join(sep);
					const pad = " ".repeat(Math.max(0, width - visibleWidth(left) - visibleWidth(right)));

					return [truncateToWidth(`${left}${pad}${right}`, width)];
				},
			};
		});
	});
}