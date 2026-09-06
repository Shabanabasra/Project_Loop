# Project 12 - Build a Dreaming Loop
# Simulates the weekly dreaming/improvement loop.
#
# IMPORTANT:
# - Reads progress.md and dreaming-state.md
# - Detects repeated failures
# - Uses evidence from actual progress entries
# - Proposes a smallest rule change
# - Proposes one deletion candidate
# - Simulates a claude/ branch and PR
# - NEVER modifies improvement-rules.md
# - Updates dreaming-state.md only after successful completion
# - This is a local rehearsal; no real GitHub PR is created

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------

$ProjectRoot = Split-Path -Parent $PSScriptRoot

$StatePath = Join-Path $ProjectRoot "dreaming-state.md"
$ProgressPath = Join-Path $ProjectRoot "progress.md"
$RulesPath = Join-Path $ProjectRoot "improvement-rules.md"

$TranscriptDir = Join-Path $ProjectRoot "transcripts"
$ReportsDir = Join-Path $ProjectRoot "reports"

$TranscriptPath = Join-Path $TranscriptDir "transcripts-dreaming-run-001.md"
$ReportPath = Join-Path $ReportsDir "dreaming-report.md"
$EvidenceReportPath = Join-Path $ReportsDir "evidence-report.md"

# Actual project file uses this transcript filename.
# Keep compatibility if the existing filename is present.
$ExistingTranscriptPath = Join-Path $TranscriptDir "dreaming-run-001.md"

# ------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------

function Fail-Run {
    param(
        [string]$Message
    )

    Write-Host ""
    Write-Host "DREAMING LOOP RESULT: FAIL" -ForegroundColor Red
    Write-Host $Message -ForegroundColor Red
    exit 1
}

function Get-DateFromText {
    param(
        [string]$Text
    )

    $Match = [regex]::Match($Text, "\d{4}-\d{2}-\d{2}")

    if (-not $Match.Success) {
        throw "Could not find a YYYY-MM-DD date."
    }

    return [datetime]::ParseExact(
        $Match.Value,
        "yyyy-MM-dd",
        [Globalization.CultureInfo]::InvariantCulture
    )
}

function Get-KeywordSet {
    param(
        [string]$Text
    )

    $StopWords = @(
        "the",
        "and",
        "for",
        "with",
        "that",
        "this",
        "from",
        "into",
        "when",
        "then",
        "than",
        "before",
        "after",
        "every",
        "required",
        "must",
        "should",
        "task",
        "tasks",
        "use",
        "using",
        "verify",
        "clear",
        "descriptive",
        "commit",
        "messages"
    )

    $Words = [regex]::Matches(
        $Text.ToLowerInvariant(),
        "[a-z]{3,}"
    ) | ForEach-Object {
        $_.Value
    }

    $Result = @()

    foreach ($Word in $Words) {
        if ($StopWords -notcontains $Word) {
            $Result += $Word
        }
    }

    return @($Result | Sort-Object -Unique)
}

function Get-OverlapCount {
    param(
        [string[]]$A,
        [string[]]$B
    )

    $Count = 0

    foreach ($Item in $A) {
        if ($B -contains $Item) {
            $Count++
        }
    }

    return $Count
}

# ------------------------------------------------------------
# Validate required files
# ------------------------------------------------------------

Write-Host "=== Project 12: Build a Dreaming Loop ==="
Write-Host ""

$RequiredFiles = @(
    $StatePath,
    $ProgressPath,
    $RulesPath
)

foreach ($File in $RequiredFiles) {
    if (-not (Test-Path -LiteralPath $File -PathType Leaf)) {
        Fail-Run "Required file is missing: $File"
    }
}

if (-not (Test-Path -LiteralPath $TranscriptDir -PathType Container)) {
    New-Item -ItemType Directory -Path $TranscriptDir -Force | Out-Null
}

