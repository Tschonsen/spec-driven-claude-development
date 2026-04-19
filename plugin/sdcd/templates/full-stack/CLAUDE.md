# {{project_name}} — project rules

This project follows **Spec-Driven Claude Development (SDCD)**. Core rules live at `~/.claude/CLAUDE.md`; procedural detail at `~/.claude/methodology.md`.

## State hygiene tier

- **Tier:** Larger (§1.5), often upgrading to Milestone-driven.
- **Files:** `design/CURRENT_STATE.md` + `design/ARCHITECTURE.md`.
- Upgrade to Milestone-driven (`SESSION_HISTORY.md` + `AUDIT_LOG.md`) when shipping releases.

## Stack

- **Backend language:** <Python / Node / Go / Rust / …>
- **Backend framework:** <fill>
- **Frontend framework:** <React / Vue / Svelte / HTMX / …>
- **Storage:** <fill — forces DATA_PLAN>
- **Auth:** <fill>
- **Deployment:** <monorepo deploy / split front+back / static FE + API>

## Applicable plans

All five — full-stack projects hit every planning layer:

- `design/UR_PLAN.md`
- `design/DATA_PLAN.md`
- `design/BACKEND_PLAN.md`
- `design/DESIGN_SYSTEM.md`
- `design/FRONTEND_PLAN.md`

## Project-specific rules

- **Repo layout decision logged.** Monorepo vs split repos is a day-one decision; record in `ARCHITECTURE.md`.
- **API contract is the coupling point.** Frontend and backend agree on the contract document; changes to it trigger both plans' open-question lists.

## Brain files

Per §1.6, brain files sit next to every source file across both frontend and backend.
