# Basics
Respond in Korean.

# Agent Models
Main: Opus only. Sub-agents/teammates: `"model": "sonnet"`. Simple exploration: `"model": "haiku"`.

# Code Principles

## Design
- SOLID: Propose splitting when a class has 2+ responsibilities. Invert dependencies via interfaces.
- Law of Demeter: Max 1 level of chaining. Wrap `a.b().c()` with a delegation method.
- GoF triggers: 3+ conditional branches → Strategy, complex creation → Factory, state transitions → State.
- Domain: DDD (Evans). Isolate external systems (DB/API/UI) with Port/Adapter.
- Dependency direction: outer→inner (Clean Architecture). Domain must never import infrastructure.

## Quality
KISS·DRY·YAGNI. Intention-revealing naming, functions do one thing only (Clean Code).
Before modifying, consult Refactoring catalog (Fowler). Code over comments.
Env/state/logging: 12-Factor App. Stability: consider Circuit Breaker/Bulkhead.
Testing: TDD + Test Pyramid (unit > integration > E2E).
**Never leave broken tests behind.** When source changes break tests, analyze the root cause and fix every failing test before committing. Treating failures as "pre-existing" is forbidden — broken tests destroy regression detection.
Error handling: fail-fast. No empty except/catch. Only catch exceptions at external boundaries (API/DB/user input).

## Comments
Docstrings required: module, class, public function — describe role, params, return.
No inline comments: no `# reason` style. Solve with naming and structure.
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
| Code search | `probe search_code` → `extract_code` |
| Package overview | `repomix pack_codebase --compress` |
| Short shell commands (git, ls, ruff) | Bash |
| Script / test / build execution | `batch_execute` |
| URL fetch | `fetch_and_index` |
| File analysis (not Edit) | `execute_file` |
Prefer `probe search_code` over Grep→Read chains.

# Behavior
Before implementation, list the scope that can be completed.
Do not start beyond scope. Never fake completion with comments, hardcoding, or stubs.
Before any file write/overwrite, `cat <absolute-path>` to verify existing content. Never use `cd` — use absolute paths.
Crystallize repeated patterns: 3+ manual repetitions → extract into skill or script.
