#!/bin/bash
# Storyline remote installer
# Usage: curl -fsSL https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.sh | bash

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}📖 Storyline Remote Installer${NC}"
echo "Story-driven development workflow for Claude Code"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed${NC}"
    echo "Please install git first: https://git-scm.com/downloads"
    exit 1
fi

# Determine installation directory
INSTALL_DIR="${STORYLINE_INSTALL_DIR:-$HOME/.local/share/storyline}"
echo "Installation directory: $INSTALL_DIR"
echo ""

# Create installation directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Clone the repository with submodules
echo "Cloning Storyline repository with dependencies..."
if [ -d "$INSTALL_DIR/.git" ]; then
    echo "Storyline already cloned. Updating..."
    cd "$INSTALL_DIR"
    # Reset any local changes to ensure clean update
    git reset --hard HEAD
    git clean -fd
    git pull origin main
    git submodule update --init --recursive
else
    git clone --recurse-submodules https://github.com/prillcode/storyline.git "$INSTALL_DIR"
fi

echo ""
echo -e "${GREEN}✅ Repository cloned successfully${NC}"
echo ""

# Run the installer
cd "$INSTALL_DIR"
chmod +x install.sh
./install.sh

echo ""
echo -e "${GREEN}✅ Storyline v2.1.4 installation complete!${NC}"
echo ""
echo "You can update Storyline anytime by running:"
echo -e "${YELLOW}  curl -fsSL https://raw.githubusercontent.com/prillcode/storyline/main/remote-install.sh | bash${NC}"
