#!/bin/bash
# Comad Voice Installer
# "말만 해. 나머지는 AI가 다 한다."

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}=============================${NC}"
echo -e "${CYAN}  Comad Voice Installer v1.0 ${NC}"
echo -e "${CYAN}=============================${NC}"
echo ""

# 1. Check prerequisites
echo -e "${YELLOW}[1/4] Checking prerequisites...${NC}"

# Check Claude Code
if command -v claude &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} Claude Code found"
else
    echo -e "  ${RED}✗${NC} Claude Code not found"
    echo "    Install: https://docs.anthropic.com/en/docs/claude-code"
    echo "    Claude Max subscription recommended"
    exit 1
fi

# Check OMC
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
if [ -f "$CLAUDE_MD" ] && grep -q "OMC" "$CLAUDE_MD" 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} oh-my-claudecode (OMC) detected"
else
    echo -e "  ${YELLOW}!${NC} oh-my-claudecode (OMC) not detected"
    echo "    Install: Run 'setup omc' in Claude Code"
    echo "    Comad Voice requires OMC. Install it first, then re-run this script."
    exit 1
fi

# Check gstack
if [ -f "$CLAUDE_MD" ] && grep -q "gstack" "$CLAUDE_MD" 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} gstack detected"
else
    echo -e "  ${YELLOW}!${NC} gstack not detected (optional but recommended)"
fi

# Check Codex CLI (optional)
if command -v codex &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} Codex CLI found (parallel work enabled)"
else
    echo -e "  ${YELLOW}!${NC} Codex CLI not found (optional — install with: npm i -g @openai/codex)"
fi

# Check tmux (optional)
if command -v tmux &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} tmux found"
else
    echo -e "  ${YELLOW}!${NC} tmux not found (optional — install with: brew install tmux)"
fi

echo ""

# 2. Determine source directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_FILE="$SCRIPT_DIR/core/comad-voice.md"

# If running from curl, download the core file
if [ ! -f "$CORE_FILE" ]; then
    echo -e "${YELLOW}[2/4] Downloading Comad Voice config...${NC}"
    TEMP_DIR=$(mktemp -d)
    curl -fsSL "https://raw.githubusercontent.com/kinkos1234/comad-voice/main/core/comad-voice.md" -o "$TEMP_DIR/comad-voice.md"
    CORE_FILE="$TEMP_DIR/comad-voice.md"

    # Also download memory templates
    mkdir -p "$TEMP_DIR/memory-templates"
    curl -fsSL "https://raw.githubusercontent.com/kinkos1234/comad-voice/main/memory-templates/MEMORY.md" -o "$TEMP_DIR/memory-templates/MEMORY.md"
    curl -fsSL "https://raw.githubusercontent.com/kinkos1234/comad-voice/main/memory-templates/experiments.md" -o "$TEMP_DIR/memory-templates/experiments.md"
    curl -fsSL "https://raw.githubusercontent.com/kinkos1234/comad-voice/main/memory-templates/architecture.md" -o "$TEMP_DIR/memory-templates/architecture.md"
    SCRIPT_DIR="$TEMP_DIR"
    echo -e "  ${GREEN}✓${NC} Downloaded"
else
    echo -e "${YELLOW}[2/4] Using local config files...${NC}"
    echo -e "  ${GREEN}✓${NC} Found core/comad-voice.md"
fi

echo ""

# 3. Install to CLAUDE.md
echo -e "${YELLOW}[3/4] Installing Comad Voice config...${NC}"

# Check if already installed
if grep -q "COMAD-VOICE:START" "$CLAUDE_MD" 2>/dev/null; then
    echo -e "  ${YELLOW}!${NC} Comad Voice already installed in CLAUDE.md"
    read -p "  Overwrite? (y/N): " overwrite
    if [ "$overwrite" != "y" ] && [ "$overwrite" != "Y" ]; then
        echo "  Skipping CLAUDE.md update"
    else
        # Remove existing installation
        sed -i.bak '/<!-- COMAD-VOICE:START -->/,/<!-- COMAD-VOICE:END -->/d' "$CLAUDE_MD"
        echo "" >> "$CLAUDE_MD"
        cat "$CORE_FILE" >> "$CLAUDE_MD"
        echo -e "  ${GREEN}✓${NC} Updated CLAUDE.md"
    fi
else
    echo "" >> "$CLAUDE_MD"
    cat "$CORE_FILE" >> "$CLAUDE_MD"
    echo -e "  ${GREEN}✓${NC} Added Comad Voice to CLAUDE.md"
fi

echo ""

# 4. Offer memory templates
echo -e "${YELLOW}[4/4] Memory templates${NC}"
echo "  Memory templates help Claude remember across sessions."
echo ""
read -p "  Copy memory templates to current project? (y/N): " install_memory

if [ "$install_memory" = "y" ] || [ "$install_memory" = "Y" ]; then
    # Find the project-specific memory directory
    PROJECT_DIR=$(pwd)
    SAFE_PATH=$(echo "$PROJECT_DIR" | sed 's|/|-|g' | sed 's|^-||')
    MEMORY_DIR="$HOME/.claude/projects/$SAFE_PATH/memory"

    mkdir -p "$MEMORY_DIR"

    if [ ! -f "$MEMORY_DIR/MEMORY.md" ]; then
        cp "$SCRIPT_DIR/memory-templates/MEMORY.md" "$MEMORY_DIR/MEMORY.md"
        echo -e "  ${GREEN}✓${NC} Created $MEMORY_DIR/MEMORY.md"
    else
        echo -e "  ${YELLOW}!${NC} MEMORY.md already exists, skipping"
    fi

    if [ ! -f "$MEMORY_DIR/experiments.md" ]; then
        cp "$SCRIPT_DIR/memory-templates/experiments.md" "$MEMORY_DIR/experiments.md"
        echo -e "  ${GREEN}✓${NC} Created experiments.md"
    else
        echo -e "  ${YELLOW}!${NC} experiments.md already exists, skipping"
    fi

    if [ ! -f "$MEMORY_DIR/architecture.md" ]; then
        cp "$SCRIPT_DIR/memory-templates/architecture.md" "$MEMORY_DIR/architecture.md"
        echo -e "  ${GREEN}✓${NC} Created architecture.md"
    else
        echo -e "  ${YELLOW}!${NC} architecture.md already exists, skipping"
    fi
else
    echo "  Skipping memory templates"
fi

echo ""
echo -e "${GREEN}=============================${NC}"
echo -e "${GREEN}  Comad Voice installed!     ${NC}"
echo -e "${GREEN}=============================${NC}"
echo ""
echo "  Get started:"
echo "    1. Open Claude Code in your project"
echo "    2. Type: 검토해봐"
echo "    3. Pick a card number"
echo ""
echo -e "  ${CYAN}\"말만 해. 나머지는 AI가 다 한다.\"${NC}"
echo ""
echo "  Made with AI by Comad J"
echo "  https://github.com/kinkos1234/comad-voice"
echo ""
