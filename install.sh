#!/usr/bin/env bash
# Spec-Driven Claude Development — Installer (macOS/Linux)
# Backs up any existing ~/.claude/CLAUDE.md and ~/.claude/methodology.md,
# then copies SDCD files into ~/.claude/.

set -euo pipefail

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$CLAUDE_DIR"

backup_and_copy() {
    local src_name="$1"
    local src="$SCRIPT_DIR/$src_name"
    local dst="$CLAUDE_DIR/$src_name"
    if [[ -f "$dst" ]]; then
        cp "$dst" "$dst.bak"
        echo "Backed up existing $src_name -> $dst.bak"
    fi
    cp "$src" "$dst"
    echo "Installed $src_name -> $dst"
}

backup_and_copy "CLAUDE.md"
backup_and_copy "methodology.md"

echo ""
echo "SDCD installed. Start a new Claude Code session to pick up the rules."
echo "The methodology file is read on demand - Claude will consult it when relevant."