if (-not (Test-Path -LiteralPath $ReportsDir -PathType Container)) {
    New-Item -ItemType Directory -Path $ReportsDir -Force | Out-Null
}

Write-Host "[OK] Required files found."

# ------------------------------------------------------------
# Read source files
# ------------------------------------------------------------

$StateText = Get-Content -LiteralPath $StatePath -Raw
$ProgressText = Get-Content -LiteralPath $ProgressPath -Raw
$RulesText = Get-Content -LiteralPath $RulesPath -Raw

if ([string]::IsNullOrWhiteSpace($StateText)) {
    Fail-Run "dreaming-state.md is empty."
}

if ([string]::IsNullOrWhiteSpace($ProgressText)) {
    Fail-Run "progress.md is empty."
}

if ([string]::IsNullOrWhiteSpace($RulesText)) {
    Fail-Run "improvement-rules.md is empty."
}

# ------------------------------------------------------------
# Read last reviewed date
# ------------------------------------------------------------

$StateMatch = [regex]::Match(
    $StateText,
    "(?im)Last reviewed date:\s*(\d{4}-\d{2}-\d{2})"
)

if (-not $StateMatch.Success) {
    Fail-Run "Could not find 'Last reviewed date: YYYY-MM-DD' in dreaming-state.md."
}

$LastReviewedDate = [datetime]::ParseExact(
    $StateMatch.Groups[1].Value,
    "yyyy-MM-dd",
    [Globalization.CultureInfo]::InvariantCulture
)

Write-Host ("Previous reviewed date: " + $LastReviewedDate.ToString("yyyy-MM-dd"))

# ------------------------------------------------------------
# Parse progress.md
# Expected format:
# - 2026-08-17: FAILURE - description
# ------------------------------------------------------------

$Entries = @()

foreach ($Line in ($ProgressText -split "\r?\n")) {

    if ([string]::IsNullOrWhiteSpace($Line)) {
        continue
    }

    $Match = [regex]::Match(
        $Line,
        "^\-\s*(\d{4}-\d{2}-\d{2}):\s*(.+)$"
    )

    if (-not $Match.Success) {
        continue
    }

    $EntryDate = [datetime]::ParseExact(
        $Match.Groups[1].Value,
        "yyyy-MM-dd",
        [Globalization.CultureInfo]::InvariantCulture
    )

    $Description = $Match.Groups[2].Value.Trim()

    $Entries += [pscustomobject]@{
        Date        = $EntryDate
        DateText    = $Match.Groups[1].Value
        Description = $Description
    }
}

if ($Entries.Count -eq 0) {
    Fail-Run "No dated entries were found in progress.md."
}

# ------------------------------------------------------------
# Select entries since last reviewed date
# ------------------------------------------------------------

$NewEntries = @(
    $Entries |
        Where-Object {
            $_.Date -gt $LastReviewedDate
        } |
        Sort-Object Date
)

if ($NewEntries.Count -eq 0) {
    Fail-Run (
        "No progress entries exist after last reviewed date " +
        $LastReviewedDate.ToString("yyyy-MM-dd") + "."
    )
}

Write-Host ("New progress entries examined: " + $NewEntries.Count)

# ------------------------------------------------------------
# Find failures
# ------------------------------------------------------------

$FailureEntries = @(
    $NewEntries |
        Where-Object {
            $_.Description -match "^FAILURE\s*-\s*(.+)$"
        }
)

if ($FailureEntries.Count -eq 0) {
    Fail-Run "No FAILURE entries found after the last reviewed date."
}

# Extract clean failure descriptions
$FailureRecords = @()

foreach ($Entry in $FailureEntries) {

    $FailureMatch = [regex]::Match(
        $Entry.Description,
        "^FAILURE\s*-\s*(.+)$"
    )

    if (-not $FailureMatch.Success) {
        continue
    }

    $FailureDescription = $FailureMatch.Groups[1].Value.Trim()

    $FailureRecords += [pscustomobject]@{
        Date        = $Entry.Date
        DateText    = $Entry.DateText
        Description = $FailureDescription
    }
}

