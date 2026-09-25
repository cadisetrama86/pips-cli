#!/usr/bin/env bash
# ============================================================
# pips-cli installer
# https://github.com/cadisetrama86/pips-cli
# ============================================================
set -e

REPO_URL="https://raw.githubusercontent.com/cadisetrama86/pips-cli/main"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="pips-cli"

# ── Colors ──────────────────────────────────────────────────
CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'

info()    { echo -e "${CYAN}[pips]${NC} $1"; }
success() { echo -e "${GREEN}[pips]${NC} $1"; }
warn()    { echo -e "${YELLOW}[pips]${NC} $1"; }
error()   { echo -e "${RED}[pips]${NC} $1"; exit 1; }

echo ""
echo -e "${BOLD}${CYAN}PIPS CLI Installer${NC}"
echo "────────────────────────────────────"
echo ""

# ── Check Python 3 ──────────────────────────────────────────
info "Checking Python 3..."
if ! command -v python3 &>/dev/null; then
    error "Python 3 not found. Please install Python 3.8+."
fi
PY_VER=$(python3 --version 2>&1)
success "Found: $PY_VER"

# ── Check/install rich ──────────────────────────────────────
info "Checking rich library..."
if python3 -c "import rich" 2>/dev/null; then
    success "rich already installed"
else
    info "Installing rich..."
    pip3 install --user rich || pip install --user rich || \
        error "Failed to install rich. Try: pip3 install rich"
    success "rich installed"
fi

# ── Create install dir ──────────────────────────────────────
mkdir -p "$INSTALL_DIR"

# ── Download script ─────────────────────────────────────────
info "Downloading pips-cli..."
if command -v curl &>/dev/null; then
    curl -fsSL "$REPO_URL/bin/pips-cli" -o "$INSTALL_DIR/$SCRIPT_NAME"
elif command -v wget &>/dev/null; then
    wget -q "$REPO_URL/bin/pips-cli" -O "$INSTALL_DIR/$SCRIPT_NAME"
else
    error "curl or wget required"
fi

chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
success "Installed to: $INSTALL_DIR/$SCRIPT_NAME"

# ── PATH check ──────────────────────────────────────────────
SHELL_RC=""
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_RC="$HOME/.bashrc"
fi

if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    warn "$INSTALL_DIR not in PATH"
    if [[ -n "$SHELL_RC" ]]; then
        echo "" >> "$SHELL_RC"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_RC"
        success "Added to $SHELL_RC"
        warn "Run: source $SHELL_RC"
    fi
fi

# ── Setup API key ────────────────────────────────────────────
echo ""
echo "────────────────────────────────────"
echo -e "${BOLD}Setup${NC}"
echo ""

if [[ -z "$PIPS_API_KEY" ]]; then
    echo -e "  Enter your PIPS API key ${CYAN}(get from pips.dvikara.cloud)${NC}:"
    read -r -s -p "  API Key: " USER_KEY
    echo ""

    if [[ -n "$USER_KEY" ]]; then
        # Save to shell rc
        if [[ -n "$SHELL_RC" ]]; then
            echo "" >> "$SHELL_RC"
            echo "# PIPS CLI" >> "$SHELL_RC"
            echo "export PIPS_API_KEY=\"$USER_KEY\"" >> "$SHELL_RC"
            success "API key saved to $SHELL_RC"
        fi
    else
        warn "Skipped. Set later with: export PIPS_API_KEY=your-key"
    fi
else
    success "PIPS_API_KEY already set"
fi

# ── Done ─────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────────"
echo -e "${GREEN}${BOLD}Installation complete!${NC}"
echo ""
echo -e "  ${BOLD}Usage:${NC}"
echo -e "    ${CYAN}pips-cli${NC}              # Start chat (default model)"
echo -e "    ${CYAN}pips-cli --select${NC}     # Choose model at startup"
echo -e "    ${CYAN}pips-cli --help${NC}       # Show all options"
echo ""
echo -e "  ${BOLD}First run:${NC}"
echo -e "    ${CYAN}source $SHELL_RC${NC}"
echo -e "    ${CYAN}pips-cli${NC}"
echo ""
