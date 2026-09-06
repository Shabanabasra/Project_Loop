# update-spine.ps1
# Project 8: Your Own Daily Loop
#
# Rewrites progress.md (the spine) with the latest run's state, while
# preserving prior run history underneath. This does NOT create a
# separate memory database - progress.md itself is the only memory.

param(
    [Parameter(Mandatory = $true)]
    [string]$RunId,

    [Parameter(Mandatory = $true)]
    [string]$Timestamp,

    [Parameter(Mandatory = $true)]
    [string]$MakerStatus,

    [Parameter(Mandatory = $true)]
    [string]$ReviewerVerdict,

    [Parameter(Mandatory = $true)]
    [string]$NeedsHuman,

    [Parameter(Mandatory = $true)]
    [string]$Reason,

    [Parameter(Mandatory = $true)]
    [string]$NextAction
)

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ProgressPath = Join-Path $ProjectRoot "progress.md"

$HistoryMarker = "## Run History"
$OldHistoryLines = @()

if (Test-Path $ProgressPath) {
    $ExistingContent = Get-Content $ProgressPath -Raw
    $Parts = $ExistingContent -split $HistoryMarker, 2

    if ($Parts.Count -ge 2) {
        $HistoryPart = $Parts[1]
        $CandidateLines = $HistoryPart -split "`r`n"
        foreach ($CandidateLine in $CandidateLines) {
            if ($CandidateLine.Trim() -ne "") {
                $OldHistoryLines += $CandidateLine
            }
        }
    }
}

$NewEntry = "- " + $Timestamp + " | " + $RunId + " | Maker=" + $MakerStatus + " | Reviewer=" + $ReviewerVerdict + " | NeedsHuman=" + $NeedsHuman

$NewFileLines = @()
$NewFileLines += "# Project 8 Progress"
$NewFileLines += ""
$NewFileLines += "## Current State"
$NewFileLines += ""
$NewFileLines += "This file is the spine for the Daily Dependency Audit Loop. It is read"
$NewFileLines += "at the start of every run and rewritten at the end of every run by"
$NewFileLines += "scripts\update-spine.ps1. Do not edit the Run History section by hand."
$NewFileLines += ""
$NewFileLines += "## Latest Run"
$NewFileLines += ""
$NewFileLines += ("Run ID: " + $RunId)
$NewFileLines += ("Timestamp: " + $Timestamp)
$NewFileLines += ("Maker status: " + $MakerStatus)
$NewFileLines += ("Reviewer verdict: " + $ReviewerVerdict)
$NewFileLines += ("Needs Human: " + $NeedsHuman)
$NewFileLines += ("Reason: " + $Reason)
$NewFileLines += ("Next action: " + $NextAction)
$NewFileLines += ""
$NewFileLines += $HistoryMarker
$NewFileLines += $NewEntry

foreach ($OldLine in $OldHistoryLines) {
    $NewFileLines += $OldLine
}

Set-Content -Path $ProgressPath -Value $NewFileLines

Write-Host "  Spine updated: progress.md rewritten with the latest run state."