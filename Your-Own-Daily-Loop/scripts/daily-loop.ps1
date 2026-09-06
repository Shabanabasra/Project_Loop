# daily-loop.ps1
# Project 8: Your Own Daily Loop
#
# This is the main command for the Daily Dependency Audit Loop. It runs
# ONE complete cycle: generate a run ID, read the spine, check the
# budget, create an isolated workspace, run the implementer (maker),
# run the reviewer (checker), update the spine, write a log line, and
# stop safely. It does NOT loop forever - run it again by hand, or use
# scripts\heartbeat.ps1 to fire it a bounded number of times.
#
# This script only calls other scripts inside this same project folder.
# It does not call the network and does not call any AI model.

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ScriptsDir = $PSScriptRoot

$LoopConfigPath = Join-Path $ProjectRoot "config\loop-config.json"
$ProgressPath = Join-Path $ProjectRoot "progress.md"
$LogPath = Join-Path $ProjectRoot "logs\loop.log"

$RunId = "RUN-" + (Get-Date -Format "yyyyMMdd-HHmmss")
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "=========================================================="
Write-Host (" Daily Dependency Audit Loop - starting run " + $RunId)
Write-Host "=========================================================="

# Step 1 and 2: generate run ID (done above) and read the spine
Write-Host "Step 1-2: Reading progress.md (the spine)..."
if (Test-Path $ProgressPath) {
    $PreviousProgress = Get-Content $ProgressPath -Raw
    if ($PreviousProgress -match "Run ID:\s*(\S+)") {
        Write-Host ("  Previous run recorded in the spine: " + $Matches[1])
    }
    else {
        Write-Host "  No previous run ID found. This may be the first run."
    }
}
else {
    Write-Host "  [MISSING] progress.md was not found. It will be created by update-spine.ps1."
}

if (-not (Test-Path $LoopConfigPath)) {
    Write-Host "[MISSING] config\loop-config.json - cannot continue."
    exit 1
}
$LoopConfig = Get-Content $LoopConfigPath -Raw | ConvertFrom-Json
$FailureMode = $LoopConfig.simulateFailure
$SimulateReviewerFailure = [bool]$LoopConfig.simulateReviewerFailure

# Step 3: check budget
Write-Host ""
Write-Host "Step 3: Checking budget..."
& (Join-Path $ScriptsDir "budget-check.ps1") -RunId $RunId
$BudgetExitCode = $LASTEXITCODE

if ($BudgetExitCode -eq 0) {
    $BudgetStatus = "OK"
}
else {
    $BudgetStatus = "EXCEEDED"
}

if ($BudgetStatus -eq "EXCEEDED") {
    $MakerStatus = "SKIPPED"
    $ReviewerVerdict = "SKIPPED"
    $NeedsHuman = "YES"
    $Reason = "Daily budget limit reached (see config\budget-config.json maxRunsPerDay)."
    $NextAction = "A human should review today's runs, then either wait until tomorrow or raise maxRunsPerDay in config\budget-config.json if that is intentional."

    $LogLine = "RUN_ID=" + $RunId + " | TIMESTAMP=" + $Timestamp + " | MAKER_STATUS=" + $MakerStatus + " | REVIEWER_VERDICT=" + $ReviewerVerdict + " | BUDGET_STATUS=" + $BudgetStatus + " | NEEDS_HUMAN=" + $NeedsHuman + " | REASON=" + $Reason
    Add-Content -Path $LogPath -Value $LogLine

    & (Join-Path $ScriptsDir "update-spine.ps1") -RunId $RunId -Timestamp $Timestamp -MakerStatus $MakerStatus -ReviewerVerdict $ReviewerVerdict -NeedsHuman $NeedsHuman -Reason $Reason -NextAction $NextAction

    Write-Host ""
    Write-Host "=========================================================="
    Write-Host " Run stopped safely: budget exceeded. NEEDS HUMAN: YES"
    Write-Host "=========================================================="
    exit 1
}

