#!/usr/bin/env bash
# ============================================================
# pips-cli installer
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
# ============================================================
set -e

REPO_RAW="https://raw.githubusercontent.com/cadisetrama86/pips-cli/main"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="pips-cli"

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'

info()    { echo -e "${CYAN}[pips]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
err()     { echo -e "${RED}[✗]${NC} $1"; exit 1; }

echo ""
echo -e "${CYAN}${BOLD}"
cat << 'BANNER'
  ██████╗ ██╗██████╗ ███████╗
  ██╔══██╗██║██╔══██╗██╔════╝
  ██████╔╝██║██████╔╝███████╗
  ██╔═══╝ ██║██╔═══╝ ╚════██║
  ██║     ██║██║     ███████║
  ╚═╝     ╚═╝╚═╝     ╚══════╝
BANNER
echo -e "${NC}${BOLD}  Personal AI Infrastructure & Pipeline Server${NC}"
echo -e "  ${CYAN}CLI Installer${NC}"
echo ""
echo "  ─────────────────────────────────────────"
echo ""

# ── Python 3 ────────────────────────────────────────────────
info "Checking Python 3..."
command -v python3 &>/dev/null || err "Python 3 not found. Install: sudo apt install python3"
success "$(python3 --version)"

# ── rich ────────────────────────────────────────────────────
info "Checking 'rich' library..."
if python3 -c "import rich" 2>/dev/null; then
    success "rich already installed"
else
    info "Installing rich..."
    pip3 install --user --quiet rich 2>/dev/null || \
    pip install --user --quiet rich 2>/dev/null || \
    err "Failed to install rich. Run: pip3 install rich"
    success "rich installed"
fi

# ── Install dir ─────────────────────────────────────────────
mkdir -p "$INSTALL_DIR"

# ── Download ─────────────────────────────────────────────────
info "Downloading pips-cli..."
TMP=$(mktemp)
if command -v curl &>/dev/null; then
    curl -fsSL "$REPO_RAW/bin/pips-cli" -o "$TMP" || err "Download failed"
elif command -v wget &>/dev/null; then
    wget -q "$REPO_RAW/bin/pips-cli" -O "$TMP" || err "Download failed"
else
    err "curl or wget required"
fi

head -1 "$TMP" | grep -q "python" || err "Downloaded file invalid"
cp "$TMP" "$INSTALL_DIR/$SCRIPT_NAME"
rm -f "$TMP"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
success "Installed → $INSTALL_DIR/$SCRIPT_NAME"

# ── PATH ─────────────────────────────────────────────────────
case "$SHELL" in
    */zsh)  SHELL_RC="$HOME/.zshrc" ;;
    */bash) SHELL_RC="$HOME/.bashrc" ;;
    *)      SHELL_RC="$HOME/.profile" ;;
esac

if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
    if ! grep -qF ".local/bin" "$SHELL_RC" 2>/dev/null; then
        echo "" >> "$SHELL_RC"
        echo "# pips-cli" >> "$SHELL_RC"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_RC"
        success "PATH updated in $SHELL_RC"
    fi
    export PATH="$INSTALL_DIR:$PATH"
fi

# ── API key ──────────────────────────────────────────────────
echo ""
echo -e "  ${BOLD}API Key Setup${NC}"
echo "  ─────────────────────────────────────────"

if [[ -n "$PIPS_API_KEY" ]]; then
    success "PIPS_API_KEY already set"
else
    echo -e "  Enter PIPS API key ${CYAN}(Enter to skip)${NC}:"
    read -r -s -p "  API Key: " USER_KEY
    echo ""
    if [[ -n "$USER_KEY" ]]; then
        grep -v "PIPS_API_KEY" "$SHELL_RC" > /tmp/.rc_tmp 2>/dev/null && mv /tmp/.rc_tmp "$SHELL_RC" || true
        { echo ""; echo "# PIPS CLI"; echo "export PIPS_API_KEY=\"$USER_KEY\""; } >> "$SHELL_RC"
        export PIPS_API_KEY="$USER_KEY"
        success "API key saved to $SHELL_RC"
    else
        warn "Skipped. Set later: export PIPS_API_KEY=your-key"
    fi
fi

# ── Done ─────────────────────────────────────────────────────
echo ""
echo "  ─────────────────────────────────────────"
echo -e "  ${GREEN}${BOLD}Done!${NC}"
echo ""
echo -e "  ${BOLD}Start chatting:${NC}"
echo ""
if ! command -v pips-cli &>/dev/null 2>&1; then
    echo -e "    ${CYAN}source $SHELL_RC${NC}   # reload PATH first"
fi
echo -e "    ${CYAN}pips-cli${NC}              # start with default model"
echo -e "    ${CYAN}pips-cli --select${NC}     # choose model at startup"
echo -e "    ${CYAN}pips-cli --help${NC}       # all options"
echo ""
