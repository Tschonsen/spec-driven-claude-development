---
name: session-end
description: Close out a Claude session cleanly — update CURRENT_STATE with what changed, append a SESSION_HISTORY entry (if the project keeps one), ensure brain files are fresh for every source edited this session. Run before you close the terminal so the next session starts with accurate state.
---

# session-end

## Trigger

End of a work session. User says "wrap up", "session end", "/sdcd:session-end", or indicates they're done for now.

Also appropriate before a context-heavy rollover — even mid-session — if you want to persist the state so a fresh session can pick up cleanly.

## Procedure

### Step 1 — Collect what changed this session

Use git to identify changes since session start:

- `git diff --stat` for unstaged + `git log --oneline <start>..HEAD` for committed.
- If the session spanned multiple branches / commits, use the user's sense of "since we started" rather than guessing.

Also check: which plan sections were updated (if any), which source files were edited / created.

### Step 2 — Update CURRENT_STATE

Read `design/CURRENT_STATE.md`. Update these sections (only the ones that changed):

- **Status** — what's now done that wasn't before.
- **As next** — reflect the new top-of-list (may be the same as before if partial progress).
- **Open questions** — add new ones surfaced this session, resolve ones that got decided.
- **Constraints** — usually static; touch only if a hard constraint emerged.

Keep CURRENT_STATE under ~60 lines (§1.5). If it's growing, that's a sign to archive older items to SESSION_HISTORY.

### Step 3 — Append SESSION_HISTORY (if the project keeps one)

If `design/SESSION_HISTORY.md` exists, append a dated entry:

```markdown
## {YYYY-MM-DD} — {session title}

**Focus:** <one line>

**Changed:**
- <files / plan sections / decisions>

**Decisions made:**
- <any §1.2 Tier-2 decisions with their rationale, briefly>

**Open items surfaced:**
- <new open questions, if any>

**Next session starts with:** <from As-next in CURRENT_STATE>
```

### Step 4 — Refresh brain files (§1.6)

For every source file edited this session (from git):

- Confirm `<file>.brain` exists and is hash-current.
- If missing/stale AND the file is a source file worth summarising (>10 non-whitespace chars, not generated / vendored): regenerate via CodeBrain MCP if available, else via the `auto-brain` skill.

Report the count: "Refreshed N brain files" or "No brain-file work needed".

### Step 5 — Report

Return a short close-out summary:

```
## Session end — {project}

- **Done this session:** <summary>
- **CURRENT_STATE updated:** yes / no
- **SESSION_HISTORY entry:** appended / skipped
- **Brain files refreshed:** N files
- **Next session starts with:** <one-line pointer>

Clean to exit.
```

### Step 6 — Commit suggestion (do not auto-commit)

If there are uncommitted changes relevant to the work done:

- List them briefly.
- Suggest a commit message draft.
- Let the user trigger the commit (do NOT commit without explicit user OK — §1.2 Tier 3 applies for any git operation that changes shared state).

## Invariants

- **Never auto-commit or push.** Always pause for user confirmation (§1.2).
- **State file stays bounded.** If CURRENT_STATE exceeds ~60 lines, archive to SESSION_HISTORY instead of growing the state file.
- **Brain file refresh is not optional.** §1.6 is a default; session end is when the default gets honoured if it was skipped in the heat of coding.
- **Report, don't dump.** Summarise what happened — don't paste diffs or full plan content.
