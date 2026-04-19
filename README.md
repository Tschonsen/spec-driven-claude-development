# Spec-Driven Claude Development (SDCD)

> A methodology framework for collaborating with Claude on software projects — without losing the plot between sessions.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Status](https://img.shields.io/badge/status-early--access-orange.svg)
[![Docs](https://img.shields.io/badge/docs-online-brightgreen.svg)](https://tschonsen.github.io/spec-driven-claude-development/)

**📖 Full documentation: [tschonsen.github.io/spec-driven-claude-development](https://tschonsen.github.io/spec-driven-claude-development/)**

---

## The Problem

Claude has no memory between sessions. Every conversation starts cold. You end up re-explaining the project, re-stating the rules, or — worse — letting Claude make inconsistent decisions across sessions because nothing binds it to a previous one.

The usual answer is to write a `CLAUDE.md` with the rules. That works for small projects. For anything larger, it decays: the rules get ignored, the plans go stale, the state files drift from reality.

## What SDCD Is

SDCD ships in two complementary layers. Use either, use both.

### Layer 1 — Core rules (always on)

Two files that the installer drops into `~/.claude/`:

- **`CLAUDE.md`** — §1 core rules. Loaded automatically in every Claude Code session. Covers context hygiene, decision tiers, code quality, plan-vs-code alignment, state hygiene, and brain files.
- **`methodology.md`** — §2–§7 detailed procedures. Loaded on demand (project start, audits, planning steps).

Small, opinionated, battle-tested. See the [methodology page](https://tschonsen.github.io/spec-driven-claude-development/methodology) for the full text.

### Layer 2 — The `sdcd` Claude Code plugin (opt-in)

A plugin at `plugin/sdcd/` that operationalises the methodology:

- **11 skills** — namespaced as `/sdcd:new-project`, `/sdcd:data-plan`, `/sdcd:backend-plan`, `/sdcd:design-system-plan`, `/sdcd:frontend-plan`, `/sdcd:audit`, `/sdcd:milestone-audit`, `/sdcd:adopt`, `/sdcd:session-start`, `/sdcd:session-end`, `/sdcd:auto-brain`.
- **8 subagents** — a five-lens challenger pool (security / performance / maintainability / UX / accessibility), `test-designer`, `sdcd-reviewer`, `plan-drift-detector`.
- **4 project archetypes** — `cli`, `web-service`, `library`, `full-stack`. Each with pre-shaped templates.

See the [plugin page](https://tschonsen.github.io/spec-driven-claude-development/plugin) for the full catalogue, or jump straight to [install instructions](https://tschonsen.github.io/spec-driven-claude-development/install).

## Status

- **§1 Core Rules** — Stable, in active use. §1.6 (brain files) added 2026-04-19.
- **§2–§7 Methodology Detail** — Drafted in English, will be refined as real projects expose gaps.
- **Project templates** — Minimal but functional, at the root (`project-templates/`) and inside the plugin (`plugin/sdcd/templates/`).
- **Installer scripts** — Working for Windows (PowerShell) and Unix (bash).
- **`plugin/sdcd/`** — 11 skills + 8 subagents + 4 archetypes. Early access, testable via `claude --plugin-dir`.

This is an early-access repository. Expect edits.

## Quick install

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

The installer backs up any existing `~/.claude/CLAUDE.md` or `~/.claude/methodology.md` to `.bak` files, then copies the SDCD core rules into `~/.claude/`.

### Plugin install

Once the core rules are live, try the plugin locally:

```bash
claude --plugin-dir plugin/sdcd
```

When satisfied, install it persistently:

```bash
claude plugin install ./plugin/sdcd
```

Full install + verify guide: [tschonsen.github.io/spec-driven-claude-development/install](https://tschonsen.github.io/spec-driven-claude-development/install).

## Using it — two flows

### New project

```
/sdcd:new-project           → Ur-Plan + 3-challenger trio review
/sdcd:data-plan             → Data model, storage, indexes
/sdcd:backend-plan          → API contract (references Data-Plan)
/sdcd:design-system-plan    → Visual direction, tokens, component language
/sdcd:frontend-plan         → Routes, components, state (4-challenger quartet)
/sdcd:audit                 → GO / NO-GO gate over all applicable plans

/sdcd:session-start         → onboard each work session cheaply
                              <implementation under §1 rules>
/sdcd:session-end           → persist state + refresh brain files
/sdcd:milestone-audit       → verify code matches plan after each milestone
```

Smaller projects skip what doesn't apply. CLI tools don't need a design system; libraries don't need a data plan. See [Examples](https://tschonsen.github.io/spec-driven-claude-development/examples) for a full walk-through.

### Existing project

```
/sdcd:adopt
```

Scans the repo, detects stack and size, scaffolds a `design/` layout, and **reverse-engineers an Ur-Plan stub** from your existing README + git log + code. Additive only — never modifies existing files. [Retrofit guide](https://tschonsen.github.io/spec-driven-claude-development/adopt).

## File layout

```
spec-driven-claude-development/
├── CLAUDE.md                          # User-level core rules → ~/.claude/CLAUDE.md
├── methodology.md                     # Detailed procedures → ~/.claude/methodology.md
├── install.ps1                        # Windows installer
├── install.sh                         # Unix installer
├── project-templates/                 # Starter files for new projects
├── plugin/
│   └── sdcd/
│       ├── .claude-plugin/plugin.json
│       ├── skills/                    # 11 named skills
│       ├── agents/                    # 8 subagents
│       ├── templates/                 # 4 project archetypes
│       └── README.md
├── docs/                              # GitHub Pages content (Jekyll, just-the-docs)
├── index.md                           # Pages landing
└── _config.yml                        # Pages config
```

## Customising

SDCD is opinionated, but it is not yours until you fork it.

- **Fork and edit** — clone your own copy, change rules to match your style, install from your fork.
- **Project-level overrides** — keep the user-level SDCD as-is, override specific rules in `<project>/CLAUDE.md` (per §1.5, projects declare their own state-file tier and may override other §1 rules with a reason).
- **Add archetypes** — drop a new directory under `plugin/sdcd/templates/<name>/` following the shape of the existing ones.
- **Add challenger lenses** — drop a new `challenger-<lens>.md` under `plugin/sdcd/agents/` and update the skill procedures that should dispatch it.

## Philosophy

A few ideas the framework leans on:

- **Claude is a brilliant junior who forgets everything overnight.** The methodology is the set of written artifacts that survive the forgetting.
- **Plans are living documents, not archaeology.** They get updated in the same commits as the code they describe. Stale plans are worse than no plans.
- **Duplication is cheaper than the wrong abstraction.** Patience before extracting pays off.
- **State hygiene scales with stakes.** A one-shot script needs nothing; a portfolio-grade project needs the full set.
- **Challenger voices belong outside the author.** Security, performance, maintainability, UX, accessibility — concerns come from subagents that didn't write the plan. Independent review is cheaper when the reviewer literally cannot see the author's reasoning.

## Relation to existing practice

SDCD is not an alternative to TDD, DDD, or Clean Architecture. It is scaffolding that makes those practices sustainable when one of the collaborators is an LLM with no memory between sessions.

## Contributing

SDCD is one person's methodology crystallised. Pull requests are welcome, but the easier path for disagreement is a fork — your workflow is yours, and SDCD is more useful as a reference point than as a mandate.

## License

MIT — see [`LICENSE`](LICENSE).

---

Built by [Tschonsen](https://github.com/Tschonsen) with Claude as co-author.
