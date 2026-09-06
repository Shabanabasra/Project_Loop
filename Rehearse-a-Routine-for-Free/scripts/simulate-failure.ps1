# simulate-failure.ps1
# Project 9: Rehearse a Routine for Free
#
# Simulates a DELIBERATELY BROKEN one-off Routine run: attempts to read
# candidates\file-that-does-not-exist.txt (which does not exist on
# purpose), safely records the failure without crashing, and writes a
# full transcript and a failure report. This is a LOCAL SIMULATION
# only. It does not call any AI model, API, or the network.

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$MissingFilePath = Join-Path $ProjectRoot "candidates\file-that-does-not-exist.txt"
$TranscriptPath = Join-Path $ProjectRoot "transcripts\failed-run.md"
$ReportPath = Join-Path $ProjectRoot "reports\failure-report.md"

$RunId = "ROUTINE-RUN-" + (Get-Date -Format "yyyyMMdd-HHmmss")
$StartTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "=========================================================="
Write-Host " Simulating DELIBERATELY FAILED Routine run: $RunId"
Write-Host "=========================================================="

$ErrorMessage = "None"
$AttemptSucceeded = $false

try {
    Write-Host ("  Attempting to read: " + $MissingFilePath)
    $Content = Get-Content -Path $MissingFilePath -Raw -ErrorAction Stop
    $AttemptSucceeded = $true
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Host ("  Read attempt failed as expected: " + $ErrorMessage)
}

$TranscriptLines = @()
$TranscriptLines += "# Failed Run Transcript"
$TranscriptLines += ""
$TranscriptLines += ("Run ID: " + $RunId)
$TranscriptLines += ("Start time: " + $StartTime)
$TranscriptLines += "Trigger type: one-off (Run now / one-off schedule simulation)"
$TranscriptLines += ""
$TranscriptLines += "## Broken prompt used"
$TranscriptLines += ""
$TranscriptLines += "Read candidates/file-that-does-not-exist.txt and summarize it."
$TranscriptLines += ""
$TranscriptLines += "## Missing file"
$TranscriptLines += ""
$TranscriptLines += ("Path attempted: " + $MissingFilePath)
$TranscriptLines += "This file does not exist. It was left out on purpose, to rehearse a"
$TranscriptLines += "failure safely, using the Project 9 method of pointing a task at a"
$TranscriptLines += "file that does not exist."
$TranscriptLines += ""
$TranscriptLines += "## Error"
$TranscriptLines += ""
$TranscriptLines += ("Error message recorded: " + $ErrorMessage)
$TranscriptLines += ""
$TranscriptLines += "## Task result"
$TranscriptLines += ""
$TranscriptLines += "Task Result: FAILED"
$TranscriptLines += "The requested file could not be found, so no summary could be"
$TranscriptLines += "produced and nothing was pushed to any branch."
$TranscriptLines += ""
$TranscriptLines += "## Platform status"
$TranscriptLines += ""
$TranscriptLines += "Platform Status: GREEN"
$TranscriptLines += "(The simulated session still ended without an infrastructure"
$TranscriptLines += "error. PowerShell caught the missing-file error safely, the script"
$TranscriptLines += "did not crash, and the session completed normally. This is exactly"
$TranscriptLines += "why status alone is not enough: an infrastructure-level GREEN can"
$TranscriptLines += "still wrap a task-level failure.)"
$TranscriptLines += ""
$TranscriptLines += "## Explanation"
$TranscriptLines += ""
$TranscriptLines += "This run demonstrates the A5 lesson directly. The session itself"
$TranscriptLines += "completed without an infrastructure error (no crash, no network"
$TranscriptLines += "failure, no authentication failure) so its platform status is"
$TranscriptLines += "GREEN, exactly like the successful run. But the actual task, that"
$TranscriptLines += "is, summarizing a real file, could not happen, because the file"
$TranscriptLines += "named in the prompt does not exist. Only reading this transcript"
$TranscriptLines += "reveals that difference. The status color cannot."
$TranscriptLines += ""
$TranscriptLines += "## What a human should investigate"
$TranscriptLines += ""
$TranscriptLines += "1. Confirm whether the missing file was expected to exist."
$TranscriptLines += "2. If the file was supposed to exist, find out why it does not"
$TranscriptLines += "   (wrong path in the prompt, file not yet created, file moved,"
$TranscriptLines += "   or a typo)."
$TranscriptLines += "3. Fix the prompt or the missing input, then re-run a one-off"
$TranscriptLines += "   rehearsal before ever putting this prompt on a repeating"
$TranscriptLines += "   schedule."

Set-Content -Path $TranscriptPath -Value $TranscriptLines

$ReportLines = @()
$ReportLines += "# Failure Report"
$ReportLines += ""
$ReportLines += ("Run ID: " + $RunId)
$ReportLines += ("Timestamp: " + $StartTime)
$ReportLines += ""
$ReportLines += "## What failed"
$ReportLines += ""
$ReportLines += "The simulated Routine attempted to read"
$ReportLines += "candidates\file-that-does-not-exist.txt, which does not exist."
$ReportLines += ""
$ReportLines += "## Why it failed"
$ReportLines += ""
$ReportLines += "The prompt named a file path that was never created in this"
$ReportLines += "project, on purpose, to safely rehearse what a real failed Routine"
$ReportLines += "run looks like."
$ReportLines += ""
$ReportLines += "## Which file was missing"
$ReportLines += ""
$ReportLines += ("candidates\file-that-does-not-exist.txt (full path attempted: " + $MissingFilePath + ")")
$ReportLines += ""
$ReportLines += "## Why transcript reading matters"
$ReportLines += ""
$ReportLines += "The simulated session still completed without an infrastructure"
$ReportLines += "error (PowerShell caught the missing-file error and the script kept"
$ReportLines += "running normally), so Platform Status: GREEN. Only reading the"
$ReportLines += "transcript in transcripts\failed-run.md reveals that the actual task"
$ReportLines += "result was FAILED. A real Routine's status column would look the"
$ReportLines += "same in both cases; this is the whole A5 lesson."
$ReportLines += ""
$ReportLines += "## What a human should do next"
$ReportLines += ""
$ReportLines += "Confirm the expected input file, fix the prompt or the missing"
$ReportLines += "file, and rehearse again with a one-off run before scheduling"
$ReportLines += "anything repeating."

Set-Content -Path $ReportPath -Value $ReportLines

Write-Host ""
Write-Host "Routine simulation completed."
Write-Host "Platform Status: GREEN"
Write-Host "Task Result: FAILED"
Write-Host ""
Write-Host "The simulated session completed, but the requested task failed."
Write-Host "Read the transcript to understand what actually happened."
Write-Host ""
Write-Host "Transcript written to transcripts\failed-run.md"
Write-Host "Report written to reports\failure-report.md"