# simulate-env-failure.ps1
# Project 10: The Secrets Drill
#
# Rehearses the DELIBERATE .env failure. This script performs REAL
# checks (not hardcoded strings): it looks for your actual local .env
# file, confirms .env is listed in .gitignore, builds a simulated fresh
# clone that excludes .env, and then genuinely attempts to read .env
# from inside that simulated clone to prove the failure. It NEVER
# prints your real key value anywhere, and it never calls any AI model,
# API, or the network.

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$LocalEnvPath = Join-Path $ProjectRoot ".env"
$GitignorePath = Join-Path $ProjectRoot ".gitignore"
$EvidenceDir = Join-Path $ProjectRoot "evidence\fresh-clone-simulation"
$TranscriptPath = Join-Path $ProjectRoot "transcripts\failed-env-file-run.md"
$ReportPath = Join-Path $ProjectRoot "reports\failure-report.md"

$RunId = "SECRETS-DRILL-RUN-" + (Get-Date -Format "yyyyMMdd-HHmmss")
$StartTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$KeyName = "OPENROUTER_API_KEY"

Write-Host "=========================================================="
Write-Host " Simulating .env FAILURE run: $RunId"
Write-Host "=========================================================="

# ----------------------------------------------------------------
# Step 1: check whether a local .env file actually exists.
# This script never reads the real value into any output. It only
# checks for the presence of a line naming the key, to confirm the
# file is set up the way this drill expects, without ever printing
# the value itself.
# ----------------------------------------------------------------
$LocalEnvExists = Test-Path -LiteralPath $LocalEnvPath -PathType Leaf
$LocalEnvHasKeyLine = $false

if ($LocalEnvExists) {
    Write-Host "  Local .env file found. Checking for a key entry (value will not be read or shown)..."
    $EnvLines = Get-Content -LiteralPath $LocalEnvPath
    foreach ($Line in $EnvLines) {
        if ($Line -match ("^" + $KeyName + "=")) {
            $LocalEnvHasKeyLine = $true
        }
    }
    if ($LocalEnvHasKeyLine) {
        Write-Host ("  Local .env contains a " + $KeyName + " entry (value not read).")
    }
    else {
        Write-Host ("  Local .env exists but no " + $KeyName + " line was found in it.")
    }
}
else {
    Write-Host "  No local .env file found. Continuing the drill using .env.example as a stand-in."
    Write-Host "  For the most realistic rehearsal, create your own local .env with your real key first."
}

# ----------------------------------------------------------------
# Step 2: confirm .env is actually listed in .gitignore.
# ----------------------------------------------------------------
$EnvIsGitignored = $false

if (Test-Path -LiteralPath $GitignorePath -PathType Leaf) {
    $GitignoreLines = Get-Content -LiteralPath $GitignorePath
    foreach ($Line in $GitignoreLines) {
        if ($Line.Trim() -eq ".env") {
            $EnvIsGitignored = $true
        }
    }
}

Write-Host ("  .env listed in .gitignore: " + $(if ($EnvIsGitignored) { "YES" } else { "NO" }))

# ----------------------------------------------------------------
# Step 3: build a simulated fresh clone that excludes .env, the same
# way a real git clone would exclude anything listed in .gitignore.
# ----------------------------------------------------------------
if (Test-Path -LiteralPath $EvidenceDir) {
    Remove-Item -LiteralPath $EvidenceDir -Recurse -Force
}
New-Item -ItemType Directory -Path $EvidenceDir -Force | Out-Null

$FilesToInclude = @("README.md", ".gitignore", ".env.example", "routine-prompt.md")
foreach ($FileName in $FilesToInclude) {
    $SourcePath = Join-Path $ProjectRoot $FileName
    if (Test-Path -LiteralPath $SourcePath -PathType Leaf) {
        Copy-Item -LiteralPath $SourcePath -Destination (Join-Path $EvidenceDir $FileName) -Force
    }
}

$ConfigSourceDir = Join-Path $ProjectRoot "config"
$ConfigDestDir = Join-Path $EvidenceDir "config"
if (Test-Path -LiteralPath $ConfigSourceDir -PathType Container) {
    Copy-Item -LiteralPath $ConfigSourceDir -Destination $ConfigDestDir -Recurse -Force
}

$NoteLines = @()
$NoteLines += "This folder simulates a fresh repository clone."
$NoteLines += "It intentionally excludes .env, because .env is listed"
$NoteLines += "in .gitignore and a real fresh clone would never receive it."
Set-Content -LiteralPath (Join-Path $EvidenceDir "WHAT-THIS-PROVES.txt") -Value $NoteLines

Write-Host ("  Simulated fresh clone created at: " + $EvidenceDir)

# ----------------------------------------------------------------
# Step 4: GENUINELY attempt to read .env from inside the simulated
# fresh clone. This is a real file operation with a real try/catch,
# not a hardcoded result.
# ----------------------------------------------------------------
$CloneEnvPath = Join-Path $EvidenceDir ".env"
$CloneContainsEnv = Test-Path -LiteralPath $CloneEnvPath -PathType Leaf

