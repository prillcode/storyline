#!/bin/bash
# Storyline uninstaller
# https://github.com/prillcode/storyline

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}📖 Storyline Uninstaller${NC}"
echo ""

# Confirm uninstallation
echo -e "${YELLOW}This will remove all Storyline skills and commands from ~/.claude/${NC}"
echo "Do you want to continue? (y/n)"
read -r response

if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${BLUE}Uninstall cancelled.${NC}"
    exit 0
fi

echo ""
echo "Removing Storyline components..."

# Remove skills (both old and new naming)
rm -rf ~/.claude/skills/storyline-epic-creator 2>/dev/null || true
rm -rf ~/.claude/skills/storyline-story-creator 2>/dev/null || true
rm -rf ~/.claude/skills/storyline-spec-story 2>/dev/null || true
rm -rf ~/.claude/skills/storyline-dev-story 2>/dev/null || true
rm -rf ~/.claude/skills/storyline-develop 2>/dev/null || true
rm -rf ~/.claude/skills/storyline-setup 2>/dev/null || true

# Remove old skill names (if they exist from previous installation)
rm -rf ~/.claude/skills/epic-creator 2>/dev/null || true
rm -rf ~/.claude/skills/story-creator 2>/dev/null || true
rm -rf ~/.claude/skills/spec-story 2>/dev/null || true
rm -rf ~/.claude/skills/dev-story 2>/dev/null || true
rm -rf ~/.claude/skills/develop 2>/dev/null || true

# Remove commands (both old and new naming)
rm -f ~/.claude/commands/sl-epic-creator.md 2>/dev/null || true
rm -f ~/.claude/commands/sl-story-creator.md 2>/dev/null || true
rm -f ~/.claude/commands/sl-spec-story.md 2>/dev/null || true
rm -f ~/.claude/commands/sl-dev-story.md 2>/dev/null || true
rm -f ~/.claude/commands/sl-develop.md 2>/dev/null || true
rm -f ~/.claude/commands/sl-setup.md 2>/dev/null || true

# Remove old command names (if they exist from previous installation)
rm -f ~/.claude/commands/epic-creator.md 2>/dev/null || true
rm -f ~/.claude/commands/story-creator.md 2>/dev/null || true
rm -f ~/.claude/commands/spec-story.md 2>/dev/null || true
rm -f ~/.claude/commands/dev-story.md 2>/dev/null || true
rm -f ~/.claude/commands/develop.md 2>/dev/null || true

echo -e "${GREEN}✅ Storyline skills and commands removed${NC}"
echo ""

# Ask about removing the cloned repository
if [ -d "$HOME/.local/share/storyline" ]; then
    echo -e "${YELLOW}Remove cloned repository at ~/.local/share/storyline? (y/n)${NC}"
    read -r response
    
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        rm -rf "$HOME/.local/share/storyline"
        echo -e "${GREEN}✅ Repository removed${NC}"
    else
        echo -e "${BLUE}Repository kept at ~/.local/share/storyline${NC}"
    fi
fi

echo ""
echo -e "${GREEN}✅ Storyline uninstalled successfully!${NC}"
echo ""
echo "Note: This does not remove cc-resources dependencies."
echo "If you want to remove those as well, manually delete:"
echo "  ~/.claude/skills/create-plans"
echo "  ~/.claude/skills/create-agent-skills"
echo "  ~/.claude/skills/create-meta-prompts"
echo "  (and other cc-resources skills/commands)"
echo ""
