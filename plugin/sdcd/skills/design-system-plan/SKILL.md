---
name: design-system-plan
description: Derive the Design-System-Plan from an approved Ur-Plan (and Backend-Plan, if present). Use when the user says "plan the design system" or "visual direction" before `/sdcd:frontend-plan`. Reads upstream plans, writes `design/DESIGN_SYSTEM.md` (target feel / colour palette / typography / spacing / shapes / motion / iconography / accessibility baseline / component visual language / dark-mode stance), dispatches challenger trio. Frontend-Plan references this document for token names and component styling.
---

# design-system-plan

## Trigger

Ur-Plan is accepted, the project has a user-facing UI, and visual direction is not yet fixed. User says: "plan the design system", "visual direction", "tokens", "what's this going to look like". Runs **before** `/sdcd:frontend-plan` — visual direction should inform component structure, not the other way around.

Do **not** use this skill:

- For backend-only / CLI projects — no UI, no design system.
- When the project will use an off-the-shelf design system verbatim (e.g., "100% shadcn defaults, no customisation"). Declare that in the project CLAUDE.md and skip to frontend-plan.
- To re-theme an existing app — that's a refactor task, not a planning one.

## Depth by project size

The full output below is aimed at serious UI-driven products. Scale down honestly:

- **Small tool, single screen, internal use:** fill only `## Target feel`, `## Colour palette`, `## Typography`. Skip the rest or mark `_Not applicable at this size._`. Running the full 10-section template on a 2-page internal admin is overkill.
- **Medium product, several screens:** add `## Spacing scale`, `## Shapes & radius`, `## Component visual language`, `## Accessibility baseline`.
- **Public / multi-surface product:** fill everything including `## Motion`, `## Iconography`, `## Tokens (naming)`, and the explicit dark-mode stance.

This is a trim at draft time, not a permission to skip mandatory items — `## Accessibility baseline` is non-optional for any user-facing product.

## Procedure

### Step 1 — Load upstream context

Read `design/UR_PLAN.md`. Extract:

- **Audience** — who uses this? Determines formality, density, tone.
- **Platform mix** — web-only / PWA / also-mobile — constrains token portability.
- **Accessibility mandate** — stated target (WCAG AA? AAA?). Drives contrast minimums.
- **Brand anchors** — existing logo, brand colour, or typography the project inherits. If none, you're greenfield on visuals.

Optionally read `design/BACKEND_PLAN.md` if it exists — for hints about content types that'll shape layout (e.g., long-form text vs short messages).

### Step 2 — Establish target feel

Before numbers: three-line positioning paragraph. Pick 3–5 adjectives from opposing axes (pick one per axis):

- Minimal ↔ Rich
- Playful ↔ Serious
- Dense ↔ Spacious
- Warm ↔ Cool
- Soft ↔ Sharp

"This app should feel minimal, serious, spacious, cool, sharp" → *different* component decisions than "rich, playful, dense, warm, soft". Without this anchor, the rest of the design system drifts.

### Step 3 — Draft the Design-System-Plan

Write `design/DESIGN_SYSTEM.md`:

