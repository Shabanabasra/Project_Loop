# setup-check.ps1
# Project 10: The Secrets Drill
#
# Verifies that all required project files exist. This does NOT
# require CCR, Claude Code, OpenCode, GitHub, or internet access, and
# it never reads or prints any real secret value.

$ProjectRoot = Split-Path -Parent $PSScriptRoot

$RequiredFiles = @(
    "README.md",
    ".gitignore",
    ".env.example",
    "routine-prompt.md",
    "config\routine-config.json",
    "transcripts\README.md",
    "transcripts\failed-env-file-run.md",
    "transcripts\successful-environment-run.md",
    "reports\failure-report.md",
    "reports\success-report.md",
    "reports\comparison-report.md",
    "evidence\README.md",
    "skills\secrets-drill-skill.md",
    "reviewers\secrets-drill-reviewer.md",
    "scripts\setup-check.ps1",
    "scripts\simulate-env-failure.ps1",
    "scripts\simulate-environment-success.ps1",
    "scripts\compare-runs.ps1",
    "scripts\read-transcript.ps1"
)

Write-Host "=========================================================="
Write-Host " Project 10: The Secrets Drill - Setup Check"
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