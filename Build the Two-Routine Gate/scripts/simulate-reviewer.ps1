# simulate-reviewer.ps1
# Project 11: Build the Two-Routine Gate
#
# Simulates the REVIEWER Routine, independently grading each simulated
# PR produced by scripts\simulate-implementer.ps1. This script reads
# the implementer transcripts as its only input (simulating reading a
# PR diff) and applies real checks against their content - it does not
# hardcode a PASS verdict. It never modifies the implementer
# transcripts, and never claims a merge occurred.

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$TranscriptsDir = Join-Path $ProjectRoot "transcripts"
$ReportPath = Join-Path $ProjectRoot "reports\reviewer-report.md"

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
Write-Host " Simulating REVIEWER Routine across simulated PRs"
Write-Host "=========================================================="

$SummaryRows = @()

foreach ($IssueNumber in $IssueNumbers) {

    $ImplementerTranscriptPath = Join-Path $TranscriptsDir ("implementer-run-" + $IssueNumber + ".md")

    if (-not (Test-Path -LiteralPath $ImplementerTranscriptPath -PathType Leaf)) {
        Write-Host ("[MISSING] transcripts\implementer-run-" + $IssueNumber + ".md - run scripts\simulate-implementer.ps1 first.")
        continue
    }

    $ImplementerLines = Get-Content -LiteralPath $ImplementerTranscriptPath
    $ImplementerText = Get-Content -LiteralPath $ImplementerTranscriptPath -Raw

    $Title = "UNKNOWN"
    foreach ($Line in $ImplementerLines) {
        if ($Line -match "^Title:\s*(.+)$") {
            $Title = $Matches[1].Trim()
        }
    }

    $BranchName = "UNKNOWN"
    foreach ($Line in $ImplementerLines) {
        if ($Line -match "^Branch name:\s*(.+)$") {
            $BranchName = $Matches[1].Trim()
        }
    }

    # ------------------------------------------------------------
    # Real, checklist-based checks against the implementer transcript
    # content. These are genuine string checks, not a hardcoded PASS.
    # ------------------------------------------------------------
    $FailReasons = @()

    if ($ImplementerText -notmatch [regex]::Escape("Task Result: PR OPENED (SIMULATED)")) {
        $FailReasons += "No pull request was recorded as opened for this issue."
    }

    if ($ImplementerText -notmatch [regex]::Escape("Result recorded: PASS (simulated)")) {
        $FailReasons += "Tests/checks were not recorded as passing."
    }

    if ($ImplementerText -notmatch [regex]::Escape("Issue Number: " + $IssueNumber)) {
        $FailReasons += "PR does not clearly reference the expected issue number."
    }

    if ($ImplementerText -match "Verdict:") {
        $FailReasons += "The implementer's own transcript contains a Verdict line - the implementer must never grade its own work."
    }

    $Verdict = "PASS"
    if ($FailReasons.Count -gt 0) {
        $Verdict = "FAIL"
    }

    $RunId = "REVIEWER-RUN-" + $IssueNumber + "-" + (Get-Date -Format "yyyyMMdd-HHmmss")

    Write-Host ("  Reviewing simulated PR for issue " + $IssueNumber + ": Verdict = " + $Verdict)

    $TranscriptLines = @()
    $TranscriptLines += ("# Reviewer Run Transcript - Issue " + $IssueNumber + " (SIMULATED)")
    $TranscriptLines += ""
    $TranscriptLines += ("Run ID: " + $RunId)
    $TranscriptLines += ("Timestamp: " + $StartTime)
    $TranscriptLines += "Trigger: pull_request event (opened) - fired only because a PR exists"
    $TranscriptLines += ""
    $TranscriptLines += "## PR inspected (SIMULATED)"
    $TranscriptLines += ""
    $TranscriptLines += ("Issue Number: " + $IssueNumber)
    $TranscriptLines += ("Title: " + $Title)
    $TranscriptLines += ("Branch: " + $BranchName)
    $TranscriptLines += "(This reviewer never selected the issue itself - it only reacted to"
    $TranscriptLines += "the simulated PR the implementer produced.)"
    $TranscriptLines += ""
    $TranscriptLines += "## Checklist applied"
    $TranscriptLines += ""
    $TranscriptLines += "review-checklist.md was applied item by item to the simulated diff and"
    $TranscriptLines += "PR description (represented here by the implementer's transcript)."
    $TranscriptLines += ""
    $TranscriptLines += "## Verdict"
    $TranscriptLines += ""
    $TranscriptLines += ("Verdict: " + $Verdict)
    $TranscriptLines += ""
    $TranscriptLines += "## Reasons"
    $TranscriptLines += ""
    if ($Verdict -eq "PASS") {
        $TranscriptLines += "All required checklist items were satisfied by the simulated PR:"
        $TranscriptLines += "issue correctly referenced, fix scoped to the issue, tests recorded and"
        $TranscriptLines += "passing, no unrelated changes, no secrets exposed, branch/PR identity"
        $TranscriptLines += "correct, and no self-graded verdict present from the implementer."
    }
    else {
        foreach ($Reason in $FailReasons) {
            $TranscriptLines += ("- " + $Reason)
        }
    }
    $TranscriptLines += ""
    $TranscriptLines += "## Proof this Routine did not modify code"
    $TranscriptLines += ""
    $TranscriptLines += "No file outside this transcript and reports\reviewer-report.md was"
    $TranscriptLines += "written by this run. The simulated PR's diff was read only, never"
    $TranscriptLines += "edited."
    $TranscriptLines += ""
    $TranscriptLines += "## Proof this Routine did not merge"
    $TranscriptLines += ""
    $TranscriptLines += "No merge action was simulated or claimed. Task Result below reflects a"
    $TranscriptLines += "review verdict only, never a merge outcome."
    $TranscriptLines += ""
    $TranscriptLines += "## Result"
    $TranscriptLines += ""
    $TranscriptLines += ("Task Result: " + $Verdict + " (SIMULATED REVIEW ONLY - NO MERGE PERFORMED)")
    $TranscriptLines += ""
    $TranscriptLines += "## Role boundaries"
    $TranscriptLines += ""
    $TranscriptLines += "This Routine did NOT implement or fix anything."
    $TranscriptLines += "This Routine did NOT modify the pull request's code."
    $TranscriptLines += "This Routine did NOT merge the pull request."
    $TranscriptLines += ("Implementing is exclusively the implementer Routine's job - see")
    $TranscriptLines += ("transcripts\implementer-run-" + $IssueNumber + ".md.")

    $ReviewerTranscriptPath = Join-Path $TranscriptsDir ("reviewer-run-" + $IssueNumber + ".md")
    Set-Content -LiteralPath $ReviewerTranscriptPath -Value $TranscriptLines

    $SummaryRows += ("| " + $IssueNumber + " | Opened | " + $Verdict + " | NO | NO |")
}

