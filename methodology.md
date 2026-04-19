# Spec-Driven Claude Development — Methodology

The detailed companion to `CLAUDE.md`. This file is read on demand, not automatically loaded per session. Consult it when:

- **Starting a new project** → §2
- **Planning a feature or a sub-system** (frontend / backend / data) → §3
- **In the thick of implementation and want the full TDD procedure** → §4
- **Running a mini-audit or milestone audit** → §5
- **Setting up state files for the first time, or uncertain about a format** → §6
- **Session start or end, unclear on the routine** → §7

---

## §1 Core Rules

See `CLAUDE.md`. The core rules are defined there and are not duplicated here. The sections below extend and detail them.

---

## §2 Project Start

When a project is worth running under SDCD (anything multi-session, serious, or portfolio-grade), lay a foundation before writing substantive code. The initial friction pays back within days, not weeks.

### §2.1 The Ur-Plan Artifact

Every SDCD project starts with an **Ur-Plan** — a foundational plan document that captures what the project is before the code exists. It lives in the project's spec directory as `UR_PLAN.md` (or under `design/UR_PLAN.md`, consistent with the project's state-file layout).

Required sections:

1. **Goal** — One paragraph. What are we building, and what problem does it solve?
2. **Non-Goals** — Explicit scope boundaries. What this project is *not* doing.
3. **Success Criteria** — How do we know it is done? Concrete, verifiable outcomes.
4. **Tech Stack** — High-level stack decisions. Language(s), framework(s), storage, key libraries. Versioned specifics go in the project's `CLAUDE.md`.
5. **Major Milestones** — Rough phases if the project spans weeks or longer. Optional for smaller projects.
6. **Open Questions** — Explicitly acknowledged unknowns. These become items to resolve as planning deepens.

The Ur-Plan is a **living document**. It gets updated as decisions are made and reality diverges from early assumptions — per §1.4 Plan-vs-Code Alignment.

### §2.2 Artifact Structure

Create files based on the project's state-hygiene tier (§1.5). A tiered checklist:

**Tier: Serious project (minimum)**

```
<root>/
├── CLAUDE.md                        # project-level rules
└── design/
    ├── UR_PLAN.md
    └── CURRENT_STATE.md
```

**Tier: Larger project (add)**

```
    ├── ARCHITECTURE.md
```

**Tier: Large with milestones (add)**

```
    ├── SESSION_HISTORY.md
    └── AUDIT_LOG.md
```

Use the templates in `project-templates/` as starting points; they are intentionally minimal to avoid ritual overhead.

### §2.3 Tech-Stack Decisions

Fix the stack **early** — ideally during Ur-Plan drafting. Ongoing stack re-evaluation is an energy drain and erodes code quality.

When to document:

- Core choices (language, framework, storage) → Ur-Plan §4 Tech Stack.
- Versioned specifics (Python 3.11, Node 20, Postgres 16) → project `CLAUDE.md`.
- Library-level decisions accumulated during implementation → append to the project `CLAUDE.md` under an `Adopted Libraries` section.

When a stack choice turns out wrong mid-project:

- If discovered early (first week, small codebase): consider switching. Document the why in the Ur-Plan.
- If discovered late: adapt around it. Document the constraint explicitly so future decisions do not compound the problem.

Never silently swap the stack. Decisions of this weight are Tier 2 or Tier 3 per §1.2.

---

## §3 Planning

The Ur-Plan is the trunk. Sub-plans are branches — created when a sub-system needs its own design before implementation.

### §3.1 General Planning

A sub-plan is warranted when:

- The sub-system has its own interface that must be designed before use.
- Multiple sessions will work on this sub-system.
- Cross-cutting concerns (frontend ↔ backend) need coordination.

A sub-plan is NOT warranted when:

- The work fits in a single session and affects one file.
- The design is obvious from the Ur-Plan.

Sub-plan format (keep it under one screen):

```
# Plan: <subsystem name>

## Scope
<1-2 sentences>

## Approach
<chosen approach in 3-5 bullets>

## Key Decisions
- <decision> — <reason>

## Risks
- <risk> — <mitigation>

## Testing Strategy
<how this will be verified>

## Trace
Linked to UR_PLAN.md §<n> <section>
```

The `Trace` line keeps sub-plans tethered to the Ur-Plan. When the Ur-Plan shifts, follow the trace links to see what may need to shift too.

