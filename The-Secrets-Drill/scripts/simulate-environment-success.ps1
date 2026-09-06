# simulate-environment-success.ps1
# Project 10: The Secrets Drill
#
# Rehearses the CORRECT environment-variable approach. This script
# checks the REAL process environment variable OPENROUTER_API_KEY (set
# by you, before running this script). It never loads or reads .env,
# never prints the key value, and only reports availability status.
#
# Before running this script, set your key for this PowerShell session
# only (it will not persist after you close the window):
#
#   $env:OPENROUTER_API_KEY = "YOUR_REAL_KEY_HERE"
#
# Do not put your real key inside this script or any file in this
# project.

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$TranscriptPath = Join-Path $ProjectRoot "transcripts\successful-environment-run.md"
$ReportPath = Join-Path $ProjectRoot "reports\success-report.md"

$RunId = "SECRETS-DRILL-RUN-" + (Get-Date -Format "yyyyMMdd-HHmmss")
$StartTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$KeyName = "OPENROUTER_API_KEY"

Write-Host "=========================================================="
Write-Host " Simulating ENVIRONMENT VARIABLE success run: $RunId"
Write-Host "=========================================================="

# ----------------------------------------------------------------
# Step 1 and 2: check the REAL process environment variable. This
# script never reads .env at any point.
# ----------------------------------------------------------------
$KeyValue = [System.Environment]::GetEnvironmentVariable($KeyName)
$KeyIsSet = -not [string]::IsNullOrEmpty($KeyValue)

if (-not $KeyIsSet) {
    Write-Host ""
    Write-Host ("[MISSING] " + $KeyName + " is not set in this PowerShell session.")
    Write-Host ""
    Write-Host "This run cannot honestly report SUCCESS without a real key being"
    Write-Host "present in the environment. Set it for this session only, then run"
    Write-Host "this script again:"
    Write-Host ""
    Write-Host ('  $env:' + $KeyName + ' = "YOUR_REAL_KEY_HERE"')
    Write-Host ("  .\simulate-environment-success.ps1")
    Write-Host ""
    Write-Host "Do not paste your real key into any chat, script, or file in this"
    Write-Host "project. Only set it directly in your own PowerShell session."
    exit 1
}

Write-Host ("  " + $KeyName + " found in the process environment.")

# ----------------------------------------------------------------
# Step 3: never print the key. Only check length and a loose,
# best-effort shape check, without exposing the value.
# ----------------------------------------------------------------
$KeyLength = $KeyValue.Length
$LooksPlausible = $false
if ($KeyValue.Length -gt 10) {
    $LooksPlausible = $true
}

Write-Host ("  Key length (characters, value itself not shown): " + $KeyLength)
Write-Host ("  Looks like a plausible key by length alone (best-effort only): " + $(if ($LooksPlausible) { "YES" } else { "NO" }))

# ----------------------------------------------------------------
# Step 4: this script deliberately does NOT read .env anywhere.
# ----------------------------------------------------------------
Write-Host "  .env was NOT read at any point in this script."

$KeyStatus = "[AVAILABLE]"
$TaskResult = "SUCCESS"

Write-Host ("  Result: " + $KeyName + " = " + $KeyStatus)

# ----------------------------------------------------------------
# Write the transcript
# ----------------------------------------------------------------
$PlausibleText = "NO"
if ($LooksPlausible) { $PlausibleText = "YES" }

