# heartbeat.ps1
# Project 8: Your Own Daily Loop
#
# This script SAFELY demonstrates the idea of an unattended heartbeat
# by calling scripts\daily-loop.ps1 a bounded number of times, reading
# the limit from config\loop-config.json ("maxRuns"). It never sleeps
# forever and never fires more than maxRuns times in one call.
#
# This is a LOCAL DEMONSTRATION of the heartbeat concept, not a real
# scheduler. A real unattended heartbeat for this chore would later be
# one of:
#   - A Claude Code Routine (cloud schedule), created with /schedule
#   - An OpenCode "opencode run" command wrapped in your own cron entry
#   - A Windows Task Scheduler entry running this script daily
#   - A GitHub Actions workflow on a schedule trigger
# None of those are required for this local demonstration.

param(
    [int]$MaxRuns = 0,
    [int]$DelaySeconds = 0
)

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$LoopConfigPath = Join-Path $ProjectRoot "config\loop-config.json"
$DailyLoopScript = Join-Path $PSScriptRoot "daily-loop.ps1"

if ($MaxRuns -le 0) {
    if (Test-Path $LoopConfigPath) {
        $LoopConfig = Get-Content $LoopConfigPath -Raw | ConvertFrom-Json
        $MaxRuns = [int]$LoopConfig.maxRuns
    }
    else {
        $MaxRuns = 1
    }
}

if ($MaxRuns -lt 1) {
    $MaxRuns = 1
}

# Safety cap: never allow more than 10 firings in one demonstration call,
# regardless of what the config file says.
if ($MaxRuns -gt 10) {
    Write-Host "maxRuns in config is higher than the safety cap. Limiting to 10 for this demonstration."
    $MaxRuns = 10
}

# Safety cap on delay too, so this can never behave like an infinite sleep.
if ($DelaySeconds -gt 10) {
    $DelaySeconds = 10
}

Write-Host "=========================================================="
Write-Host " Heartbeat demonstration starting"
Write-Host (" This will fire scripts\daily-loop.ps1 " + $MaxRuns + " time(s), then stop.")
Write-Host "=========================================================="

for ($i = 1; $i -le $MaxRuns; $i++) {
    Write-Host ""
    Write-Host ("Heartbeat firing " + $i + " of " + $MaxRuns + "...")

    & $DailyLoopScript

    if ($i -lt $MaxRuns -and $DelaySeconds -gt 0) {
        Write-Host ("Waiting " + $DelaySeconds + " second(s) before the next firing...")
        Start-Sleep -Seconds $DelaySeconds
    }
}

Write-Host ""
Write-Host "=========================================================="
Write-Host (" Heartbeat demonstration finished after " + $MaxRuns + " firing(s).")
Write-Host " This did NOT run forever, by design."
Write-Host "=========================================================="