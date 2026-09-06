# read-transcript.ps1
# Project 12: Build a Dreaming Loop
#
# Displays transcripts and evidence. Supports:
#   .\read-transcript.ps1 dreaming
#   .\read-transcript.ps1 evidence
#   .\read-transcript.ps1 all
# If no argument is given, shows a menu instead.

param(
    [Parameter(Position = 0)]
    [string]$Which = ""
)

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$DreamingTranscriptPath = Join-Path $ProjectRoot "transcripts\dreaming-run-001.md"
$EvidenceReportPath = Join-Path $ProjectRoot "reports\evidence-report.md"
$PlantedEvidencePath = Join-Path $ProjectRoot "evidence\planted-failure-evidence.md"
$CitationsPath = Join-Path $ProjectRoot "evidence\evidence-citations.md"

function Show-FileOrMissing {
    param(
        [string]$Path,
        [string]$Label
    )

    Write-Host ""
    Write-Host ("---------- " + $Label + " ----------")
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        Get-Content -LiteralPath $Path
    }
    else {
        Write-Host ("[MISSING] " + $Path)
    }
}

function Show-Dreaming {
    Show-FileOrMissing -Path $DreamingTranscriptPath -Label "transcripts\dreaming-run-001.md"
}

function Show-Evidence {
    Show-FileOrMissing -Path $EvidenceReportPath -Label "reports\evidence-report.md"
    Show-FileOrMissing -Path $PlantedEvidencePath -Label "evidence\planted-failure-evidence.md"
    Show-FileOrMissing -Path $CitationsPath -Label "evidence\evidence-citations.md"
}

$Normalized = $Which.Trim().ToLower()

if ($Normalized -eq "dreaming") {
    Show-Dreaming
}
elseif ($Normalized -eq "evidence") {
    Show-Evidence
}
elseif ($Normalized -eq "all") {
    Show-Dreaming
    Show-Evidence
}
elseif ($Normalized -eq "") {
    Write-Host "=========================================================="
    Write-Host " Read Transcript"
    Write-Host "=========================================================="
    Write-Host "1. Read the dreaming run transcript"
    Write-Host "2. Read the evidence files"
    Write-Host "3. Read everything"
    Write-Host ""

    $Choice = Read-Host "Choose an option (1-3)"

    if ($Choice -eq "1") {
        Show-Dreaming
    }
    elseif ($Choice -eq "2") {
        Show-Evidence
    }
    elseif ($Choice -eq "3") {
        Show-Dreaming
        Show-Evidence
    }
    else {
        Write-Host "Invalid choice. Please run this script again and choose 1, 2, or 3."
    }
}
else {
    Write-Host ("Unrecognized argument: " + $Which)
    Write-Host "Usage:"
    Write-Host "  .\read-transcript.ps1 dreaming"
    Write-Host "  .\read-transcript.ps1 evidence"
    Write-Host "  .\read-transcript.ps1 all"
    Write-Host "  .\read-transcript.ps1        (shows a menu)"
}