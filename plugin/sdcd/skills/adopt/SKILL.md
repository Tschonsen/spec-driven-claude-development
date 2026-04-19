---
name: adopt
description: Bootstrap SDCD into an existing project — scans the repo, detects stack & state, scaffolds a `design/` layout, writes a project-level CLAUDE.md, and reverse-engineers an Ur-Plan stub from README + git log + code evidence. Additive only — does not modify existing source files. Use when an already-running project decides to adopt SDCD mid-flight.
---

# adopt

## Trigger

SDCD is being introduced into a project that already has code, tests, history. User says: "let's adopt SDCD here", "retrofit", "put SDCD on this existing codebase". The project likely has a README, possibly has docs, but has no `design/` directory and no SDCD-shaped planning artefacts.

Do **not** use this skill:

- On a greenfield project — that's `/sdcd:new-project`.
- On an SDCD-governed project that already has `design/` — that's already adopted; use the regular skills.
- On a drive-by contribution to someone else's repo — don't impose SDCD on code you don't own.

## Core rule: additive only

This skill **never modifies existing source files, never deletes, never renames**. It writes new files only. If a target file already exists (CLAUDE.md, design/…), it either skips it or proposes the new content for the user to merge manually.

## Procedure

### Step 1 — Detect existing state

Use read-only commands to inventory:

- Stack markers: `pyproject.toml`, `package.json`, `Cargo.toml`, `go.mod`, `pom.xml`, `build.gradle` (there may be several — monorepo).
- Existing docs: `README.md`, `CONTRIBUTING.md`, any `docs/` directory, any `ADR*.md` files.
- Existing SDCD-like files: `CLAUDE.md`, `design/`, `.spec/`, `AGENTS.md`.
- Test setup: `tests/`, `__tests__/`, `*_test.go`, etc.
- CI: `.github/workflows/`, `.gitlab-ci.yml`, CI config present or absent.
- Git history depth: `git log --oneline | wc -l` to gauge project maturity.

Produce an **inventory** block (written to chat, not to a file yet) so the user sees what you saw.

### Step 2 — Classify the project

Based on inventory, classify:

- **Tier** (§1.5): Serious / Larger / Large-with-milestones. File count + commit count are the proxies.
- **Kind**: CLI / library / backend-service / frontend-app / full-stack / monorepo. Drives which plans to scaffold.
- **UI presence**: yes / no. If no, skip design-system templates.
- **Persistent data**: yes / no (detected via migrations dir, ORM config, DB connection strings in config). If no, skip data-plan template.

### Step 3 — Propose the scaffold

List what you will write (and what you will NOT write because it exists):

```
Will create (new):
  ✓ design/UR_PLAN.md  (stub, reverse-engineered from README + recent commits)
  ✓ design/CURRENT_STATE.md
  ✓ design/ARCHITECTURE.md  (only if Larger/Large tier)
  ✓ .claude/settings.json  (if missing; else propose merge)

Will propose (requires user merge):
  ⚠ CLAUDE.md — existing file found; I have a suggested diff, do you want to see it?

Will skip:
  ✗ design/DATA_PLAN.md  (project has no persistent data detected)
  ✗ design/DESIGN_SYSTEM.md  (CLI project, no UI)
```

Pause here. Wait for user OK before writing.

### Step 4 — Scaffold additive files

For each "will create" entry, write the file using the appropriate template from `plugin/sdcd/templates/` — but **fill it with detected content where possible**, not with placeholder text.

**Ur-Plan stub auto-fill:**

- **Goal** — derive one paragraph from the README's opening lines. Mark it with `(auto-generated from README.md — verify and edit)`.
- **Non-goals** — empty with a `TODO: explicit scope fences`. Auto-detection is too unreliable.
- **Success criteria** — look in README for performance claims, scale claims. If none found, `TODO`.
- **Tech stack** — fill from detected markers (language, major framework, storage).
- **Major milestones** — from git log: find tag-like commits or merge commits that mark phases. Best-effort.
- **Open questions** — leave empty with `TODO`.

**CURRENT_STATE stub auto-fill:**

- **Status** — one line per detected piece: "Tests: X files. CI: present/absent. Last commit: date."
- **As next** — `TODO: fill in with your actual current task`.
- **Open questions** — empty.
- **Constraints** — note the tier (§1.5) and any detected rules (e.g., "CI requires `npm test` pass").

### Step 5 — Write `CLAUDE.md` or propose merge

If no project-level `CLAUDE.md`: create it from the template, fill stack and tier.

If one exists: do not overwrite. Show a proposed **additions** block:

```markdown
## Adding to your CLAUDE.md (suggested)

To enable SDCD in this project, please add the following sections if not already present:

### State hygiene tier
- **Tier:** <detected tier>
- **Files:** design/CURRENT_STATE.md (mandatory) …

### Brain files
Per §1.6 …
```

User applies this manually.

### Step 6 — Offer brain-file backfill (optional)

If the project has >20 source files and SDCD's §1.6 brain-files rule applies:

- Offer: "Want me to run `/sdcd:auto-brain` or CodeBrain's `scan_repo` across existing sources to backfill brain files?"
- If yes and CodeBrain is available, invoke `codebrain_scan_repo`. If not, offer the `auto-brain` skill batch-wise (smaller scope each time).

This is **optional and opt-in**. Never do it unprompted — thousands of brain files appearing in a diff is noise.

### Step 7 — Report

End with a short summary:

```
## Adoption summary

Created:
  - design/UR_PLAN.md  (stub — PLEASE REVIEW before treating as truth)
  - design/CURRENT_STATE.md
  - design/ARCHITECTURE.md

Proposed (not applied):
  - CLAUDE.md additions (shown above; you apply manually)

Next steps:
  1. Review the auto-generated UR_PLAN.md and correct everything marked (auto-generated ...).
  2. Apply the CLAUDE.md additions.
  3. When ready, run challenger trio on the revised UR_PLAN: use the 3 challenger subagents directly (not `/sdcd:new-project`, which is for greenfield).
  4. From there, the standard SDCD flow applies: `/sdcd:session-start` each session, §1 rules for implementation, `/sdcd:session-end` to persist state.
```

## Invariants

- **Additive only.** No existing file gets modified, renamed, deleted. Proposals for existing files are shown, not applied.
- **Every auto-generated field is marked.** Ur-Plan stub sections that came from README / git have the `(auto-generated — verify)` marker until the user edits them.
- **No challenger trio on the stub.** The stub is auto-generated; challenger pushback on auto-generation is noise. User reviews and edits the stub, then runs challengers manually on the revised version.
- **Brain-file backfill is opt-in.** Never invoked without user OK.
- **Tier is detected, not assumed.** Small library gets Serious-tier, large repo gets Larger, monorepo with releases gets Large-with-milestones. Detected from inventory; declared in the new CLAUDE.md.
