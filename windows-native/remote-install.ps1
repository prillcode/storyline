# Storyline remote installer
# Usage: Invoke-WebRequest -Uri https://raw.githubusercontent.com/prillcode/storyline/main/windows-native/remote-install.ps1 | Invoke-Expression

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "📖 Storyline Remote Installer" -ForegroundColor Blue
Write-Host "Story-driven development workflow for Claude Code"
Write-Host ""

# Check if git is installed
try {
    git --version | Out-Null
} catch {
    Write-Host "Error: git is not installed" -ForegroundColor Red
    Write-Host "Please install git first: https://git-scm.com/downloads"
    exit 1
}

# Determine installation directory
$installDir = $env:STORYLINE_INSTALL_DIR
if (-not $installDir) {
    $installDir = Join-Path $env:USERPROFILE ".local\share\storyline"
}

Write-Host "Installation directory: $installDir"
Write-Host ""

# Create installation directory if it doesn't exist
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

# Clone the repository with submodules
Write-Host "Cloning Storyline repository with dependencies..."

$gitDir = Join-Path $installDir ".git"
if (Test-Path $gitDir) {
    Write-Host "Storyline already cloned. Updating..."
    Push-Location $installDir
    try {
        # Reset any local changes to ensure clean update
        git reset --hard HEAD
        git clean -fd
        git pull origin main
        git submodule update --init --recursive
    } finally {
        Pop-Location
    }
} else {
    git clone --recurse-submodules https://github.com/prillcode/storyline.git $installDir
}

Write-Host ""
Write-Host "✅ Repository cloned successfully" -ForegroundColor Green
Write-Host ""

# Run the installer
Push-Location $installDir
try {
    $installScript = Join-Path $installDir "windows-native\install.ps1"
    & $installScript
} finally {
    Pop-Location
}

Write-Host ""
Write-Host "✅ Storyline v2.1.3 installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "You can update Storyline anytime by running:"
Write-Host "  Invoke-WebRequest -Uri https://raw.githubusercontent.com/prillcode/storyline/main/windows-native/remote-install.ps1 | Invoke-Expression" -ForegroundColor Yellow
