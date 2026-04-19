# Library project — SDCD template

Starter skeleton for a reusable library governed by SDCD. The library template emphasises public-API contracts, semver discipline, and brain-file coverage (external readers benefit most).

## What this template gives you

- `CLAUDE.md` — project-level rules snippet, library-specific (semver, deprecation policy, brain-files emphasis).
- `design/UR_PLAN.md` — library-specific Ur-Plan with dependency policy, versioning, distribution target fields.
- `design/CURRENT_STATE.md` — baseline, assumed path skips data/design-system/frontend.

## Assumed path

```
new-project → backend-plan (public API contract) → audit → implementation
```

No data plan (no state), no design-system, no frontend.

## Placeholders

`{{project_name}}`, `{{stack}}`, `{{today}}` substituted by `/sdcd:new-project`.
