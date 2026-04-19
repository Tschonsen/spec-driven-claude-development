# {{project_name}} — project rules

This project follows **Spec-Driven Claude Development (SDCD)**. Core rules live at `~/.claude/CLAUDE.md`; procedural detail at `~/.claude/methodology.md`. Project-specific extensions below.

## State hygiene tier

- **Tier:** Larger (§1.5) — web services usually cross ~10–15 files quickly.
- **Files:** `design/CURRENT_STATE.md` + `design/ARCHITECTURE.md`.
- Upgrade to Milestone-driven once releases / deploys enter the picture.

## Stack

- **Language:** {{stack}}
- **Framework:** <fill once decided>
- **Storage:** <fill once decided — forces a DATA_PLAN section>
- **Entry point:** <fill once the first source file exists>

## Applicable plans

- `design/UR_PLAN.md` (always)
- `design/DATA_PLAN.md` (persistent state is the norm for services)
- `design/BACKEND_PLAN.md` (always)
- `design/FRONTEND_PLAN.md` — only if this service has an admin UI / web console; declare here if not.
- `design/DESIGN_SYSTEM.md` — only if UI present.

## Project-specific rules

- (Add rules that only apply to this project.)

## Brain files

Per §1.6, every source file gets a `.brain` sibling. Skip for files under ~10 non-whitespace chars, generated code, or vendored code.
