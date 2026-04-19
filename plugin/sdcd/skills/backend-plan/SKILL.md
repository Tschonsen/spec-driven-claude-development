---
name: backend-plan
description: Derive the Backend-Plan from an existing Ur-Plan. Use when the user says "plan the backend" or after `/sdcd:new-project` when the Ur-Plan is approved. Reads `design/UR_PLAN.md`, writes `design/BACKEND_PLAN.md` (domain model / API contract / storage / auth / error handling / observability), then dispatches the three challenger subagents for independent pushback.
---

# backend-plan

## Trigger

The Ur-Plan exists and is accepted. User wants the next layer of planning. Typical phrases: "now plan the backend", "let's design the backend", "next step after Ur-Plan".

Do **not** use this skill:

- Without a saved `design/UR_PLAN.md` — run `/sdcd:new-project` first.
- For frontend-only projects (static site, pure UI library) — skip to frontend-plan.
- To revise an approved Backend-Plan — edit the file directly.

## Procedure

### Step 1 — Load upstream plans

Read `design/UR_PLAN.md` completely. If `design/DATA_PLAN.md` exists, read that too. Key items:

- From Ur-Plan: success criteria (drive API contract and performance targets), tech stack, open questions.
- From Data-Plan (if present): entities, relationships, storage choices, indexes, retention rules. The backend API contract is built **on top of** this data model — don't duplicate it.

If `UR_PLAN.md` is missing, stop and direct the user to `/sdcd:new-project`.

If the project has persistent data but no `DATA_PLAN.md`, recommend running `/sdcd:data-plan` first — skip only if the user confirms data is trivial enough to inline here.

### Step 2 — Draft the Backend-Plan

Write `design/BACKEND_PLAN.md` with these exact sections:

```markdown
# <Project> — Backend Plan

_Derived from UR_PLAN.md draft {n} — {today}_

## Domain model

**If `DATA_PLAN.md` exists**, this section is one line: "See `design/DATA_PLAN.md`." Do not duplicate entity / relationship / storage content here.

**If no `DATA_PLAN.md`**, briefly list the 3–7 core entities and relationships here. More than 10 entities means you should have run `/sdcd:data-plan` instead.

## API contract

Endpoint / RPC / message list. Per endpoint: method + path, request shape, response shape, error cases. Name contracts like `POST /conversations/{id}/messages` — not "send-message endpoint".

## Storage

**If `DATA_PLAN.md` exists**, this section is one line: "See `design/DATA_PLAN.md` — storage choices + indexes."

**If not**, per entity: the storage target, key pattern, and why that store was chosen. Call out indexes needed to hit success criteria.

## Auth & authorisation

Authentication flow (sessions / JWT / OAuth). Authorisation model (who can do what to what). Token lifetime, rotation, secret storage.

## Error handling & validation

Where validation happens (request boundary, not inside domain). Error taxonomy (4xx vs 5xx, client-facing messages). Retry behaviour for dependencies.

## Observability

What gets logged (with levels), what gets metrics'd, what gets traced. Name at least one alert signal per success criterion.

## Open questions

Backend unknowns that feed the next layer of planning or need external input.
```

Derive every section from the Ur-Plan — when a decision has no anchor in Ur-Plan (goal, non-goals, success criteria), that's a signal to escalate to the user, not to invent one.

### Step 3 — Dispatch challenger trio

Same as `/sdcd:new-project` Step 5, but pointed at `BACKEND_PLAN.md`:

- `challenger-security` — auth gaps, data-at-rest, injection surfaces, secret handling.
- `challenger-performance` — N+1s lurking in domain model, index coverage for success criteria, synchronous calls to slow dependencies.
- `challenger-maintainability` — coupling that'll bite, domain leaks across boundaries, validation scattered across layers.

Synthesise into a single `## Challenger pushback` section at the bottom of `BACKEND_PLAN.md`.

### Step 4 — Present & pause

Show:

1. The BACKEND_PLAN.md section headers + key decisions (1 line each).
2. Top three challenger concerns, prioritised.
3. Question: "which do we address now, which land in Open questions?"

Do not proceed to frontend-plan in the same turn.

## Invariants

- **Everything traces to Ur-Plan.** If a design choice has no anchor there, escalate — don't invent.
- **No code yet.** Still planning. No pseudo-code, no file paths for source — only for the plan document.
- **Challenger output lives in the plan file.** Not in the chat.
- **One plan, one file.** No "draft-01, draft-02" filenames — the file evolves in place, its draft number is in the frontmatter.
