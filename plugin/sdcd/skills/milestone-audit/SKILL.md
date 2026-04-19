---
name: milestone-audit
description: Run a milestone-level audit DURING implementation — after a feature or phase is nominally complete. Verifies the implemented code matches the plan section that drove it, state files are in sync, tests cover the success criteria, and brain files are fresh. Different from `/sdcd:audit` which is the pre-implementation gate over plan documents only.
---

# milestone-audit

## Trigger

A feature or milestone is nominally done and the user wants a structured check before moving on. Typical phrases: "milestone audit", "check off M2", "I think phase 2 is done, verify". Runs **during** implementation, not before.

Do **not** use this skill:

- Pre-implementation — use `/sdcd:audit` (the gate over plans, not code).
- After every commit — too heavy; use `sdcd-reviewer` for per-commit checks.
- On work that's mid-flight ("I'm halfway through M2") — finish the milestone first.

## Difference from `/sdcd:audit`

- `audit` reads planning documents, never code. Verdict: ready-to-code or not.
- `milestone-audit` reads code + current state + the relevant plan section. Verdict: milestone-complete or not, and what's missing.

## Procedure

### Step 1 — Identify the milestone

Ask the user which milestone (by name from `UR_PLAN.md §Major milestones`, or "the feature we just finished"). Read the plan sections that define what this milestone should deliver.

### Step 2 — Inventory what's actually there

- `git log` since the milestone started (or since a stated tag/commit).
- Files changed, added, deleted.
- Tests added / modified.
- Brain files in sync (hash matches source)?
- State files updated?

### Step 3 — Check against milestone definition

For each bullet in the milestone's plan section:

- **Done:** code implements this, tests cover it.
- **Partial:** code exists but tests are thin, or edge cases unhandled per the plan.
- **Missing:** plan mentioned it, code doesn't have it, no test exists.
- **Extra:** code has something the milestone plan didn't mention. Either the plan is stale, or this is scope creep — flag it.

### Step 4 — Dispatch `plan-drift-detector`

Run the `plan-drift-detector` agent pointed at the milestone's plan sections + the code scope changed during this milestone. Its output feeds directly into the audit report.

### Step 5 — Dispatch `sdcd-reviewer`

Run the `sdcd-reviewer` agent against the milestone's code changes. Its output feeds into the audit report.

### Step 6 — Write `design/AUDIT_LOG.md` (append)

If the project doesn't have `AUDIT_LOG.md` yet, create it. Append a dated entry:

```markdown
## {YYYY-MM-DD} — Milestone: {name}

**Milestone definition source:** `UR_PLAN.md §Major milestones` item N (or wherever).

**Against definition:**
- Done: ...
- Partial: ...
- Missing: ...
- Extra / scope creep: ...

**Drift findings** (from `plan-drift-detector`):
- ...

**Reviewer findings** (from `sdcd-reviewer`):
- ...

**State hygiene check:**
- CURRENT_STATE.md updated: yes / no
- ARCHITECTURE.md updated (if applicable): yes / no
- Brain files in sync: N of M files
- Tests added for milestone scope: count + coverage note

**Verdict:** COMPLETE / INCOMPLETE — block on {items}

**Reasoning:** <one paragraph>
```

### Step 7 — Update `CURRENT_STATE.md`

If the verdict is COMPLETE, update:

- `Status`: mark this milestone done.
- `As next`: advance to the next milestone.

If INCOMPLETE, the `As next` stays on this milestone with the block list.

### Step 8 — Report

Show the user:

1. Verdict (top line).
2. The three most important blocking items (if INCOMPLETE).
3. Pointer: "Full report appended to `design/AUDIT_LOG.md`."

## Invariants

- **Code, not plans.** This audit reads source, tests, brain files. Not plans in isolation.
- **Dispatch both agents.** `plan-drift-detector` and `sdcd-reviewer` are not optional — they are the mechanical layer of the audit, and milestone-audit is the synthesis.
- **One entry per milestone.** Do not run this skill twice for the same milestone; if you need to re-check after fixes, update the existing entry with a "revision" note.
- **Do not advance state on INCOMPLETE.** `CURRENT_STATE.As next` stays on the same milestone until the block list is empty.
