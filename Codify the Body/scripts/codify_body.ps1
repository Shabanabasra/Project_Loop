# ==========================================================================
# Codify the Body - Project 5 (Loop Engineering Crash Course)
# ==========================================================================

# --------------------------------------------------------------------------
# CONFIGURATION
# --------------------------------------------------------------------------

$ScriptRoot = $PSScriptRoot
$ProjectRoot = Split-Path -Parent $ScriptRoot

$CandidatesDir = Join-Path $ProjectRoot "candidates"
$WorkspacesDir = Join-Path $ProjectRoot "workspaces"

$CandidateFiles = @(
    "issue1.md",
    "issue2.md",
    "issue3.md"
)

$Results = @()

# --------------------------------------------------------------------------
# FUNCTION: New-IsolatedWorkspace
# --------------------------------------------------------------------------

function New-IsolatedWorkspace {
    param(
        [string]$CandidateName
    )

    if (-not (Test-Path $WorkspacesDir)) {
        New-Item -ItemType Directory -Path $WorkspacesDir -Force | Out-Null
    }

    $WorkspacePath = Join-Path $WorkspacesDir $CandidateName

    if (Test-Path $WorkspacePath) {
        Remove-Item -Path $WorkspacePath -Recurse -Force
    }

    $IsGitRepo = $false

    try {
        git -C $ProjectRoot rev-parse --is-inside-work-tree 2>$null | Out-Null

        if ($LASTEXITCODE -eq 0) {
            $IsGitRepo = $true
        }
    }
    catch {
        $IsGitRepo = $false
    }

    if ($IsGitRepo) {
        Write-Host "  -> Git repo detected. Creating a real git worktree..."

        git -C $ProjectRoot worktree add `
            $WorkspacePath `
            -b "fix/$CandidateName" `
            2>$null | Out-Null

        if (-not (Test-Path $WorkspacePath)) {
            Write-Host "  -> Worktree creation failed. Using a plain isolated folder."
            New-Item -ItemType Directory -Path $WorkspacePath -Force | Out-Null
        }
    }
    else {
        Write-Host "  -> Not a git repo. Using a plain isolated folder."
        New-Item -ItemType Directory -Path $WorkspacePath -Force | Out-Null
    }

    return $WorkspacePath
}

# --------------------------------------------------------------------------
# FUNCTION: Invoke-Implementer
# Simulated maker/implementer
# --------------------------------------------------------------------------

function Invoke-Implementer {
    param(
        [string]$CandidateFile,
        [string]$WorkspacePath
    )

    Write-Host "  -> Implementer: reading issue file..."

    $IssuePath = Join-Path $CandidatesDir $CandidateFile

    if (-not (Test-Path $IssuePath)) {
        throw "Candidate issue file not found: $IssuePath"
    }

    $IssueContent = Get-Content $IssuePath -Raw

    $FixSummary = `
        "CANDIDATE: $CandidateFile`r`n" +
        "FILES CHANGED: (simulated) source file referenced in the issue`r`n" +
        "SUMMARY OF FIX: (simulated) applied the smallest change described in the issue's acceptance criteria.`r`n" +
        "TESTS RUN: (simulated) relevant test file run; assumed passing for this scaffold run."

    $ReportPath = Join-Path $WorkspacePath "implementer-report.txt"

    $FixSummary | Out-File `
        -FilePath $ReportPath `
        -Encoding utf8

    return $ReportPath
}

# --------------------------------------------------------------------------
# FUNCTION: Invoke-Reviewer
# Simulated checker/reviewer
# --------------------------------------------------------------------------

function Invoke-Reviewer {
    param(
        [string]$CandidateFile,
        [string]$ImplementerReportPath
    )

    Write-Host "  -> Reviewer: inspecting implementer's report..."

    if (-not (Test-Path $ImplementerReportPath)) {
        return [PSCustomObject]@{
            Candidate = $CandidateFile
            Verdict   = "FAIL"
            Reasons   = @("Implementer report was not found.")
        }
    }

    $ReportContent = Get-Content $ImplementerReportPath -Raw

    if ($ReportContent -match "TESTS RUN") {
        $Verdict = "PASS"
        $Reasons = @()
    }
    else {
        $Verdict = "FAIL"
        $Reasons = @(
            "No evidence of tests being run was found in the implementer's report."
        )
    }

    return [PSCustomObject]@{
        Candidate = $CandidateFile
        Verdict   = $Verdict
        Reasons   = $Reasons
    }
}

# --------------------------------------------------------------------------
# MAIN ORCHESTRATION
# --------------------------------------------------------------------------

Write-Host "=========================================================="
Write-Host " Codify the Body - running full draft-and-review workflow"
Write-Host "=========================================================="

foreach ($CandidateFile in $CandidateFiles) {

    $CandidateName = [System.IO.Path]::GetFileNameWithoutExtension(
        $CandidateFile
    )

    Write-Host ""
    Write-Host "---- Processing candidate: $CandidateFile ----"

    # Step 1: Create isolated workspace
    $Workspace = New-IsolatedWorkspace `
        -CandidateName $CandidateName

    # Step 2: Implementer / maker
    $ImplementerReport = Invoke-Implementer `
        -CandidateFile $CandidateFile `
        -WorkspacePath $Workspace

    # Step 3: Reviewer / checker
    $ReviewResult = Invoke-Reviewer `
        -CandidateFile $CandidateFile `
        -ImplementerReportPath $ImplementerReport

    # Step 4: Collect result
    $Results += $ReviewResult

    Write-Host "  -> Verdict for ${CandidateFile}: $($ReviewResult.Verdict)"
}

# --------------------------------------------------------------------------
# FINAL REPORT
# --------------------------------------------------------------------------

Write-Host ""
Write-Host "=========================================================="
Write-Host " FINAL REPORT"
Write-Host "=========================================================="

foreach ($Result in $Results) {

    Write-Host ""
    Write-Host "Candidate : $($Result.Candidate)"
    Write-Host "Verdict   : $($Result.Verdict)"

    if ($Result.Verdict -eq "FAIL") {

        Write-Host "Reasons   :"

        foreach ($Reason in $Result.Reasons) {
            Write-Host "  - $Reason"
        }
    }
}

Write-Host ""
Write-Host "=========================================================="
Write-Host " NOTE: This script has NO MEMORY between runs."
Write-Host " It does not read or write any progress file."
Write-Host " Every run starts completely fresh."
Write-Host "=========================================================="