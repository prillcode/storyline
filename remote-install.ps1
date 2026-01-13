# Storyline remote installer
# Usage: iwr -useb https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.ps1 | iex

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "📖 Storyline Remote Installer" -ForegroundColor Cyan
Write-Host "Story-driven development workflow for Claude Code"
Write-Host ""

# Check if git is installed
try {
    $gitVersion = git --version 2>$null
    if (-not $gitVersion) {
        throw "Git not found"
    }
}
catch {
    Write-Host "Error: git is not installed" -ForegroundColor Red
    Write-Host "Please install git first: https://git-scm.com/downloads"
    exit 1
}

# Determine installation directory
$installDir = $env:STORYLINE_INSTALL_DIR
if (-not $installDir) {
    $installDir = Join-Path $HOME ".local\share\storyline"
}

Write-Host "Installation directory: $installDir"
Write-Host ""

# Create installation directory if it doesn't exist
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

# Clone the repository with submodules
Write-Host "Cloning Storyline repository with dependencies..."

if (Test-Path (Join-Path $installDir ".git")) {
    Write-Host "Storyline already cloned. Updating..."
    Set-Location $installDir

    try {
        # Reset any local changes to ensure clean update
        git reset --hard HEAD 2>&1 | Out-Null
        git clean -fd 2>&1 | Out-Null
        git pull origin main
        git submodule update --init --recursive
    }
    catch {
        Write-Host "Error updating repository: $_" -ForegroundColor Red
        exit 1
    }
}
else {
    try {
        git clone --recurse-submodules https://github.com/prillcode/storyline.git $installDir
    }
    catch {
        Write-Host "Error cloning repository: $_" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "✅ Repository cloned successfully" -ForegroundColor Green
Write-Host ""

# Run the installer
Set-Location $installDir
& .\install.ps1

if ($LASTEXITCODE -ne 0) {
    Write-Host "Installation failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Storyline v2.1.3 installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "You can update Storyline anytime by running:"
Write-Host "  iwr -useb https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.ps1 | iex" -ForegroundColor Yellow
