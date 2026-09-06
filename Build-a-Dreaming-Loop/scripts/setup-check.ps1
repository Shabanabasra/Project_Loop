# setup-check.ps1
# Project 12: Build a Dreaming Loop
#
# Verifies that all required project files exist. This does NOT
# require CCR, Claude Code, OpenCode, GitHub, or internet access, and
# never reads or prints any credential.

$ProjectRoot = Split-Path -Parent $PSScriptRoot

$RequiredFiles = @(
    "README.md",
    ".gitignore",
    "progress.md",
    "dreaming-state.md",
    "dream-loop-prompt.md",
    "improvement-rules.md",
    "config\dreaming-config.json",
    "logs\README.md",
    "logs\week-001.md",
    "logs\week-002.md",
    "logs\week-003.md",
    "transcripts\README.md",
    "transcripts\dreaming-run-001.md",
    "reports\dreaming-report.md",
    "reports\evidence-report.md",
    "reports\gate-report.md",
    "evidence\README.md",
    "evidence\planted-failure-evidence.md",
    "evidence\evidence-citations.md",
    "skills\dreaming-loop-skill.md",
    "reviewers\dreaming-loop-reviewer.md",
    "scripts\setup-check.ps1",
    "scripts\plant-test-failure.ps1",
    "scripts\simulate-dreaming-loop.ps1",
    "scripts\validate-evidence.ps1",
    "scripts\compare-gate.ps1",
    "scripts\read-transcript.ps1"
)

Write-Host "=========================================================="
Write-Host " Project 12: Build a Dreaming Loop - Setup Check"
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