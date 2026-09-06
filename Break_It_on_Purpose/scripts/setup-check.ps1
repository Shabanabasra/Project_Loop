# setup-check.ps1
# Project 7: Break It on Purpose
#
# Verifies that all required project files exist. This does NOT require
# CCR, Claude Code, OpenCode, GitHub, or internet access. It only checks
# the local file system.

$ProjectRoot = Split-Path -Parent $PSScriptRoot

$RequiredFiles = @(
    "README.md",
    "progress.md",
    "source-data.txt",
    "logs\loop.log",
    "scripts\morning-brief.ps1",
    "scripts\sabotage-loop.ps1",
    "scripts\diagnose-failure.ps1",
    "scripts\estimate-cost.ps1",
    "scripts\setup-check.ps1",
    "config\loop-config.json",
    "config\sabotage-config.json",
    "reports\cost-report.md",
    "reports\diagnosis-report.md",
    "evidence\README.md",
    "skills\morning-brief-skill.md",
    "skills\observability-skill.md",
    "reviewers\failure-reviewer.md"
)

Write-Host "=========================================================="
Write-Host " Project 7: Break It on Purpose - Setup Check"
Write-Host "=========================================================="

$AllFound = $true

foreach ($RelativePath in $RequiredFiles) {
    $FullPath = Join-Path $ProjectRoot $RelativePath

    if (Test-Path $FullPath) {
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