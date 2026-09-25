# ============================================================
# pips-cli installer — Windows (PowerShell)
#
# Run in PowerShell:
#   iwr -useb https://pips.dvikara.cloud/install.ps1 | iex
#
# Or download and run:
#   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
#   .\install.ps1
# ============================================================

$ErrorActionPreference = "Stop"

$REPO_RAW = "https://pips.dvikara.cloud"
$SCRIPT_NAME = "pips-cli.py"
$WRAPPER_NAME = "pips-cli.cmd"
$INSTALL_DIR = "$env:USERPROFILE\.local\bin"

function Write-Info    { Write-Host "[pips] $args" -ForegroundColor Cyan }
function Write-Success { Write-Host "[OK]   $args" -ForegroundColor Green }
function Write-Warn    { Write-Host "[!]    $args" -ForegroundColor Yellow }
function Write-Err     { Write-Host "[ERR]  $args" -ForegroundColor Red; exit 1 }

# ── Banner ────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ██████  ██ ██████  ███████ " -ForegroundColor Cyan
Write-Host "  ██   ██ ██ ██   ██ ██      " -ForegroundColor Cyan
Write-Host "  ██████  ██ ██████  ███████ " -ForegroundColor Cyan
Write-Host "  ██      ██ ██           ██ " -ForegroundColor Cyan
Write-Host "  ██      ██ ██      ███████ " -ForegroundColor Cyan
Write-Host ""
Write-Host "  Personal AI Infrastructure & Pipeline Server" -ForegroundColor White
Write-Host "  Windows Installer" -ForegroundColor Cyan
Write-Host ""
Write-Host "  ─────────────────────────────────────────"
Write-Host ""

# ── Python 3 ──────────────────────────────────────────────────
Write-Info "Checking Python 3..."
$PYTHON = $null

foreach ($cmd in @("python", "python3", "py")) {
    try {
        $ver = & $cmd --version 2>&1
        if ($ver -match "Python 3") {
            $PYTHON = $cmd
            Write-Success $ver
            break
        }
    } catch {}
}

if (-not $PYTHON) {
    Write-Host ""
    Write-Host "  Python 3 not found." -ForegroundColor Red
    Write-Host "  Download from: https://www.python.org/downloads/" -ForegroundColor Yellow
    Write-Host "  Make sure to check 'Add Python to PATH' during install." -ForegroundColor Yellow
    Write-Err "Python 3 required"
}

# ── pip / rich ────────────────────────────────────────────────
Write-Info "Checking 'rich' library..."
$richOk = & $PYTHON -c "import rich" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Success "rich already installed"
} else {
    Write-Info "Installing rich..."
    & $PYTHON -m pip install --user --quiet rich
    if ($LASTEXITCODE -ne 0) {
        Write-Err "Failed to install rich. Run: pip install rich"
    }
    Write-Success "rich installed"
}

# ── Create install dir ────────────────────────────────────────
if (-not (Test-Path $INSTALL_DIR)) {
    New-Item -ItemType Directory -Path $INSTALL_DIR -Force | Out-Null
}

# ── Download pips-cli.py ──────────────────────────────────────
Write-Info "Downloading pips-cli..."
$PY_DEST = "$INSTALL_DIR\$SCRIPT_NAME"
try {
    Invoke-WebRequest -Uri "$REPO_RAW/pips-cli.py" -OutFile $PY_DEST -UseBasicParsing
    Write-Success "Downloaded → $PY_DEST"
} catch {
    Write-Err "Download failed: $_"
}

# ── Create .cmd wrapper ───────────────────────────────────────
# So user can just type "pips-cli" in CMD / PowerShell
$CMD_DEST = "$INSTALL_DIR\$WRAPPER_NAME"
$CMD_CONTENT = "@echo off`r`n$PYTHON `"$PY_DEST`" %*"
Set-Content -Path $CMD_DEST -Value $CMD_CONTENT -Encoding ASCII
Write-Success "Wrapper created → $CMD_DEST"

# ── PATH ──────────────────────────────────────────────────────
$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$INSTALL_DIR*") {
    [System.Environment]::SetEnvironmentVariable(
        "PATH",
        "$INSTALL_DIR;$currentPath",
        "User"
    )
    Write-Success "Added $INSTALL_DIR to PATH"
    Write-Warn "Restart your terminal to use pips-cli"
} else {
    Write-Success "PATH already contains $INSTALL_DIR"
}

# Update current session PATH too
$env:PATH = "$INSTALL_DIR;$env:PATH"

# ── API key ───────────────────────────────────────────────────
Write-Host ""
Write-Host "  API Key Setup" -ForegroundColor White
Write-Host "  ─────────────────────────────────────────"

if ($env:PIPS_API_KEY) {
    Write-Success "PIPS_API_KEY already set"
} else {
    Write-Host "  Enter your PIPS API key (press Enter to skip):" -ForegroundColor Cyan
    $USER_KEY = Read-Host "  API Key"

    if ($USER_KEY) {
        [System.Environment]::SetEnvironmentVariable("PIPS_API_KEY", $USER_KEY, "User")
        $env:PIPS_API_KEY = $USER_KEY
        Write-Success "API key saved to user environment"
    } else {
        Write-Warn "Skipped. Set later:"
        Write-Host "  `$env:PIPS_API_KEY = 'your-key'" -ForegroundColor Cyan
        Write-Host "  Or via System Properties > Environment Variables" -ForegroundColor DarkGray
    }
}

# ── Done ──────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ─────────────────────────────────────────"
Write-Host "  Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "  Start chatting (restart terminal first):" -ForegroundColor White
Write-Host "    pips-cli              " -ForegroundColor Cyan -NoNewline
Write-Host "# default model"
Write-Host "    pips-cli --select     " -ForegroundColor Cyan -NoNewline
Write-Host "# choose model"
Write-Host "    pips-cli --help       " -ForegroundColor Cyan -NoNewline
Write-Host "# all options"
Write-Host ""
