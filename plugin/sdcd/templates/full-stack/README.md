# Full-stack project — SDCD template

Starter skeleton for a project with both a frontend and a backend (classic web app, internal tool, SaaS core).

## What this template gives you

- `CLAUDE.md` — Tier-Larger default, both FE and BE stack fields.
- `design/UR_PLAN.md` — full-stack Ur-Plan covering both ends.
- `design/CURRENT_STATE.md` — tier-Larger baseline, all 5 plans in the next-step list.
- `design/ARCHITECTURE.md` — monorepo-vs-split decision, BE + FE layer layouts.

## Assumed path

```
new-project → data-plan → backend-plan → design-system-plan → frontend-plan → audit → implementation
```

The full SDCD pipeline. If any layer doesn't apply, declare it in `UR_PLAN.md §Non-goals`.

## Placeholders

`{{project_name}}`, `{{stack}}`, `{{today}}` substituted by `/sdcd:new-project`.
