# {{project_name}} — Current State

_Last updated: {{today}}_

## Status

- Ur-Plan drafted; awaiting challenger review.
- Code tree: not yet created.

## As next

1. Run challenger trio (security / performance / maintainability) against `UR_PLAN.md`.
2. Address any **block** or **high** findings.
3. Run `/sdcd:backend-plan` — for a library this means the public-API contract.
4. Skip `data-plan`, `design-system-plan`, `frontend-plan` (no persistent state, no UI).
5. Run `/sdcd:audit` for a GO/NO-GO on the API contract before the first test goes in.

## Open questions

- <carry over from UR_PLAN §Open questions until resolved>

## Constraints

- Tier: Serious project (§1.5). Baseline file = this one.
- §1.6: brain files mandatory — library consumers rely on them.
- Public-API changes pass through a version/changelog check.

## Tech reference

- Path: `<fill in>`
- Entry point / public surface: `<fill in once API is sketched>`
- MCP servers in use: <CodeBrain? others?>
