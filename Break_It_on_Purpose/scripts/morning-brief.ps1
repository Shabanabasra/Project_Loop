# morning-brief.ps1
# Project 7: Break It on Purpose
#
# This script simulates ONE run (one beat) of a Project 3 style
# morning-brief loop. It can run in two modes:
#
#   Mode "normal"   - reads source-data.txt and writes a real brief.
#   Mode "sabotage" - deliberately fails, using one of two methods,
#                     so Project 7 can rehearse a loud, observable
#                     failure. This mode is normally called by
#                     sabotage-loop.ps1, not run directly by hand.
#
# This script never deletes files, never calls the network, and never
# calls any AI model. It only reads and writes plain text files inside
# this project folder.

param(
    [string]$Mode = "normal",
    [string]$SabotageMethod = "",
    [int]$Attempt = 1,
    [int]$MaxAttempts = 1
)

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$SourcePath = Join-Path $ProjectRoot "source-data.txt"
$ProgressPath = Join-Path $ProjectRoot "progress.md"
$LogPath = Join-Path $ProjectRoot "logs\loop.log"

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$RunId = "RUN-" + (Get-Date -Format "yyyyMMdd-HHmmss") + "-A" + $Attempt

$Status = "UNKNOWN"
$NeedsHuman = "NO"
$Reason = "None"
$SourceRead = "NO"
$OutputWritten = "NO"

if ($Mode -eq "normal") {

    if (Test-Path $SourcePath) {
        $Content = Get-Content $SourcePath -Raw
        $SourceRead = "YES"

        $SnippetLength = [Math]::Min(120, $Content.Length)
        $Snippet = $Content.Substring(0, $SnippetLength)
        $Brief = "Morning Brief (" + $Timestamp + "): " + $Snippet

        Write-Host $Brief
        $OutputWritten = "YES"
        $Status = "SUCCESS"
        $NeedsHuman = "NO"
        $Reason = "None"
    }
    else {
        $Status = "FAILED"
        $NeedsHuman = "YES"
        $Reason = "Source file not found in normal mode: " + $SourcePath
    }

}
elseif ($Mode -eq "sabotage") {

    if ($SabotageMethod -eq "missingFile") {

        $BadPath = Join-Path $ProjectRoot "this-file-does-not-exist.txt"

        if (Test-Path $BadPath) {
            $Content = Get-Content $BadPath -Raw
            $SourceRead = "YES"
            $OutputWritten = "YES"
            $Status = "SUCCESS"
            $NeedsHuman = "NO"
            $Reason = "None"
        }
        else {
            $SourceRead = "NO"
            $OutputWritten = "NO"
            $Status = "FAILED"
            $Reason = "Sabotage method missingFile: source path does not exist: " + $BadPath
            if ($Attempt -ge $MaxAttempts) {
                $NeedsHuman = "YES"
            }
            else {
                $NeedsHuman = "NO"
            }
        }

    }
    elseif ($SabotageMethod -eq "impossibleCondition") {

        if (Test-Path $SourcePath) {
            $Content = Get-Content $SourcePath -Raw
            $SourceRead = "YES"

            $SnippetLength = [Math]::Min(120, $Content.Length)
            $Snippet = $Content.Substring(0, $SnippetLength)
            $Brief = "Morning Brief (" + $Timestamp + "): " + $Snippet

            $RequiredMarker = "UNICORN-CONDITION-NEVER-TRUE"

            if ($Brief -like ("*" + $RequiredMarker + "*")) {
                $OutputWritten = "YES"
                $Status = "SUCCESS"
                $NeedsHuman = "NO"
                $Reason = "None"
            }
            else {
                $OutputWritten = "NO"
                $Status = "FAILED"
                $Reason = "Sabotage method impossibleCondition: output does not contain required marker " + $RequiredMarker
                if ($Attempt -ge $MaxAttempts) {
                    $NeedsHuman = "YES"
                }
                else {
                    $NeedsHuman = "NO"
                }
            }
        }
        else {
            $SourceRead = "NO"
            $Status = "FAILED"
            $Reason = "Source file missing even though impossibleCondition method does not normally touch this path: " + $SourcePath
            $NeedsHuman = "YES"
        }

    }
    else {
        $Status = "FAILED"
        $Reason = "Unknown sabotage method requested: " + $SabotageMethod
        $NeedsHuman = "YES"
    }

}
else {
    $Status = "FAILED"
    $Reason = "Unknown mode requested: " + $Mode
    $NeedsHuman = "YES"
}

# Build one log line and append it to logs\loop.log
$LogLine = "RUN_ID=" + $RunId + " | TIMESTAMP=" + $Timestamp + " | MODE=" + $Mode + " | ATTEMPT=" + $Attempt + " | MAX_ATTEMPTS=" + $MaxAttempts + " | STATUS=" + $Status + " | NEEDS_HUMAN=" + $NeedsHuman + " | SOURCE_READ=" + $SourceRead + " | OUTPUT_WRITTEN=" + $OutputWritten + " | REASON=" + $Reason

Add-Content -Path $LogPath -Value $LogLine

# Rewrite progress.md with the latest known state (the spine)
$NextAction = ""
if ($Status -eq "SUCCESS") {
    $NextAction = "No action needed. Loop is healthy."
}
elseif ($NeedsHuman -eq "YES") {
    $NextAction = "A human must investigate the reason above, fix the underlying cause, and set sabotageEnabled to false in config\sabotage-config.json before resuming normal operation."
}
else {
    $NextAction = "Automatic retry will occur on the next attempt within this sabotage run."
}

$ProgressLines = @()
$ProgressLines += "# Progress (Spine) - Project 7 Morning Brief Loop"
$ProgressLines += ""
$ProgressLines += "This file always reflects the latest known state of the loop. It is"
$ProgressLines += "rewritten by scripts\morning-brief.ps1 after every run, whether the run"
$ProgressLines += "succeeds or fails."
$ProgressLines += ""
$ProgressLines += "Last run: " + $RunId
$ProgressLines += "Timestamp: " + $Timestamp
$ProgressLines += "Status: " + $Status
$ProgressLines += "Attempt: " + $Attempt + " of " + $MaxAttempts
$ProgressLines += "Failure reason: " + $Reason
$ProgressLines += "Needs human: " + $NeedsHuman
$ProgressLines += "Next action: " + $NextAction

Set-Content -Path $ProgressPath -Value $ProgressLines

Write-Host ("Run " + $RunId + " finished with status " + $Status + " (needs human: " + $NeedsHuman + ")")