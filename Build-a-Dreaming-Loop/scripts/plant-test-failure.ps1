# plant-test-failure.ps1
# Project 12: Build a Dreaming Loop
#
# Ensures progress.md contains the deliberately planted repeated
# failure pattern (3 occurrences) plus a one-off negative control (1
# occurrence), and records a baseline checksum of improvement-rules.md
# so later scripts can prove it was never modified directly. This
# script only touches files inside this project folder.

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ProgressPath = Join-Path $ProjectRoot "progress.md"
$RulesPath = Join-Path $ProjectRoot "improvement-rules.md"
$ChecksumPath = Join-Path $ProjectRoot "evidence\rules-checksum.txt"

$RepeatedFailureLines = @(
    "- 2026-08-17: FAILURE - validation step failed because required field was not checked.",
    "- 2026-08-24: FAILURE - validation step failed because required field was not checked.",
    "- 2026-08-31: FAILURE - validation step failed because required field was not checked."
)
$OneOffFailureLine = "- 2026-08-26: FAILURE - network timeout while fetching commit data (transient)."

Write-Host "=========================================================="
Write-Host " Planting/verifying test failure pattern in progress.md"
Write-Host "=========================================================="

if (-not (Test-Path -LiteralPath $ProgressPath -PathType Leaf)) {
    Write-Host "[MISSING] progress.md - cannot continue."
    exit 1
}

$ProgressLines = Get-Content -LiteralPath $ProgressPath
$ProgressText = Get-Content -LiteralPath $ProgressPath -Raw

$LinesToAdd = @()

foreach ($Line in $RepeatedFailureLines) {
    if ($ProgressText -notmatch [regex]::Escape($Line)) {
        $LinesToAdd += $Line
    }
}

if ($ProgressText -notmatch [regex]::Escape($OneOffFailureLine)) {
    $LinesToAdd += $OneOffFailureLine
}

if ($LinesToAdd.Count -gt 0) {
    Write-Host ("  Adding " + $LinesToAdd.Count + " missing planted line(s) to progress.md...")
    $NewLines = $ProgressLines + $LinesToAdd
    Set-Content -LiteralPath $ProgressPath -Value $NewLines
}
else {
    Write-Host "  All planted lines already present in progress.md. Nothing to add."
}

Write-Host ""
Write-Host "  Planted repeated failure (3 occurrences expected):"
Write-Host "    validation step failed because required field was not checked."
foreach ($Line in $RepeatedFailureLines) {
    Write-Host ("    " + $Line)
}

Write-Host ""
Write-Host "  Planted one-off negative control (1 occurrence expected):"
Write-Host ("    " + $OneOffFailureLine)

# ----------------------------------------------------------------
# Record a baseline checksum of improvement-rules.md, so later
# scripts can genuinely prove it was never modified directly.
# ----------------------------------------------------------------
if (Test-Path -LiteralPath $RulesPath -PathType Leaf) {
    $Hash = Get-FileHash -LiteralPath $RulesPath -Algorithm SHA256
    $EvidenceDir = Split-Path -Parent $ChecksumPath
    if (-not (Test-Path -LiteralPath $EvidenceDir)) {
        New-Item -ItemType Directory -Path $EvidenceDir -Force | Out-Null
    }
    Set-Content -LiteralPath $ChecksumPath -Value $Hash.Hash
    Write-Host ""
    Write-Host ("  Baseline checksum of improvement-rules.md recorded: " + $Hash.Hash)
    Write-Host "  Saved to evidence\rules-checksum.txt"
}
else {
    Write-Host "[MISSING] improvement-rules.md - could not record a baseline checksum."
}

Write-Host ""
Write-Host "Plant/verify complete. No file outside this project was touched."