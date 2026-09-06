# sabotage-loop.ps1
# Project 7: Break It on Purpose
#
# This script deliberately breaks the morning-brief loop, in a
# controlled and reversible way, so you can rehearse diagnosing a
# failure from the log and progress.md alone.
#
# It reads config\sabotage-config.json to decide:
#   sabotageEnabled - must be true, or this script refuses to run
#   method          - either missingFile or impossibleCondition
#   maxAttempts     - a small positive number, so this can NEVER
#                     run forever
#
# This script only calls scripts\morning-brief.ps1 in this same
# project folder. It does not touch any file outside this project,
# does not call the network, and does not call any AI model.

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$SabotageConfigPath = Join-Path $ProjectRoot "config\sabotage-config.json"
$MorningBriefScript = Join-Path $PSScriptRoot "morning-brief.ps1"

if (-not (Test-Path $SabotageConfigPath)) {
    Write-Host "[MISSING] config\sabotage-config.json - cannot continue."
    exit 1
}

$Config = Get-Content $SabotageConfigPath -Raw | ConvertFrom-Json

if (-not $Config.sabotageEnabled) {
    Write-Host "Sabotage is disabled in config\sabotage-config.json."
    Write-Host "Set sabotageEnabled to true and choose a method to run this exercise."
    exit 0
}

$Method = $Config.method
$MaxAttempts = [int]$Config.maxAttempts

if ($MaxAttempts -lt 1) {
    Write-Host "maxAttempts must be at least 1. Fix config\sabotage-config.json."
    exit 1
}

if ($Method -ne "missingFile" -and $Method -ne "impossibleCondition") {
    Write-Host "Unknown method in config\sabotage-config.json. Use missingFile or impossibleCondition."
    exit 1
}

Write-Host "=========================================================="
Write-Host " Sabotage exercise starting"
Write-Host " Method: $Method"
Write-Host " Max attempts: $MaxAttempts"
Write-Host "=========================================================="

for ($Attempt = 1; $Attempt -le $MaxAttempts; $Attempt++) {

    Write-Host ""
    Write-Host ("Attempt " + $Attempt + " of " + $MaxAttempts + " ...")

    & $MorningBriefScript -Mode "sabotage" -SabotageMethod $Method -Attempt $Attempt -MaxAttempts $MaxAttempts

    if ($Attempt -eq $MaxAttempts) {
        Write-Host ""
        Write-Host "Maximum attempt limit reached. Stopping the loop now."
        Write-Host "Check logs\loop.log and progress.md for the failure details."
    }
}

Write-Host ""
Write-Host "=========================================================="
Write-Host " Sabotage exercise finished after $MaxAttempts attempt(s)."
Write-Host " The loop did NOT run forever, as designed."
Write-Host "=========================================================="