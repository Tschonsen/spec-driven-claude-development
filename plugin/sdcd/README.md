# sdcd — Spec-Driven Claude Development plugin

A Claude Code plugin that bundles the SDCD methodology into actionable skills and subagents. Once installed, you can drive a project from zero-code to shippable via namespaced slash-commands:

```
/sdcd:new-project       → Ur-Plan + challenger trio
/sdcd:backend-plan      → Backend plan + challengers
/sdcd:frontend-plan     → Frontend plan + challengers
/sdcd:audit             → Cross-cutting gate before implementation
/sdcd:session-start     → Onboard a fresh session cheaply
/sdcd:session-end       → Persist state + refresh brain files
/sdcd:auto-brain        → Write or refresh a `<file>.brain` summary
```

Plus specialised subagents that the skills dispatch on their own:

- **`challenger-security`** / **`challenger-performance`** / **`challenger-maintainability`** — three independent reviewers that push back on planning documents.
- **`test-designer`** — writes the test plan *before* implementation starts (outside-in TDD).
- **`sdcd-reviewer`** — solo-dev stand-in reviewer for post-commit checks.
- **`plan-drift-detector`** — enforces §1.4 mechanically; halts when code diverges from the plan.

## Prerequisites

- Claude Code CLI installed (plugin support enabled).
- The SDCD core rules loaded into your user config: `~/.claude/CLAUDE.md` should include (or link to) the rules in this repo's root `CLAUDE.md`.

If you haven't set up SDCD at all yet, start with the repo-root `install.sh` / `install.ps1`.

## Install (local dev)

Clone this repo, then point Claude Code at the plugin directory:

```bash
claude --plugin-dir path/to/spec-driven-claude-development/plugin/sdcd
```

Inside a session, confirm the plugin loaded:

```
/plugins
```

You should see `sdcd` listed with its skills and agents.

## Install (persistent)

Once the plugin is stable, install it into your Claude Code config. From the repo root:

```bash
claude plugin install ./plugin/sdcd
```

Verify:

```bash
claude plugin list
```

## Typical flow on a new project

```
User: "New project: messenger service for small teams, stack Python + FastAPI"

/sdcd:new-project
  → draft design/UR_PLAN.md
  → challenger trio runs in parallel
  → surface top 3 concerns, wait for user

User: "Address concerns 1 and 3, defer 2. Move on."

/sdcd:backend-plan
  → draft design/BACKEND_PLAN.md from UR_PLAN
  → challenger trio on backend plan
  → surface concerns, wait

/sdcd:frontend-plan
  → draft design/FRONTEND_PLAN.md
  → challenger trio on frontend plan

/sdcd:audit
  → cross-cutting review
  → GO / NO-GO verdict, wait

User: "GO. /sdcd:session-start"
  → load CURRENT_STATE, active plan section, brain files
  → ready to code

<implementation work — §1 rules + §1.6 brain files throughout>

User: "/sdcd:session-end"
  → update state, session history, refresh brain files
```

## Which skill does what to which file

| Skill | Reads | Writes / updates |
|---|---|---|
| `new-project` | (user intent) | `design/UR_PLAN.md`, `design/CURRENT_STATE.md`, `design/` scaffolding |
| `backend-plan` | `UR_PLAN.md` | `design/BACKEND_PLAN.md` |
| `frontend-plan` | `UR_PLAN.md`, `BACKEND_PLAN.md` | `design/FRONTEND_PLAN.md` |
| `audit` | all three plans | `design/AUDIT.md` |
| `session-start` | `CURRENT_STATE.md`, active plan section, brain files | (nothing — onboarding only) |
| `session-end` | git diff, plans | `CURRENT_STATE.md`, `SESSION_HISTORY.md` (if present), refreshes `.brain` files |
| `auto-brain` | source file | `<source>.brain` |

## Opting out

If a project should **not** use SDCD (one-shot script, exploratory spike, external repo where you're a drive-by contributor):

- Don't install the project-level `CLAUDE.md` snippet.
- Don't invoke `/sdcd:new-project`.
- The core `~/.claude/CLAUDE.md` §1 still applies to you, but the project-specific layer doesn't activate.

For brain files specifically, a project can declare `no brain files` in its `CLAUDE.md` to opt out of §1.6.

## Customising

- **Templates:** add new project archetypes under `templates/<type>/`. The `new-project` skill reads from there.
- **Challenger lenses:** add another `challenger-<perspective>.md` under `agents/`. The `-plan` skills dispatch all three by default — if you add a fourth, update the skill procedures.
- **Rules:** project-level rules (not SDCD-wide) live in the project's own `CLAUDE.md`, not here.

## License

MIT — see repository root.
