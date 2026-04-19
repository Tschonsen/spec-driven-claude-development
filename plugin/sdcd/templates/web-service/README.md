# Web-service project — SDCD template

Starter skeleton for a server-side HTTP / RPC service governed by SDCD.

## What this template gives you

- `CLAUDE.md` — project-level rules snippet, Tier-Larger default.
- `design/UR_PLAN.md` — web-service-specific Ur-Plan (auth model, deployment target, observability fields).
- `design/CURRENT_STATE.md` — baseline state file, tier-aware next-step list.
- `design/ARCHITECTURE.md` — file inventory + layer layout + decisions log.

## Assumed path

```
new-project → data-plan → backend-plan → audit → implementation
```

Services almost always have persistent state, so `data-plan` is on by default. If admin UI is in scope, the path extends: `… → design-system-plan → frontend-plan → audit`.

## Placeholders

`{{project_name}}`, `{{stack}}`, `{{today}}` substituted by `/sdcd:new-project`.
