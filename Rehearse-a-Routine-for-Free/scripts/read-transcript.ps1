# read-transcript.ps1
# Project 9: Rehearse a Routine for Free
#
# Lets you select and read one of the two transcripts. Works completely
# offline, no external tools required.

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$SuccessTranscript = Join-Path $ProjectRoot "transcripts\successful-run.md"
$FailureTranscript = Join-Path $ProjectRoot "transcripts\failed-run.md"

Write-Host "=========================================================="
Write-Host " Read Transcript"
Write-Host "=========================================================="
Write-Host "1. Read successful-run.md"
Write-Host "2. Read failed-run.md"
Write-Host "3. Read both"
Write-Host ""

$Choice = Read-Host "Choose an option (1-3)"

if ($Choice -eq "1") {
    if (Test-Path $SuccessTranscript) {
        Get-Content $SuccessTranscript
    }
    else {
        Write-Host "[MISSING] transcripts\successful-run.md - run scripts\simulate-success.ps1 first."
    }
}
elseif ($Choice -eq "2") {
    if (Test-Path $FailureTranscript) {
        Get-Content $FailureTranscript
    }
    else {
        Write-Host "[MISSING] transcripts\failed-run.md - run scripts\simulate-failure.ps1 first."
    }
}
elseif ($Choice -eq "3") {
    Write-Host ""
    Write-Host "---------- SUCCESSFUL RUN ----------"
    if (Test-Path $SuccessTranscript) {
        Get-Content $SuccessTranscript
    }
    else {
        Write-Host "[MISSING] transcripts\successful-run.md"
    }

    Write-Host ""
    Write-Host "---------- FAILED RUN ----------"
    if (Test-Path $FailureTranscript) {
        Get-Content $FailureTranscript
    }
    else {
        Write-Host "[MISSING] transcripts\failed-run.md"
    }
}
else {
    Write-Host "Invalid choice. Please run this script again and choose 1, 2, or 3."
}