# Step 4: heartbeat notice (the actual repeated firing lives in heartbeat.ps1)
Write-Host ""
Write-Host "Step 4: Heartbeat fired for this run (manually, or via scripts\heartbeat.ps1)."

# Step 5: create isolated workspace
Write-Host ""
Write-Host "Step 5: Creating isolated workspace..."
$WorkspacePath = & (Join-Path $ScriptsDir "create-workspace.ps1") -RunId $RunId
Write-Host ("  Workspace: " + $WorkspacePath)

# Step 6 and 7: run implementer (maker), which saves its own report
Write-Host ""
Write-Host "Step 6-7: Running implementer (maker)..."
& (Join-Path $ScriptsDir "implementer.ps1") -RunId $RunId -WorkspacePath $WorkspacePath -FailureMode $FailureMode
$ImplementerExitCode = $LASTEXITCODE

if ($ImplementerExitCode -eq 0) {
    $MakerStatus = "SUCCESS"
}
else {
    $MakerStatus = "FAILED"
}

# Step 8 and 9: run reviewer (checker), which saves its own report
Write-Host ""
Write-Host "Step 8-9: Running reviewer (checker)..."

if ($MakerStatus -eq "SUCCESS") {
    & (Join-Path $ScriptsDir "reviewer.ps1") -RunId $RunId -SimulateFailure $SimulateReviewerFailure
    $ReviewerExitCode = $LASTEXITCODE

    if ($ReviewerExitCode -eq 0) {
        $ReviewerVerdict = "PASS"
    }
    else {
        $ReviewerVerdict = "FAIL"
    }
}
else {
    Write-Host "  Skipping reviewer because the implementer failed."
    $ReviewerVerdict = "SKIPPED"
}

# Determine needs-human and reason
if ($MakerStatus -eq "FAILED") {
    $NeedsHuman = "YES"
    $Reason = "Implementer failed. See logs\loop.log and progress.md for details. Check config\loop-config.json simulateFailure if this was expected."
    $NextAction = "A human should investigate the implementer failure, then set simulateFailure back to none in config\loop-config.json once resolved."
}
elseif ($ReviewerVerdict -eq "FAIL") {
    $NeedsHuman = "YES"
    $Reason = "Reviewer returned FAIL. See reports\reviewer-report.md for specific reasons."
    $NextAction = "A human should review reports\reviewer-report.md, fix the underlying issue, and re-run scripts\daily-loop.ps1."
}
else {
    $NeedsHuman = "NO"
    $Reason = "None"
    $NextAction = "No action needed. Loop is healthy."
}

# Step 10: update the spine
Write-Host ""
Write-Host "Step 10: Updating progress.md (the spine)..."
& (Join-Path $ScriptsDir "update-spine.ps1") -RunId $RunId -Timestamp $Timestamp -MakerStatus $MakerStatus -ReviewerVerdict $ReviewerVerdict -NeedsHuman $NeedsHuman -Reason $Reason -NextAction $NextAction

# Step 11: write the log line
Write-Host ""
Write-Host "Step 11: Writing log line..."
$LogLine = "RUN_ID=" + $RunId + " | TIMESTAMP=" + $Timestamp + " | MAKER_STATUS=" + $MakerStatus + " | REVIEWER_VERDICT=" + $ReviewerVerdict + " | BUDGET_STATUS=" + $BudgetStatus + " | NEEDS_HUMAN=" + $NeedsHuman + " | REASON=" + $Reason
Add-Content -Path $LogPath -Value $LogLine
Write-Host "  Logged to logs\loop.log"

# Step 12 and 13: final result, then stop safely (no loop)
Write-Host ""
Write-Host "=========================================================="
Write-Host (" Run " + $RunId + " finished.")
Write-Host (" Maker status:     " + $MakerStatus)
Write-Host (" Reviewer verdict: " + $ReviewerVerdict)
Write-Host (" Needs human:      " + $NeedsHuman)
Write-Host "=========================================================="

if ($NeedsHuman -eq "YES") {
    exit 1
}
else {
    exit 0
}