```markdown
# <Project> — Design System

_Derived from UR_PLAN.md — {today}_

## Target feel

(3-line positioning statement + adjective set, per Step 2.)

## Colour palette

Not hex codes yet — families and roles. Hex comes during implementation.

- **Primary** — role: main brand action. Family: <e.g., "deep indigo", "forest green", "flame orange">.
- **Secondary** — role. Family.
- **Neutral scale** — greyscale. How many steps (e.g., 50, 100, 200, 300, 500, 700, 900)? Warm-cast, cool-cast, or pure grey?
- **Semantic** — success / warning / error / info. Each: role + family.
- **Surface layers** — background / elevated surface / overlay. If three layers are too many for the product, say so.

**Dark mode:** stance — supported from day one / eventually / not / system-preference-only. If supported, the palette section lists both tones per role.

**Contrast baseline** — WCAG AA (4.5:1 text, 3:1 UI) / AAA (7:1). All token pairs (text on background, button on surface) must hit this — verify during implementation.

## Typography

- **Typeface(s)** — primary (UI + body), secondary (optional, for display or code). Name the concrete fonts or font categories (humanist sans-serif / grotesque / serif / mono).
- **Scale** — number of steps (e.g., xs / sm / base / lg / xl / 2xl). Ratio (e.g., 1.2 minor third, 1.25 major third, 1.333 perfect fourth).
- **Weight usage** — which weights, and what each signals (regular = body, medium = UI text, semibold = headings, bold = emphasis).
- **Line-height pairs** — one for body (1.5–1.7), one for headings (1.1–1.3).

## Spacing scale

Numeric scale (4 / 8 / 12 / 16 / 24 / 32 / 48 / 64 …) or named (xs / s / m / l / xl). Base unit (4px? 8px?). How it applies: padding, margins, gap. One scale, not two.

## Shapes & radius

- **Border-radius scale** — none / small / medium / full. When each applies (buttons, cards, inputs, avatars).
- **Stroke / border weight** — default hairline, emphasis heavier.
- **Shadows** — depth scale (none / sm / md / lg) — role per depth (surface elevation, overlay, toast). Skip if the aesthetic is flat.

## Motion

- **Duration scale** — instant / short / medium / long (e.g., 0 / 150 / 250 / 400 ms).
- **Easing** — default easing curves. One or two, not five.
- **Motion categories** — state transitions (hover, focus), layout changes (modal open, list add/remove), attention (toast appear). Per category: duration + easing.
- **Reduced-motion** — respect `prefers-reduced-motion`. Skip all attention motions when set.

## Iconography

- **Style** — outlined / filled / duotone / mixed. Pick one as default.
- **Source** — library name (Lucide, Phosphor, Heroicons, custom set).
- **Size scale** — matches the spacing scale; usually 16 / 20 / 24 px.
- **Colour usage** — inherit from surrounding text or always a specific token.

## Component visual language

Per major component (button, input, card, modal, table, navigation): the *visual* decisions, not the implementation.

- **Button** — variants (primary / secondary / ghost / destructive), padding, corner radius, hover/pressed/disabled states.
- **Input** — bordered / underlined / filled, label position, error state, focus ring.
- **Card** — surface layer, padding, radius, border vs shadow.
- **Modal / overlay** — scrim darkness, enter/exit motion, max-width.
- **Navigation** — sidebar / top-bar / bottom-bar, active-state treatment.

Don't enumerate every component — cover the primitives that set the tone; derivatives inherit.

## Accessibility baseline

- Contrast: hit WCAG AA (or the stated mandate) for text, UI, and graphics. State ratio targets.
- Focus: every interactive element has a visible focus ring. Describe it (e.g., 2px offset, primary colour).
- Keyboard: Tab/Shift-Tab covers everything; no mouse-only actions.
- Screen readers: landmarks (header/nav/main/footer) present; live regions for dynamic content.

## Tokens (naming)

A suggested token namespace. Per category: prefix + structure.

- `color.bg.{surface|elevated|overlay}`
- `color.text.{primary|secondary|muted|inverse}`
- `color.border.{default|strong|subtle}`
- `color.accent.{primary|secondary|success|warning|danger|info}`
- `space.{xs|s|m|l|xl|2xl|3xl}`
- `font.size.{xs|sm|base|lg|xl|2xl|3xl}`
- `font.weight.{regular|medium|semibold|bold}`
- `radius.{none|sm|md|lg|full}`
- `shadow.{none|sm|md|lg}`
- `duration.{instant|short|medium|long}`
- `easing.{standard|decelerate|accelerate}`

Names are suggestions; the project picks the exact shape but stays consistent once chosen.

## Open questions

Design unknowns needing user or external design review.
```

### Step 4 — Dispatch challenger trio (design-specific lenses)

For design-system work, the standard security/performance combo is less useful than UX + accessibility. Dispatch:

- `challenger-ux` — target-feel coherence, component states, feedback / empty / first-time-experience patterns.
- `challenger-accessibility` — contrast numbers vs mandate, focus-ring spec, colour-as-signal, motion/reduced-motion, typography legibility.
- `challenger-maintainability` — token naming that'll drift, too many component variants, escape hatches that'll multiply.

Synthesise into `## Challenger pushback`. If the project has strong security or performance implications for visuals (e.g., 3rd-party typeface hosting, CSS injection surface), additionally dispatch `challenger-security` and `challenger-performance`.

### Step 5 — Present & pause

Show:

1. Target-feel statement + the palette roles (not hex) + typography choice.
2. Top three challenger concerns.
3. Question: "Proceed to frontend-plan, or adjust tokens / visual direction?"

## Invariants

- **Feel before numbers.** The positioning statement drives every later decision. Without it, the palette is arbitrary.
- **Token names are a contract, not a style.** Once named, they don't get renamed during implementation — that's breaking change for every downstream reference.
- **Dark mode is declared, not silent.** The stance (yes / later / no) is in the document. "We'll see" is not a stance.
- **Accessibility baseline is numeric.** "Accessible" alone is too vague; contrast targets and focus-ring specifics are required.
- **No hex yet.** The implementation phase picks concrete values; the plan names the families and roles.
