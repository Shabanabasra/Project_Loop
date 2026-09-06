# validate-evidence.ps1
# Project 12: Build a Dreaming Loop
#
# Independently re-derives every fact from progress.md and
# improvement-rules.md directly - it does NOT simply trust
# transcripts\dreaming-run-001.md's claims. It fails loudly if any
# cited evidence cannot be independently confirmed.

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ProgressPath = Join-Path $ProjectRoot "progress.md"
$RulesPath = Join-Path $ProjectRoot "improvement-rules.md"
$TranscriptPath = Join-Path $ProjectRoot "transcripts\dreaming-run-001.md"
$ChecksumPath = Join-Path $ProjectRoot "evidence\rules-checksum.txt"
$ReportPath = Join-Path $ProjectRoot "reports\evidence-report.md"

$MinimumOccurrences = 2
$FailReasons = @()
$CheckLines = @()

Write-Host "=========================================================="
Write-Host " Validating evidence independently"
Write-Host "=========================================================="

if (-not (Test-Path -LiteralPath $TranscriptPath -PathType Leaf)) {
    Write-Host "[MISSING] transcripts\dreaming-run-001.md - run scripts\simulate-dreaming-loop.ps1 first."
    exit 1
}
if (-not (Test-Path -LiteralPath $ProgressPath -PathType Leaf)) {
    Write-Host "[MISSING] progress.md - cannot validate."
    exit 1
}

$TranscriptText = Get-Content -LiteralPath $TranscriptPath -Raw

# ----------------------------------------------------------------
# Extract the transcript's claims
# ----------------------------------------------------------------
$CitedDescription = $null
if ($TranscriptText -match "Description:\s*(.+)") {
    $CitedDescription = $Matches[1].Trim()
}

$CitedCount = 0
if ($TranscriptText -match "Occurrences:\s*(\d+)\r?\nEvidence dates:") {
    $CitedCount = [int]$Matches[1]
}

$CitedDatesLine = $null
if ($TranscriptText -match "Evidence dates:\s*(.+)") {
    $CitedDatesLine = $Matches[1].Trim()
}
$CitedDates = @()
if ($CitedDatesLine) {
    $CitedDates = $CitedDatesLine -split "," | ForEach-Object { $_.Trim() }
}

if (-not $CitedDescription -or $CitedDates.Count -eq 0) {
    Write-Host "[ERROR] Could not parse the repeated-pattern claim out of the transcript."
    exit 1
}

Write-Host ("  Transcript claims repeated description: " + $CitedDescription)
Write-Host ("  Transcript claims occurrence count: " + $CitedCount)
Write-Host ("  Transcript claims evidence dates: " + ($CitedDates -join ", "))

# ----------------------------------------------------------------
# Independently re-parse progress.md
# ----------------------------------------------------------------
$ProgressLines = Get-Content -LiteralPath $ProgressPath
$RealFailures = @()

foreach ($Line in $ProgressLines) {
    if ($Line -match "^-\s*(\d{4}-\d{2}-\d{2}):\s*FAILURE - (.+)$") {
        $RealFailures += [PSCustomObject]@{
            DateText = $Matches[1]
            Description = $Matches[2].Trim()
        }
    }
}

# Check 1, 2, 3: does each cited date really exist with matching text?
foreach ($CitedDate in $CitedDates) {
    $Match = $RealFailures | Where-Object { $_.DateText -eq $CitedDate -and $_.Description -eq $CitedDescription }
    if ($Match) {
        $CheckLines += ("Does " + $CitedDate + " exist in progress.md as a FAILURE line matching the cited text? YES.")
    }
    else {
        $CheckLines += ("Does " + $CitedDate + " exist in progress.md as a FAILURE line matching the cited text? NO.")
        $FailReasons += ("Cited date " + $CitedDate + " does not match an actual FAILURE line for the cited description.")
    }
}

# Check 4: independently recompute the true occurrence count
$RealCount = ($RealFailures | Where-Object { $_.Description -eq $CitedDescription }).Count
$CheckLines += ("Independently recomputed occurrence count for " + [char]34 + $CitedDescription + [char]34 + ": " + $RealCount + " (transcript claimed " + $CitedCount + ").")

if ($RealCount -ne $CitedCount) {
    $FailReasons += ("Independently recomputed occurrence count (" + $RealCount + ") does not match the transcript's claim (" + $CitedCount + ").")
}

