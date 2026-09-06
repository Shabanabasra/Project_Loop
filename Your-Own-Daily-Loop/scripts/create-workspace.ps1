# create-workspace.ps1
# Project 8: Your Own Daily Loop
#
# Creates an isolated workspace for one run, under workspaces\<RunId>.
# If the project folder is itself a real git repository, this creates a
# real git worktree. If not, it safely falls back to a plain folder
# copy. This never touches or deletes anything outside this project.
#
# The ONLY thing written to the normal output stream is the final
# workspace path, so this script can be safely captured with:
#   $WorkspacePath = & .\create-workspace.ps1 -RunId $RunId

param(
    [Parameter(Mandatory = $true)]
    [string]$RunId
)

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$WorkspacesDir = Join-Path $ProjectRoot "workspaces"
$SourcePath = Join-Path $ProjectRoot "source-data.txt"

if (-not (Test-Path $WorkspacesDir)) {
    New-Item -ItemType Directory -Path $WorkspacesDir | Out-Null
}

$WorkspacePath = Join-Path $WorkspacesDir $RunId

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
    Write-Host "  Git repo detected. Creating a real git worktree for this run..."
    git -C $ProjectRoot worktree add $WorkspacePath -b ("audit/" + $RunId) 2>$null | Out-Null

    if (-not (Test-Path $WorkspacePath)) {
        Write-Host "  Worktree creation did not succeed. Falling back to a plain folder."
        New-Item -ItemType Directory -Path $WorkspacePath -Force | Out-Null
    }
}
else {
    Write-Host "  Not a git repo (or git not available). Using a plain isolated folder instead."
    New-Item -ItemType Directory -Path $WorkspacePath -Force | Out-Null
}

if (Test-Path $SourcePath) {
    Copy-Item -Path $SourcePath -Destination (Join-Path $WorkspacePath "source-data.txt") -Force
}

Write-Output $WorkspacePath