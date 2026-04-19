---
name: new-project
description: Drive the Ur-Plan phase for a brand-new project. Use when the user says "new project X" or "let's plan X from scratch". Produces `design/UR_PLAN.md` with goal/non-goals/success-criteria/stack/milestones/open-questions, scaffolds the `.spec/` layout for the declared tier, then dispatches the three challenger subagents (security / performance / maintainability) to push back before anything is written to code.
---

# new-project

## Trigger

User kicks off a brand-new project — phrases like "new project: messenger", "let's plan X from scratch", "I want to build Y". The project has **no code yet**; this skill runs before any implementation.

Do **not** use this skill:

- Inside an existing project — use `/sdcd:backend-plan` or `/sdcd:frontend-plan` instead.
- For one-shot scripts or exploratory spikes (those don't need SDCD overhead).
- To *refine* an existing Ur-Plan (edit the file directly and re-run challengers manually).

## Procedure

### Step 1 — Elicit the project intent

Ask the user (one short message, not a form dump):

> "Before I draft the Ur-Plan, tell me in 3–5 sentences: what does this project do for whom, and what's the one non-trivial constraint I should know? (stack preference, deadline, must-integrate-with-X, etc.)"

Wait for the answer. Do not proceed on vague input — if the answer is less than 2 sentences, ask a sharper follow-up.

### Step 2 — Declare the state-hygiene tier

Based on the user's answer, pick one:

- **Tier 1 — Serious project (default):** multi-session, not one-shot. → `CURRENT_STATE.md` only.
- **Tier 2 — Larger:** >10–15 files expected, multi-month, or portfolio-grade. → adds `ARCHITECTURE.md`.
- **Tier 3 — Milestone-driven:** add `SESSION_HISTORY.md` + `AUDIT_LOG.md`.

State the tier choice with a reason (Tier 2 per §1.2). User can interject.

### Step 3 — Draft the Ur-Plan

Write `design/UR_PLAN.md` with these exact sections:

```markdown
# <Project> — Ur-Plan

_Draft 1 — {today}_

## Goal

One paragraph. What are we building and what problem does it solve?

## Non-goals

What this project is explicitly NOT doing. Scope fences.

## Success criteria

Concrete, verifiable outcomes. "X works" is too vague; "user can send a message and see it delivered in <200 ms P95" is right.

## Tech stack

Language, framework, storage, key libraries. Name versions where they matter (Python 3.11, Node 20).

## Major milestones

Rough phases if the project spans weeks. Skip for smaller projects.

## Open questions

Explicit unknowns. These will drive the challenger review and the backend/frontend planning phases.
```

Keep it short — a 1-page Ur-Plan is better than a 10-page one. Unknowns belong in **Open questions**, not padded into other sections.

### Step 4 — Scaffold the `.spec/` (or `design/`) layout

Create the directory structure matching the declared tier. Use `methodology.md §2.2` tier templates.

### Step 5 — Dispatch the challenger trio

Run all three challenger subagents **in parallel** against the draft Ur-Plan:

- `challenger-security` — read the Ur-Plan, report security assumptions that are untested or missing.
- `challenger-performance` — look for performance risks in the stack + success criteria combo.
- `challenger-maintainability` — flag abstractions that'll rot, unclear ownership, cross-cutting concerns.

Each returns a short pushback report. Synthesise them into a single `## Challenger pushback` section at the bottom of `UR_PLAN.md` — don't dump raw agent outputs.

### Step 6 — Present & pause

Show the user:

1. The `UR_PLAN.md` file tree + the Challenger-pushback section.
2. The three most important items the pushbacks surfaced (prioritised — not "here are 12 things").
3. The question: "which of these do we address now (update Ur-Plan), and which become Open questions for later?"

**Stop here.** Do not proceed to `/sdcd:backend-plan` in the same turn. The user explicitly moves to the next skill when ready.

## Invariants

- **No code yet.** `new-project` never writes source code. It writes planning artefacts only.
- **Challenger output goes in the plan, not the chat.** The pushback section is written to `UR_PLAN.md` so it survives across sessions.
- **Tier choice is sticky.** Don't downgrade tiers mid-project (§1.5).
- **Refuse vague input.** A one-line "it's a messenger" is not enough to draft an Ur-Plan. Push back.
