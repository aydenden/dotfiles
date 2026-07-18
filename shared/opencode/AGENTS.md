# Basics
Respond in Korean.

# Agent Models
Main: use OpenAI `openai/gpt-5.5` for conversation, planning, and architectural judgment.
Sub-agents/teammates: use OpenCode Go models configured in `~/.config/opencode/opencode.json`.
Simple exploration: prefer read-only or low-cost subagents such as `explorer` or `fast-worker`.
Do not use Anthropic/Claude models unless the user explicitly asks.

# Code Principles

## Design
- SOLID: Propose splitting when a class has 2+ responsibilities. Invert dependencies via interfaces.
- Law of Demeter: Max 1 level of chaining. Wrap `a.b().c()` with a delegation method.
- GoF triggers: 3+ conditional branches -> Strategy, complex creation -> Factory, state transitions -> State.
- Domain: DDD (Evans). Isolate external systems (DB/API/UI) with Port/Adapter.
- Dependency direction: outer -> inner (Clean Architecture). Domain must never import infrastructure.

## Quality
KISS, DRY, YAGNI. Use intention-revealing names and functions that do one thing only.
Before modifying, consult Refactoring catalog (Fowler). Prefer code over comments.
Env/state/logging: 12-Factor App. Stability: consider Circuit Breaker/Bulkhead.
Testing: TDD + Test Pyramid (unit > integration > E2E).
Never leave broken tests behind. When source changes break tests, analyze the root cause and fix every failing test before committing. Treating failures as pre-existing is forbidden.
Error handling: fail-fast. No empty except/catch. Only catch exceptions at external boundaries (API/DB/user input).

## Comments
Docstrings required: module, class, public function. Describe role, params, return.
No inline comments. Solve with naming and structure.
Section dividers allowed: `# --- Section Name ---` only.

# Knowledge Vault
Path: `~/dev/Knowledge Repository/Knowledge Repository`.
Search rule: frontmatter (summary/tags) scan first, then read matched notes only.
Query triggers: search vault when evaluating a new tool/library/MCP server, choosing architecture patterns, or when the same approach failed twice and alternatives are needed.

# SSoT
When a new term, constant, or design concept appears, check the SSoT location list in the project `AGENTS.md` first.
If no location is defined, stop and propose an SSoT location before proceeding.
Never define inline or duplicate without approval.
If the project has no SSoT location list, warn the user and recommend creating one.

# Git Convention
Conventional Commits format, Korean body allowed. Commit per logical change.
Format: `type(scope): summary` where type is `feat`, `fix`, `refactor`, `test`, `docs`, or `chore`.

# Tool Selection
| Goal | Tool |
|------|------|
| Code search | `probe search_code` -> `extract_code` |
| Package overview | `repomix pack_codebase --compress` |
| Short shell commands | Bash |
| Script / test / build execution | `batch_execute` |
| URL fetch | `fetch_and_index` |
| File analysis | `execute_file` |

Prefer `probe search_code` over Grep -> Read chains when the MCP tooling is available.

# Long-Running Commands
Commands over 2 minutes: run once in background, wait for completion notification, and do not rerun because output is not visible. Check running processes before killing duplicates and preserve the most advanced process.

# Behavior
Before implementation, list the scope that can be completed.
Do not start beyond scope. Never fake completion with comments, hardcoding, or stubs.
Before file writes, verify existing content.
Never use `cd`; use tool working directories or absolute paths.
Crystallize repeated patterns: 3+ manual repetitions -> extract into skill or script.
