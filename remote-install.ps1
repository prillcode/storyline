# Storyline remote installer for Windows PowerShell
# Usage: irm https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.ps1 | iex

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "📖 Storyline Remote Installer" -ForegroundColor Blue
Write-Host "Story-driven development workflow for Claude Code"
Write-Host ""

# Check if git is installed
try {
    $null = Get-Command git -ErrorAction Stop
} catch {
    Write-Host "Error: git is not installed" -ForegroundColor Red
    Write-Host "Please install git first: https://git-scm.com/downloads"
    exit 1
}

# Determine installation directory
$InstallDir = if ($env:STORYLINE_INSTALL_DIR) { $env:STORYLINE_INSTALL_DIR } else { "$HOME\.local\share\storyline" }
Write-Host "Installation directory: $InstallDir"
Write-Host ""

# Create installation directory if it doesn't exist
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# Clone the repository with submodules
Write-Host "Cloning Storyline repository with dependencies..."
if (Test-Path "$InstallDir\.git") {
    Write-Host "Storyline already cloned. Updating..."
    Push-Location $InstallDir
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
    git clone --recurse-submodules https://github.com/prillcode/storyline.git $InstallDir
}

Write-Host ""
Write-Host "✅ Repository cloned successfully" -ForegroundColor Green
Write-Host ""

# Normalize line endings for PowerShell scripts
# PowerShell on Windows requires CRLF endings, but Git may clone with LF
Write-Host "Normalizing line endings for PowerShell compatibility..."
$InstallScript = Join-Path $InstallDir "install.ps1"
if (Test-Path $InstallScript) {
    $content = Get-Content $InstallScript -Raw
    # Convert LF to CRLF if needed
    $content = $content -replace "`r`n", "`n"  # First normalize to LF
    $content = $content -replace "`n", "`r`n"  # Then convert to CRLF
    Set-Content -Path $InstallScript -Value $content -NoNewline
}

# Run the installer
Push-Location $InstallDir
try {
    & powershell -ExecutionPolicy Bypass -File ".\install.ps1"
} finally {
    Pop-Location
}

Write-Host ""
Write-Host "✅ Storyline v2.1.3 installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "You can update Storyline anytime by running:"
Write-Host "  irm https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.ps1 | iex" -ForegroundColor Yellow
Write-Host ""
