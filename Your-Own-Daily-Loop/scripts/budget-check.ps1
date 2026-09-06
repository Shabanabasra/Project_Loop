# budget-check.ps1
# Project 8: Your Own Daily Loop
#
# Checks whether today's run count has already reached the configured
# daily limit, using ONLY logs\loop.log and config\budget-config.json.
# Exits with code 0 if the budget is OK, or code 1 if the budget has
# been reached or exceeded. Prints a clear message either way.
#
# This script does not call the network or any AI model.

param(
    [string]$RunId = "UNKNOWN"
)

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$BudgetConfigPath = Join-Path $ProjectRoot "config\budget-config.json"
$LogPath = Join-Path $ProjectRoot "logs\loop.log"

if (-not (Test-Path $BudgetConfigPath)) {
    Write-Host "[MISSING] config\budget-config.json - cannot check budget."
    exit 1
}

$BudgetConfig = Get-Content $BudgetConfigPath -Raw | ConvertFrom-Json
$MaxRunsPerDay = [int]$BudgetConfig.maxRunsPerDay

$Today = Get-Date -Format "yyyy-MM-dd"
$RunsToday = 0

if (Test-Path $LogPath) {
    $LogLines = Get-Content $LogPath
    foreach ($Line in $LogLines) {
        if ($Line -and ($Line -notmatch "^#")) {
            if ($Line -match ("TIMESTAMP=" + $Today)) {
                $RunsToday = $RunsToday + 1
            }
        }
    }
}

Write-Host ("Budget check for run " + $RunId + ": " + $RunsToday + " run(s) already logged today, limit is " + $MaxRunsPerDay + ".")

if ($RunsToday -ge $MaxRunsPerDay) {
    Write-Host "BUDGET STATUS: EXCEEDED"
    exit 1
}
else {
    Write-Host "BUDGET STATUS: OK"
    exit 0
}