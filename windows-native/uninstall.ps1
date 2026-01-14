# Storyline uninstaller
# https://github.com/prillcode/storyline

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "📖 Storyline Uninstaller" -ForegroundColor Blue
Write-Host ""

# Confirm uninstallation
Write-Host "This will remove all Storyline skills and commands from ~/.claude/" -ForegroundColor Yellow
$response = Read-Host "Do you want to continue? (y/n)"

if ($response -notmatch "^[yY](es)?$") {
    Write-Host "Uninstall cancelled." -ForegroundColor Blue
    exit 0
}

Write-Host ""
Write-Host "Removing Storyline components..."

# Define base paths
$claudeDir = Join-Path $env:USERPROFILE ".claude"
$skillsDir = Join-Path $claudeDir "skills"
$commandsDir = Join-Path $claudeDir "commands"

# Remove skills (both old and new naming)
$skillsToRemove = @(
    "storyline-epic-creator",
    "storyline-story-creator",
    "storyline-spec-story",
    "storyline-dev-story",
    "storyline-develop",
    "storyline-setup",
    # Old skill names
    "epic-creator",
    "story-creator",
    "spec-story",
    "dev-story",
    "develop"
)

foreach ($skill in $skillsToRemove) {
    $skillPath = Join-Path $skillsDir $skill
    if (Test-Path $skillPath) {
        Remove-Item -Path $skillPath -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Remove commands (both old and new naming)
$commandsToRemove = @(
    "sl-epic-creator.md",
    "sl-story-creator.md",
    "sl-spec-story.md",
    "sl-dev-story.md",
    "sl-develop.md",
    "sl-setup.md",
    # Old command names
    "epic-creator.md",
    "story-creator.md",
    "spec-story.md",
    "dev-story.md",
    "develop.md"
)

foreach ($command in $commandsToRemove) {
    $commandPath = Join-Path $commandsDir $command
    if (Test-Path $commandPath) {
        Remove-Item -Path $commandPath -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "✅ Storyline skills and commands removed" -ForegroundColor Green
Write-Host ""

# Ask about removing the cloned repository
$repoPath = Join-Path $env:USERPROFILE ".local\share\storyline"
if (Test-Path $repoPath) {
    Write-Host "Remove cloned repository at ~/.local/share/storyline? (y/n)" -ForegroundColor Yellow
    $response = Read-Host

    if ($response -match "^[yY](es)?$") {
        Remove-Item -Path $repoPath -Recurse -Force
        Write-Host "✅ Repository removed" -ForegroundColor Green
    } else {
        Write-Host "Repository kept at ~/.local/share/storyline" -ForegroundColor Blue
    }
}

Write-Host ""
Write-Host "✅ Storyline uninstalled successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Note: This does not remove cc-resources dependencies."
Write-Host "If you want to remove those as well, manually delete:"
Write-Host "  ~/.claude/skills/create-plans"
Write-Host "  ~/.claude/skills/create-agent-skills"
Write-Host "  ~/.claude/skills/create-meta-prompts"
Write-Host "  (and other cc-resources skills/commands)"
Write-Host ""