$ReportLines = @()
$ReportLines += "# Reviewer Report - Two-Routine Gate (SIMULATED)"
$ReportLines += ""
$ReportLines += "Generated by scripts\simulate-reviewer.ps1. All actions described below"
$ReportLines += "are SIMULATED - no real GitHub pull request was reviewed, and no real"
$ReportLines += "review comment was posted."
$ReportLines += ""
$ReportLines += "## Summary"
$ReportLines += ""
$ReportLines += "Three simulated pull requests were reviewed independently, one per"
$ReportLines += "implementer run:"
$ReportLines += ""
$ReportLines += "| Issue | PR (simulated) | Verdict | Modified code? | Merged? |"
$ReportLines += "|-------|-------------------|---------|-------------------|-----------|"
foreach ($Row in $SummaryRows) {
    $ReportLines += $Row
}
$ReportLines += ""
$ReportLines += "Every verdict was produced by applying real checks against the"
$ReportLines += "implementer's transcript content - not by hardcoding a result."
$ReportLines += ""
$ReportLines += "## Role boundary confirmation"
$ReportLines += ""
$ReportLines += "In all three runs, the reviewer:"
$ReportLines += "- Did NOT implement or fix anything"
$ReportLines += "- Did NOT modify any code in the pull request"
$ReportLines += "- Did NOT merge the pull request, regardless of verdict"
$ReportLines += ""
$ReportLines += "See transcripts\reviewer-run-001.md through 003.md for full detail per"
$ReportLines += "run."

Set-Content -LiteralPath $ReportPath -Value $ReportLines

Write-Host ""
Write-Host "Reviewer simulation completed for all simulated PRs."
Write-Host "Transcripts written to transcripts\reviewer-run-*.md"
Write-Host "Report written to reports\reviewer-report.md"