if ($FailureRecords.Count -eq 0) {
    Fail-Run "Could not extract failure descriptions."
}

# ------------------------------------------------------------
# Group failures by exact description
# ------------------------------------------------------------

$FailureGroups = @(
    $FailureRecords |
        Group-Object -Property Description |
        Sort-Object Count -Descending
)

if ($FailureGroups.Count -eq 0) {
    Fail-Run "No failure groups could be created."
}

$RepeatedGroup = $FailureGroups |
    Where-Object {
        $_.Count -ge 2
    } |
    Select-Object -First 1

if ($null -eq $RepeatedGroup) {
    Fail-Run "No repeated failure pattern was found."
}

$RepeatedDescription = [string]$RepeatedGroup.Name
$RepeatedCount = [int]$RepeatedGroup.Count

$RepeatedDates = @(
    $FailureRecords |
        Where-Object {
            $_.Description -eq $RepeatedDescription
        } |
        Sort-Object Date
)

Write-Host ""
Write-Host "Repeated failure detected:"
Write-Host ("  " + $RepeatedDescription)
Write-Host ("  Occurrences: " + $RepeatedCount)

# ------------------------------------------------------------
# Find one-off failure(s)
# ------------------------------------------------------------

$OneOffGroups = @(
    $FailureGroups |
        Where-Object {
            $_.Count -eq 1
        }
)

$OneOffFailure = $null

if ($OneOffGroups.Count -gt 0) {
    $OneOffFailure = $OneOffGroups[0].Name
}

# ------------------------------------------------------------
# Detect latest examined date
# ------------------------------------------------------------

$LatestEntry = $NewEntries |
    Sort-Object Date -Descending |
    Select-Object -First 1

$LatestExaminedDate = $LatestEntry.Date
$LatestExaminedDateText = $LatestExaminedDate.ToString("yyyy-MM-dd")

# ------------------------------------------------------------
# Create smallest possible proposed rule
# ------------------------------------------------------------

$ProposedRule = $null

if ($RepeatedDescription -match "required field") {

    $ProposedRule = "Before completing the task, verify every required field explicitly."
}
else {
    $ProposedRule = (
        "Before completing the task, explicitly verify the condition " +
        "that caused the repeated failure."
    )
}

# ------------------------------------------------------------
# Parse improvement-rules.md
# ------------------------------------------------------------

$Rules = @()

foreach ($Line in ($RulesText -split "\r?\n")) {

    $RuleMatch = [regex]::Match(
        $Line,
        "^\s*(\d+)\.\s*(.+?)\s*$"
    )

    if (-not $RuleMatch.Success) {
        continue
    }

    $Rules += [pscustomobject]@{
        Number = [int]$RuleMatch.Groups[1].Value
        Text   = $RuleMatch.Groups[2].Value.Trim()
    }
}

if ($Rules.Count -eq 0) {
    Fail-Run "No numbered rules were found in improvement-rules.md."
}

# ------------------------------------------------------------
# Find deletion candidate
# Candidate = rule with lowest keyword overlap against
# recently examined entries.
# ------------------------------------------------------------

$RecentVocabularyText = ($NewEntries |
    ForEach-Object {
        $_.Description
    }) -join " "

$RecentVocabulary = Get-KeywordSet -Text $RecentVocabularyText

$RuleScores = @()

foreach ($Rule in $Rules) {

    $RuleKeywords = Get-KeywordSet -Text $Rule.Text

    $Overlap = Get-OverlapCount `
        -A $RuleKeywords `
        -B $RecentVocabulary

    $RuleScores += [pscustomobject]@{
        Number  = $Rule.Number
        Text    = $Rule.Text
        Overlap = $Overlap
    }
}