$ReadErrorMessage = "None"
$KeyFoundInClone = $false

try {
    $CloneEnvContent = Get-Content -LiteralPath $CloneEnvPath -Raw -ErrorAction Stop
    $KeyFoundInClone = $true
}
catch {
    $ReadErrorMessage = $_.Exception.Message
    $KeyFoundInClone = $false
}

Write-Host ("  Does the simulated fresh clone contain .env? " + $(if ($CloneContainsEnv) { "YES" } else { "NO" }))
Write-Host ("  Genuine read attempt inside simulated clone: " + $(if ($KeyFoundInClone) { "SUCCEEDED (unexpected)" } else { "FAILED as expected" }))

# ----------------------------------------------------------------
# Step 5: also check the process environment variable, purely for
# informational context in the transcript. This does NOT determine
# the verdict - the verdict is based on the genuine .env-in-clone
# check above, because the drill's first prompt relies on .env, not
# on the environment variables panel.
# ----------------------------------------------------------------
$EnvVarValue = [System.Environment]::GetEnvironmentVariable($KeyName)
$EnvVarFound = -not [string]::IsNullOrEmpty($EnvVarValue)

Write-Host ("  (Informational only) Process environment variable " + $KeyName + ": " + $(if ($EnvVarFound) { "SET" } else { "NOT SET" }))

$KeyStatus = "[NOT AVAILABLE]"
$TaskResult = "FAILED"

if ($KeyFoundInClone) {
    $KeyStatus = "[AVAILABLE]"
    $TaskResult = "SUCCESS"
}

Write-Host ("  Result: " + $KeyName + " = " + $KeyStatus)

# ----------------------------------------------------------------
# Write the transcript
# ----------------------------------------------------------------
$LocalEnvExistsText = "NO"
if ($LocalEnvExists) { $LocalEnvExistsText = "YES" }

$EnvIsGitignoredText = "NO"
if ($EnvIsGitignored) { $EnvIsGitignoredText = "YES" }

$CloneHasEnvText = "NO"
if ($CloneContainsEnv) { $CloneHasEnvText = "YES" }

$EnvVarFoundText = "NOT SET"
if ($EnvVarFound) { $EnvVarFoundText = "SET" }

$TranscriptLines = @()
$TranscriptLines += "# Failed .env File Run Transcript"
$TranscriptLines += ""
$TranscriptLines += ("Run ID: " + $RunId)
$TranscriptLines += ("Start time: " + $StartTime)
$TranscriptLines += "Trigger type: one-off (Run now / one-off schedule simulation)"
$TranscriptLines += ""
$TranscriptLines += "## Prompt used"
$TranscriptLines += ""
$TranscriptLines += ("Read the " + $KeyName + " value needed for this task and confirm")
$TranscriptLines += "that it is available. Look in the project's .env file if needed. Do"
$TranscriptLines += "not print the key."
$TranscriptLines += ""
$TranscriptLines += "## Local .env check"
$TranscriptLines += ""
$TranscriptLines += ("Local .env file exists at project root: " + $LocalEnvExistsText)
$TranscriptLines += ("Local .env is listed in .gitignore: " + $EnvIsGitignoredText)
$TranscriptLines += "(The real value, if any, is never read into this transcript.)"
$TranscriptLines += ""
$TranscriptLines += "## Fresh clone simulation"
$TranscriptLines += ""
$TranscriptLines += "A simulated fresh clone was created at:"
$TranscriptLines += 'evidence\fresh-clone-simulation\'
$TranscriptLines += ""
$TranscriptLines += "Only non-gitignored files were copied into it. The .env file was"
$TranscriptLines += "deliberately NOT copied, because a real Routine's fresh clone would"
$TranscriptLines += "never receive a gitignored file either."
$TranscriptLines += ""
$TranscriptLines += ("Does the simulated fresh clone contain .env? " + $CloneHasEnvText)
$TranscriptLines += ""
$TranscriptLines += "## Genuine read attempt"
$TranscriptLines += ""
$TranscriptLines += ("A real attempt was made to read .env from inside the simulated")
$TranscriptLines += ("fresh clone. Error recorded: " + $ReadErrorMessage)
$TranscriptLines += ""
$TranscriptLines += "## Informational: process environment variable"
$TranscriptLines += ""
$TranscriptLines += ("Process environment variable " + $KeyName + ": " + $EnvVarFoundText)
$TranscriptLines += "(This does not change the verdict for this run, since this prompt"
$TranscriptLines += "relies on .env, not the environment variables panel.)"
$TranscriptLines += ""
$TranscriptLines += "## Result"
$TranscriptLines += ""
$TranscriptLines += ($KeyName + " = " + $KeyStatus)
$TranscriptLines += ""
$TranscriptLines += "## What was attempted"
$TranscriptLines += ""
$TranscriptLines += "1. Looked for .env inside the simulated fresh clone."
$TranscriptLines += "2. Attempted a genuine file read of that path."
$TranscriptLines += "3. The read failed because the file does not exist in the clone,"
$TranscriptLines += "   which is the expected, correct outcome for this drill."
$TranscriptLines += ""
$TranscriptLines += "## Task result"
$TranscriptLines += ""
$TranscriptLines += ("Task Result: " + $TaskResult)
$TranscriptLines += ""
$TranscriptLines += "## Platform status"
$TranscriptLines += ""
$TranscriptLines += "Platform Status: GREEN"
$TranscriptLines += "(The simulated session ended without an infrastructure error. The"
$TranscriptLines += "missing-secret condition was detected and handled safely, without"
$TranscriptLines += "crashing the script.)"
$TranscriptLines += ""
$TranscriptLines += "## Explanation of why it failed"
$TranscriptLines += ""
$TranscriptLines += "The key is only ever expected to live in your local .env file. Per"
$TranscriptLines += ".gitignore, .env is excluded from anything that reaches a real"
$TranscriptLines += "repository clone. A real cloud Routine always starts from a fresh"
$TranscriptLines += "clone, and this simulation reproduces that by building a fresh-clone"
$TranscriptLines += "folder that genuinely excludes gitignored files, then genuinely"
$TranscriptLines += "attempting to read .env from inside it. The read fails because the"
$TranscriptLines += "file is not there. This is not a bug - it is the mechanical, expected"
$TranscriptLines += "consequence of relying on a gitignored file for a secret."
$TranscriptLines += ""
$TranscriptLines += "## What should be changed before the next run"
$TranscriptLines += ""
$TranscriptLines += ("Move " + $KeyName + " into the Routine's environment variables panel")
$TranscriptLines += "(or, in this local rehearsal, set it as a real process environment"
$TranscriptLines += 'variable before firing the Routine), and add the line "credentials'
$TranscriptLines += 'are available as environment variables; do not look for a .env'
$TranscriptLines += 'file" to the prompt. See transcripts\successful-environment-run.md'
$TranscriptLines += "for the corrected version of this run."

