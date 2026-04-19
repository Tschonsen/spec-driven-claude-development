---
name: session-start
description: Onboard a fresh Claude session into an SDCD project — load CURRENT_STATE, active plan section, any open tasks, and recent brain files for zuletzt changed areas. Use at the beginning of a work session to pick up cold without wasting context on files you don't need.
---

# session-start

## Trigger

Start of a fresh Claude session on an SDCD-governed project. User typically says "session start", "let's pick up where we left off", "/sdcd:session-start". Also appropriate after a `/compact` or a crash-recovery session.

Do **not** use when the user has a specific task in mind that doesn't need full onboarding — ask first if they want lightweight or full context load.

## Procedure

### Step 1 — Read CURRENT_STATE

Read `design/CURRENT_STATE.md` (or wherever the project declares it). This is the baseline. If it's missing or older than ~2 weeks, flag that to the user — state hygiene is stale.

Do NOT dump its contents into the chat. Absorb it, then report back in one paragraph: "We are at X, last touched Y, next on the list is Z."

### Step 2 — Identify the active plan section

From CURRENT_STATE's "As next" or equivalent, identify which plan + section is active. Read just that section of the relevant plan file (`UR_PLAN.md`, `BACKEND_PLAN.md`, `FRONTEND_PLAN.md`). Do not read the whole plan.

### Step 3 — Inspect recent change surface (optional — only if working on code)

If the user indicates code work (not just planning / reading):

- Run `git log --oneline -10` to see what's been changed recently.
- For files changed in the last 3 commits, read their `<file>.brain` (not the sources). This gives you the mental model without the source-read cost.

### Step 4 — Check for blockers

Look for:
- Open questions flagged in the active plan section.
- Drift indicators (if CURRENT_STATE mentions "drift detected", run `plan-drift-detector`).
- Uncommitted work (if `git status` shows dirty tree, note it).

### Step 5 — Report

Return a short onboarding summary to the user:

```
## Session start — {project}

- **We are at:** <one-line state>
- **Active plan section:** <plan file + section name>
- **Next item:** <from CURRENT_STATE or plan>
- **Watch items:** <blockers / drift / dirty tree / stale state>

Ready to continue. What's the focus today?
```

## Invariants

- **Never dump file contents into the chat.** Summarise, don't paste. Context budget matters.
- **Read brain files, not source.** When §1.6 is followed, brain files are the cheapest mental-model anchor.
- **Flag staleness.** State older than two weeks, or open questions from before the last session, surface them.
- **Don't start work.** This skill only onboards. The user picks the next action.
