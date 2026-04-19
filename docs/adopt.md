---
title: Retrofitting SDCD
layout: default
nav_order: 6
permalink: /adopt
---

# Retrofitting SDCD into an existing project

SDCD is designed to start a project clean — but most real projects aren't clean when you meet them. `/sdcd:adopt` brings a running codebase under SDCD governance **without** touching the existing source.

## What `adopt` does

1. **Scans the repo** read-only. Detects:
   - Stack markers (`pyproject.toml`, `package.json`, `Cargo.toml`, `go.mod`, `pom.xml`, `build.gradle`).
   - Existing docs (`README.md`, `docs/`, `ADR*.md`, `CONTRIBUTING.md`).
   - SDCD-like files (`CLAUDE.md`, `design/`, `AGENTS.md`).
   - Test setup (`tests/`, `__tests__/`, `*_test.go`).
   - CI config (`.github/workflows/`, `.gitlab-ci.yml`).
   - Git depth (commit count as a proxy for maturity).

2. **Classifies** the project:
   - **Tier** — Serious / Larger / Large-with-milestones, based on file count and commit count.
   - **Kind** — CLI / library / backend-service / full-stack.
   - **UI presence** — yes / no.
   - **Persistent data** — yes / no (detected via migrations dir, ORM config, DB connection strings).

3. **Proposes** a scaffold — showing you what it will create and what it will NOT touch, before writing anything.

4. **Writes additively** only the files you approve. Never overwrites existing.

5. **Reports** with a next-step checklist.

## What `adopt` does NOT do

- **Never modifies existing files.** If `CLAUDE.md` exists, `adopt` shows a proposed diff for you to merge manually.
- **Never deletes or renames.** If it finds something unexpected, it flags it and moves on.
- **Never starts implementation.** It only scaffolds planning + state files.
- **Never runs the challenger trio on the stub.** The Ur-Plan it generates is reverse-engineered from README + git + code. Challengers on auto-generated text is noise — you review and correct first, then run challengers on the revised version.

## The reverse-engineered Ur-Plan stub

The most valuable part of `adopt` is the auto-filled Ur-Plan. Claude extracts what it can from evidence:

- **Goal** — first paragraph of README, marked `(auto-generated — verify)`.
- **Tech stack** — detected languages, frameworks, storage from marker files.
- **Major milestones** — tag-like commits and merge commits from `git log`.
- **Non-goals** — left empty with a `TODO: explicit scope fences` note. Auto-detection is too unreliable here.
- **Success criteria** — scanned from README for performance or scale claims. If none found, `TODO`.
- **Open questions** — left empty.

Every auto-generated field is **marked**, so future Claude sessions (and future you) can tell what came from evidence vs. what you've verified.

## Typical adoption session

```
User: "Retrofit SDCD into this project"

/sdcd:adopt

Claude: Scanning the repo...

Inventory:
- Stack: Python (pyproject.toml)
- Size: 47 source files, 183 commits
- UI: no
- Persistent state: yes (SQLAlchemy detected)
- Existing CLAUDE.md: no
- Existing docs: README.md, CONTRIBUTING.md

Classification:
- Tier: Larger
- Archetype: web-service (Python + SQLAlchemy + FastAPI detected)

I will create:
  ✓ design/UR_PLAN.md       (stub from README + git log)
  ✓ design/CURRENT_STATE.md (baseline)
  ✓ design/ARCHITECTURE.md  (Larger-tier)
  ✓ CLAUDE.md               (new)

I will skip:
  ✗ design/DESIGN_SYSTEM.md  (no UI detected)
  ✗ design/FRONTEND_PLAN.md  (no UI)

Proceed?

User: "go"

Claude: [writes files]

Done.

Next steps:
1. Review design/UR_PLAN.md — every section marked (auto-generated) needs your verification.
2. Run the challenger trio manually on the revised Ur-Plan (NOT via /sdcd:new-project —
   that's for greenfield).
3. When the Ur-Plan is verified, run /sdcd:data-plan and /sdcd:backend-plan as usual.
4. From there, /sdcd:session-start / §1 rules / /sdcd:session-end apply.
```

## Optional: brain-file backfill

If the project has more than ~20 source files, `adopt` offers to backfill brain files across the existing code. This is **opt-in** — thousands of brain files appearing in one diff is noise. You say yes only if you want to invest the batch.

If CodeBrain is available in the session, backfill goes via `codebrain_scan_repo`. Otherwise the `auto-brain` skill is invoked batch-wise over the files you care about.

## Opting out of parts

If some part of SDCD doesn't fit your existing project:

- **No brain files** — declare that in the new project `CLAUDE.md` under §1.6 opt-out.
- **No design/ directory, keep your existing docs dir** — adopt will respect an existing `docs/` or `.spec/` directory and write state files there if you tell it to.
- **Different tier** — you can downgrade the detected tier if `adopt`'s classification feels too heavy.

## When NOT to retrofit

- **Drive-by contribution to someone else's repo** — don't impose SDCD on code you don't own.
- **One-shot script / experiment** — SDCD is overhead. Skip for anything that won't outlive one sitting.
- **Project on the cusp of being thrown away** — don't polish a sinking ship. If you're migrating to something new, adopt SDCD on the new project.

## After retrofit

Post-adoption, the project is governed by SDCD like any greenfield SDCD project. The only difference is that your initial `design/` artefacts carry `(auto-generated — verify)` markers until you've reviewed each section. Those markers are the audit trail for "what did we actually confirm vs. what did Claude guess."

Run `/sdcd:session-start` to begin your next work session. From there, it's normal flow.
