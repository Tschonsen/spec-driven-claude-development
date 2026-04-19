---
title: Install
layout: default
nav_order: 2
permalink: /install
---

# Install

SDCD comes in two layers. You can install the core rules alone, or the rules plus the plugin.

## Layer 1 — Core rules (every install gets these)

The core rules at `~/.claude/CLAUDE.md` are loaded in every Claude Code session automatically. That makes the §1 discipline opt-out, not opt-in — which is the point.

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

The installer:

- Backs up any existing `~/.claude/CLAUDE.md` or `~/.claude/methodology.md` to `.bak` files.
- Copies `CLAUDE.md` and `methodology.md` into `~/.claude/`.
- Does **not** touch project-specific files. Each project is still free to add its own `<project>/CLAUDE.md`.

After this, every Claude Code session you start will have the §1 rules loaded. That is the minimum viable SDCD install.

## Layer 2 — The plugin (optional but recommended for serious projects)

The plugin bundles the methodology as namespaced slash-commands (`/sdcd:*`) and specialised subagents. You can use SDCD without it — but you'll manually do what the plugin automates.

### Testing the plugin locally

```bash
claude --plugin-dir path/to/spec-driven-claude-development/plugin/sdcd
```

Then in a Claude Code session:

```
/plugins
```

You should see `sdcd` listed with its 11 skills and 8 subagents.

### Installing the plugin persistently

Once you are happy with the behaviour, install the plugin into your Claude Code config:

```bash
claude plugin install ./plugin/sdcd
```

Verify:

```bash
claude plugin list
```

The plugin will now be available in every session without the `--plugin-dir` flag.

## Verifying the install

In a new Claude Code session, check that §1.6 (Brain Files) is loaded:

> Ask Claude: "Show me §1.6 from the core rules."

You should get the Brain-File convention text back. If Claude has no idea what §1.6 is, the install did not land; check the installer output.

If the plugin is installed, try:

```
/sdcd:new-project
```

Claude should recognise the skill and ask for the project intent.

## Uninstalling

### Core rules

```bash
rm ~/.claude/CLAUDE.md ~/.claude/methodology.md
# restore your backups if you had them:
mv ~/.claude/CLAUDE.md.bak ~/.claude/CLAUDE.md
mv ~/.claude/methodology.md.bak ~/.claude/methodology.md
```

### Plugin

```bash
claude plugin uninstall sdcd
```

## Updating

From the repo checkout:

```bash
git pull
./install.sh   # or install.ps1 on Windows
claude plugin update sdcd
```

The installer always creates fresh `.bak` copies before overwriting, so you can roll back if an update breaks your workflow.

## Customisation

SDCD is opinionated, but it is not yours until you fork it. Two paths:

- **Fork and edit** — clone your own copy, change rules to match your style, install from your fork.
- **Project-level overrides** — keep the user-level SDCD as-is, override specific rules in `<project>/CLAUDE.md`. Every project can declare its own state-file tier and opt out of specific rules with a reason.
