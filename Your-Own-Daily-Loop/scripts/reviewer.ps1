# reviewer.ps1
# Project 8: Your Own Daily Loop
#
# This is the CHECKER. It independently inspects
# reports\dependency-audit.md and writes reports\reviewer-report.md
# with a verdict of exactly PASS or FAIL. It never modifies the audit
# report and never fixes anything itself.
#
# Exit code 0 means PASS. Exit code 1 means FAIL.

param(
    [Parameter(Mandatory = $true)]
    [string]$RunId,

    [bool]$SimulateFailure = $false
)

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$AuditReportPath = Join-Path $ProjectRoot "reports\dependency-audit.md"
$ReviewerReportPath = Join-Path $ProjectRoot "reports\reviewer-report.md"
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$Reasons = @()
$Verdict = "PASS"

if ($SimulateFailure) {
    $Verdict = "FAIL"
    $Reasons += "Reviewer failure was deliberately simulated (config\loop-config.json simulateReviewerFailure=true)."
}
else {

    if (-not (Test-Path $AuditReportPath)) {
        $Verdict = "FAIL"
        $Reasons += "reports\dependency-audit.md does not exist."
    }
    else {
        $ReportText = Get-Content $AuditReportPath -Raw

        if ($ReportText -notmatch [regex]::Escape("Run ID: " + $RunId)) {
            $Verdict = "FAIL"
            $Reasons += "Report does not contain the current Run ID."
        }

        if ($ReportText -notmatch "## Dependencies Checked") {
            $Verdict = "FAIL"
            $Reasons += "Report is missing the Dependencies Checked section."
        }

        if ($ReportText -notmatch "## Summary") {
            $Verdict = "FAIL"
            $Reasons += "Report is missing the Summary section."
        }

        if ($ReportText -notmatch "simulated / local demonstration data") {
            $Verdict = "FAIL"
            $Reasons += "Report does not clearly label its data as simulated / local demonstration data."
        }

        if ($ReportText -notmatch "Recommendation:") {
            $Verdict = "FAIL"
            $Reasons += "Report does not contain recommendations for the dependencies checked."
        }
    }
}

$ReviewerLines = @()
$ReviewerLines += "# Reviewer Report"
$ReviewerLines += ""
$ReviewerLines += ("Run ID: " + $RunId)
$ReviewerLines += ("Timestamp: " + $Timestamp)
$ReviewerLines += ""
$ReviewerLines += ("Verdict: " + $Verdict)

if ($Verdict -eq "FAIL") {
    $ReviewerLines += ""
    $ReviewerLines += "Reasons:"
    foreach ($Reason in $Reasons) {
        $ReviewerLines += ("- " + $Reason)
    }
}
else {
    $ReviewerLines += ""
    $ReviewerLines += "All checks passed: report exists, contains the current Run ID, lists"
    $ReviewerLines += "dependencies with statuses and recommendations, includes a summary, and"
    $ReviewerLines += "clearly labels its data as simulated / local demonstration data."
}

Set-Content -Path $ReviewerReportPath -Value $ReviewerLines

Write-Host ("  Reviewer verdict: " + $Verdict)

if ($Verdict -eq "PASS") {
    exit 0
}
else {
    exit 1
}