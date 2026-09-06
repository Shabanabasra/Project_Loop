# simulate-success.ps1
# Project 9: Rehearse a Routine for Free
#
# Simulates a SUCCESSFUL one-off Routine run: reads
# candidates\yesterday-commits.txt, produces a summary, simulates
# pushing it to a claude/summary branch, and writes a full transcript
# and a success report. This is a LOCAL SIMULATION only. It does not
# call any AI model, API, or the network.

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$CandidatePath = Join-Path $ProjectRoot "candidates\yesterday-commits.txt"
$TranscriptPath = Join-Path $ProjectRoot "transcripts\successful-run.md"
$ReportPath = Join-Path $ProjectRoot "reports\success-report.md"

$RunId = "ROUTINE-RUN-" + (Get-Date -Format "yyyyMMdd-HHmmss")
$StartTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "=========================================================="
Write-Host " Simulating SUCCESSFUL Routine run: $RunId"
Write-Host "=========================================================="

if (-not (Test-Path $CandidatePath)) {
    Write-Host "[MISSING] candidates\yesterday-commits.txt - cannot simulate success."
    exit 1
}

$CommitLines = Get-Content $CandidatePath

$SummaryLines = @()
foreach ($Line in $CommitLines) {
    if ($Line.Trim() -ne "") {
        $SummaryLines += ("- " + $Line.Trim())
    }
}

$SimulatedBranch = "claude/summary"

$TranscriptLines = @()
$TranscriptLines += "# Successful Run Transcript"
$TranscriptLines += ""
$TranscriptLines += ("Run ID: " + $RunId)
$TranscriptLines += ("Start time: " + $StartTime)
$TranscriptLines += "Trigger type: one-off (Run now / one-off schedule simulation)"
$TranscriptLines += ""
$TranscriptLines += "## Prompt used"
$TranscriptLines += ""
$TranscriptLines += "Summarize yesterday's commits and prepare the summary on the"
$TranscriptLines += "claude/summary branch. Report exactly what was changed and verify"
$TranscriptLines += "the result."
$TranscriptLines += ""
$TranscriptLines += "## Files read"
$TranscriptLines += ""
$TranscriptLines += "- candidates\yesterday-commits.txt (found, read successfully)"
$TranscriptLines += ""
$TranscriptLines += "## Work performed"
$TranscriptLines += ""
$TranscriptLines += "Read " + $CommitLines.Count + " line(s) from yesterday-commits.txt and"
$TranscriptLines += "produced the following summary:"
$TranscriptLines += ""
foreach ($SummaryLine in $SummaryLines) {
    $TranscriptLines += $SummaryLine
}
$TranscriptLines += ""
$TranscriptLines += "## Branch simulated"
$TranscriptLines += ""
$TranscriptLines += ("Simulated push to branch: " + $SimulatedBranch)
$TranscriptLines += "(No real git operation was performed. This is a local simulation.)"
$TranscriptLines += ""
$TranscriptLines += "## Task result"
$TranscriptLines += ""
$TranscriptLines += "Task Result: SUCCESS"
$TranscriptLines += "The requested file was found, read, summarized, and the summary was"
$TranscriptLines += "simulated as pushed to the correct branch."
$TranscriptLines += ""
$TranscriptLines += "## Platform status"
$TranscriptLines += ""
$TranscriptLines += "Platform Status: GREEN"
$TranscriptLines += "(The simulated session ended without an infrastructure error.)"
$TranscriptLines += ""
$TranscriptLines += "## Final result"
$TranscriptLines += ""
$TranscriptLines += "GREEN status and SUCCESS task result agree in this run. This is the"
$TranscriptLines += "case where reading the transcript confirms what the status color"
$TranscriptLines += "already suggested. Compare this with failed-run.md, where the status"
$TranscriptLines += "is also GREEN but the task result is different."

Set-Content -Path $TranscriptPath -Value $TranscriptLines

$ReportLines = @()
$ReportLines += "# Success Report"
$ReportLines += ""
$ReportLines += ("Run ID: " + $RunId)
$ReportLines += ("Timestamp: " + $StartTime)
$ReportLines += ""
$ReportLines += "## Why this run succeeded"
$ReportLines += ""
$ReportLines += "The prompt asked for one small, checkable thing: summarize"
$ReportLines += "yesterday's commits and simulate pushing the result to a"
$ReportLines += "claude/summary branch. The input file"
$ReportLines += "(candidates\yesterday-commits.txt) existed and was readable, so the"
$ReportLines += "task had everything it needed to complete. The transcript shows the"
$ReportLines += "file being read, a real summary being produced from its actual"
$ReportLines += "contents, and the simulated branch push happening as requested."
$ReportLines += ""
$ReportLines += "Platform Status: GREEN"
$ReportLines += "Task Result: SUCCESS"
$ReportLines += ""
$ReportLines += "In this run, the green status and the actual task result agree. That"
$ReportLines += "will not always be true - see reports\failure-report.md for a run"
$ReportLines += "where they do not."

Set-Content -Path $ReportPath -Value $ReportLines

Write-Host ""
Write-Host "Routine simulation completed."
Write-Host "Platform Status: GREEN"
Write-Host "Task Result: SUCCESS"
Write-Host ""
Write-Host "Transcript written to transcripts\successful-run.md"
Write-Host "Report written to reports\success-report.md"