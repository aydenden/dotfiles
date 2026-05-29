# Basics
Respond in Korean.

# Agent Models
Main: Opus only. Sub-agents/teammates: `"model": "sonnet"`. Simple exploration: `"model": "haiku"`.

# Code Principles

## Design
- SOLID: single responsibility — propose splitting when responsibilities are mixed. Invert dependencies via interfaces.
- Law of Demeter: avoid deep chaining; wrap with a delegation method. Fluent APIs / builders / iterator chains are exempt.
- GoF: consider Strategy when branching proliferates, Factory for complex creation, State for state transitions — don't force on simple match/dict dispatch (YAGNI).
- Domain: DDD (Evans). Isolate external systems (DB/API/UI) with Port/Adapter.
- Dependency direction: outer→inner (Clean Architecture). Domain must never import infrastructure.

## Quality
KISS·DRY. Speculative generality is forbidden, but known failure modes, boundary conditions, and necessary extension points / Ports must not be skipped. Intention-revealing naming, functions do one thing only (Clean Code).
Before modifying, consult Refactoring catalog (Fowler). Code over comments.
Env/state/logging: 12-Factor App. Stability: consider Circuit Breaker/Bulkhead.
Testing: TDD + Test Pyramid (unit > integration > E2E).
**Never leave broken tests behind.** When source changes break tests, analyze the root cause and fix every failing test before committing. Treating failures as "pre-existing" is forbidden — broken tests destroy regression detection.
Error handling: fail-fast. No empty except/catch. Only catch exceptions at external boundaries (API/DB/user input).

## Comments
Docstrings required: module, class, public function — describe role, params, return.
Inline comments only for non-obvious *why* (workarounds, non-trivial rationale) — never restate what code shows. Prefer naming and structure.
Section dividers allowed: `# --- Section Name ---` only.

# Knowledge Vault
Path: `~/dev/Knowledge Repository/Knowledge Repository` (via additionalDirectories).
Search rule: frontmatter (summary/tags) scan first → then Read matched notes only.
Query triggers — search vault when:
- Evaluating a new tool, library, or MCP server
- Choosing between architecture patterns (A vs B)
- Same approach failed 2× and need alternatives

# SSoT
When a new term, constant, or design concept appears, check the SSoT location list in the project CLAUDE.md first.
If no location is defined, stop and propose an SSoT location before proceeding.
Never define inline or duplicate without approval.
If the project CLAUDE.md has no SSoT location list, warn the user and recommend creating one (~/.claude/templates/project-claude-ssot.md).

# Git Convention
Conventional Commits format, Korean body allowed. Commit per logical change.
Format: `type(scope): summary` — type: feat, fix, refactor, test, docs, chore.

# Tool Selection
| Goal | Tool |
|------|------|
| Code search (semantic / many candidates) | `probe search_code` → `extract_code` |
| Package overview (large handoff) | `repomix pack_codebase --compress` |
Exact strings → `rg` first. `probe` over Grep→Read for semantic search. Single shell/test/build → `Bash(run_in_background)`. URL fetch → `WebFetch`. Large-output analysis → context-mode hook auto-routes.

# Long-Running Commands
Commands >2min: use `Bash(run_in_background: true)` once → wait for completion notification. Never re-run because output isn't visible — check `ps aux | grep` first. Before killing duplicates, check progress and preserve the most advanced process.

# Behavior
Before implementation, list the scope that can be completed.
Do not start beyond scope. Never fake completion with comments, hardcoding, or stubs.
Crystallize repeated patterns: 3+ manual repetitions → extract into skill or script.
