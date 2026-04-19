---
title: Methodology
layout: default
nav_order: 3
permalink: /methodology
---

# Methodology

The methodology splits into two files:

- **`CLAUDE.md`** — the core rules (§1). Loaded in every session.
- **`methodology.md`** — detailed procedures (§2–§7). Loaded on demand.

This page summarises both. For the authoritative version, read the raw files in the [repository](https://github.com/Tschonsen/spec-driven-claude-development).

## §1 Core rules (always loaded)

### §1.1 Context hygiene

- Read only what the current task requires. Never load large files whole.
- Before loading a large file, check whether grep, a structure scan, or a brain file would suffice.
- Use agents for parallel research. Compress their findings — never pass through raw agent output unchanged.

### §1.2 Decision tiers

Decisions fall into three tiers based on reversibility, blast radius, and architectural weight:

- **Tier 1 — Act autonomously:** reversible + local + small + clear requirement. Variable renames, helper extraction, adding a test, minor refactors.
- **Tier 2 — Name the choice, give a reason, proceed; user can interject:** architecturally relevant decisions (database choice, framework, API contract) or ambiguous requirements with more than one sensible interpretation.
- **Tier 3 — Confirm before acting, with detail:** irreversible (`git push`, `reset --hard`), blast radius beyond local (public repos, messages to third parties), destructive (force-push, `rm -rf`, dropping a table).

When uncertain, escalate one tier.

### §1.3 Code quality

- **Test discipline** — TDD default (Red → Green → Refactor). Exceptions stated before starting.
- **Logging** — structured, levelled, with WHAT / WITH-WHICH-DATA / WHY on errors.
- **Error handling** — validate at boundaries, fail fast internally. No fallbacks for impossible states.
- **Comments** — default none. Only for non-obvious WHY.
- **Abstractions** — Rule of three. Duplication is cheaper than the wrong abstraction.
- **Scope discipline** — stay on task. Direct blockers can be fixed in passing; everything else is named, not silently included.
- **Function size** — qualitative first. Hard trigger at 60 lines — above, always evaluate splitting.
- **Code language** — code artefacts in English. Domain terms may stay native.

### §1.4 Plan-vs-Code alignment

- **Plan check** before substantial change (new feature, architecture change, new module).
- **Divergence halts.** When code diverges from the plan — no matter how small — stop. Name the divergence. User decides whether plan adapts or code realigns.
- **No plan present** for substantial work → sketch one in 5–10 lines before implementing.

### §1.5 State hygiene

Tier-based; scales with stakes:

| Tier | When | State files |
|---|---|---|
| Ad-hoc / one-shot | Exploratory, single session | None required |
| Serious | Multi-session, > a few days | `CURRENT_STATE.md` |
| Larger | > 10–15 files, multi-month, portfolio | + `ARCHITECTURE.md` |
| Large with milestones | Releases, phases, deploys | + `SESSION_HISTORY.md`, `AUDIT_LOG.md` |

The tier is declared in the project's `CLAUDE.md`.

### §1.6 Brain files

For every source file Claude creates or substantially edits in an SDCD project, write a `<file>.brain` summary. Brain files let the next reader grasp a file's purpose, exports, and gotchas **without opening the source** — a context-budget saver on large repos.

- **Format** — YAML frontmatter (`source`, `source_hash`, `model`, `generated_at`) + five fixed sections: `## Purpose`, `## Key exports`, `## Collaborators`, `## Gotchas`, `## Conventions`.
- **Hash gate** — content-only SHA256; whitespace-only edits do not trigger regeneration.
- **Skip** — files under ~10 non-whitespace chars, generated/vendored code, text/docs.
- **Tooling** — if the session has CodeBrain available, use its `codebrain_scan_file` (has retry/validate). Otherwise use the `auto-brain` skill inline.
- **Opt-out** — projects that declare "no brain files" in `CLAUDE.md` are exempt.

## §2–§7 — Detailed procedures (on-demand)

Loaded when you need them, not per session. Each section drives a specific moment in a project's lifecycle.

### §2 Project start

How to lay the foundation before writing substantive code.

- **§2.1** — The Ur-Plan artifact (goal / non-goals / success-criteria / stack / milestones / open-questions).
- **§2.2** — Artifact structure by tier.
- **§2.3** — Tech-stack decisions: when to fix, how to document.

Use `/sdcd:new-project` for the scripted version.

### §3 Planning

How specialised plans are derived from the Ur-Plan.

- **§3.1** — Trace-links from sub-plans back to Ur-Plan.
- **§3.2** — Frontend planning.
- **§3.3** — Backend planning.
- **§3.4** — Data planning.
- **§3.5** — When to re-plan vs. push through.

Use `/sdcd:data-plan`, `/sdcd:backend-plan`, `/sdcd:design-system-plan`, `/sdcd:frontend-plan` for the scripted versions.

### §4 Implementation

The TDD-forward implementation flow.

- **§4.1** — TDD in detail: Red → Green → Refactor, test categories.
- **§4.2** — Logging standards.
- **§4.3** — Commit discipline and message format.
- **§4.4** — Divergence handling in code form.

### §5 Audits

- **§5.1** — Mini-audit after a feature.
- **§5.2** — Milestone audit at phase boundaries. Scripted by `/sdcd:milestone-audit`.
- **§5.3** — Ad-hoc audit when something feels wrong.
- **§5.4** — Audit-log format.

### §6 State hygiene (detail)

Format specs for each state file, what goes in, what stays out, max length guidelines.

### §7 Session routines

- **§7.1** — Session start: reading order. Scripted by `/sdcd:session-start`.
- **§7.2** — Session end: update order. Scripted by `/sdcd:session-end`.
- **§7.3** — Interruption handling: token-limit rollovers, crash recovery.

## Philosophy

**Claude is a brilliant junior who forgets everything overnight.** The methodology is the set of written artifacts that survive the forgetting.

**Plans are living documents, not archaeology.** They are updated in the same commits as the code they describe. Stale plans are worse than no plans.

**Duplication is cheaper than the wrong abstraction.** Patience before extracting pays off — the plugin enforces this via the Rule of Three in §1.3.

**State hygiene scales with stakes.** A one-shot script needs nothing; a portfolio-grade project needs the full set.

**The methodology is not an alternative to TDD, DDD, or Clean Architecture.** It is scaffolding that makes those practices sustainable when one collaborator has no memory between sessions.

[Read the raw files on GitHub →](https://github.com/Tschonsen/spec-driven-claude-development)
