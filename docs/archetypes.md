---
title: Project archetypes
layout: default
nav_order: 5
permalink: /archetypes
---

# Project archetypes

An archetype is a pre-shaped project template — `CLAUDE.md`, `UR_PLAN.md`, `CURRENT_STATE.md`, and optionally `ARCHITECTURE.md` with fields already tuned for that kind of project. `/sdcd:new-project` copies one into the project root and substitutes placeholders. You can pick manually, or the skill picks based on your stated project.

Four archetypes ship today. Each sets a default **state-hygiene tier** per §1.5 and a default set of **applicable plans** — the ones the project actually needs, skipping the rest.

---

## `cli` — command-line tool

**Tier:** Serious project (§1.5) — baseline `CURRENT_STATE.md` only.

**Typical applicable plans:**

| Plan | Why |
|---|---|
| UR_PLAN | Always. |
| BACKEND_PLAN | Treated as the "internal module / subcommand structure" plan — CLI tools rarely have an HTTP surface but do have an internal API. |
| DATA_PLAN | Usually skipped — most CLI tools don't own persistent data. Include only if the tool maintains its own storage (e.g., a task tracker). |
| DESIGN_SYSTEM | Skipped — no UI. |
| FRONTEND_PLAN | Skipped — no UI. |

**Good fits:**

- Code formatters, linters, generators.
- Developer-tools (git helpers, build scripts, scaffolders).
- One-purpose utilities that read input and produce output.

**Bad fits:**

- Interactive TUIs with complex state (closer to frontend, consider full-stack or custom adaptation).

---

## `web-service` — backend service

**Tier:** Larger (§1.5) — `CURRENT_STATE.md` + `ARCHITECTURE.md` from day one.

Upgrades to Milestone-driven once releases / deploys enter the picture.

**Typical applicable plans:**

| Plan | Why |
|---|---|
| UR_PLAN | Always. |
| DATA_PLAN | Almost always — services carry state. Skip only for genuinely stateless transformers. |
| BACKEND_PLAN | Always. |
| DESIGN_SYSTEM | Only if the service ships an admin UI or web console. Declare in `CLAUDE.md` if not. |
| FRONTEND_PLAN | Same condition. |

**Good fits:**

- REST / GraphQL / RPC services.
- Background workers with an HTTP control surface.
- Event-processing services.
- Internal API gateways.

**Bad fits:**

- Projects where the UI is co-equal to the service — pick `full-stack` instead.
- Services that are really libraries with an HTTP front-end — pick `library` and declare the HTTP surface as a thin deployment detail.

---

## `library` — reusable package

**Tier:** Serious project (§1.5) — baseline state file.

Upgrades to Larger only when the public surface grows past ~10–15 modules.

**Typical applicable plans:**

| Plan | Why |
|---|---|
| UR_PLAN | Always. |
| BACKEND_PLAN | For a library this **is** the public-API contract plan. The single most important document. |
| DATA_PLAN | Usually skipped — libraries rarely own state. Include only for stateful libraries (caches, embedded databases). |
| DESIGN_SYSTEM | Skipped — no UI. |
| FRONTEND_PLAN | Skipped. |

**Extra rules** the archetype's `CLAUDE.md` adds:

- Semantic versioning is non-negotiable. Every public-API change is assessed: patch / minor / major.
- `CHANGELOG.md` updated before tagging.
- Deprecation policy is stated upfront (soft-deprecate for N minors vs. hard-break at major).

**Brain-file emphasis:** for libraries, brain files are especially valuable — external readers (other Claude sessions, users exploring the source) benefit directly from them. §1.6 is not optional here.

**Good fits:**

- Published packages (pypi / npm / crates.io / maven central).
- Internal reusable libraries across a team.
- SDKs and client libraries.

**Bad fits:**

- Projects whose primary artefact is a running service or app — wrong archetype.

---

## `full-stack` — frontend + backend product

**Tier:** Larger (§1.5) — `CURRENT_STATE.md` + `ARCHITECTURE.md`.

Upgrades to Milestone-driven once releases / deploys enter the picture (most full-stack products reach this quickly).

**Typical applicable plans:** all five.

| Plan | Why |
|---|---|
| UR_PLAN | Always. |
| DATA_PLAN | Full-stack apps almost always carry state. |
| BACKEND_PLAN | Always. API contract is the FE/BE coupling point. |
| DESIGN_SYSTEM | Always for greenfield. Exception: using an off-the-shelf system verbatim (e.g., "100% shadcn defaults"). |
| FRONTEND_PLAN | Always. |

**Extra rules** the archetype's `CLAUDE.md` adds:

- Repo layout decision (monorepo vs. split repos) logged in `ARCHITECTURE.md` on day one.
- The API contract is the coupling point — changes to it trigger both plans' open-question lists.

**Good fits:**

- SaaS products.
- Internal tools with admin UIs.
- Multi-surface apps (web + mobile web).

**Bad fits:**

- Native desktop or mobile apps — the templates assume web. Adapt the `frontend-plan` section for your platform, or fork the archetype into `desktop-app` / `mobile-app`.

---

## When none fits

Pick the **closest** archetype and adapt. The template is a head-start, not a contract. If you adapt the same way three times, that is a new archetype — contribute it back by dropping a directory under `plugin/sdcd/templates/<name>/`.

Archetypes are intentionally thin. They avoid imposing framework choices, directory conventions, or CI setup. Those are project-level decisions that belong in the project's `CLAUDE.md`, not the shared template.

## What every archetype provides

- A `CLAUDE.md` with the state-hygiene tier declared and project-specific rule slots.
- A `UR_PLAN.md` with archetype-appropriate fields (semver for libraries, auth/deploy for web-services, etc.).
- A `CURRENT_STATE.md` with a tier-aware "As next" list — the actual next steps for this archetype, not generic placeholders.
- Where relevant: an `ARCHITECTURE.md` with decision-log skeleton.

All templates use `{{project_name}}`, `{{stack}}`, `{{today}}` placeholders. `/sdcd:new-project` substitutes them while scaffolding.
