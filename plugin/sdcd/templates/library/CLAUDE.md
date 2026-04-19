# {{project_name}} — project rules

This project follows **Spec-Driven Claude Development (SDCD)**. Core rules live at `~/.claude/CLAUDE.md`; procedural detail at `~/.claude/methodology.md`.

## State hygiene tier

- **Tier:** Serious project (§1.5) — libraries start small, often stay manageable.
- **Files:** `design/CURRENT_STATE.md`.
- Upgrade to Larger (add `ARCHITECTURE.md`) once public surface exceeds ~10–15 modules.

## Stack

- **Language:** {{stack}}
- **Public API shape:** <functions / classes / traits / types — fill when first designed>
- **Distribution target:** <pypi / npm / crates.io / maven central / …>
- **Test framework:** <pytest / jest / cargo test / …>
- **Docs:** <sphinx / typedoc / rustdoc / built-in / …>

## Applicable plans

- `design/UR_PLAN.md` (always)
- `design/DATA_PLAN.md` — skip unless the library manages persistent state (most don't).
- `design/BACKEND_PLAN.md` — for libraries, this is the **public API contract** plan; keep it.
- `design/FRONTEND_PLAN.md` — skip (no UI).
- `design/DESIGN_SYSTEM.md` — skip.

## Library-specific rules

- **Semantic versioning is non-negotiable.** Every public-API change is assessed: patch / minor / major.
- **Changelog is part of the release.** `CHANGELOG.md` updated before tagging.
- **Deprecation policy stated in CLAUDE.md.** Decide now: soft-deprecate for one minor, or hard-break at major?

## Brain files

Per §1.6, every source file gets a `.brain` sibling. For libraries, brain files are especially valuable — external readers (other Claude sessions, users exploring the source) benefit directly.