Set-Content -LiteralPath $TranscriptPath -Value $TranscriptLines

# ----------------------------------------------------------------
# Write the failure report
# ----------------------------------------------------------------
$ReportLines = @()
$ReportLines += "# Failure Report - Secrets Drill"
$ReportLines += ""
$ReportLines += ("Run ID: " + $RunId)
$ReportLines += ("Timestamp: " + $StartTime)
$ReportLines += ""
$ReportLines += "## What failed"
$ReportLines += ""
$ReportLines += ("The attempt to obtain " + $KeyName + " from .env, inside a simulated")
$ReportLines += ("fresh clone of the project, failed. " + $KeyName + " = " + $KeyStatus + ".")
$ReportLines += ""
$ReportLines += "## Why it failed"
$ReportLines += ""
$ReportLines += ($KeyName + " is only ever expected to live in your local .env file, and")
$ReportLines += ".env is listed in .gitignore. A fresh clone (real or simulated) never"
$ReportLines += "receives gitignored files, so the key was never present in the clone"
$ReportLines += "that the task actually ran against."
$ReportLines += ""
$ReportLines += "## Mechanical chain of failure"
$ReportLines += ""
$ReportLines += ".env is gitignored"
$ReportLines += "-> gitignored files do not reach GitHub"
$ReportLines += "-> a Routine starts from a fresh clone"
$ReportLines += "-> the fresh clone does not contain .env"
$ReportLines += "-> the secret is unavailable"
$ReportLines += "-> the task fails"
$ReportLines += ""
$ReportLines += "## Was the real secret exposed anywhere"
$ReportLines += ""
$ReportLines += "No. This report and the corresponding transcript both report the"
$ReportLines += "key's status only. No real key value is stored or printed anywhere in"
$ReportLines += "this project."
$ReportLines += ""
$ReportLines += "## What a human should do next"
$ReportLines += ""
$ReportLines += ("Move " + $KeyName + " into the environment variables panel (or, for")
$ReportLines += "this local rehearsal, set it as a real process environment variable),"
$ReportLines += 'and add the required prompt line: "credentials are available as'
$ReportLines += 'environment variables; do not look for a .env file." Then run'
$ReportLines += "scripts\simulate-environment-success.ps1 and confirm success."

Set-Content -LiteralPath $ReportPath -Value $ReportLines

Write-Host ""
Write-Host "Secrets drill failure rehearsal completed."
Write-Host "Platform Status: GREEN"
Write-Host ("Task Result: " + $TaskResult)
Write-Host ""
Write-Host "Transcript written to transcripts\failed-env-file-run.md"
Write-Host "Report written to reports\failure-report.md"
Write-Host 'Evidence written to evidence\fresh-clone-simulation\'

if ($TaskResult -eq "FAILED") {
    exit 1
}
else {
    exit 0
}