### §3.2 Frontend Planning

A frontend sub-plan covers:

- **Component tree sketch** — named components, nesting, which ones own state.
- **State management** — local state vs. shared state vs. server state; which library (or none).
- **Routes** — route map with path → component; route guards if any.
- **Responsive breakpoints** — target viewport widths; what adapts at each.
- **Interaction patterns** — forms (controlled vs. uncontrolled, validation location), modals, notifications, loading states.
- **Accessibility baseline** — keyboard navigation, ARIA, color contrast.

Keep it a sketch, not a specification. One screen, not a chapter.

### §3.3 Backend Planning

A backend sub-plan covers:

- **Domain model** — core entities, relationships, aggregate boundaries.
- **API contract** — endpoints with method, path, request/response shape, status codes.
- **Data flow** — request lifecycle: where validation happens, where business logic lives, where persistence is called.
- **Storage** — schema at the entity level; index strategy for known access patterns.
- **Auth** — authentication mechanism and authorization model (who can do what).
- **External dependencies** — third-party APIs, their contracts, timeout and retry policies.

### §3.4 Data Planning

For projects with non-trivial data:

- **Schema** — tables/collections, key fields, relationships.
- **Migrations** — migration strategy (forward-only, reversible), tool choice.
- **Seed data** — what gets seeded for dev, what for demos, what for tests.
- **Backup and restore** — if production data matters, how it is backed up and how restore is tested.

### §3.5 Re-Planning Triggers

A plan is invalidated when:

- A fundamental assumption turns out wrong (the chosen approach does not work).
- A new requirement changes scope beyond minor adjustment.
- Implementation reveals a blocker that was not foreseen.

Re-planning is **delta-based**, not from-scratch:

1. Identify which section of the plan changes.
2. Write the delta (what was → what is, with reason).
3. Update the plan file; commit with a message that surfaces the change.
4. Update the Ur-Plan's `Open Questions` if the re-planning surfaced a new unknown.

Avoid "plan thrashing" — frequent minor re-plans erode trust in the plan. If you are re-planning weekly, the original plan was probably at the wrong level of detail. Step back.

---

## §4 Implementation

### §4.1 TDD Flow (detail)

The default loop per §1.3:

1. **Red** — Write the smallest test that captures the next behavior. Run it. Confirm it fails with the expected error (not a syntax error).
2. **Green** — Write the minimum code to make the test pass. Resist the urge to generalize or handle cases the test does not exercise.
3. **Refactor** — While green, improve the structure: rename for clarity, extract if the Rule of Three is met, simplify logic. Run tests continuously during refactoring.

Test pyramid guidance (rough defaults, adjust per project):

- ~70% unit tests (fast, isolated, lots of them).
- ~20% integration tests (real dependencies at boundaries).
- ~10% end-to-end tests (full user flows, expensive).

Bugfix TDD:

1. Reproduce the bug with a failing test.
2. Fix the code until the test passes.
3. The test now guards against regression.

### §4.2 Logging Standards (detail)

Log level mapping:

- **DEBUG** — verbose, developer-only; never on in production.
- **INFO** — normal operations worth recording (service started, job completed, user action).
- **WARN** — anomaly that was handled gracefully but deserves attention (retry succeeded, fallback used, deprecated API called).
- **ERROR** — something failed and requires action.

Structured format (key-value or JSON in production):

```
level=ERROR event=order_payment_failed order_id=... user_id=... amount=... error="card declined"
```

Log at:

- System boundaries (incoming request, outgoing external call).
- Error paths, with the full context per §1.3 (WHAT was attempted, WITH WHICH DATA, WHY it failed).
- State transitions of long-lived entities (user created, order fulfilled, job completed).

Do NOT log:

- PII (emails, names, card numbers) without explicit masking.
- Secrets (tokens, passwords).
- Every iteration of a hot loop — collapse to aggregate metrics instead.

### §4.3 Commit Discipline

When to commit:

- After every green test in TDD flow (small commits, reversible).
- At logical boundaries within a feature.
- When pausing work (explicit WIP commit rather than losing context).

Commit message style (Conventional Commits):

