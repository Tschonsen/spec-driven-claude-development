---
title: The sdcd plugin
layout: default
nav_order: 4
permalink: /plugin
---

# The `sdcd` plugin

A Claude Code plugin that operationalises SDCD as namespaced slash-commands and specialised subagents. You can use the methodology without the plugin — but the plugin automates what would otherwise be manual discipline.

## What you get

- **11 skills** covering the full project lifecycle.
- **8 subagents** for independent review, test design, post-commit checks, and plan-drift detection.
- **4 project archetypes** for common project shapes.

All skills are namespaced: `/sdcd:new-project`, `/sdcd:audit`, etc. That keeps them distinct from any other plugin you have installed.

---

## Skills

### Planning pipeline

| Skill | Purpose | Writes |
|---|---|---|
| `/sdcd:new-project` | Drive the Ur-Plan phase of a brand-new project | `design/UR_PLAN.md`, `design/CURRENT_STATE.md`, scaffolding |
| `/sdcd:data-plan` | Design the data model from the Ur-Plan | `design/DATA_PLAN.md` |
| `/sdcd:backend-plan` | Design the backend API contract | `design/BACKEND_PLAN.md` |
| `/sdcd:design-system-plan` | Establish visual direction + tokens | `design/DESIGN_SYSTEM.md` |
| `/sdcd:frontend-plan` | Design routes + components + state | `design/FRONTEND_PLAN.md` |

Each planning skill dispatches a subset of the challenger pool tuned for its concerns. For example, `design-system-plan` dispatches **UX + accessibility + maintainability** instead of the default security/performance trio — because visual work is where user-facing concerns dominate.

### Audits

| Skill | When | Writes |
|---|---|---|
| `/sdcd:audit` | **Pre-implementation**, after all plans are drafted | `design/AUDIT.md` (GO / NO-GO verdict) |
| `/sdcd:milestone-audit` | **Mid-implementation**, after a feature / milestone completes | Appends to `design/AUDIT_LOG.md`, updates `CURRENT_STATE.md` |

The two audits do not overlap: `audit` reads plans only, `milestone-audit` reads code + state + the milestone's plan section.

### Retrofit (for running projects)

| Skill | Purpose |
|---|---|
| `/sdcd:adopt` | Scan an existing repo, scaffold `design/`, reverse-engineer an Ur-Plan stub from README + git-log + code-evidence |

`adopt` is **additive only** — it never modifies existing files. If your project already has a `CLAUDE.md`, the skill proposes a diff for you to merge manually rather than overwriting. See the [retrofit guide]({{ '/adopt' | relative_url }}).

### Session management

| Skill | When | What |
|---|---|---|
| `/sdcd:session-start` | Start of each work session | Loads `CURRENT_STATE.md`, active plan section, brain files of recently-changed files |
| `/sdcd:session-end` | End of each work session | Updates `CURRENT_STATE.md`, appends to `SESSION_HISTORY.md` (if present), refreshes brain files |

### Brain files

| Skill | Purpose |
|---|---|
| `/sdcd:auto-brain` | Write or refresh a `<file>.brain` summary for one source file |

`auto-brain` is typically invoked automatically by `session-end` or as part of §1.6. You can call it explicitly when you've just hand-edited a file and want the brain updated immediately.

---

## Subagents

### Challenger pool — five lenses

Challenger subagents run **independently** of the author. They read a planning document (or several, for cross-cutting audits) and return pushback reports. They never see the author's reasoning — which is the point; independent review is cheaper when the reviewer literally cannot inherit the author's blind spots.

| Agent | Lens | Dispatched by |
|---|---|---|
| `challenger-security` | Trust boundaries, auth, data sensitivity, injection surfaces | new-project, data-plan, backend-plan, audit (cross-cut), frontend-plan |
| `challenger-performance` | Latency vs. targets, N+1, index coverage, bundle size | new-project, data-plan, backend-plan, audit (cross-cut), frontend-plan |
| `challenger-maintainability` | Abstractions that rot, ownership, scope sprawl | All planning skills + audit |
| `challenger-ux` | Flow dead-ends, feedback loops, empty / first-time states | design-system-plan, frontend-plan, audit (if UI) |
| `challenger-accessibility` | Contrast vs. mandate, keyboard coverage, screen-reader gaps, colour-as-signal | design-system-plan, frontend-plan, audit (if UI) |

Each returns max 7 findings with severity (block / high / medium / note). The skill synthesises the findings into a `## Challenger pushback` section in the plan document itself — not the chat. That way the feedback survives across sessions.

### Implementation-phase subagents

| Agent | Purpose |
|---|---|
| `test-designer` | Writes the test plan **before** implementation starts. Outside-in TDD — every test anchors to a spec bullet. |
| `sdcd-reviewer` | Post-commit / pre-push review. Focuses on §1 compliance + code quality. Solo-dev stand-in reviewer. |
| `plan-drift-detector` | Enforces §1.4 mechanically. Compares code state to plan state and halts on contradictions. |

`sdcd-reviewer` and `plan-drift-detector` are deliberately separate — one is opinion-bearing (is this good code?), the other is mechanical (does it match the plan?). Skills that need both call both.

---

## Project archetypes

Each archetype ships a `CLAUDE.md`, `UR_PLAN.md`, `CURRENT_STATE.md` (and `ARCHITECTURE.md` where relevant) with sensible defaults for that shape of project.

| Archetype | Tier | Typical applicable plans |
|---|---|---|
| `cli` | Serious | UR_PLAN, BACKEND_PLAN (as public-API plan) |
| `web-service` | Larger | UR_PLAN, DATA_PLAN, BACKEND_PLAN, optional FE |
| `library` | Serious | UR_PLAN, BACKEND_PLAN (as public-API contract) |
| `full-stack` | Larger | All five plans |

`/sdcd:new-project` picks the closest match based on user intent and stack hints. You can override or adapt the template after scaffolding — the archetype just saves typing for the common case.

See the [archetype guide]({{ '/archetypes' | relative_url }}) for detail on when to pick which.

---

## Anatomy of a skill dispatch

When you invoke `/sdcd:backend-plan`, the skill:

1. Reads `design/UR_PLAN.md`. If missing, stops and points you at `/sdcd:new-project`.
2. Optionally reads `design/DATA_PLAN.md` if it exists — recommends `/sdcd:data-plan` first if persistent state is implied but no data plan was written.
3. Drafts `design/BACKEND_PLAN.md` with structured sections (Domain model / API contract / Storage / Auth / Error handling / Observability / Open questions). Section headers are exact and consistent across skills — that consistency is what lets `audit` trace-link decisions later.
4. Dispatches the three core challengers (security / performance / maintainability) in parallel against the draft. Each returns a short findings report.
5. Synthesises the pushback into a `## Challenger pushback` section at the bottom of the draft.
6. Presents a top-three summary of the pushback to you in chat. Waits.
7. You decide: address now (update the plan in place) or defer (move to `## Open questions`).

No skill proceeds to the next phase automatically. You drive the transitions.

---

## Customisation

The plugin is opinionated but not locked.

- **Add an archetype:** drop a new directory under `plugin/sdcd/templates/<name>/`. The `new-project` skill picks it up automatically if the user's stated project matches its intent.
- **Add a challenger lens:** drop a new `challenger-<lens>.md` under `plugin/sdcd/agents/`. Update the skill procedures to dispatch it where appropriate.
- **Override rules:** project-level `CLAUDE.md` can override user-level rules with a stated reason (per §1.5).

The plugin and the rules are intentionally thin. If you want something heavier (CI integration, multi-repo coordination, team-specific workflows), fork it.
