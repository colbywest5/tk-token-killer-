#!/bin/bash

# TK - Token Killer Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/colbywest5/tk-Claude-Skill/main/install.sh | bash

set -e

VERSION="1.0.0"
REPO="colbywest5/tk-Claude-Skill"
CYAN='\033[0;36m'
GREEN='\033[0;32m'
DIM='\033[2m'
RESET='\033[0m'

echo ""
echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║              TK v${VERSION}                  ║${RESET}"
echo -e "${CYAN}║     Token-optimized Claude Commands    ║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
echo ""

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)     CLAUDE_DIR="$HOME/.claude/commands";;
    Darwin*)    CLAUDE_DIR="$HOME/.claude/commands";;
    MINGW*|MSYS*|CYGWIN*)    CLAUDE_DIR="$USERPROFILE/.claude/commands";;
    *)          CLAUDE_DIR="$HOME/.claude/commands";;
esac

# Parse arguments
INSTALL_DIR="$CLAUDE_DIR"
for arg in "$@"; do
    case $arg in
        --local|-l)
            INSTALL_DIR="./.claude/commands"
            ;;
        --global|-g)
            INSTALL_DIR="$CLAUDE_DIR"
            ;;
        --uninstall)
            echo "Uninstalling TK..."
            rm -f "$CLAUDE_DIR/tk.md" 2>/dev/null || true
            rm -rf "$CLAUDE_DIR/tk" 2>/dev/null || true
            echo -e "${GREEN}✓${RESET} Uninstalled TK"
            exit 0
            ;;
    esac
done

# Create temp directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

echo -e "${DIM}Downloading TK...${RESET}"

# Download files
curl -fsSL "https://raw.githubusercontent.com/$REPO/main/tk.md" -o "$TMP_DIR/tk.md"

mkdir -p "$TMP_DIR/commands"
for cmd in _shared map build design debug qa review clean doc deploy init resume learn status help; do
    curl -fsSL "https://raw.githubusercontent.com/$REPO/main/commands/${cmd}.md" -o "$TMP_DIR/commands/${cmd}.md" 2>/dev/null || true
done

# Create install directory
mkdir -p "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR/tk"

# Copy files
cp "$TMP_DIR/tk.md" "$INSTALL_DIR/tk.md"
echo -e "${GREEN}✓${RESET} Installed tk.md"

cp -r "$TMP_DIR/commands/"* "$INSTALL_DIR/tk/"
echo -e "${GREEN}✓${RESET} Installed commands/"

echo ""
echo -e "${DIM}Installed to: $INSTALL_DIR${RESET}"
echo ""
echo -e "${GREEN}Done!${RESET} Run ${CYAN}/tk:help${RESET} in Claude Code to get started."
echo ""
