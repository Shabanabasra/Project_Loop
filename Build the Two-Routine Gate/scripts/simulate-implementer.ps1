# simulate-implementer.ps1
# Project 11: Build the Two-Routine Gate
#
# Simulates the IMPLEMENTER Routine across all three labeled test
# issues, one independent run per issue. This is a LOCAL SIMULATION
# only: no real GitHub issue, branch, or pull request is created. It
# never calls any AI model, API, or the network, and never claims a
# real GitHub action occurred.

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$IssuesDir = Join-Path $ProjectRoot "issues"
$TranscriptsDir = Join-Path $ProjectRoot "transcripts"
$ReportPath = Join-Path $ProjectRoot "reports\implementer-report.md"

$IssueNumbers = @("001", "002", "003")
$StartTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

function Get-FieldValue {
    param(
        [string[]]$Lines,
        [string]$Header
    )

    $Found = $false
    foreach ($Line in $Lines) {
        if ($Found) {
            if ($Line.Trim() -ne "") {
                return $Line.Trim()
            }
        }
        if ($Line.Trim() -eq $Header) {
            $Found = $true
        }
    }
    return "UNKNOWN"
}

Write-Host "=========================================================="
Write-Host " Simulating IMPLEMENTER Routine across labeled issues"
Write-Host "=========================================================="

$SummaryRows = @()

foreach ($IssueNumber in $IssueNumbers) {

    $IssuePath = Join-Path $IssuesDir ("issue-" + $IssueNumber + ".md")

    if (-not (Test-Path -LiteralPath $IssuePath -PathType Leaf)) {
        Write-Host ("[MISSING] issues\issue-" + $IssueNumber + ".md - skipping.")
        continue
    }

    $IssueLines = Get-Content -LiteralPath $IssuePath

    $Title = Get-FieldValue -Lines $IssueLines -Header "## Title"
    $BranchName = Get-FieldValue -Lines $IssueLines -Header "## Expected Branch Name"
    $TestFile = Get-FieldValue -Lines $IssueLines -Header "## Expected Test/Check"

    $RunId = "IMPLEMENTER-RUN-" + $IssueNumber + "-" + (Get-Date -Format "yyyyMMdd-HHmmss")

    Write-Host ("  Selected exactly ONE issue this run: " + $IssueNumber + " - " + $Title)
    Write-Host ("  Simulated branch: " + $BranchName)

    $TranscriptLines = @()
    $TranscriptLines += ("# Implementer Run Transcript - Issue " + $IssueNumber + " (SIMULATED)")
    $TranscriptLines += ""
    $TranscriptLines += ("Run ID: " + $RunId)
    $TranscriptLines += ("Timestamp: " + $StartTime)
    $TranscriptLines += "Trigger: schedule (repeating trigger, this is one firing of many)"
    $TranscriptLines += ""
    $TranscriptLines += "## Issue selected"
    $TranscriptLines += ""
    $TranscriptLines += ("Issue Number: " + $IssueNumber)
    $TranscriptLines += ("Title: " + $Title)
    $TranscriptLines += "Label matched: claude-fix"
    $TranscriptLines += "Selection rule applied: oldest open claude-fix issue with no existing"
    $TranscriptLines += "open PR - exactly ONE issue selected this run."
    $TranscriptLines += ""
    $TranscriptLines += "## Branch created (SIMULATED)"
    $TranscriptLines += ""
    $TranscriptLines += ("Branch name: " + $BranchName)
    $TranscriptLines += "(No real git branch was created. This is a local simulation only.)"
    $TranscriptLines += ""
    $TranscriptLines += "## Work performed (SIMULATED)"
    $TranscriptLines += ""
    $TranscriptLines += "Inspected the issue's description and acceptance criteria. Drafted the"
    $TranscriptLines += "smallest correct fix addressing this issue only. No unrelated files"
    $TranscriptLines += "were touched."
    $TranscriptLines += ""
    $TranscriptLines += "## Tests/checks recorded (SIMULATED)"
    $TranscriptLines += ""
    $TranscriptLines += ("Test file: " + $TestFile)
    $TranscriptLines += "Result recorded: PASS (simulated)"
    $TranscriptLines += ""
    $TranscriptLines += "## Pull request (SIMULATED)"
    $TranscriptLines += ""
    $TranscriptLines += ("A pull request was simulated, referencing issue " + $IssueNumber + ", from branch")
    $TranscriptLines += ($BranchName + ". No real GitHub pull request was opened.")
    $TranscriptLines += ""
    $TranscriptLines += "## Result"
    $TranscriptLines += ""
    $TranscriptLines += "Task Result: PR OPENED (SIMULATED)"
    $TranscriptLines += ""
    $TranscriptLines += "## Role boundaries"
    $TranscriptLines += ""
    $TranscriptLines += "This Routine did NOT review its own work."
    $TranscriptLines += "This Routine did NOT approve its own pull request."
    $TranscriptLines += "This Routine did NOT merge anything."
    $TranscriptLines += ("Grading is exclusively the reviewer Routine's job - see")
    $TranscriptLines += ("transcripts\reviewer-run-" + $IssueNumber + ".md.")

    $TranscriptPath = Join-Path $TranscriptsDir ("implementer-run-" + $IssueNumber + ".md")
    Set-Content -LiteralPath $TranscriptPath -Value $TranscriptLines

    $SummaryRows += ("| " + $IssueNumber + " | " + $Title + " | " + $BranchName + " | Opened |")
}

$ReportLines = @()
$ReportLines += "# Implementer Report - Two-Routine Gate (SIMULATED)"
$ReportLines += ""
$ReportLines += "Generated by scripts\simulate-implementer.ps1. All actions described"
$ReportLines += "below are SIMULATED - no real GitHub issue, branch, or pull request was"
$ReportLines += "created."
$ReportLines += ""
$ReportLines += "## Summary"
$ReportLines += ""
$ReportLines += "Three labeled (claude-fix) issues were processed independently, one per"
$ReportLines += "simulated run:"
$ReportLines += ""
$ReportLines += "| Issue | Title | Branch (simulated) | PR (simulated) |"
$ReportLines += "|-------|-------|----------------------|-------------------|"
foreach ($Row in $SummaryRows) {
    $ReportLines += $Row
}
$ReportLines += ""
$ReportLines += "Each run selected exactly ONE eligible issue, exactly as the"
$ReportLines += "implementer prompt requires - no run touched more than one issue."
$ReportLines += ""
$ReportLines += "## Role boundary confirmation"
$ReportLines += ""
$ReportLines += "In all three runs, the implementer:"
$ReportLines += "- Did NOT review its own work"
$ReportLines += "- Did NOT approve its own pull request"
$ReportLines += "- Did NOT merge anything"
$ReportLines += ""
$ReportLines += "See transcripts\implementer-run-001.md through 003.md for full detail"
$ReportLines += "per run."

Set-Content -LiteralPath $ReportPath -Value $ReportLines

Write-Host ""
Write-Host "Implementer simulation completed for all labeled issues."
Write-Host "Transcripts written to transcripts\implementer-run-*.md"
Write-Host "Report written to reports\implementer-report.md"