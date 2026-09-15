# Writing code

Prefer the smallest clear, correct change that fully solves the task.

- Before editing, trace the affected flow. Check whether existing code, the standard
  library, native platform features, or installed dependencies already solve it.
- Build only what the task requires. Avoid speculative abstractions, flexibility,
  boilerplate, and unnecessary dependencies.
- Name literals whose meaning is not obvious at the call site. Do not create
  constants for self-explanatory values.
- For bug fixes, inspect callers of the function being changed. Fix the shared root
  cause and verify affected sibling paths, not just the reported symptom.
- Prefer deletion and reuse. Never sacrifice correctness, security, accessibility,
  or readability to reduce line count or diff size.
- Choose a simpler approach when it meets the same requirements. Make routine
  implementation decisions without asking for approval. Ask when ambiguity changes
  scope, user-visible behavior, or the risk of data loss.
- Comment on non-obvious intent or constraints, not what the code already says.
  Mark deliberate shortcuts with `ponytail:` and name the limit and upgrade path.
- Keep hand-written source files at 1,000 lines or fewer. Split by responsibility
  before exceeding the limit. Exclude generated files, lockfiles, and fixtures.
- Preserve unrelated changes. Do not expand the task into incidental cleanup.

# Tests and verification

- Follow the project's verification policy and reuse its existing tools.
- Add tests only when a failure would indicate broken behavior. Focus on observable
  outcomes, meaningful edge cases, and regressions rather than implementation details.
- Avoid assertions on incidental styling values, colors, or internal structure unless
  those details are explicitly part of the requirement.
- Run checks appropriate to the change, such as type checking, linting, a build,
  focused tests, or a manual check. Avoid redundant coverage and new test frameworks
  unless the task requires them.
- Report what you actually verified and any blockers. Tool availability is not proof
  that an operation works. Use a live check when asked whether something works.

# Writing style

- Be direct and concise. No em dashes, decorative prose, or unnecessary metaphors.
- Prefer literal wording: "a parameter worth varying," not "a dial worth turning";
  "still matters," not "earns its keep."
- State conclusions, relevant evidence, and remaining uncertainty. Do not narrate
  internal deliberation or repeat the plan at every step.
- Distinguish observed facts from assumptions. Do not present an inference as a
  verified result.