# Storyline installer - Story-driven development workflow for Claude Code
# https://github.com/prillcode/storyline

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "📖 Installing Storyline..." -ForegroundColor Cyan
Write-Host ""

# Create .claude directories if they don't exist
$claudeDir = Join-Path $HOME ".claude"
$skillsDir = Join-Path $claudeDir "skills"
$commandsDir = Join-Path $claudeDir "commands"
$agentsDir = Join-Path $claudeDir "agents"

New-Item -ItemType Directory -Force -Path $skillsDir | Out-Null
New-Item -ItemType Directory -Force -Path $commandsDir | Out-Null
New-Item -ItemType Directory -Force -Path $agentsDir | Out-Null

# Determine installation source
$scriptDir = $PSScriptRoot
$dependencyDir = Join-Path $scriptDir "dependencies\cc-resources"

# Check if we have the dependency available locally (submodule)
if (Test-Path (Join-Path $dependencyDir "skills")) {
    Write-Host "📦 Installing from local repository with submodules..." -ForegroundColor Cyan

    # Install cc-resources from submodule
    Write-Host "Installing cc-resources dependencies..."

    $ccSkillsPath = Join-Path $dependencyDir "skills\*"
    $ccCommandsPath = Join-Path $dependencyDir "commands\*"
    $ccAgentsPath = Join-Path $dependencyDir "agents\*"

    if (Test-Path (Join-Path $dependencyDir "skills")) {
        Copy-Item -Path $ccSkillsPath -Destination $skillsDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path (Join-Path $dependencyDir "commands")) {
        Copy-Item -Path $ccCommandsPath -Destination $commandsDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path (Join-Path $dependencyDir "agents")) {
        Copy-Item -Path $ccAgentsPath -Destination $agentsDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Host "✅ cc-resources installed" -ForegroundColor Green
}
else {
    Write-Host "⚠️  Dependency submodule not found" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "It looks like the cc-resources submodule wasn't initialized."
    Write-Host "This usually happens when you clone without --recurse-submodules."
    Write-Host ""

    $response = Read-Host "Would you like to initialize it now? (y/n)"

    if ($response -match "^[Yy]") {
        Write-Host "Initializing submodules..."
        Set-Location $scriptDir

        try {
            git submodule update --init --recursive

            if (Test-Path (Join-Path $dependencyDir "skills")) {
                Write-Host "Installing cc-resources dependencies..."

                $ccSkillsPath = Join-Path $dependencyDir "skills\*"
                $ccCommandsPath = Join-Path $dependencyDir "commands\*"
                $ccAgentsPath = Join-Path $dependencyDir "agents\*"

                if (Test-Path (Join-Path $dependencyDir "skills")) {
                    Copy-Item -Path $ccSkillsPath -Destination $skillsDir -Recurse -Force -ErrorAction SilentlyContinue
                }
                if (Test-Path (Join-Path $dependencyDir "commands")) {
                    Copy-Item -Path $ccCommandsPath -Destination $commandsDir -Recurse -Force -ErrorAction SilentlyContinue
                }
                if (Test-Path (Join-Path $dependencyDir "agents")) {
                    Copy-Item -Path $ccAgentsPath -Destination $agentsDir -Recurse -Force -ErrorAction SilentlyContinue
                }

                Write-Host "✅ cc-resources installed" -ForegroundColor Green
            }
            else {
                Write-Host "Failed to initialize submodules" -ForegroundColor Red
                exit 1
            }
        }
        catch {
            Write-Host "Error initializing submodules: $_" -ForegroundColor Red
            exit 1
        }
    }
    else {
        Write-Host "Installation cancelled." -ForegroundColor Red
        Write-Host ""
        Write-Host "To install manually, run:"
        Write-Host "  git submodule update --init --recursive"
        Write-Host "  .\install.ps1"
        exit 1
    }
}

# Install storyline skills
Write-Host "Installing Storyline skills..."
$storylineSkillsPath = Join-Path $scriptDir "skills\*"
Copy-Item -Path $storylineSkillsPath -Destination $skillsDir -Recurse -Force

# Install storyline commands
Write-Host "Installing Storyline commands..."
$storylineCommandsPath = Join-Path $scriptDir "commands\*"
Copy-Item -Path $storylineCommandsPath -Destination $commandsDir -Recurse -Force

Write-Host ""
Write-Host "✅ Storyline v2.1.3 installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Available sl-commands (story-led development):"
Write-Host "  /sl-setup [command]            - Initialize, manage, check projects"
Write-Host "  /sl-epic-creator [PRD.md]      - Create epics from PRD (or guided mode)"
Write-Host "  /sl-story-creator <epic-file>  - Generate user stories from epic"
Write-Host "  /sl-spec-story <story-file>    - Create technical spec from story"
Write-Host "  /sl-develop <spec-file>        - Execute technical spec (implement)"
Write-Host "  /sl-commit [message]           - Create conventional commit (auto or manual)"
Write-Host ""
Write-Host "Quick start:"
Write-Host "  1. /sl-setup init                          # Initialize project"
Write-Host "  2. /sl-epic-creator                        # Guided PRD creation"
Write-Host "  3. /sl-story-creator .storyline/epics/epic-{id}-01.md"
Write-Host "  4. /sl-spec-story .storyline/stories/epic-{id}-01/story-01.md"
Write-Host "  5. /sl-develop .storyline/specs/epic-{id}-01/spec-01.md"
Write-Host "  6. /sl-setup status                        # Check progress"
Write-Host ""
Write-Host "Start a new Claude Code session and run: /sl-setup check"
Write-Host ""
Write-Host "Documentation: https://github.com/prillcode/storyline" -ForegroundColor Yellow
