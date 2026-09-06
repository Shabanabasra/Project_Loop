# setup-check.ps1
# Project 8: Your Own Daily Loop
#
# Verifies that all required project files and folders exist. This does
# NOT require CCR, Claude Code, OpenCode, GitHub, or internet access.

$ProjectRoot = Split-Path -Parent $PSScriptRoot

$RequiredFiles = @(
    "README.md",
    "progress.md",
    "source-data.txt",
    "config\loop-config.json",
    "config\budget-config.json",
    "config\connector-config.json",
    "logs\loop.log",
    "reports\dependency-audit.md",
    "reports\reviewer-report.md",
    "reports\concept-15-review.md",
    "reports\cost-report.md",
    "evidence\README.md",
    "skills\dependency-audit-skill.md",
    "skills\reviewer-skill.md",
    "reviewers\dependency-reviewer.md",
    "scripts\setup-check.ps1",
    "scripts\daily-loop.ps1",
    "scripts\heartbeat.ps1",
    "scripts\create-workspace.ps1",
    "scripts\implementer.ps1",
    "scripts\reviewer.ps1",
    "scripts\update-spine.ps1",
    "scripts\budget-check.ps1",
    "scripts\diagnose-failure.ps1",
    "scripts\estimate-cost.ps1"
)

$RequiredFolders = @(
    "workspaces"
)

Write-Host "=========================================================="
Write-Host " Project 8: Your Own Daily Loop - Setup Check"
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

foreach ($RelativeFolder in $RequiredFolders) {
    $FullFolder = Join-Path $ProjectRoot $RelativeFolder

    if (Test-Path $FullFolder -PathType Container) {
        Write-Host "[OK] $RelativeFolder\ (folder)"
    }
    else {
        Write-Host "[MISSING] $RelativeFolder\ (folder)"
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