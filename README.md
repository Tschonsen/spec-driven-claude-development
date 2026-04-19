# Spec-Driven Claude Development (SDCD)

> A methodology framework for collaborating with Claude on software projects — without losing the plot between sessions.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Status](https://img.shields.io/badge/status-early--access-orange.svg)

## The Problem

Claude has no memory between sessions. Every conversation starts cold. You end up re-explaining the project, re-stating the rules, or — worse — letting Claude make inconsistent decisions across sessions because nothing binds it to a previous one.

The usual answer is to write a `CLAUDE.md` with the rules. That works for small projects. For anything larger, it decays: the rules get ignored, the plans go stale, the state files drift from reality.

## What SDCD Is

SDCD is a small set of files plus a written methodology that together give Claude consistent, enforceable context across every session:

- **`~/.claude/CLAUDE.md`** — core rules (context hygiene, decision tiers, code quality, plan-vs-code alignment, state hygiene, brain files). Loaded in every session automatically.
- **`~/.claude/methodology.md`** — the detailed procedures referenced from `CLAUDE.md`. Loaded on demand (project start, audits, planning steps).
- **`project-templates/`** — starter files for a new project (project-level `CLAUDE.md`, `CURRENT_STATE.md`, `ARCHITECTURE.md`).
- **`plugin/sdcd/`** — Claude Code plugin that operationalises the methodology as namespaced slash-commands (`/sdcd:new-project`, `/sdcd:data-plan`, `/sdcd:backend-plan`, `/sdcd:design-system-plan`, `/sdcd:frontend-plan`, `/sdcd:audit`, `/sdcd:adopt`, `/sdcd:session-start`, `/sdcd:session-end`, `/sdcd:auto-brain`) plus specialised subagents (challenger trio, test-designer, reviewer, plan-drift-detector). Install-guide: `plugin/sdcd/README.md`.

The rules are opinionated but not dogmatic: TDD by default with documented exceptions, three tiers of decision autonomy based on blast radius, state-file hygiene that scales from "none for an ad-hoc script" to "full set for a multi-month project."

## Status

- **§1 Core Rules** — Stable, in active use. §1.6 (brain files) added 2026-04-19.
- **§2–§7 Methodology Detail** — Drafted in English, will be refined as real projects expose gaps.
- **Project templates** — Minimal but functional.
- **Installer scripts** — Working for Windows (PowerShell) and Unix (bash).
- **`plugin/sdcd/`** — Claude Code plugin with 10 skills (planning × 5 including data-plan & design-system-plan, lifecycle × 3, auto-brain, adopt for retrofit into existing projects) + 6 agents. Early access, testable via `claude --plugin-dir`.

This is an early-access repository. Expect edits.

## Install

### Windows (PowerShell)

```powershell
git clone https://github.com/Tschonsen/spec-driven-claude-development.git
cd spec-driven-claude-development
.\install.ps1
```

### macOS / Linux

```bash
git clone https://github.com/Tschonsen/spec-driven-claude-development.git
cd spec-driven-claude-development
./install.sh
```

The installer:
- Backs up any existing `~/.claude/CLAUDE.md` or `~/.claude/methodology.md` to `.bak` files.
- Copies `CLAUDE.md` and `methodology.md` into `~/.claude/`.
- Does **not** touch project-specific files. Each project is still free to add its own `<project>/CLAUDE.md`.

## Using It

1. **Install** (see above) so the core rules load in every Claude Code session.
2. **When starting a new project**, copy `project-templates/CLAUDE.md.template` into your project root and fill in the stack and gotchas. Create `design/CURRENT_STATE.md` from the template. Add `design/ARCHITECTURE.md` once the project has enough files to warrant one.
3. **Write an Ur-Plan** (`design/UR_PLAN.md`) before substantial implementation — see methodology §2.1.
4. **Run mini-audits** after each feature (§5.1) and a milestone audit at each phase boundary (§5.2).

None of this is magic. It is a discipline that costs ~5 extra minutes per session and keeps the project recoverable when Claude (or you) returns after a week away.

## File Layout

```
spec-driven-claude-development/
├── CLAUDE.md                          # User-level core rules (→ ~/.claude/CLAUDE.md)
├── methodology.md                     # Detailed procedures (→ ~/.claude/methodology.md)
├── install.ps1                        # Windows installer
├── install.sh                         # Unix installer
└── project-templates/
    ├── CLAUDE.md.template             # Project-level CLAUDE.md starter
    ├── CURRENT_STATE.md.template
    └── ARCHITECTURE.md.template
```

## Customizing

SDCD is opinionated, but it is not yours until you fork it. Two paths:

- **Fork and edit** — clone your own copy, change rules to match your style, install from your fork.
- **Project-level overrides** — keep the user-level SDCD as-is, override specific rules in `<project>/CLAUDE.md` (per §1.5, projects declare their own state-file tier and may override other §1 rules with a reason).

## Philosophy

A few ideas the framework leans on:

- **Claude is a brilliant junior who forgets everything overnight.** The methodology is the set of written artifacts that survive the forgetting.
- **Plans are living documents, not archaeology.** They get updated in the same commits as the code they describe. Stale plans are worse than no plans.
- **Duplication is cheaper than the wrong abstraction.** Patience before extracting pays off.
- **State hygiene scales with stakes.** A one-shot script needs nothing; a portfolio-grade project needs the full set.

## Relation to Existing Practice

SDCD is not an alternative to TDD, DDD, or Clean Architecture. It is scaffolding that makes those practices sustainable when one of the collaborators is an LLM with no memory between sessions. See methodology.md Appendix for details.

## Contributing

SDCD is one person's methodology crystallized. Pull requests are welcome, but the easier path for disagreement is a fork — your workflow is yours, and SDCD is more useful as a reference point than as a mandate.

## License

MIT — see [`LICENSE`](LICENSE).

---

Built by [Tschonsen](https://github.com/Tschonsen).
