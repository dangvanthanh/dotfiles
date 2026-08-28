---
name: eli5
description: Use when the user wants to understand something — "explain X", "what is X", "how does this work", "walk me through this project/codebase", "ELI5", "I don't get it", or a confused follow-up to a previous answer. Symptoms you need it — you're about to enumerate every variant/operator/edge case of a topic in one answer, or to explain a whole codebase at full resolution in one pass.
argument-hint: "what to explain (optionally: --literal-5yo)"
---

# ELI5 — explain simply

Audience: a sharp person from a different domain. Simplify the packaging, never the facts. With `--literal-5yo`, use everyday analogies only, zero code.

The failure this skill prevents is the complete answer: everything you know about the topic, at full resolution, in one pass. Completeness is what makes explanations unreadable — the reader needed a foothold and got a survey. Depth is delivered by descent, not by volume.

## Voice — both modes

- A term of art gets one plain-words clause at first use, or gets cut. Don't lean on adjacent knowledge the reader may not have (explaining Flow via RxJava explains nothing to someone who knows neither).
- Concrete beats abstract: "Room re-runs your query when the table changes", not "the invalidation tracker triggers re-emission".
- Walk, don't sprint: one new idea per step, and let each land before the next. A numbered walk-through at learning pace beats a compressed paragraph that's technically complete.
- End by naming 2–3 deeper branches the reader can pick from. That offer is what makes the length budget safe — nothing is lost, it's just not all _now_.

## Concept mode — a term, mechanism, or API

Budget: ~200 words before the descent offer.

1. The problem it solves, in one everyday sentence — an analogy if a good one exists (flag where it breaks if that would bite).
2. The default behavior — the one thing to remember.
3. One concrete example.
4. Descent offer.

One well-chosen variant beats the full taxonomy. If you catch yourself writing the third bullet of operators or edge cases, you're writing the reference manual, not the explanation.

## System mode — a codebase, architecture, or service

Explore first, silently — read the code/docs (Codegraph, IDE index, Explore agents) before simplifying anything; a fluent simplification of unread code is confidently wrong. Don't narrate the exploration.

Budget: one screen — under ~450 words — before the descent offer.

1. One-sentence pitch: what it does, for whom.
2. The 3–5 big blocks, plain-named ("the part that talks to New Relic"), one job each.
3. One journey: a single request/run/click traced end to end through the blocks. One trace teaches more than a component inventory.
4. The weird bits: the THREE decisions that would most surprise a newcomer, each with its one-line why. Everything conventional goes unmentioned; the surprises that didn't make the cut become descent branches. Selection, not compression, is what keeps this section short.
5. A small mermaid diagram of the blocks and arrows, names matching the prose.

Cite files/ADRs as a short reading list at the end, never inline — not even as parenthetical ADR/file refs inside the weird bits' why-lines. Inline citations turn an explanation into documentation.

On "go deeper": descend into ONE block at the same discipline, don't re-show the whole map at higher resolution.