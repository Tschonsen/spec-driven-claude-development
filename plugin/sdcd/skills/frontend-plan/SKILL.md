---
name: frontend-plan
description: Derive the Frontend-Plan from an approved Ur-Plan and Backend-Plan. Use when the user says "plan the frontend" or "next: UI" after `/sdcd:backend-plan`. Reads both upstream plans, writes `design/FRONTEND_PLAN.md` (routes / component tree / state model / data-fetching / forms / error & empty states / accessibility), then dispatches challengers.
---

# frontend-plan

## Trigger

Ur-Plan and Backend-Plan both exist and are accepted. User wants the UI layer planned. Typical phrases: "now the frontend", "plan the UI", "let's design the client".

Do **not** use this skill:

- Without `design/UR_PLAN.md` AND `design/BACKEND_PLAN.md` — earlier skills run first.
- For backend-only projects (CLI, service with no UI). Use implementation skills directly.
- For trivial UIs with no state (a single form) — overkill.

## Procedure

### Step 1 — Load upstream plans

Read `UR_PLAN.md`, `BACKEND_PLAN.md`, and (if present) `DESIGN_SYSTEM.md`. If `DATA_PLAN.md` exists, skim it for entity names the UI will reference. Key items:

- From Ur-Plan: user-facing success criteria, target devices / viewports.
- From Backend-Plan: API contract (every call maps to a fetch), auth flow (drives gated routes).
- From Design-System: target feel, tokens (colour / type / spacing / radius / motion), component visual language. The frontend plan **references** these tokens by name — it does not redeclare them.

If Ur-Plan or Backend-Plan is missing, stop and direct to the correct preceding skill.

If `DESIGN_SYSTEM.md` is missing and the UI is non-trivial, recommend running `/sdcd:design-system-plan` first — skip only when the project explicitly uses an off-the-shelf design system (e.g., "100% shadcn defaults").

### Step 2 — Draft the Frontend-Plan

Write `design/FRONTEND_PLAN.md`:

```markdown
# <Project> — Frontend Plan

_Derived from UR_PLAN.md + BACKEND_PLAN.md — {today}_

## Routes

URL / route list. Per route: title, who can access it (auth), what backend endpoints it calls.

## Component tree

Not every component — the shape. List the 5–10 structural components and how they nest. Leaf components (buttons, inputs) are noted by category, not exhaustively.

## State model

What state lives where:

- Server state (React Query / SWR / equivalent): what cache keys, what invalidation triggers.
- URL state (query params, path params).
- Local component state.
- Global client state (if any — default is none; require a reason to add).

## Data fetching

For each backend endpoint from the API contract: fetch location (route loader? component? action?), loading state, error state, success state.

## Forms & mutations

Form list. Per form: validation (client-side, server-side, which takes precedence), submit behaviour, success/error UX, optimistic update or not.

## Error & empty states

Every data-fetching component has three states. Name them explicitly — do not leave "error state TBD".

## Visual language anchors

**If `DESIGN_SYSTEM.md` exists**: per major route / screen, name the tokens that dominate (e.g., "dashboard uses `color.bg.surface` + `color.accent.primary` + `space.l` grid"). Don't redeclare tokens; reference them.

**If not**: skip this section (but flag it as an open question).

## Accessibility

Keyboard navigation paths, ARIA roles for non-native controls, colour-contrast baseline, screen-reader targets.

## Responsive breakpoints

Which breakpoints matter for this product. Not "mobile/tablet/desktop" abstractly — concrete viewport widths the UI must not break at.

## Open questions

Frontend unknowns needing external input or design review.
```

### Step 3 — Dispatch challenger trio

Point at `FRONTEND_PLAN.md`:

- `challenger-security` — XSS surfaces, auth-token storage, client-side validation trusted as source-of-truth.
- `challenger-performance` — waterfall fetches, bundle size implications of stack choice, render-blocking patterns.
- `challenger-maintainability` — component tree that won't scale, state duplicated across layers, design-token escape hatches.

Synthesise into a single `## Challenger pushback` section at the bottom of `FRONTEND_PLAN.md`.

### Step 4 — Present & pause

Show:

1. Route list + component tree (the two sections a user can sanity-check fastest).
2. Top three challenger concerns.
3. Question: "address now or open question?"

Do not proceed to audit in the same turn.

## Invariants

- **Every fetch traces to an API contract entry.** If the frontend needs data no backend endpoint provides — it's an **Open question**, not invented.
- **Every form traces to a mutation endpoint.** Same rule.
- **Three states per data component.** loading / error / success is non-negotiable.
- **Accessibility is not TBD.** If the section has no specifics, the plan is not done.