```
<type>: <subject, imperative mood, ≤72 chars>

<optional body: why, not what>

<optional footer: references, breaking changes>
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `style`, `perf`.

Never commit:

- Broken tests (without a `wip:` prefix if intentional).
- Debug statements (`console.log`, `print`, stray breakpoints).
- Commented-out code (Git history remembers it; comments do not explain).
- Generated files or dependencies (use `.gitignore`).

### §4.4 Plan-vs-Code Alignment (in practice)

Before starting substantial work (per §1.4):

1. Re-read the relevant plan section.
2. Note silently if anything in the plan looks stale; act on it at the next checkpoint.

During implementation:

- If the plan says A and the code will do B, **halt**. Name the divergence. Ask the user.
- Two legitimate outcomes: the plan updates to reflect B (write the update), or the implementation returns to A (continue as planned).
- A third outcome is not acceptable: code does B while the plan still says A.

Documenting divergence:

- If the plan updates: commit the plan change in the same commit as the code that realized it, or in an immediately adjacent commit.
- If the user decides to realign code to plan: just continue; no special documentation needed.

---

## §5 Audits

Audits are structured checkpoints where you verify that the work done matches the spec, the state, and the quality bars. They are not reviews — they are self-executed procedures.

### §5.1 Mini-Audit (after a feature)

Run when a feature is considered complete. Checklist:

- [ ] Feature behavior matches the plan / spec.
- [ ] Tests written and green (including the regression test if the work was a bugfix).
- [ ] Logging at boundaries and error paths; error logs carry context.
- [ ] No debug artifacts (console.log, print, commented code).
- [ ] Current-State file updated: current work removed from "In Progress", next steps updated.
- [ ] Plan file updated if divergence occurred.

If any item fails, fix it before declaring done. A mini-audit is cheap; skipping it is expensive.

### §5.2 Milestone Audit

Run at the end of a phase or milestone from the Ur-Plan. Checklist:

- [ ] All Mini-Audit items for the features in this milestone.
- [ ] Performance check: critical paths have measured response times; DB query counts per request are bounded; memory usage is reasonable.
- [ ] Integration test run: full integration suite green.
- [ ] Ur-Plan section for this milestone is reconciled with reality (what shipped vs. what was planned).
- [ ] Breaking changes documented (in a CHANGELOG, release notes, or the Ur-Plan's appendix).
- [ ] Audit entry added to `AUDIT_LOG.md` (see §5.4 format).

### §5.3 Ad-hoc Audit (on bug or suspicion)

Triggered by: a reported bug, a performance concern, or a gut-check that something is off.

Procedure:

1. **Reproduce** — write a failing test that demonstrates the issue.
2. **Isolate** — narrow the scope. Is it this module, this function, this condition?
3. **Fix** — TDD the fix (the test from step 1 becomes green).
4. **Root cause** — write one paragraph: what was the underlying cause, not just the symptom.
5. **Prevent** — is there a class of similar bugs that could exist? Add tests or structural guards if so.
6. **Log** — add an entry to `AUDIT_LOG.md` with the root cause and prevention.

### §5.4 Audit-Log Format

```
## <YYYY-MM-DD> <type> audit — <short title>

**Scope:** <what was audited>

**Findings:**
- <finding 1>
- <finding 2>

**Actions taken:**
- <action 1>
- <action 2>

**Sign-off:** <by whom, if multi-person; omit for solo>
```

`AUDIT_LOG.md` is append-only. Older entries stay for historical context. When it gets too long, archive into `design/audits/` by year.

---

## §6 State Hygiene (detail)

The files from §1.5, with specific formats.

### §6.1 Current-State File

```md
# Current State — <project name>

*Last updated: <YYYY-MM-DD>*

## Running
- <feature/component that works>

## In Progress
- <what is being worked on right now>

## Known Issues
- <bug or limitation not yet addressed>

## Next Up
- <immediate next steps>

## Recent Decisions
- <significant decision from the last few sessions>
```

Rules:

- Max ~60 lines.
- No session-by-session logs here (those go in `SESSION_HISTORY.md`).
- Updated after substantial work, not after every commit.
- First read at session start per §7.1.

### §6.2 Architecture File

```md
# Architecture — <project name>

## File Inventory

### <Module / folder name>
- `path/to/file.ext` — <purpose, 1 line>. Key exports: <X, Y>. Depends on: <A, B>.
- `path/to/other.ext` — <purpose>.

### <Next module>
...

## Cross-Module Dependencies

