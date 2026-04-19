# Spec-Driven Claude Development — Installer (Windows)
# Backs up any existing ~/.claude/CLAUDE.md and ~/.claude/methodology.md,
# then copies SDCD files into ~/.claude/.

$ErrorActionPreference = "Stop"

$claudeDir = Join-Path $env:USERPROFILE ".claude"
$scriptDir = $PSScriptRoot

if (-not (Test-Path $claudeDir)) {
    New-Item -Path $claudeDir -ItemType Directory | Out-Null
    Write-Host "Created $claudeDir"
}

function BackupAndCopy($srcName) {
    $src = Join-Path $scriptDir $srcName
    $dst = Join-Path $claudeDir $srcName
    if (Test-Path $dst) {
        $bak = "$dst.bak"
        Copy-Item $dst $bak -Force
        Write-Host "Backed up existing $srcName -> $bak"
    }
    Copy-Item $src $dst -Force
    Write-Host "Installed $srcName -> $dst"
}

BackupAndCopy "CLAUDE.md"
BackupAndCopy "methodology.md"

Write-Host ""
Write-Host "SDCD installed. Start a new Claude Code session to pick up the rules."
Write-Host "The methodology file is read on demand - Claude will consult it when relevant."