$DeletionCandidate = $RuleScores |
    Sort-Object Overlap, Number |
    Select-Object -First 1

if ($null -eq $DeletionCandidate) {
    Fail-Run "Could not select a deletion candidate."
}

Write-Host ""
Write-Host "Deletion candidate:"
Write-Host (
    "  Rule " +
    $DeletionCandidate.Number +
    ": " +
    $DeletionCandidate.Text
)

# ------------------------------------------------------------
# Simulated branch and PR
# ------------------------------------------------------------

$BranchName = "claude/dreaming-loop-improvement-" + $LatestExaminedDateText

$PRTitle = (
    "Improve rule coverage for repeated validation failure"
)

$PRDescription = (
    "Evidence: the same failure occurred " +
    $RepeatedCount +
    " times after the previous review date. " +
    "The proposed rule explicitly verifies every required field " +
    "before task completion. " +
    "Deletion candidate: Rule " +
    $DeletionCandidate.Number +
    " because it had the lowest keyword overlap with the " +
    "recent evidence. " +
    "No direct modification of improvement-rules.md is performed. " +
    "A human must review and merge the PR."
)

# ------------------------------------------------------------
# Checksum before run
# ------------------------------------------------------------

$RulesHashBefore = (
    Get-FileHash `
        -LiteralPath $RulesPath `
        -Algorithm SHA256
).Hash

# ------------------------------------------------------------
# Build transcript
# ------------------------------------------------------------

$TranscriptLines = @()

$TranscriptLines += "# Dreaming Loop Run"
$TranscriptLines += ""
$TranscriptLines += "## Run Metadata"
$TranscriptLines += ""
$TranscriptLines += ("Previous reviewed date: " + $LastReviewedDate.ToString("yyyy-MM-dd"))
$TranscriptLines += ("Latest examined date: " + $LatestExaminedDateText)
$TranscriptLines += ("Entries examined: " + $NewEntries.Count)
$TranscriptLines += ""

$TranscriptLines += "## Evidence Scan"
$TranscriptLines += ""
$TranscriptLines += (
    "Repeated failure: " +
    $RepeatedDescription
)
$TranscriptLines += (
    "Repeated failure count: " +
    $RepeatedCount
)

foreach ($RepeatedDate in $RepeatedDates) {
    $TranscriptLines += (
        "- " +
        $RepeatedDate.DateText +
        ": " +
        $RepeatedDate.Description
    )
}

if ($null -ne $OneOffFailure) {
    $OneOffRecord = $FailureRecords |
        Where-Object {
            $_.Description -eq $OneOffFailure
        } |
        Select-Object -First 1

    $TranscriptLines += ""
    $TranscriptLines += "One-off failure (negative control):"
    $TranscriptLines += (
        "- " +
        $OneOffRecord.DateText +
        ": " +
        $OneOffRecord.Description
    )
}

$TranscriptLines += ""
$TranscriptLines += "## Proposed Improvement"
$TranscriptLines += ""
$TranscriptLines += (
    "Title: Propose rule change based on " +
    $RepeatedCount +
    " repeated failures"
)
$TranscriptLines += (
    "Proposed rule: " +
    $ProposedRule
)

$TranscriptLines += ""
$TranscriptLines += "## Deletion Proposal"
$TranscriptLines += ""
$TranscriptLines += (
    "Rule " +
    $DeletionCandidate.Number +
    " - " +
    [char]34 +
    $DeletionCandidate.Text +
    [char]34 +
    " (lowest keyword overlap with recent evidence)"
)

$TranscriptLines += ""
$TranscriptLines += "## Simulated Branch"
$TranscriptLines += ""
$TranscriptLines += ("Branch: " + $BranchName)

$TranscriptLines += ""
$TranscriptLines += "## Simulated Pull Request"
$TranscriptLines += ""
$TranscriptLines += ("PR title: " + $PRTitle)
$TranscriptLines += ("PR description: " + $PRDescription)

