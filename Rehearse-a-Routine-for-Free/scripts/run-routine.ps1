# run-routine.ps1
# Project 9: Rehearse a Routine for Free
#
# Simple offline menu that ties together the other scripts in this
# project. No AI model, API, or network access is used anywhere here.

$ScriptsDir = $PSScriptRoot

Write-Host "=========================================================="
Write-Host " Project 9: Rehearse a Routine for Free - Menu"
Write-Host "=========================================================="
Write-Host "1. Run successful Routine"
Write-Host "2. Run deliberately failed Routine"
Write-Host "3. Read successful transcript"
Write-Host "4. Read failed transcript"
Write-Host "5. Compare both runs"
Write-Host "6. Exit"
Write-Host ""

$Choice = Read-Host "Choose an option (1-6)"

if ($Choice -eq "1") {
    & (Join-Path $ScriptsDir "simulate-success.ps1")
}
elseif ($Choice -eq "2") {
    & (Join-Path $ScriptsDir "simulate-failure.ps1")
}
elseif ($Choice -eq "3") {
    $TranscriptPath = Join-Path (Split-Path -Parent $ScriptsDir) "transcripts\successful-run.md"
    if (Test-Path $TranscriptPath) {
        Get-Content $TranscriptPath
    }
    else {
        Write-Host "[MISSING] transcripts\successful-run.md - run option 1 first."
    }
}
elseif ($Choice -eq "4") {
    $TranscriptPath = Join-Path (Split-Path -Parent $ScriptsDir) "transcripts\failed-run.md"
    if (Test-Path $TranscriptPath) {
        Get-Content $TranscriptPath
    }
    else {
        Write-Host "[MISSING] transcripts\failed-run.md - run option 2 first."
    }
}
elseif ($Choice -eq "5") {
    & (Join-Path $ScriptsDir "compare-runs.ps1")
}
elseif ($Choice -eq "6") {
    Write-Host "Exiting."
}
else {
    Write-Host "Invalid choice. Please run this script again and choose 1 through 6."
}