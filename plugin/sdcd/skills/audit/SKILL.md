---
name: audit
description: Run a large cross-cutting audit across the Ur-Plan, Backend-Plan, and Frontend-Plan before implementation starts. Use when all three plans are drafted and the user says "audit everything" or "are we ready to code?". Produces `design/AUDIT.md` with gap analysis, trace-link check, contradictions list, and a go/no-go verdict. Dispatches all challengers one more time, this time across the whole surface.
---

# audit

## Trigger

All **applicable** plans exist (`UR_PLAN.md` always; `DATA_PLAN.md`, `BACKEND_PLAN.md`, `DESIGN_SYSTEM.md`, `FRONTEND_PLAN.md` as relevant). User wants the big gate check before implementation. Phrases: "audit all plans", "are we ready to code?", "big pass".

Applicable-plan matrix:

- Any project: `UR_PLAN.md`.
- Project with persistent state: `DATA_PLAN.md`.
- Project with a server / API / CLI: `BACKEND_PLAN.md`.
- Project with a UI: `DESIGN_SYSTEM.md` + `FRONTEND_PLAN.md`.

Skip checks for plans the project doesn't need — but the user declares that explicitly ("no UI in this project") rather than silently omitting.

Do **not** use this skill:

- When any of the three plans is missing or still marked draft-without-challenger-review.
- Mid-implementation — that's a milestone audit, not this skill (see `methodology.md §5.2`).

## Procedure

### Step 1 — Load all applicable plans

Read fully, in order:

- `design/UR_PLAN.md`
- `design/DATA_PLAN.md` (if the project has persistent state)
- `design/BACKEND_PLAN.md`
- `design/DESIGN_SYSTEM.md` (if the project has a UI)
- `design/FRONTEND_PLAN.md` (if the project has a UI)

Also check for a `CURRENT_STATE.md` — absent means the project hasn't been scaffolded yet; stop and tell the user to finish setup.

If a plan is expected per the matrix but missing, stop and direct the user to the matching skill.

### Step 2 — Trace-link check

Every design decision should anchor in something upstream. Walk each layer in dependency order:

- **Data-Plan → Ur-Plan:** every entity traces to something named (or clearly implied) in Ur-Plan goals or success criteria. Orphan entities are flagged.
- **Backend-Plan → Data-Plan:** every mentioned entity in API contract exists in Data-Plan. Every storage reference matches Data-Plan's storage choice.
- **Backend-Plan → Ur-Plan:** every API endpoint traces to a success criterion or non-goal carve-out. Orphans flagged.
- **Design-System → Ur-Plan:** target feel is consistent with the stated audience / platform / accessibility mandate.
- **Frontend-Plan → Backend-Plan:** every fetch traces to a contract entry; every form traces to a mutation.
- **Frontend-Plan → Design-System:** every component's visual-language anchor references existing tokens (no ad-hoc colours, spacings, radii).
- **All → Ur-Plan tech stack:** no stack drift ("Ur-Plan says Python, Backend-Plan mentions Node" = hard flag).

### Step 3 — Contradictions check

Look for conflicts between plans:

- Auth model in Backend vs auth-gated routes in Frontend — do they agree on token type, refresh flow, logout semantics?
- Error shape Backend emits vs what Frontend expects to render.
- Performance target in Ur-Plan vs stack choices that can't hit it.
- Non-goals violated by a plan section.

### Step 4 — Open-questions rollup

Collect every `## Open questions` section across all three plans. List them in one place. Categorise:

- **Blocker:** prevents starting implementation (unknown required).
- **Defer:** can be decided during implementation without re-planning.
- **External:** needs user input or third party (design review, business decision).

### Step 5 — Dispatch challenger trio — cross-cutting pass

Different from earlier passes: challengers now see **all three plans at once** and focus on cross-document issues, not intra-document ones.

- `challenger-security` — auth/data flow end-to-end, trust boundaries at each layer transition.
- `challenger-performance` — latency budget across the stack, N+1 that only appears when frontend + backend are combined.
- `challenger-maintainability` — whether this design will survive the first 3 months of real use, cross-doc ownership gaps.

### Step 6 — Verdict

Write `design/AUDIT.md`:

```markdown
# Audit — pre-implementation gate

_Run: {today}_

## Trace-link findings

- (entries — "OK" or "FLAG: <what>")

## Contradictions

- (list, or "_None found._")

## Open questions — rolled up

**Blockers:** ...
**Defer during implementation:** ...
**External input needed:** ...

## Challenger cross-cutting pushback

(synthesis, not raw agent output)

## Verdict

- **GO** / **NO-GO — block on: <items>**

Reasoning: <one short paragraph>
```

### Step 7 — Present

Show the user the verdict first (top-line), then the top 3 reasons if it's NO-GO. Ask:

- **If GO:** "Ready to start implementation. Run `/sdcd:session-start` when you want to begin a coding session."
- **If NO-GO:** "These items block implementation. Which do we resolve now?"

## Invariants

- **The audit is binary.** Verdict is GO or NO-GO. "Partial go" is NO-GO with a specific unblock list.
- **Raw findings go in `AUDIT.md`.** The chat gets only the verdict + top blockers. The file preserves everything for later reference.
- **Cross-cutting > intra-document.** This audit does not redo the challenger passes of individual plans — it looks at interactions between plans.
- **Do not proceed to implementation** even on GO. The user explicitly moves.
