import type { ExtensionMode } from "./types.ts";

let ctxMode: ExtensionMode | undefined;

export function setTestCtxMode(mode: ExtensionMode | undefined): void {
	ctxMode = mode;
}

export function getCtxMode(): ExtensionMode | undefined {
	return ctxMode;
}

// Syntax routing belongs in prompt guidance, not regex validation: $ and {
// are also valid regex syntax and ordinary text in configuration files.
export function validateQuery(query: string): string | null {
	return typeof query === "string" && query.trim() ? null : "Query must be a non-empty string";
}

export const trackedTempDirs = new Set<string>();

export function registerTempDir(dir: string): void {
	trackedTempDirs.add(dir);
}

export async function cleanupTrackedTempDirs(
	rmFn: (path: string, opts?: { recursive?: boolean; force?: boolean }) => Promise<void>,
): Promise<void> {
	for (const dir of trackedTempDirs) {
		await rmFn(dir, { recursive: true, force: true });
	}
	trackedTempDirs.clear();
}