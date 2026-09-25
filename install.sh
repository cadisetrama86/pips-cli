#!/usr/bin/env bash
# ============================================================
# pips-cli installer — Linux / macOS / WSL
#
# One-liner:
#   curl -fsSL https://pips.dvikara.cloud/install.sh | bash
#
# Windows: use install.ps1 instead
# ============================================================
set -e

REPO_RAW="https://pips.dvikara.cloud"
SCRIPT_NAME="pips-cli"

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'

info()    { echo -e "${CYAN}[pips]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
err()     { echo -e "${RED}[✗]${NC} $1"; exit 1; }

# ── Banner ───────────────────────────────────────────────────
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
echo ""

# ── Detect OS ────────────────────────────────────────────────
OS="linux"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif grep -qi microsoft /proc/version 2>/dev/null; then
    OS="wsl"
fi
info "Detected: $OS"

# ── Detect install dir ───────────────────────────────────────
if [[ "$OS" == "macos" ]]; then
    # macOS: prefer /usr/local/bin if writable, else ~/.local/bin
    if [[ -w "/usr/local/bin" ]]; then
        INSTALL_DIR="/usr/local/bin"
    else
        INSTALL_DIR="$HOME/.local/bin"
    fi
else
    INSTALL_DIR="$HOME/.local/bin"
fi

# ── Python 3 ────────────────────────────────────────────────
info "Checking Python 3..."
PYTHON=""
for cmd in python3 python; do
    if command -v "$cmd" &>/dev/null; then
        VER=$($cmd --version 2>&1)
        if echo "$VER" | grep -q "Python 3"; then
            PYTHON="$cmd"
            break
        fi
    fi
done

if [[ -z "$PYTHON" ]]; then
    echo ""
    if [[ "$OS" == "macos" ]]; then
        err "Python 3 not found. Install: brew install python3"
    elif [[ "$OS" == "wsl" ]]; then
        err "Python 3 not found. Install: sudo apt install python3 python3-pip"
    else
        err "Python 3 not found. Install: sudo apt install python3 python3-pip"
    fi
fi
success "$($PYTHON --version)"

# ── pip ──────────────────────────────────────────────────────
PIP=""
for cmd in pip3 pip; do
    if command -v "$cmd" &>/dev/null; then
        PIP="$cmd"
        break
    fi
done

if [[ -z "$PIP" ]]; then
    # try python -m pip
    if $PYTHON -m pip --version &>/dev/null 2>&1; then
        PIP="$PYTHON -m pip"
    else
        err "pip not found. Install: sudo apt install python3-pip"
    fi
fi

# ── rich ────────────────────────────────────────────────────
info "Checking 'rich' library..."
if $PYTHON -c "import rich" 2>/dev/null; then
    success "rich already installed"
else
    info "Installing rich..."
    $PIP install --user --quiet rich 2>/dev/null || \
    $PIP install --quiet rich 2>/dev/null || \
    err "Failed to install rich. Run: pip3 install rich"
    success "rich installed"
fi

# ── Create install dir ──────────────────────────────────────
mkdir -p "$INSTALL_DIR"

# ── Download ─────────────────────────────────────────────────
info "Downloading pips-cli..."
TMP=$(mktemp)
if command -v curl &>/dev/null; then
    curl -fsSL "$REPO_RAW/pips-cli.py" -o "$TMP" || err "Download failed. Check internet connection."
elif command -v wget &>/dev/null; then
    wget -q "$REPO_RAW/pips-cli.py" -O "$TMP" || err "Download failed."
else
    if [[ "$OS" == "macos" ]]; then
        err "curl not found. Install Xcode Command Line Tools: xcode-select --install"
    else
        err "curl or wget required. Install: sudo apt install curl"
    fi
fi

head -1 "$TMP" | grep -q "python" || err "Downloaded file is invalid. Try again."
cp "$TMP" "$INSTALL_DIR/$SCRIPT_NAME"
rm -f "$TMP"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
success "Installed → $INSTALL_DIR/$SCRIPT_NAME"

# ── PATH ─────────────────────────────────────────────────────
# Detect shell rc file
if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL" == */zsh ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ -n "$BASH_VERSION" ]] || [[ "$SHELL" == */bash ]]; then
    if [[ "$OS" == "macos" ]]; then
        # macOS bash uses .bash_profile
        SHELL_RC="$HOME/.bash_profile"
        [[ -f "$HOME/.bashrc" ]] && SHELL_RC="$HOME/.bashrc"
    else
        SHELL_RC="$HOME/.bashrc"
    fi
else
    SHELL_RC="$HOME/.profile"
fi

PATH_LINE="export PATH=\"\$HOME/.local/bin:\$PATH\""

if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
    if ! grep -qF ".local/bin" "$SHELL_RC" 2>/dev/null; then
        { echo ""; echo "# pips-cli"; echo "$PATH_LINE"; } >> "$SHELL_RC"
        success "PATH updated in $SHELL_RC"
    fi
    export PATH="$INSTALL_DIR:$PATH"
fi

# ── macOS: also check /usr/local/bin in PATH ────────────────
if [[ "$OS" == "macos" ]] && [[ "$INSTALL_DIR" == "/usr/local/bin" ]]; then
    # /usr/local/bin should already be in PATH on macOS
    true
fi

# ── API key ──────────────────────────────────────────────────
echo ""
echo -e "  ${BOLD}API Key Setup${NC}"
echo "  ─────────────────────────────────────────"

if [[ -n "$PIPS_API_KEY" ]]; then
    success "PIPS_API_KEY already set"
else
    echo -e "  Enter your PIPS API key ${CYAN}(press Enter to skip)${NC}:"
    read -r -s -p "  API Key: " USER_KEY
    echo ""
    if [[ -n "$USER_KEY" ]]; then
        # Remove old key if exists
        grep -v "PIPS_API_KEY" "$SHELL_RC" > /tmp/.pips_rc_tmp 2>/dev/null \
            && mv /tmp/.pips_rc_tmp "$SHELL_RC" || true
        { echo ""; echo "# PIPS CLI"; echo "export PIPS_API_KEY=\"$USER_KEY\""; } >> "$SHELL_RC"
        export PIPS_API_KEY="$USER_KEY"
        success "API key saved to $SHELL_RC"
    else
        warn "Skipped. Set later:"
        echo -e "    ${CYAN}export PIPS_API_KEY=\"your-key\"${NC}"
    fi
fi

# ── Done ─────────────────────────────────────────────────────
echo ""
echo "  ─────────────────────────────────────────"
echo -e "  ${GREEN}${BOLD}Installation complete!${NC}"
echo ""

NEED_RELOAD=false
if ! command -v pips-cli &>/dev/null 2>&1; then
    NEED_RELOAD=true
fi

if $NEED_RELOAD; then
    echo -e "  ${BOLD}Reload your shell first:${NC}"
    echo -e "    ${CYAN}source $SHELL_RC${NC}"
    echo ""
fi

echo -e "  ${BOLD}Start chatting:${NC}"
echo -e "    ${CYAN}pips-cli${NC}              # default model"
echo -e "    ${CYAN}pips-cli --select${NC}     # choose model"
echo -e "    ${CYAN}pips-cli --help${NC}       # all options"
echo ""