if ($RealCount -lt $MinimumOccurrences) {
    $FailReasons += ("Real occurrence count (" + $RealCount + ") is below the minimum threshold of " + $MinimumOccurrences + " - this is not actually a repeated pattern.")
}

# Check 5: was any one-off failure (true count of 1) incorrectly cited
# as part of the repeated pattern's evidence?
$AllDescriptions = $RealFailures | Group-Object -Property Description
$TrueOneOffs = $AllDescriptions | Where-Object { $_.Count -eq 1 }

$OneOffMisusedAsRepeated = $false
foreach ($OneOff in $TrueOneOffs) {
    if ($OneOff.Name -eq $CitedDescription -and $RealCount -lt $MinimumOccurrences) {
        $OneOffMisusedAsRepeated = $true
    }
}

if ($OneOffMisusedAsRepeated) {
    $CheckLines += "Is a true one-off failure included in the repeated-pattern evidence list? YES (this is an error)."
    $FailReasons += "A failure with a true occurrence count of 1 was presented as a repeated pattern."
}
else {
    $CheckLines += "Is a true one-off failure included in the repeated-pattern evidence list? NO (correctly excluded)."
}

# Check 6: improvement-rules.md checksum comparison
if (Test-Path -LiteralPath $RulesPath -PathType Leaf) {
    $CurrentHash = (Get-FileHash -LiteralPath $RulesPath -Algorithm SHA256).Hash

    if (Test-Path -LiteralPath $ChecksumPath -PathType Leaf) {
        $BaselineHash = (Get-Content -LiteralPath $ChecksumPath -Raw).Trim()
        if ($CurrentHash -eq $BaselineHash) {
            $CheckLines += "Does improvement-rules.md still match its baseline checksum (unmodified)? YES."
        }
        else {
            $CheckLines += "Does improvement-rules.md still match its baseline checksum (unmodified)? NO."
            $FailReasons += "improvement-rules.md's checksum no longer matches the baseline recorded by scripts\plant-test-failure.ps1 - it may have been modified directly."
        }
    }
    else {
        $CheckLines += "Does improvement-rules.md still match its baseline checksum (unmodified)? UNVERIFIED - no baseline found. Run scripts\plant-test-failure.ps1 first to record one."
    }
}
else {
    $FailReasons += "improvement-rules.md is missing - cannot verify it was not modified."
}

$Verdict = "PASS"
if ($FailReasons.Count -gt 0) {
    $Verdict = "FAIL"
}

Write-Host ""
foreach ($CheckLine in $CheckLines) {
    Write-Host ("  " + $CheckLine)
}
Write-Host ""
Write-Host ("EVIDENCE VALIDATION: " + $Verdict)

# ----------------------------------------------------------------
# Write the evidence report
# ----------------------------------------------------------------
$ReportLines = @()
$ReportLines += "# Evidence Report (SIMULATED)"
$ReportLines += ""
$ReportLines += "Generated by scripts\validate-evidence.ps1. This report independently"
$ReportLines += "re-derives every fact from progress.md and improvement-rules.md - it"
$ReportLines += "does not simply trust transcripts\dreaming-run-001.md's claims."
$ReportLines += ""
$ReportLines += "## Independent re-verification"
$ReportLines += ""
$Counter = 1
foreach ($CheckLine in $CheckLines) {
    $ReportLines += ($Counter.ToString() + ". " + $CheckLine)
    $Counter = $Counter + 1
}
$ReportLines += ""

if ($FailReasons.Count -gt 0) {
    $ReportLines += "## Problems found"
    $ReportLines += ""
    foreach ($Reason in $FailReasons) {
        $ReportLines += ("- " + $Reason)
    }
    $ReportLines += ""
}

$ReportLines += "## Verdict"
$ReportLines += ""
$ReportLines += ("EVIDENCE VALIDATION: " + $Verdict)
$ReportLines += ""

if ($Verdict -eq "PASS") {
    $ReportLines += "Every cited date and occurrence count was independently confirmed"
    $ReportLines += "against the actual content of progress.md, not merely accepted from"
    $ReportLines += "the dreaming loop's own transcript."
}
else {
    $ReportLines += "One or more claims could not be independently confirmed. See Problems"
    $ReportLines += "found above. Do not trust or merge the associated proposal until this"
    $ReportLines += "is resolved."
}

Set-Content -LiteralPath $ReportPath -Value $ReportLines

Write-Host ""
Write-Host "Report written to reports\evidence-report.md"

if ($Verdict -eq "PASS") {
    exit 0
}
else {
    exit 1
}