$TranscriptLines = @()
$TranscriptLines += "# Successful Environment Variable Run Transcript"
$TranscriptLines += ""
$TranscriptLines += ("Run ID: " + $RunId)
$TranscriptLines += ("Start time: " + $StartTime)
$TranscriptLines += "Trigger type: one-off (Run now / one-off schedule simulation)"
$TranscriptLines += ""
$TranscriptLines += "## Corrected prompt used"
$TranscriptLines += ""
$TranscriptLines += ("Read " + $KeyName + " from the environment and confirm that it is")
$TranscriptLines += "available. Do not print the key. Credentials are available as"
$TranscriptLines += "environment variables; do not look for a .env file."
$TranscriptLines += ""
$TranscriptLines += "## Environment variable check"
$TranscriptLines += ""
$TranscriptLines += ($KeyName + " was read directly from the process environment.")
$TranscriptLines += "It was NOT read from any .env file - this script never opens .env."
$TranscriptLines += ""
$TranscriptLines += ("Key length (characters only, value not shown): " + $KeyLength)
$TranscriptLines += ("Looks plausible by length (best-effort, informational only): " + $PlausibleText)
$TranscriptLines += ""
$TranscriptLines += "## Result"
$TranscriptLines += ""
$TranscriptLines += ($KeyName + " = " + $KeyStatus)
$TranscriptLines += "(The actual key value is never printed in this transcript or any"
$TranscriptLines += "report.)"
$TranscriptLines += ""
$TranscriptLines += "## Task result"
$TranscriptLines += ""
$TranscriptLines += ("Task Result: " + $TaskResult)
$TranscriptLines += "The key was found through the environment variable and confirmed to"
$TranscriptLines += "be available, exactly as the prompt required."
$TranscriptLines += ""
$TranscriptLines += "## Platform status"
$TranscriptLines += ""
$TranscriptLines += "Platform Status: GREEN"
$TranscriptLines += "(The simulated session ended without an infrastructure error, and"
$TranscriptLines += "this time the actual task also succeeded.)"
$TranscriptLines += ""
$TranscriptLines += "## Explanation of why it succeeded"
$TranscriptLines += ""
$TranscriptLines += ($KeyName + " was supplied as a real environment variable rather")
$TranscriptLines += "than through a gitignored .env file, so it was available regardless"
$TranscriptLines += "of whether a fresh clone was used. Environment variables are set on"
$TranscriptLines += "the execution environment itself, not carried inside the repository"
$TranscriptLines += "contents, so they survive the fresh-clone process that a real cloud"
$TranscriptLines += "Routine always uses. The added prompt line also stopped any wasted"
$TranscriptLines += "attempt to look for a .env file that was never going to be there."

Set-Content -LiteralPath $TranscriptPath -Value $TranscriptLines

# ----------------------------------------------------------------
# Write the success report
# ----------------------------------------------------------------
$ReportLines = @()
$ReportLines += "# Success Report - Secrets Drill"
$ReportLines += ""
$ReportLines += ("Run ID: " + $RunId)
$ReportLines += ("Timestamp: " + $StartTime)
$ReportLines += ""
$ReportLines += "## Why this run succeeded"
$ReportLines += ""
$ReportLines += ($KeyName + " was supplied as a real process environment variable, not")
$ReportLines += "through a .env file. Environment variables live on the execution"
$ReportLines += "environment itself and are not affected by the fresh-clone process"
$ReportLines += "that strips out gitignored files. The prompt also explicitly told the"
$ReportLines += "model not to look for a .env file, removing any wasted attempt down"
$ReportLines += "that dead-end path."
$ReportLines += ""
$ReportLines += "## Was the real secret exposed anywhere"
$ReportLines += ""
$ReportLines += "No. This report and the corresponding transcript both report the"
$ReportLines += "key's status only, never the value."
$ReportLines += ""
$ReportLines += "## Mechanical reason this works"
$ReportLines += ""
$ReportLines += "Environment variables panel -> value injected directly into the"
$ReportLines += "Routine's execution environment -> available regardless of what the"
$ReportLines += ("repository clone contains -> " + $KeyName + " found successfully.")
$ReportLines += ""
$ReportLines += "## Comparison note"
$ReportLines += ""
$ReportLines += "See reports\failure-report.md and reports\comparison-report.md for"
$ReportLines += "the side-by-side contrast with the .env-based run, which failed for"
$ReportLines += "the opposite mechanical reason."

Set-Content -LiteralPath $ReportPath -Value $ReportLines

Write-Host ""
Write-Host "Secrets drill success rehearsal completed."
Write-Host "Platform Status: GREEN"
Write-Host ("Task Result: " + $TaskResult)
Write-Host ""
Write-Host "Transcript written to transcripts\successful-environment-run.md"
Write-Host "Report written to reports\success-report.md"

exit 0