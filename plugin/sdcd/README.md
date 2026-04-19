# sdcd — Spec-Driven Claude Development plugin

A Claude Code plugin that bundles the SDCD methodology into actionable skills and subagents. Once installed, you can drive a project from zero-code to shippable via namespaced slash-commands:

```
/sdcd:new-project           → Ur-Plan + challenger trio
/sdcd:data-plan             → Data-Model plan (entities, storage, indexes)
/sdcd:backend-plan          → Backend plan (references Data-Plan if present)
/sdcd:design-system-plan    → Visual direction, tokens, component language
/sdcd:frontend-plan         → Frontend plan (references Design-System + Backend)
/sdcd:audit                 → Cross-cutting gate over all applicable plans
/sdcd:adopt                 → Bootstrap SDCD into an existing, running project
/sdcd:session-start         → Onboard a fresh session cheaply
/sdcd:session-end           → Persist state + refresh brain files
/sdcd:auto-brain            → Write or refresh a `<file>.brain` summary
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
User: "New project: messenger service for small teams, stack Python + FastAPI + React"

/sdcd:new-project
  → design/UR_PLAN.md + challenger trio

/sdcd:data-plan
  → design/DATA_PLAN.md (entities, storage, indexes) + challenger trio

/sdcd:backend-plan
  → design/BACKEND_PLAN.md (references Data-Plan) + challenger trio

/sdcd:design-system-plan
  → design/DESIGN_SYSTEM.md (target feel, tokens, component language) + challengers

/sdcd:frontend-plan
  → design/FRONTEND_PLAN.md (references Design-System + Backend) + challengers

/sdcd:audit
  → cross-cutting review over all five plans → GO / NO-GO

User: "GO."

/sdcd:session-start
  → load CURRENT_STATE, active plan section, brain files
  → ready to code

<implementation — §1 rules + §1.6 brain files throughout>

/sdcd:session-end
  → update state, session history, refresh brain files
```

**Skip what doesn't apply:**

- Backend-only / CLI → skip `design-system-plan` + `frontend-plan`.
- Stateless tool → skip `data-plan`.
- Pure static site → skip `data-plan` + `backend-plan`.

`/sdcd:audit` detects what's applicable automatically (based on which plans exist) — you declare absences explicitly in the Ur-Plan's `## Non-goals`.

## Adopting SDCD in an existing project

If you want to introduce SDCD into a codebase that already has source, tests, and history:

```
/sdcd:adopt
  → scans the repo (stack, tier, UI presence, persistent data)
  → proposes a scaffold (design/, project CLAUDE.md, Ur-Plan stub)
  → additive only (never modifies existing files)
  → optionally backfills brain files across existing sources
```

The Ur-Plan stub is **reverse-engineered** from README + git log + code evidence and marked `(auto-generated — verify)`. You review and correct it before running challengers on it.

## Which skill does what to which file

| Skill | Reads | Writes / updates |
|---|---|---|
| `new-project` | (user intent) | `design/UR_PLAN.md`, `design/CURRENT_STATE.md`, `design/` scaffolding |
| `data-plan` | `UR_PLAN.md` | `design/DATA_PLAN.md` |
| `backend-plan` | `UR_PLAN.md`, `DATA_PLAN.md` (if present) | `design/BACKEND_PLAN.md` |
| `design-system-plan` | `UR_PLAN.md` | `design/DESIGN_SYSTEM.md` |
| `frontend-plan` | `UR_PLAN.md`, `BACKEND_PLAN.md`, `DESIGN_SYSTEM.md` (if present) | `design/FRONTEND_PLAN.md` |
| `audit` | all applicable plans | `design/AUDIT.md` |
| `adopt` | existing repo state | additive scaffolding + Ur-Plan stub, no modifications |
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
