# setup-check.ps1
# Project 11: Build the Two-Routine Gate
#
# Verifies that all required project files exist. This does NOT
# require CCR, Claude Code, OpenCode, GitHub, or internet access, and
# never reads or prints any credential.

$ProjectRoot = Split-Path -Parent $PSScriptRoot

$RequiredFiles = @(
    "README.md",
    ".gitignore",
    "routine-implementer-prompt.md",
    "routine-reviewer-prompt.md",
    "issue-template.md",
    "review-checklist.md",
    "config\implementer-config.json",
    "config\reviewer-config.json",
    "issues\README.md",
    "issues\issue-001.md",
    "issues\issue-002.md",
    "issues\issue-003.md",
    "transcripts\README.md",
    "transcripts\implementer-run-001.md",
    "transcripts\implementer-run-002.md",
    "transcripts\implementer-run-003.md",
    "transcripts\reviewer-run-001.md",
    "transcripts\reviewer-run-002.md",
    "transcripts\reviewer-run-003.md",
    "reports\implementer-report.md",
    "reports\reviewer-report.md",
    "reports\gate-report.md",
    "evidence\README.md",
    "evidence\implementer-evidence.md",
    "evidence\reviewer-evidence.md",
    "evidence\gate-evidence.md",
    "skills\implementer-skill.md",
    "skills\reviewer-skill.md",
    "reviewers\two-routine-gate-reviewer.md",
    "scripts\setup-check.ps1",
    "scripts\simulate-implementer.ps1",
    "scripts\simulate-reviewer.ps1",
    "scripts\compare-gate.ps1",
    "scripts\read-transcript.ps1"
)

Write-Host "=========================================================="
Write-Host " Project 11: Build the Two-Routine Gate - Setup Check"
Write-Host "=========================================================="

$AllFound = $true

foreach ($RelativePath in $RequiredFiles) {
    $FullPath = Join-Path $ProjectRoot $RelativePath

    if (Test-Path -LiteralPath $FullPath -PathType Leaf) {
        Write-Host "[OK] $RelativePath"
    }
    else {
        Write-Host "[MISSING] $RelativePath"
        $AllFound = $false
    }
}

Write-Host "=========================================================="

if ($AllFound) {
    Write-Host "SETUP CHECK: PASS"
    exit 0
}
else {
    Write-Host "SETUP CHECK: FAIL"
    exit 1
}