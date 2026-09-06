# read-transcript.ps1
# Project 10: The Secrets Drill
#
# Displays one of the two transcripts. Supports a positional argument:
#   .\read-transcript.ps1 failed
#   .\read-transcript.ps1 success
# If no argument is given, shows a menu instead. Works completely
# offline, no external tools required.

param(
    [Parameter(Position = 0)]
    [string]$Which = ""
)

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$FailureTranscriptPath = Join-Path $ProjectRoot "transcripts\failed-env-file-run.md"
$SuccessTranscriptPath = Join-Path $ProjectRoot "transcripts\successful-environment-run.md"

function Show-FailureTranscript {
    if (Test-Path -LiteralPath $FailureTranscriptPath -PathType Leaf) {
        Get-Content -LiteralPath $FailureTranscriptPath
    }
    else {
        Write-Host "[MISSING] transcripts\failed-env-file-run.md - run scripts\simulate-env-failure.ps1 first."
    }
}

function Show-SuccessTranscript {
    if (Test-Path -LiteralPath $SuccessTranscriptPath -PathType Leaf) {
        Get-Content -LiteralPath $SuccessTranscriptPath
    }
    else {
        Write-Host "[MISSING] transcripts\successful-environment-run.md - run scripts\simulate-environment-success.ps1 first."
    }
}

$Normalized = $Which.Trim().ToLower()

if ($Normalized -eq "failed") {
    Show-FailureTranscript
}
elseif ($Normalized -eq "success") {
    Show-SuccessTranscript
}
elseif ($Normalized -eq "") {
    Write-Host "=========================================================="
    Write-Host " Read Transcript"
    Write-Host "=========================================================="
    Write-Host "1. Read failed-env-file-run.md"
    Write-Host "2. Read successful-environment-run.md"
    Write-Host "3. Read both"
    Write-Host ""

    $Choice = Read-Host "Choose an option (1-3)"

    if ($Choice -eq "1") {
        Show-FailureTranscript
    }
    elseif ($Choice -eq "2") {
        Show-SuccessTranscript
    }
    elseif ($Choice -eq "3") {
        Write-Host ""
        Write-Host "---------- FAILED RUN ----------"
        Show-FailureTranscript
        Write-Host ""
        Write-Host "---------- SUCCESSFUL RUN ----------"
        Show-SuccessTranscript
    }
    else {
        Write-Host "Invalid choice. Please run this script again and choose 1, 2, or 3."
    }
}
else {
    Write-Host ("Unrecognized argument: " + $Which)
    Write-Host "Usage:"
    Write-Host "  .\read-transcript.ps1 failed"
    Write-Host "  .\read-transcript.ps1 success"
    Write-Host "  .\read-transcript.ps1        (shows a menu)"
}