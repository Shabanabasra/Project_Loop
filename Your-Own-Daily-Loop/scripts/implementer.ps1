# implementer.ps1
# Project 8: Your Own Daily Loop
#
# This is the MAKER. It reads dependency data and writes
# reports\dependency-audit.md. It never grades its own work.
#
# FailureMode supports safe, deliberate demonstrations of failure:
#   none           - normal successful run
#   missingData    - simulates a missing/unreadable source file
#   unexpectedError - simulates an unexpected error being thrown
#
# Exit code 0 means the report was written successfully.
# Exit code 1 means the run failed (no report, or a partial report was
# deliberately avoided).

param(
    [Parameter(Mandatory = $true)]
    [string]$RunId,

    [Parameter(Mandatory = $true)]
    [string]$WorkspacePath,

    [string]$FailureMode = "none"
)

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ReportPath = Join-Path $ProjectRoot "reports\dependency-audit.md"
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if ($FailureMode -eq "missingData") {
    $BadPath = Join-Path $WorkspacePath "this-file-does-not-exist.txt"
    Write-Host "  Implementer: simulating missing data by reading: $BadPath"

    if (-not (Test-Path $BadPath)) {
        Write-Host "  Implementer FAILED: source data not found (simulated missingData failure)."
        exit 1
    }
}

if ($FailureMode -eq "unexpectedError") {
    Write-Host "  Implementer: simulating an unexpected error..."
    try {
        throw "Simulated unexpected error for Project 8 failure-handling demonstration."
    }
    catch {
        Write-Host ("  Implementer FAILED: unexpected error: " + $_.Exception.Message)
        exit 1
    }
}

$SourcePath = Join-Path $WorkspacePath "source-data.txt"

if (-not (Test-Path $SourcePath)) {
    Write-Host ("  Implementer FAILED: source data not found at: " + $SourcePath)
    exit 1
}

$Lines = Get-Content $SourcePath
$ProjectName = "Unknown"
$Dependencies = @()
$Current = @{}

foreach ($Line in $Lines) {
    $Trimmed = $Line.Trim()

    if ($Trimmed -eq "") {
        if ($Current.ContainsKey("dependency")) {
            $Dependencies += $Current
        }
        $Current = @{}
        continue
    }

    $ColonIndex = $Trimmed.IndexOf(":")
    if ($ColonIndex -gt 0) {
        $Key = $Trimmed.Substring(0, $ColonIndex).Trim()
        $Value = $Trimmed.Substring($ColonIndex + 1).Trim()

        if ($Key -eq "project-name") {
            $ProjectName = $Value
        }
        else {
            $Current[$Key] = $Value
        }
    }
}

if ($Current.ContainsKey("dependency")) {
    $Dependencies += $Current
}

if ($Dependencies.Count -eq 0) {
    Write-Host "  Implementer FAILED: no dependency records were found in the source data."
    exit 1
}

$OutdatedCount = 0
$CurrentCount = 0
$ReviewCount = 0

$ReportLines = @()
$ReportLines += "# Dependency Audit Report"
$ReportLines += ""
$ReportLines += ("Run ID: " + $RunId)
$ReportLines += ("Project: " + $ProjectName)
$ReportLines += ("Timestamp: " + $Timestamp)
$ReportLines += ""
$ReportLines += "Data source: simulated / local demonstration data (source-data.txt)."
$ReportLines += "This is NOT a real internet vulnerability scan and must not be treated"
$ReportLines += "as real security information."
$ReportLines += ""
$ReportLines += ("## Dependencies Checked (" + $Dependencies.Count + ")")
$ReportLines += ""

foreach ($Dep in $Dependencies) {
    $DepName = $Dep["dependency"]
    $DepVersion = $Dep["version"]
    $DepStatus = $Dep["status"]

    $Recommendation = "No recommendation available."
    if ($DepStatus -eq "outdated") {
        $Recommendation = "Update to the latest version."
        $OutdatedCount = $OutdatedCount + 1
    }
    elseif ($DepStatus -eq "current") {
        $Recommendation = "No action needed."
        $CurrentCount = $CurrentCount + 1
    }
    elseif ($DepStatus -eq "review") {
        $Recommendation = "Manually review this dependency."
        $ReviewCount = $ReviewCount + 1
    }

    $ReportLines += ("- " + $DepName + " (version " + $DepVersion + "): " + $DepStatus.ToUpper() + " - Recommendation: " + $Recommendation)
}

$ReportLines += ""
$ReportLines += "## Summary"
$ReportLines += ""
$ReportLines += ("Total dependencies checked: " + $Dependencies.Count)
$ReportLines += ("Outdated: " + $OutdatedCount)
$ReportLines += ("Current: " + $CurrentCount)
$ReportLines += ("Needs review: " + $ReviewCount)
$ReportLines += ""
$ReportLines += "This report is simulated / local demonstration data only. It is NOT a"
$ReportLines += "real vulnerability scan and must not be treated as real security data."

Set-Content -Path $ReportPath -Value $ReportLines

Write-Host ("  Implementer SUCCESS: wrote report for " + $Dependencies.Count + " dependencies.")
exit 0