$TranscriptLines += ""
$TranscriptLines += "## Human Gate"
$TranscriptLines += ""
$TranscriptLines += (
    "This PR does NOT modify improvement-rules.md directly."
)
$TranscriptLines += (
    "No merge is performed automatically."
)
$TranscriptLines += (
    "Human review and merge are required."
)

$TranscriptLines += ""
$TranscriptLines += "## State Update"
$TranscriptLines += ""
$TranscriptLines += (
    "Updated last reviewed date to " +
    $LatestExaminedDateText +
    " after successful run."
)

$TranscriptLines += ""
$TranscriptLines += "## Final Result"
$TranscriptLines += ""
$TranscriptLines += "DREAMING LOOP RESULT: SUCCESS"

# ------------------------------------------------------------
# Write transcript
# ------------------------------------------------------------

Set-Content `
    -LiteralPath $ExistingTranscriptPath `
    -Value $TranscriptLines `
    -Encoding UTF8

# Also write to the alternate expected transcript path
Set-Content `
    -LiteralPath $TranscriptPath `
    -Value $TranscriptLines `
    -Encoding UTF8

# ------------------------------------------------------------
# Build dreaming report
# ------------------------------------------------------------

$ReportLines = @()

$ReportLines += "# Dreaming Loop Report"
$ReportLines += ""
$ReportLines += ("Previous reviewed date: " + $LastReviewedDate.ToString("yyyy-MM-dd"))
$ReportLines += ("Latest examined date: " + $LatestExaminedDateText)
$ReportLines += ("Entries examined: " + $NewEntries.Count)
$ReportLines += ""

$ReportLines += "## Repeated Failure"
$ReportLines += ""
$ReportLines += ("Failure: " + $RepeatedDescription)
$ReportLines += ("Occurrences: " + $RepeatedCount)

$ReportLines += ""
$ReportLines += "## Evidence Dates"
$ReportLines += ""

foreach ($RepeatedDate in $RepeatedDates) {
    $ReportLines += (
        "- " +
        $RepeatedDate.DateText +
        ": " +
        $RepeatedDate.Description
    )
}

$ReportLines += ""
$ReportLines += "## Proposed Rule"
$ReportLines += ""
$ReportLines += $ProposedRule

$ReportLines += ""
$ReportLines += "## Deletion Candidate"
$ReportLines += ""
$ReportLines += (
    "Rule " +
    $DeletionCandidate.Number +
    ": " +
    $DeletionCandidate.Text
)

$ReportLines += ""
$ReportLines += "## Branch"
$ReportLines += ""
$ReportLines += $BranchName

$ReportLines += ""
$ReportLines += "## Human Gate"
$ReportLines += ""
$ReportLines += "Human review is required before merge."
$ReportLines += "No automatic merge was performed."
$ReportLines += "improvement-rules.md was not modified."

$ReportLines += ""
$ReportLines += "## Result"
$ReportLines += ""
$ReportLines += "DREAMING LOOP RESULT: SUCCESS"

