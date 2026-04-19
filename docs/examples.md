---
title: Example — a messenger service
layout: default
nav_order: 7
permalink: /examples
---

# A full session: planning a messenger service

A complete walk-through of `/sdcd:*` on a greenfield full-stack project — from "I want to build a messenger for small teams" to "GO for implementation." Abbreviated for readability; the real outputs are longer.

---

## Step 0 — User intent

> "Let me plan a messenger service for small teams. Python + FastAPI backend, React frontend, self-hosted."

---

## Step 1 — `/sdcd:new-project`

Claude elicits the missing details:

> Before drafting the Ur-Plan, tell me in 3–5 sentences: what does this project do for whom, and what is the one non-trivial constraint I should know?

User answers:

> "Small teams (5–50 people) want a threaded messenger that lives on their own server. Must support code-snippets and file attachments. Non-trivial constraint: deploys to a single VPS, no k8s, no managed services — low-ops is a hard requirement."

**Tier declared:** Larger (multi-month project, full-stack product).

**Archetype used:** `full-stack` (Python backend + React frontend detected).

**Files scaffolded:**

```
messenger/
├── CLAUDE.md
└── design/
    ├── UR_PLAN.md
    ├── CURRENT_STATE.md
    └── ARCHITECTURE.md
```

**Ur-Plan drafted** with goal / non-goals / success-criteria / stack / milestones / open-questions.

**Challenger trio dispatched** against the draft. Synthesised pushback, top three:

1. **block** (challenger-security): "Single-VPS deploy with no managed services — how are credentials rotated? If app secrets live in env vars on one box, there is no rotation story at all. Spec this before touching code."
2. **high** (challenger-performance): "Success criterion says <100 ms message delivery but stack is FastAPI on one VPS with Postgres on the same box. Long-connection patterns (websockets) under 50 concurrent users will be fine; at 50+ you'll eat the uvicorn worker pool."
3. **high** (challenger-maintainability): "Non-goals are empty — for a messenger the non-goals list is the difference between a working MVP and feature creep. Stating them now costs nothing and saves three months."

User addresses 1 and 3 in the Ur-Plan, defers 2 to an Open question ("revisit if we hit worker-pool ceiling; first target is 20-user teams").

---

## Step 2 — `/sdcd:data-plan`

Claude reads the Ur-Plan, drafts `DATA_PLAN.md` with 5 entities:

- `User` — SQL, email + display name + hashed password.
- `Team` — SQL, owned by a creator user.
- `Channel` — SQL, belongs to team.
- `Thread` — SQL, belongs to channel.
- `Message` — SQL, belongs to thread, has author + body + attachments list.

Plus relationships, index coverage, retention, migration stance.

**Challenger trio** on the data plan surfaces:

1. **high** (challenger-performance): "Messages table will be the hottest. Your only stated query pattern is 'thread messages paginated by time'. Index is `(thread_id, created_at)` — state this explicitly."
2. **medium** (challenger-security): "User.hashed_password is noted but which algorithm? Argon2 / bcrypt / scrypt — pick now."
3. **medium** (challenger-maintainability): "Attachments listed as 'jsonb array on Message'. That's a future regret — file IDs should be their own table once you have any non-trivial per-file metadata."

All three addressed in-place.

---

## Step 3 — `/sdcd:backend-plan`

Claude reads Ur-Plan + Data-Plan, drafts `BACKEND_PLAN.md`:

- API contract: auth endpoints, team/channel CRUD, thread fetch, message send, attachment upload.
- Domain model: references `DATA_PLAN.md`.
- Storage: references `DATA_PLAN.md`.
- Auth: sessions via signed cookie, rotated every 24h.
- Error handling: single `APIError` with problem+json response shape.
- Observability: structured logs to stdout, metrics via Prometheus endpoint.

**Challenger trio** surfaces auth-flow edge cases and logs-PII concerns. Both addressed.

---

## Step 4 — `/sdcd:design-system-plan`

Claude reads the Ur-Plan, drafts `DESIGN_SYSTEM.md` with **target feel**: "minimal, serious, spacious, cool, sharp" (messenger for work teams, not a social app).

Sections filled: palette roles, typography (humanist sans-serif, 1.25 ratio), spacing (4px base), shapes (sm radius for buttons, none for inputs), motion (150/250/400ms durations, reduced-motion respected), iconography (Lucide, outlined), accessibility baseline (WCAG AA, visible focus ring).

**Dispatched challengers** (design-system uses UX + a11y + maintainability, not the default trio):

