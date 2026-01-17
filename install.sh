#!/bin/bash
# Storyline installer - Story-driven development workflow for Claude Code
# https://github.com/prillcode/storyline

set -e

echo "📖 Installing Storyline..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create .claude directories if they don't exist
mkdir -p ~/.claude/skills
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/agents

# Determine installation source
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DEPENDENCY_DIR="$SCRIPT_DIR/cc-resources"

# Check if we have the bundled dependencies
if [ -d "$DEPENDENCY_DIR/skills" ]; then
  echo -e "${BLUE}📦 Installing from local repository...${NC}"

  # Install bundled cc-resources
  echo "Installing cc-resources dependencies..."
  cp -r "$DEPENDENCY_DIR/skills"/* ~/.claude/skills/ 2>/dev/null || true
  cp -r "$DEPENDENCY_DIR/commands"/* ~/.claude/commands/ 2>/dev/null || true
  cp -r "$DEPENDENCY_DIR/agents"/* ~/.claude/agents/ 2>/dev/null || true

  echo -e "${GREEN}✅ cc-resources installed${NC}"
else
  echo -e "${RED}❌ Error: cc-resources directory not found${NC}"
  echo ""
  echo "The bundled dependencies are missing. This shouldn't happen."
  echo "Please re-clone the repository or report this issue."
  exit 1
fi

# Install storyline skills
echo "Installing Storyline skills..."
cp -r "$SCRIPT_DIR/skills"/* ~/.claude/skills/

# Install storyline commands
echo "Installing Storyline commands..."
cp -r "$SCRIPT_DIR/commands"/* ~/.claude/commands/

echo ""
echo -e "${GREEN}✅ Storyline v0.21.5 installed successfully!${NC}"
echo ""
echo "Available sl-commands (story-led development):"
echo "  /sl-setup [command]            - Initialize, manage, check projects"
echo "  /sl-epic-creator [PRD.md]      - Create epics from PRD (or guided mode)"
echo "  /sl-story-creator <epic-file>  - Generate user stories from epic"
echo "  /sl-spec-story <story-file>    - Create technical spec from story"
echo "  /sl-develop <spec-file>        - Execute technical spec (implement)"
echo "  /sl-commit [message]           - Create conventional commit (auto or manual)"
echo ""
echo "Quick start:"
echo "  1. /sl-setup init                          # Initialize project"
echo "  2. /sl-epic-creator                        # Guided PRD creation"
echo "  3. /sl-story-creator .storyline/epics/epic-{id}-01.md"
echo "  4. /sl-spec-story .storyline/stories/epic-{id}-01/story-01.md"
echo "  5. /sl-develop .storyline/specs/epic-{id}-01/spec-01.md"
echo "  6. /sl-setup status                        # Check progress"
echo ""
echo "Start a new Claude Code session and run: /sl-setup check"
echo ""
echo -e "${YELLOW}Documentation: https://github.com/prillcode/storyline${NC}"
