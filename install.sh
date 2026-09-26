#!/usr/bin/env bash
# ============================================================
# pips-cli & agent installer — Linux / macOS / WSL
# Fully automated zero-friction setup:
#   Auto-installs Python 3 if missing
#   Auto-installs rich
#   Auto-configures PATH
#   Auto-launches pips-cli immediately!
#
# One-liner:
#   curl -fsSL https://pips.dvikara.cloud/install.sh | bash
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
echo -e "${NC}${BOLD}  Personal AI Infrastructure & Autonomous VPS Agent${NC}"
echo -e "${CYAN}  One-Click Auto Installer${NC}"
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
if [[ "$OS" == "macos" ]] && [[ -w "/usr/local/bin" ]]; then
    INSTALL_DIR="/usr/local/bin"
else
    INSTALL_DIR="$HOME/.local/bin"
fi

# ── Python 3 Detection & Auto-Install ────────────────────────
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
    warn "Python 3 not found. Attempting automatic installation..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get update -qq && sudo apt-get install -y python3 python3-pip python3-venv 2>/dev/null || true
    elif command -v brew &>/dev/null; then
        brew install python3 || true
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y python3 python3-pip 2>/dev/null || true
    elif command -v pacman &>/dev/null; then
        sudo pacman -Sy --noconfirm python python-pip 2>/dev/null || true
    fi

    for cmd in python3 python; do
        if command -v "$cmd" &>/dev/null && "$cmd" --version 2>&1 | grep -q "Python 3"; then
            PYTHON="$cmd"
            break
        fi
    done
fi

if [[ -z "$PYTHON" ]]; then
    echo ""
    if [[ "$OS" == "macos" ]]; then
        err "Python 3 not found. Install manually: brew install python3"
    else
        err "Python 3 not found. Install manually: sudo apt install python3 python3-pip"
    fi
fi
success "$($PYTHON --version)"

# ── pip Detection ───────────────────────────────────────────
PIP=""
for cmd in pip3 pip; do
    if command -v "$cmd" &>/dev/null; then
        PIP="$cmd"
        break
    fi
done

if [[ -z "$PIP" ]]; then
    if $PYTHON -m pip --version &>/dev/null 2>&1; then
        PIP="$PYTHON -m pip"
    else
        warn "pip not found, trying to bootstrap pip..."
        $PYTHON -m ensurepip --default-pip 2>/dev/null || true
        PIP="$PYTHON -m pip"
    fi
fi

# ── rich library ────────────────────────────────────────────
info "Checking 'rich' library..."
if $PYTHON -c "import rich" 2>/dev/null; then
    success "rich already installed"
else
    info "Installing rich..."
    $PIP install --user --quiet rich 2>/dev/null || \
    $PIP install --quiet rich 2>/dev/null || \
    $PIP install --break-system-packages --user --quiet rich 2>/dev/null || \
    err "Failed to install rich. Run: pip3 install rich"
    success "rich installed"
fi

# ── Create install dir ──────────────────────────────────────
mkdir -p "$INSTALL_DIR"

# ── Download pips-cli & pips-agent ───────────────────────────
info "Downloading pips-cli & pips-agent..."
TMP=$(mktemp)
TMP_AGENT=$(mktemp)

if command -v curl &>/dev/null; then
    curl -fsSL "$REPO_RAW/pips-cli.py" -o "$TMP" || err "Download failed. Check internet connection."
    curl -fsSL "$REPO_RAW/pips-agent.py" -o "$TMP_AGENT" 2>/dev/null || true
elif command -v wget &>/dev/null; then
    wget -q "$REPO_RAW/pips-cli.py" -O "$TMP" || err "Download failed."
    wget -q "$REPO_RAW/pips-agent.py" -O "$TMP_AGENT" 2>/dev/null || true
else
    err "curl or wget required."
fi

head -1 "$TMP" | grep -q "python" || err "Downloaded file is invalid. Try again."
cp "$TMP" "$INSTALL_DIR/$SCRIPT_NAME"
rm -f "$TMP"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
success "Installed → $INSTALL_DIR/$SCRIPT_NAME"

if [[ -s "$TMP_AGENT" ]] && head -1 "$TMP_AGENT" | grep -q "python"; then
    cp "$TMP_AGENT" "$INSTALL_DIR/pips-agent"
    chmod +x "$INSTALL_DIR/pips-agent"
    success "Installed → $INSTALL_DIR/pips-agent"
fi
rm -f "$TMP_AGENT"

# ── PATH Configuration ──────────────────────────────────────
if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL" == */zsh ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ -n "$BASH_VERSION" ]] || [[ "$SHELL" == */bash ]]; then
    if [[ "$OS" == "macos" ]]; then
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

# ── Launch pips-cli immediately! ────────────────────────────
echo ""
echo "  ─────────────────────────────────────────"
echo -e "  ${GREEN}${BOLD}Installation complete! Launching pips-cli...${NC}"
echo "  ─────────────────────────────────────────"
echo ""
sleep 1

# If run through pipe (curl ... | bash), restore stdin to terminal for interaction
if [[ -e /dev/tty ]]; then
    exec < /dev/tty
    "$INSTALL_DIR/$SCRIPT_NAME" "$@"
else
    echo -e "  ${BOLD}Start chatting:${NC} ${CYAN}pips-cli${NC}"
    echo -e "  ${BOLD}Control VPS   :${NC} ${CYAN}pips-cli agent${NC}"
fi