1. **high** (challenger-ux): "Threaded conversations need a visual hierarchy that distinguishes top-level messages from replies at a glance. Your component visual language section doesn't cover thread rendering at all."
2. **medium** (challenger-accessibility): "Focus ring is spec'd as `color.accent.primary` 2px offset — that's fine for light mode but does it hit 3:1 against `color.bg.surface` in dark mode? Verify during implementation; if not, introduce a dedicated `color.border.focus` token."
3. **medium** (challenger-maintainability): "Token namespace is a five-level tree (`color.bg.surface`, etc.). That's industry-standard but flag anyone tempted to add `color.header.top` — it would break the convention."

Addressed.

---

## Step 5 — `/sdcd:frontend-plan`

Claude reads Ur-Plan + Backend-Plan + Design-System, drafts `FRONTEND_PLAN.md`:

- Routes: `/login`, `/teams/:id`, `/teams/:id/channels/:cid`, `/teams/:id/channels/:cid/threads/:tid`, `/settings`.
- Component tree: AppShell → Sidebar / MainPane → ThreadList / MessageComposer, with leaf components noted by category.
- State model: server state (React Query, cache keys per endpoint), URL state (channel + thread IDs), local for composer draft.
- Data fetching: each route names the fetches.
- Forms: login, message composer, team/channel create.
- Error & empty states: per data-fetching component.
- Accessibility: keyboard-first navigation, skip-link to composer, ARIA live region for new messages.
- Visual language anchors: references Design-System tokens.

**Dispatched challengers** (frontend uses all 4: security + performance + ux + a11y):

1. **high** (challenger-security): "Messages render user content — XSS surface. Your plan doesn't say whether markdown is rendered server-side or client-side. Decide; client-side means a sanitiser on every render, server-side means HTML is in the payload."
2. **high** (challenger-performance): "Message list on a busy channel is unbounded. Your plan doesn't say virtualised list. At 500 messages the DOM will suffer."
3. **medium** (challenger-ux): "Composer submit-behaviour is 'Enter to send, Shift+Enter for newline'. Confirm this is stated in the UI (keyboard hint) — discoverability matters."
4. **medium** (challenger-accessibility): "Message live region is `polite` — correct for chat. But new-message-while-scrolled-up state needs a visible 'new messages below' affordance, not just an announcement."

All addressed, except #1 — user prefers server-side markdown and moves "renderer implementation" to Open questions for the backend-plan.

---

## Step 6 — `/sdcd:audit`

Claude reads all five plans. Trace-link checks pass. Contradictions pass. Open-questions rolled up:

- **Blockers:** 0.
- **Defer during implementation:** worker-pool ceiling, markdown renderer choice, attachments schema evolution.
- **External input needed:** self-hosted deployment story (from Ur-Plan non-goals → needs an explicit deploy guide before v1).

**Cross-cutting challenger pass** (all 5 lenses). Top concern:

- **note** (challenger-maintainability): "Auth is session-cookie rotated 24h. Token lifetime + rotation is consistent across Backend + Frontend. Logout revokes server-side. No drift."

**Verdict:** **GO**.

Claude writes `design/AUDIT.md` and reports:

> Ready to start implementation. Run `/sdcd:session-start` when you begin the first coding session.

---

## Implementation phase

`/sdcd:session-start` loads state. User codes feature-by-feature under §1 rules. Every source file gets a `.brain` per §1.6. `/sdcd:session-end` at the close of each work block.

After milestone M1 ("auth + first endpoint"):

```
/sdcd:milestone-audit
```

Claude reads M1's plan scope + actual code + tests + state. Dispatches `plan-drift-detector` and `sdcd-reviewer`. Writes an entry to `design/AUDIT_LOG.md`:

- Done: login + session + health check endpoint + auth middleware.
- Missing: plan called for account-lock-after-N-failures; code doesn't implement it. Verdict INCOMPLETE — unblock on that.

User adds the lock logic, re-runs milestone-audit — now COMPLETE. `CURRENT_STATE.md` advances to M2.

---

## What you don't see in this walk-through

- The actual plan documents are 200–400 lines each. Challenger outputs are 7 findings each, condensed above.
- Every skill dispatch pauses and waits for user input — the flow above compressed that.
- Challenger pushbacks get written into the plan files, not just the chat. That means re-reading a plan later shows what was pushed back on and how it was resolved.
- Every source file Claude touches gets a `.brain` companion. By the time M3 ships, there are dozens of brain files — and any fresh Claude session onboards via reading them, not the source.

The whole point: Claude in session N+1 can pick up where session N left off **without** re-inferring the project from scratch.
