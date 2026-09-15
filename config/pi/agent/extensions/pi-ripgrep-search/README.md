# Pi Local Ripgrep Search

Based @agentcastle/ripgrep-search

**Fast code search tool for Pi — literal text and regex, natively respects `.gitignore`.** Returns structured human-readable summaries with top-N results, file counts, and truncation info.

## Features

- **`ripgrep_search` tool** — Search codebase by literal text or regex pattern
  - Default 10 matches per file, configurable via `max_count`
  - Structured summary output showing top-N results with file counts and truncation indicator
  - One result row per matching line, not per occurrence
  - Respects `.gitignore` natively when ripgrep is available
- **No result cache** — every call re-runs the CLI so results always reflect the current tree. The tool description steers the LLM toward semantic search and AST/LSP tools for behavior and structure discovery
- **Bounded output** — Raw output capped at 2 MiB, summary capped below the built-in 50 KB / 2000-line tool limit; omitted results saved to a temp file, cleaned up at session shutdown
- **Configurable backend** — `searchBackend` in `.pi/settings.json`, see [Configuration](#configuration-optional)
- **Backend indicator** — Injects current search backend into system prompt so LLM knows which tool is active
- **TUI rendering** — Compact inline result display with match counts, truncation status, and clickable file paths via OSC 8 `file://` hyperlinks
- **Mode-aware rendering** — Automatically adapts output for TUI (rich, themed), JSON, RPC, and print modes; non-TUI modes pass raw text through without theme formatting or OSC 8 escape sequences

## How it works

1. The LLM calls `ripgrep_search` with a query and optional directory/max_count
2. The extension validates the query is non-empty, resolves the directory (traversal check, leading `@` stripped), and selects the backend (ripgrep or grep)
3. The backend runs through a bounded child process: 2 MiB output cap, 30 s timeout, abort-signal aware. Raw output over the cap fails with narrowing guidance instead of allocating unbounded memory
4. Results are parsed (one row per matching line, all matched files counted) into a summary showing top-N results, unique file count, and truncation status
5. Summaries are capped at 48 KB / 1900 lines (reserving room for notices); when anything is omitted, the full raw output is saved to a temp file with its path in the response. Temp files are cleaned up at session shutdown

## Usage

The LLM uses `ripgrep_search` automatically. Example invocations the LLM might make:

```
ripgrep_search(query="TODO", directory="src")
ripgrep_search(query="console\\.log", directory=".", max_count=20)
ripgrep_search(query="magic.number.42", directory=".")
```

### Configuration (optional)

In `.pi/settings.json` (read only when the project is trusted):

```json
{
	"ripgrepSearch": {
		"searchBackend": "auto",
		"maxLineLength": 200
	}
}
```

- `searchBackend`: `"auto"` (try ripgrep, fallback to grep), `"ripgrep"` (require), or `"grep"` (skip detection)
- `maxLineLength`: Cap line length in results (default 200)

## Requirements

- Pi Coding Agent
- ripgrep recommended (`rg` on PATH — install via `apt`, `brew`, or `choco`)
- Falls back to system `grep` if ripgrep unavailable

## ripgrep Availability Detection

The extension detects `rg` at startup in two stages:

1. **PATH scan** — walks `process.env.PATH` with `accessSync` (zero-overhead, no subprocess)
2. **Spawn fallback** — runs `rg --version` via subprocess (3 s timeout, last resort)

If neither succeeds, the extension falls back to system `grep`. Only PATH-resolved binaries are used: an `rg` that exists outside PATH is never invoked, because that is what the search would actually execute.

## Details

### Architecture

Dual-backend search engine with unified output format:

```
├── index.ts     # Entry: tool registration, backend resolution, execute, renderers
├── internal.ts  # Query validation, mode tracking, temp directory lifecycle
├── config.ts    # Load SearchConfig from .pi/settings.json, resolve backend, detect ripgrep on PATH
├── backends.ts  # Build + parse for each search backend: ripgrep and grep
└── types.ts     # RgMatch, RgResult, SearchConfig interfaces
```

Integration checks live in `config/pi/agent/extensions/check.mjs` at the repository root.

### Execution Flow

```mermaid
flowchart TD
    A[tool_call] --> B[validate: non-empty query]
    B -- invalid --> C[Throw Error]
    B -- valid --> D[verifyDirectory: resolve + traversal check]
    D --> E[resolveBackend]
    E --> F{backend?}
    F -- ripgrep --> G[buildRgArgs]
    F -- grep --> H[buildGrepArgs]
    G --> I[execFile rg, 2 MiB cap]
    H --> J[execFile grep, 2 MiB cap]
    I --> K[parseVimgrepOutput]
    J --> L[parseGrepOutput]
    K --> M[buildStructuredSummary, 48 KB cap]
    L --> M
    M -- anything omitted --> N[Save full raw output to temp file]
    M --> O[Return {content, details}]
    N --> O
```

### Backend Resolution

| Config      | rg available | Backend      |
| ----------- | ------------ | ------------ |
| `"auto"`    | Yes          | ripgrep      |
| `"auto"`    | No           | grep         |
| `"ripgrep"` | Yes          | ripgrep      |
| `"ripgrep"` | No           | Error thrown |
| `"grep"`    | Any          | grep         |

`ripgrepAvailable()` implements the detection stages described above.

### Key Design Decisions

- **Line-number mode, not `--vimgrep`** — `--vimgrep` re-emits the entire line for every occurrence on that line, wasting output bytes. Plain `--line-number --column --with-filename` returns one row per matching line.
- **`-j1`** — Single thread keeps output buffering predictable.
- **2 MiB raw-output cap** — `execFile` `maxBuffer` (with SIGKILL) prevents unbounded memory growth on broad queries; the error tells the LLM to narrow the search.
- **48 KB / 1900-line summary cap** — Stays under the built-in 50 KB / 2000-line tool truncation limit so the truncation notice and temp-file path survive.
- **`--no-config`** — User rg config files cannot change flags or output format mid-session.
- **`-e query -- directory`** — The pattern is never confused with a flag; directories starting with `-` (e.g. `-scope/`) still work.
- **Grep fallback: `-rnHEI`** — Extended regex covers common rg patterns, `-I` skips binary files, and the excluded dirs (`.git`, `node_modules`, `venv`, `__pycache__`, `.mypy_cache`, `.pytest_cache`, `dist`, `build`, `cache`, `.cache`) prevent flooding from large cache files.
- **`@scope` prefix stripped** — Models sometimes emit `@` before paths; it is normalized away before resolution.
- **Query validation is minimal** — Only empty queries are rejected. `$` and `{` are valid regex syntax, so structural-search steering lives in the tool description, not a validator.
- **Cascade prevention** — `before_agent_start` injects the backend note into the system prompt describing active backend capabilities.

## External Contracts

Kept stable across the refactor and the 2026-09-14 bottleneck pass.

| Contract                                                   | Type            | References                                       |
| ---------------------------------------------------------- | --------------- | ------------------------------------------------ |
| Tool name `ripgrep_search`                                 | Agent tool name | Agent `.md` files, system prompt                 |
| Parameters: `query`, `directory`, `max_count`              | Tool params     | Inline in extension registration                 |
| Config key `search` in `.pi/settings.json`                 | Config          | `loadSearchConfig()`                             |
| Output format `{ total_returned, total_files, results[] }` | Tool result     | All consumers                                    |
| `--exclude-dir` list for grep fallback                     | Internal        | `buildGrepArgs()`                                |
| `--max-columns`, `--max-count`, `--line-number --column`   | Internal        | `buildRgArgs()` (`--vimgrep` removed 2026-09-14) |

## Error Handling

| Error Scenario                     | Handling                                                              |
| ---------------------------------- | --------------------------------------------------------------------- |
| Invalid query (empty/whitespace)   | Return `isError: true` with descriptive message                       |
| Directory not found                | Return `isError: true` with directory listing fallback                |
| rg/grep exit code 1 (no matches)   | Return empty results, success                                         |
| rg/grep exit code 2+ (error)       | Return `isError: true` with stderr, tool-missing detection            |
| Raw output exceeds 2 MiB buffer    | Fail with narrowing guidance; nothing over the cap is buffered        |
| Parsed rows > 500 or summary > cap | Truncated summary + full raw output saved to temp file, path returned |

## Best Practices Compliance

| Rule                                     | Status | Notes                                                      |
| ---------------------------------------- | ------ | ---------------------------------------------------------- |
| No `any` on API boundaries               | ✅     | Clean                                                      |
| `details` uses `Record<string, unknown>` | ✅     | Clean                                                      |
| State encapsulated in closure            | ✅     | `rgAvailable`, `searchConfig` inside closure               |
| Explicit return type annotations         | ✅     | `: void` on default export                                 |
| No sync I/O at module init               | ✅     | `readFileSync` deferred to `session_start`                 |
| AbortSignal for spawn timeout            | ✅     | Uses `execFile` with `signal`; `maxBuffer` caps raw output |
| Child process `error` events handled     | ✅     | `execFile` rejects; errors mapped to search error text     |
| `catch` uses `instanceof Error`          | ✅     | Uses `err as { code?: string }` pattern                    |
| `import()` not `require()`               | ✅     | ESM                                                        |
| No circular imports                      | ✅     | Dependency graph is a DAG                                  |
| C10: `.ts` extension on local imports    | ✅     | All imports use `.ts`                                      |

## History

This extension was refactored from an 806-line monolith (`.pi/extensions/ripgrep-search.ts`) into the directory module above; the original PRD carried the migration plan, anti-pattern audit, and per-file breakdowns. That work completed, and the 2026-09-14 bottleneck pass (no result cache, bounded output, line-number mode) superseded parts of it. The PRD was merged into this README; the migration plan itself is obsolete and was dropped.