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
DEPENDENCY_DIR="$SCRIPT_DIR/dependencies/cc-resources"

# Check if we have the dependency available locally (submodule)
if [ -d "$DEPENDENCY_DIR/skills" ]; then
  echo -e "${BLUE}📦 Installing from local repository with submodules...${NC}"

  # Install cc-resources from submodule
  echo "Installing cc-resources dependencies..."
  cp -r "$DEPENDENCY_DIR/skills"/* ~/.claude/skills/ 2>/dev/null || true
  cp -r "$DEPENDENCY_DIR/commands"/* ~/.claude/commands/ 2>/dev/null || true
  cp -r "$DEPENDENCY_DIR/agents"/* ~/.claude/agents/ 2>/dev/null || true

  echo -e "${GREEN}✅ cc-resources installed${NC}"
else
  echo -e "${YELLOW}⚠️  Dependency submodule not found${NC}"
  echo ""
  echo "It looks like the cc-resources submodule wasn't initialized."
  echo "This usually happens when you clone without --recurse-submodules."
  echo ""
  echo "Would you like to initialize it now? (y/n)"
  read -r response

  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Initializing submodules..."
    cd "$SCRIPT_DIR"
    git submodule update --init --recursive

    if [ -d "$DEPENDENCY_DIR/skills" ]; then
      echo "Installing cc-resources dependencies..."
      cp -r "$DEPENDENCY_DIR/skills"/* ~/.claude/skills/ 2>/dev/null || true
      cp -r "$DEPENDENCY_DIR/commands"/* ~/.claude/commands/ 2>/dev/null || true
      cp -r "$DEPENDENCY_DIR/agents"/* ~/.claude/agents/ 2>/dev/null || true
      echo -e "${GREEN}✅ cc-resources installed${NC}"
    else
      echo -e "${RED}Failed to initialize submodules${NC}"
      exit 1
    fi
  else
    echo -e "${RED}Installation cancelled.${NC}"
    echo ""
    echo "To install manually, run:"
    echo "  git submodule update --init --recursive"
    echo "  ./install.sh"
    exit 1
  fi
fi

# Install storyline skills
echo "Installing Storyline skills..."
cp -r "$SCRIPT_DIR/skills"/* ~/.claude/skills/

# Install storyline commands
echo "Installing Storyline commands..."
cp -r "$SCRIPT_DIR/commands"/* ~/.claude/commands/

echo ""
echo -e "${GREEN}✅ Storyline v2.0 installed successfully!${NC}"
echo ""
echo "Available sl-commands (story-led development):"
echo "  /sl-setup [command]            - Initialize, manage, check projects"
echo "  /sl-epic-creator [PRD.md]      - Create epics from PRD (or guided mode)"
echo "  /sl-story-creator <epic-file>  - Generate user stories from epic"
echo "  /sl-spec-story <story-file>    - Create technical spec from story"
echo "  /sl-develop <spec-file>        - Execute technical spec (implement)"
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
