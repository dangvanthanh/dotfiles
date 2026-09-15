import type { RgMatch, RgResult } from "./types.ts";

/** One row per matching line. --vimgrep duplicates the entire line per occurrence. */
export function buildRgArgs(
	query: string,
	directory: string,
	maxCount: number,
	maxLineLength: number = 200,
): { command: string; args: string[] } {
	return {
		command: "rg",
		args: [
			"--no-config",
			"--line-number",
			"--column",
			"--with-filename",
			"--color=never",
			`--max-columns=${maxLineLength}`,
			`--max-count=${maxCount}`,
			"--no-heading",
			"-j1",
			"--hidden",
			"--glob",
			"!.git/**",
			"-e",
			query,
			"--",
			directory,
		],
	};
}

/** Grep has no gitignore support or column offsets. ERE covers common rg patterns. */
export function buildGrepArgs(
	query: string,
	directory: string,
	maxCount: number,
): { command: string; args: string[] } {
	const excludedDirs = [
		".git",
		"node_modules",
		"venv",
		"__pycache__",
		".mypy_cache",
		".pytest_cache",
		"dist",
		"build",
		"cache",
		".cache",
	];
	return {
		command: "grep",
		args: [
			"-rnHEI",
			"-m",
			`${maxCount}`,
			"--color=never",
			...excludedDirs.map((dir) => `--exclude-dir=${dir}`),
			"-e",
			query,
			"--",
			directory,
		],
	};
}

function parseOutput(
	raw: string | null | undefined,
	maxResults: number,
	withColumn: boolean,
): RgResult {
	const results: RgMatch[] = [];
	const files = new Set<string>();
	let totalMatches = 0;
	const pattern = withColumn ? /^(.+?):(\d+):(\d+):(.*)$/ : /^(.+?):(\d+):(.*)$/;
	for (const line of (raw ?? "").split("\n")) {
		const match = line.match(pattern);
		if (!match) continue;
		totalMatches++;
		files.add(match[1]!);
		if (results.length < maxResults) {
			results.push({
				file: match[1]!,
				line: Number(match[2]),
				column: withColumn ? Number(match[3]) : 1,
				text: match[withColumn ? 4 : 3]!,
			});
		}
	}
	return {
		total_returned: totalMatches,
		total_files: files.size,
		results,
		truncated: totalMatches > maxResults,
	};
}

export function parseVimgrepOutput(
	raw: string | null | undefined,
	maxResults: number = Infinity,
): RgResult {
	return parseOutput(raw, maxResults, true);
}

export function parseGrepOutput(
	raw: string | null | undefined,
	maxResults: number = Infinity,
): RgResult {
	return parseOutput(raw, maxResults, false);
}