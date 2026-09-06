# setup-check.ps1
# Project 9: Rehearse a Routine for Free
#
# Verifies that all required project files exist. This does NOT
# require CCR, Claude Code, OpenCode, GitHub, or internet access.

$ProjectRoot = Split-Path -Parent $PSScriptRoot

$RequiredFiles = @(
    "README.md",
    "routine-prompt.md",
    "transcripts\README.md",
    "transcripts\successful-run.md",
    "transcripts\failed-run.md",
    "config\routine-config.json",
    "candidates\yesterday-commits.txt",
    "reports\success-report.md",
    "reports\failure-report.md",
    "reports\comparison-report.md",
    "evidence\README.md",
    "skills\routine-rehearsal-skill.md",
    "reviewers\routine-reviewer.md",
    "scripts\setup-check.ps1",
    "scripts\run-routine.ps1",
    "scripts\simulate-success.ps1",
    "scripts\simulate-failure.ps1",
    "scripts\read-transcript.ps1",
    "scripts\compare-runs.ps1"
)

Write-Host "=========================================================="
Write-Host " Project 9: Rehearse a Routine for Free - Setup Check"
Write-Host "=========================================================="

$AllFound = $true

foreach ($RelativePath in $RequiredFiles) {
    $FullPath = Join-Path $ProjectRoot $RelativePath

    if (Test-Path $FullPath -PathType Leaf) {
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
}
else {
    Write-Host "SETUP CHECK: FAIL"
}

Write-Host "=========================================================="