# Spec-Driven Claude Development — Core

This file is loaded in every session. It contains the core rules that govern how Claude works across all projects. For procedures and details (planning workflows, audit checklists, state-file formats, session routines), see `methodology.md` — read it when you start a new project, run an audit, or need a planning procedure.

## §1 Core Rules

### §1.1 Context Hygiene

- Read only what the current task requires. Never load large files whole — only the relevant section.
- Before loading a large file, check whether a grep, a structure scan, or a brain file would suffice.
- Use agents for parallel research. Compress their findings in the main context — never pass through raw agent output unchanged.

### §1.2 Decisions

Decisions fall into three tiers based on reversibility, blast radius, and architectural weight:

- **Tier 1 — Act autonomously:** reversible + local + small + clear requirement. Variable rename, helper extraction, adding a test, minor refactor.
- **Tier 2 — Name the choice, give a reason, proceed; user can interject and discuss:** architecturally relevant decisions (database choice, framework, API contract) or ambiguous requirements with more than one sensible interpretation.
- **Tier 3 — Confirm before acting, with detail:** irreversible (`git push`, `reset --hard`), blast radius beyond local (creating a public repo, messages to third parties), destructive (force-push, `rm -rf`, dropping a table). Describe **what** happens, **what it affects**, **what could go wrong**. Wait for explicit OK.
- **When uncertain, escalate one tier.** Unclear whether it is Tier 1 or Tier 2 → Tier 2. Unclear whether Tier 2 or Tier 3 → Tier 3.

### §1.3 Code Quality

- **Test discipline:** TDD is the default (Red → Green → Refactor). Exceptions: prototyping, UI polish, pure renames, small behavior-preserving refactors, one-shot scripts. In an exception case, state the exception and the reason *before* starting.
- **Logging:** Structured logs with levels DEBUG / INFO / WARN / ERROR. Error logs must always include **WHAT** was attempted, **WITH WHICH DATA**, **WHY** it failed. Exception: small one-shot scripts.
- **Error handling:** Validate at system boundaries (user input, external APIs, file I/O, network). Internally, fail fast. No fallbacks for states that cannot occur per the type signature.
- **Comments:** Default none. Only when the **WHY** is non-obvious. Never *what* comments (the code describes that). No references to current tasks, fixes, or callers in comments — those belong in PR descriptions and rot otherwise.
- **Abstractions:** Rule of three. Wait for three similar occurrences before extracting. Duplication is cheaper than the wrong abstraction.
- **Scope discipline:** Stay on task. Direct blockers (missing import, broken type at call site) may be fixed in passing. Anything else is **named, not silently included**.
- **Function size:** Qualitative first — one responsibility per function. Hard trigger line 60 — above that, always evaluate whether it should be split (not automatic split, but explicit consideration with a reason).
- **Code language:** Code artifacts (variables, functions, classes, files, modules, log messages, commit messages) are in English. Domain terms without a good translation may remain in the native language. UI text is not covered — each project decides by audience.

### §1.4 Plan-vs-Code Alignment

- **Plan check:** Before a substantial change (new feature, architecture change, new module), check the existing plan. Small refactors, bugfixes, and renames are exempt.
- **Divergence:** When code diverges from the plan — no matter how small — halt. Name the divergence explicitly. The user decides whether the plan adapts or the code realigns. No silent plan edits, no silent implementation drift.
- **No plan present:** Substantial work without an existing plan → sketch a short plan (5–10 lines: goal, steps, affected files), get confirmation, then implement. Small work needs no plan.

### §1.5 State Hygiene (summary — see `methodology.md` §6 for detail)

State hygiene scales with project size:

- **Ad-hoc / exploratory / one-shot scripts:** no state files required.
- **Serious project** (multi-session, longer than a few days): **Current-State file** is the baseline (max ~60 lines; updated after substantial work; first read at session start).
- **Larger project** (>10–15 files, multi-month, or portfolio-grade): additionally an **Architecture file** (file inventory with purpose and dependencies; updated on architecture change).
- **Large project with milestones:** additionally a **Session-History file** (on-demand) and an **Audit-Log file** (appended after milestone audits).

Which files a project uses is declared in the project's `CLAUDE.md`.
