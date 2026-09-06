# ==========================================================================
# Setup Check - Project 6: The Doorbell Loop
# ==========================================================================

# Project root = one level up from this script's folder (scripts/)
$ProjectRoot = Split-Path -Parent $PSScriptRoot

# List of required files, relative to the project root
$RequiredFiles = @(
    "README.md",
    "candidates\planted-bug.md",
    "skills\pr-review-skill.md",
    "reviewers\reviewer.md",
    ".github\workflows\doorbell-review.yml"
)

Write-Host "=========================================================="
Write-Host " Project 6: The Doorbell Loop - Setup Check"
Write-Host "=========================================================="

$AllFound = $true

foreach ($RelativePath in $RequiredFiles) {

    $FullPath = Join-Path $ProjectRoot $RelativePath

    if (Test-Path $FullPath) {
        Write-Host "[OK] $RelativePath"
    }
    else {
        Write-Host "[MISSING] $RelativePath"
        $AllFound = $false
    }
}

Write-Host "=========================================================="

if ($AllFound) {
    Write-Host "SETUP CHECK: PASS"
}
else {
    Write-Host "SETUP CHECK: FAIL"
}

Write-Host "=========================================================="