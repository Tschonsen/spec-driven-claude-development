---
title: Home
layout: default
nav_order: 1
description: A methodology framework for collaborating with Claude on software projects without losing the plot between sessions.
permalink: /
---

# Spec-Driven Claude Development
{: .fs-9 }

Keep Claude Code sessions coherent across days, weeks, and projects — with five rules, ten skills, eight challenger subagents, and a plugin bundle that enforces them.
{: .fs-5 .fw-300 }

[Install]({% link docs/install.md %}){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }
[View on GitHub](https://github.com/Tschonsen/spec-driven-claude-development){: .btn .fs-5 }

---

## The problem SDCD solves

Claude Code has no memory between sessions. Every conversation starts cold. On small projects, you get away with a one-page `CLAUDE.md`. On anything larger, it decays:

- Rules drift between sessions because nothing binds one session to the next.
- Plans rot — they describe the project as it was three weeks ago.
- State files go stale because updating them is a nice-to-have, not a ritual.
- Architecture decisions get re-litigated every few days by a Claude with no memory of the last debate.

SDCD is the scaffolding that makes serious work sustainable when one of the collaborators is an LLM that forgets everything overnight.

---

## Two halves — use either, use both

SDCD ships in two complementary pieces.

### §1 — Core rules (always on)

A single file at `~/.claude/CLAUDE.md` that Claude loads in every session. Covers:

- **Context hygiene** — read only what the task needs.
- **Decision tiers** — autonomous, name-and-proceed, confirm-first.
- **Code quality** — TDD default, error handling, abstractions, scope, function size, language.
- **Plan-vs-code alignment** — halt on divergence.
- **State hygiene** — tier-based state-file discipline.
- **Brain files** — per-file summaries that save context budget on large repos.

Small, opinionated, battle-tested. [Read the methodology →]({% link docs/methodology.md %})

### The `sdcd` plugin (opt-in)

A Claude Code plugin that operationalises the methodology as slash-commands and subagents:

- **11 skills** covering the full project lifecycle — planning, audits, session management, brain files, retrofit.
- **8 subagents** — a five-lens challenger pool (security / performance / maintainability / UX / accessibility), a test designer, a code reviewer, and a plan-drift detector.
- **4 project archetypes** — CLI, web-service, library, full-stack — each with pre-shaped templates.

Install the plugin once; drive new projects from zero-to-shippable with `/sdcd:*` commands. [Explore the plugin →]({% link docs/plugin.md %})

---

## Typical flow

A full-stack project from idea to implementation:

```
User: "New project: messenger service for small teams"

/sdcd:new-project           → design/UR_PLAN.md + 3-challenger trio review
/sdcd:data-plan             → design/DATA_PLAN.md (entities, storage, indexes)
/sdcd:backend-plan          → design/BACKEND_PLAN.md (references Data-Plan)
/sdcd:design-system-plan    → design/DESIGN_SYSTEM.md (tokens, component language)
/sdcd:frontend-plan         → design/FRONTEND_PLAN.md (4-challenger quartet)
/sdcd:audit                 → GO / NO-GO gate over all 5 plans

/sdcd:session-start         → onboard the session cheaply
                              <implementation under §1 rules>
/sdcd:session-end           → persist state + refresh brain files
/sdcd:milestone-audit       → after each milestone, verify code matches plan
```

Smaller projects skip what doesn't apply. CLI tools don't need a design system. Libraries don't need a data plan. Static sites don't need a backend. [See examples →]({% link docs/examples.md %})

---

## Already running a project? Retrofit with one command

```
/sdcd:adopt
```

Scans the repo, detects stack and size, scaffolds a `design/` layout, and **reverse-engineers an Ur-Plan stub** from your existing README, git log, and code. Additive only — never modifies existing files. [Retrofit guide →]({% link docs/adopt.md %})

---

## Design principles

A few ideas the framework leans on:

**Claude is a brilliant junior who forgets everything overnight.** The methodology is the set of written artifacts that survive the forgetting.

**Plans are living documents, not archaeology.** They get updated in the same commits as the code they describe. Stale plans are worse than no plans.

**Duplication is cheaper than the wrong abstraction.** Patience before extracting pays off.

**State hygiene scales with stakes.** A one-shot script needs nothing; a portfolio-grade project needs the full set.

**Challenger voices belong outside the author.** Security, performance, maintainability, UX, and accessibility concerns come from subagents that didn't write the plan. Independent review is cheaper when the reviewer literally cannot see the author's reasoning.

---

## What SDCD is not

- **Not an alternative to TDD, DDD, or Clean Architecture.** It is scaffolding that keeps those practices sustainable when a memory-less LLM is one of the collaborators.
- **Not a silver bullet.** Skipping planning for tiny tools is still correct. SDCD scales up, not down.
- **Not dogmatic.** Fork it, edit it, override rules per project. The framework is more useful as a reference point than as a mandate.

---

## Get started

1. [Install the core rules and plugin →]({% link docs/install.md %})
2. Pick a flow:
   - New project: `/sdcd:new-project` and follow the prompts.
   - Existing project: `/sdcd:adopt` to retrofit.
3. [Read the full methodology →]({% link docs/methodology.md %}) when you want the detail.
