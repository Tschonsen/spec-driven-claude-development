# {{project_name}} — project rules

This project follows **Spec-Driven Claude Development (SDCD)**. Core rules live at `~/.claude/CLAUDE.md`; procedural detail at `~/.claude/methodology.md`. Project-specific extensions below.

## State hygiene tier

- **Tier:** Serious project (§1.5)
- **Files:** `design/CURRENT_STATE.md` (mandatory, read first at session start)
- Upgrade to Larger tier (add `ARCHITECTURE.md`) once the code crosses ~10–15 files.

## Stack

- **Language:** {{stack}}
- **Entry point:** <fill in once the first source file exists>

## Project-specific rules

- (Add rules that only apply to this project. Example: "all CLI output goes through a single formatter to keep test-capture easy.")

## Brain files

Per §1.6, every source file gets a `.brain` sibling. Skip for files under ~10 non-whitespace chars or generated code.
