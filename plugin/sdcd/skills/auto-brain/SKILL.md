---
name: auto-brain
description: Write or refresh the `<file>.brain` summary for a source file Claude just created or edited. Use this whenever editing a source file in an SDCD project — brain files keep session context small by letting the next reader (Claude or human) grasp the file without opening the source.
---

# auto-brain

## When to use

- Claude just created or significantly edited a source file (code, not text/docs).
- A `.brain` sibling file is missing or stale relative to the source.
- The project follows SDCD conventions — look for `CLAUDE.md` referencing "brain files" or a `.spec/` directory.

Do **not** use for:

- Tiny or nearly-empty files (< 10 non-whitespace chars — there's nothing to summarise).
- Generated/vendored code.
- Files outside the project root.

## How to use

A brain file lives at `<source>.brain` — inline sibling, not a mirror tree. Example: `src/auth/login.ts` → `src/auth/login.ts.brain`.

Format: YAML frontmatter + five Markdown sections in fixed order. Every section must have at least one line of text; use `_None._` (italicised, not a bullet) when truly empty.

```markdown
---
source: src/auth/login.ts
source_hash: sha256:<64-hex>
model: claude-inline
generated_at: 2026-04-19T12:34:56Z
---

## Purpose

One to two sentences: what this file does in the project.

## Key exports

- `exportName` — one-line description. Name only, no signatures, no parameter lists.

## Collaborators

- `path/to/file.ext` — how it's coupled (imports from, is imported by). Project-internal only; skip stdlib and framework imports.

## Gotchas

- Non-obvious behaviour, invariants, or bugs a reader would miss from signatures alone.

## Conventions

- Code style in this file — async/sync, error-handling, naming, typing. NOT the shape of data the file produces.
```

## Procedure

1. Compute SHA256 of the source file bytes. Format as `sha256:<64 hex chars>`.
2. Look at the top of the source: import statements drive Collaborators.
3. Scan the file for top-level exports — only the ones a caller would reach for. Private helpers don't count.
4. Write the brain file at `<source>.brain` with UTF-8 encoding.
5. Use `claude-inline` as the `model` value (distinguishes from CodeBrain-generated brains which use the model name).
6. If a CodeBrain MCP server is configured in the session (`codebrain_scan_file` tool available), prefer calling it — CodeBrain has a retry/validate loop. Only fall back to inline writing when CodeBrain is not available.

## Invariants

- Frontmatter keys are exactly `source`, `source_hash`, `model`, `generated_at` — all five brain-file consumers parse these.
- Section headers are exact: `## Purpose`, `## Key exports`, `## Collaborators`, `## Gotchas`, `## Conventions`.
- Order is fixed. Section bodies are non-empty (use `_None._` when needed).
- `source_hash` is content-only SHA256 — whitespace-only edits do not change the hash.