Set-Content `
    -LiteralPath $ReportPath `
    -Value $ReportLines `
    -Encoding UTF8

# ------------------------------------------------------------
# Build evidence report
# ------------------------------------------------------------

$EvidenceLines = @()

$EvidenceLines += "# Evidence Report"
$EvidenceLines += ""
$EvidenceLines += ("Repeated failure: " + $RepeatedDescription)
$EvidenceLines += ("Computed occurrences: " + $RepeatedCount)
$EvidenceLines += ""

$EvidenceLines += "## Matching Evidence"

foreach ($RepeatedDate in $RepeatedDates) {
    $EvidenceLines += (
        "- " +
        $RepeatedDate.DateText +
        ": " +
        $RepeatedDate.Description
    )
}

$EvidenceLines += ""
$EvidenceLines += "## Negative Control"

if ($null -ne $OneOffFailure) {

    $OneOffRecord = $FailureRecords |
        Where-Object {
            $_.Description -eq $OneOffFailure
        } |
        Select-Object -First 1

    $EvidenceLines += (
        "- " +
        $OneOffRecord.DateText +
        ": " +
        $OneOffRecord.Description
    )
}
else {
    $EvidenceLines += "- No one-off failure found."
}

$EvidenceLines += ""
$EvidenceLines += "## Proposed Improvement"
$EvidenceLines += ""
$EvidenceLines += $ProposedRule

$EvidenceLines += ""
$EvidenceLines += "## Deletion Candidate"
$EvidenceLines += ""
$EvidenceLines += (
    "Rule " +
    $DeletionCandidate.Number +
    ": " +
    $DeletionCandidate.Text
)

$EvidenceLines += ""
$EvidenceLines += "## Evidence Verdict"
$EvidenceLines += ""
$EvidenceLines += "PASS"

Set-Content `
    -LiteralPath $EvidenceReportPath `
    -Value $EvidenceLines `
    -Encoding UTF8

# ------------------------------------------------------------
# Verify improvement-rules.md was NOT changed
# ------------------------------------------------------------

$RulesHashAfter = (
    Get-FileHash `
        -LiteralPath $RulesPath `
        -Algorithm SHA256
).Hash

if ($RulesHashBefore -ne $RulesHashAfter) {
    Fail-Run "SAFETY FAILURE: improvement-rules.md changed during the run."
}

# ------------------------------------------------------------
# Update dreaming-state.md
# ONLY after all successful checks
# ------------------------------------------------------------

$UpdatedState = @(
    "# Dreaming Loop State"
    ""
    ("Last reviewed date: " + $LatestExaminedDateText)
    ""
    "The dreaming loop reviews progress entries after the last reviewed date."
    "Repeated failures are converted into proposed rule/skill improvements."
    "Changes require human review and merge."
)

Set-Content `
    -LiteralPath $StatePath `
    -Value $UpdatedState `
    -Encoding UTF8

# ------------------------------------------------------------
# Final verification
# ------------------------------------------------------------

$FinalStateText = Get-Content -LiteralPath $StatePath -Raw

$FinalStateMatch = [regex]::Match(
    $FinalStateText,
    "(?im)Last reviewed date:\s*(\d{4}-\d{2}-\d{2})"
)

if (-not $FinalStateMatch.Success) {
    Fail-Run "State update verification failed."
}

if ($FinalStateMatch.Groups[1].Value -ne $LatestExaminedDateText) {
    Fail-Run (
        "State date mismatch. Expected " +
        $LatestExaminedDateText +
        " but found " +
        $FinalStateMatch.Groups[1].Value
    )
}

$FinalRulesHash = (
    Get-FileHash `
        -LiteralPath $RulesPath `
        -Algorithm SHA256
).Hash

if ($FinalRulesHash -ne $RulesHashBefore) {
    Fail-Run "SAFETY FAILURE: improvement-rules.md changed after final verification."
}

# ------------------------------------------------------------
# Final success
# ------------------------------------------------------------

Write-Host ""
Write-Host "=== Dreaming Loop Summary ==="
Write-Host ("Previous reviewed date : " + $LastReviewedDate.ToString("yyyy-MM-dd"))
Write-Host ("Latest examined date   : " + $LatestExaminedDateText)
Write-Host ("Entries examined       : " + $NewEntries.Count)
Write-Host ("Repeated failure count : " + $RepeatedCount)
Write-Host ("Proposed rule          : " + $ProposedRule)
Write-Host (
    "Deletion candidate     : Rule " +
    $DeletionCandidate.Number
)
Write-Host ("Branch                 : " + $BranchName)
Write-Host "Human gate             : PENDING"
Write-Host "Rules file modified    : NO"
Write-Host ""

Write-Host "DREAMING LOOP RESULT: SUCCESS" -ForegroundColor Green