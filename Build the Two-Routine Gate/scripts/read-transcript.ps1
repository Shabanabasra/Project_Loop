# read-transcript.ps1
# Project 11: Build the Two-Routine Gate
#
# Displays transcripts. Supports:
#   .\read-transcript.ps1 implementer
#   .\read-transcript.ps1 reviewer
#   .\read-transcript.ps1 all
# If no argument is given, shows a menu instead.

param(
    [Parameter(Position = 0)]
    [string]$Which = ""
)

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$TranscriptsDir = Join-Path $ProjectRoot "transcripts"
$IssueNumbers = @("001", "002", "003")

function Show-ImplementerTranscripts {
    foreach ($IssueNumber in $IssueNumbers) {
        $Path = Join-Path $TranscriptsDir ("implementer-run-" + $IssueNumber + ".md")
        Write-Host ""
        Write-Host ("---------- implementer-run-" + $IssueNumber + ".md ----------")
        if (Test-Path -LiteralPath $Path -PathType Leaf) {
            Get-Content -LiteralPath $Path
        }
        else {
            Write-Host ("[MISSING] transcripts\implementer-run-" + $IssueNumber + ".md")
        }
    }
}

function Show-ReviewerTranscripts {
    foreach ($IssueNumber in $IssueNumbers) {
        $Path = Join-Path $TranscriptsDir ("reviewer-run-" + $IssueNumber + ".md")
        Write-Host ""
        Write-Host ("---------- reviewer-run-" + $IssueNumber + ".md ----------")
        if (Test-Path -LiteralPath $Path -PathType Leaf) {
            Get-Content -LiteralPath $Path
        }
        else {
            Write-Host ("[MISSING] transcripts\reviewer-run-" + $IssueNumber + ".md")
        }
    }
}

$Normalized = $Which.Trim().ToLower()

if ($Normalized -eq "implementer") {
    Show-ImplementerTranscripts
}
elseif ($Normalized -eq "reviewer") {
    Show-ReviewerTranscripts
}
elseif ($Normalized -eq "all") {
    Show-ImplementerTranscripts
    Show-ReviewerTranscripts
}
elseif ($Normalized -eq "") {
    Write-Host "=========================================================="
    Write-Host " Read Transcript"
    Write-Host "=========================================================="
    Write-Host "1. Read all implementer transcripts"
    Write-Host "2. Read all reviewer transcripts"
    Write-Host "3. Read all transcripts"
    Write-Host ""

    $Choice = Read-Host "Choose an option (1-3)"

    if ($Choice -eq "1") {
        Show-ImplementerTranscripts
    }
    elseif ($Choice -eq "2") {
        Show-ReviewerTranscripts
    }
    elseif ($Choice -eq "3") {
        Show-ImplementerTranscripts
        Show-ReviewerTranscripts
    }
    else {
        Write-Host "Invalid choice. Please run this script again and choose 1, 2, or 3."
    }
}
else {
    Write-Host ("Unrecognized argument: " + $Which)
    Write-Host "Usage:"
    Write-Host "  .\read-transcript.ps1 implementer"
    Write-Host "  .\read-transcript.ps1 reviewer"
    Write-Host "  .\read-transcript.ps1 all"
    Write-Host "  .\read-transcript.ps1        (shows a menu)"
}