- <Module A> depends on <Module B> for <reason>.
- Avoid: <Module X> importing from <Module Y> (circular risk).
```

Updated when files are added or removed, or when major dependencies change. Not per-function-change — this file describes shape, not implementation.

### §6.3 Session-History File

Append-only log of significant completed sessions.

```md
## <YYYY-MM-DD> Session — <short title>

**Scope:** <what was tackled>
**Result:** <what was achieved>
**Loose ends:** <anything carried forward>
```

Read on demand only, when historical context is needed. Not read at session start (that is what Current-State is for).

### §6.4 Audit-Log File

Format defined in §5.4.

### §6.5 Living Plan Files

Plan files (Ur-Plan, sub-plans) are versioned with the code — commits to plan files are as real as code commits. The Git history is the plan's history; there is no separate "plan archive."

When the plan changes:

- Edit the plan file in place (no "v2" sections; the file always reflects current truth).
- Commit with a message that names the change: `plan: revise auth approach to token-based`.
- If the change is substantial, reference the commit in the Current-State file's `Recent Decisions`.

Plan files never grow indefinitely. When a section is fully implemented and stable, compress it ("section moved to `ARCHITECTURE.md`") or delete it if the code is self-documenting.

---

## §7 Session Routines

Session routines keep context restoration cheap and state preservation robust.

### §7.1 Session Start

Read order:

1. `~/.claude/CLAUDE.md` — auto-loaded (SDCD core rules).
2. Project `CLAUDE.md` — auto-loaded (project rules, stack, gotchas).
3. `design/CURRENT_STATE.md` — **first explicit read**; tells you where you are.
4. If the task is substantial per §1.4: `design/UR_PLAN.md` or the relevant sub-plan.
5. If the task touches unfamiliar code: `design/ARCHITECTURE.md` — find the relevant module, then read only the files that matter.

Do NOT read at session start:

- `SESSION_HISTORY.md` (only on demand).
- The full spec / every design document (read the index, not the body).
- All source files (read only what the task needs per §1.1).

### §7.2 Session End

Update order:

1. `design/CURRENT_STATE.md` — update `In Progress`, `Next Up`, `Recent Decisions`.
2. If the session made architectural changes: `design/ARCHITECTURE.md`.
3. If the session was a logical unit (feature completed, phase ended): append to `design/SESSION_HISTORY.md` (§6.3 format).
4. If the session ran an audit: append to `design/AUDIT_LOG.md` (§5.4 format).

Commit the state updates in a dedicated commit: `state: end-of-session update`. This makes session boundaries visible in Git history.

### §7.3 Interrupt Safety

When the session is about to end unexpectedly (token limit approaching, user interruption, crash concern):

- **Priority 1:** Update Current-State. Even a single line — "currently implementing X, stopped at Y." This is the recovery anchor.
- **Priority 2:** Commit work-in-progress explicitly. `wip: <short description>` is acceptable; commented-out hacks are not.
- **Priority 3:** If tests are broken, say so in the Current-State update. The next session must not start blind.

Recovery on the next session:

1. Read Current-State per §7.1.
2. If it says "wip" or "stopped at X", your first task is to continue from X, not start something new.
3. Once stable, compose a clean commit; you may squash the wip commit if it makes the history cleaner.

---

## Appendix: Relation to Other Methodologies

SDCD is not an alternative to Test-Driven Development, Domain-Driven Design, or Clean Architecture. It is **scaffolding** that makes those practices sustainable when one of the collaborators is an LLM with no memory between sessions.

Where SDCD overlaps:

- **TDD** — adopted wholesale as the default test discipline (§1.3, §4.1).
- **Conventional Commits** — adopted as the commit message style (§4.3).
- **Architecture Decision Records** — compatible; ADRs can live alongside the Ur-Plan in `design/`.
- **Spec-Driven Design** — kindred spirit; SDCD is specifically about specs Claude can consume.

Where SDCD adds:

- Explicit state-hygiene files because Claude starts every session cold.
- Plan-vs-code alignment as a blocking rule, not a cultural norm.
- Decision tiers calibrated for LLM collaboration (autonomy with escalation).
- Context-hygiene rules because context is the LLM's scarcest resource.

---

*This is an early version of SDCD. §1 is stable and in active use. §2–§7 will be refined as real projects expose gaps. Contributions by way of forks are the expected path — your workflow is yours.*
