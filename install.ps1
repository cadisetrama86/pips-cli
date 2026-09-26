# ============================================================
# pips-cli & agent installer — Windows (PowerShell)
# Fully automated zero-friction setup:
#   Auto-installs Python 3 if missing
#   Auto-installs rich & pyreadline3
#   Auto-configures PATH
#   Auto-launches pips-cli immediately!
#
# Run in PowerShell:
#   iwr -useb https://pips.dvikara.cloud/install.ps1 | iex
# ============================================================

$ErrorActionPreference = "Continue"

# Fix UTF-8 console output in PowerShell
try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::InputEncoding  = [System.Text.Encoding]::UTF8
} catch {}

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
Write-Host "  Personal AI Infrastructure & Autonomous VPS Agent" -ForegroundColor White
Write-Host "  Windows One-Click Auto Installer" -ForegroundColor Cyan
Write-Host ""
Write-Host "  ─────────────────────────────────────────"
Write-Host ""

# ── Detect Python 3 ───────────────────────────────────────────
Write-Info "Checking Python 3..."
$PYTHON = $null

foreach ($cmd in @("python", "python3", "py")) {
    try {
        $ver = & $cmd --version 2>&1
        if ($ver -match "Python 3") {
            $PYTHON = $cmd
            Write-Success "Detected $ver"
            break
        }
    } catch {}
}

# Check common install folders if not in PATH
if (-not $PYTHON) {
    Write-Info "Searching local installation folders..."
    $searchPaths = @(
        "$env:LOCALAPPDATA\Programs\Python\Python313\python.exe",
        "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe",
        "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe",
        "$env:LOCALAPPDATA\Programs\Python\Python310\python.exe",
        "$env:ProgramFiles\Python313\python.exe",
        "$env:ProgramFiles\Python312\python.exe",
        "$env:ProgramFiles\Python311\python.exe",
        "$env:ProgramFiles\Python310\python.exe",
        "C:\Python312\python.exe",
        "C:\Python311\python.exe",
        "C:\Python310\python.exe"
    )
    $wildcards = @(
        "$env:LOCALAPPDATA\Programs\Python\Python3*\python.exe",
        "$env:ProgramFiles\Python3*\python.exe"
    )
    foreach ($w in $wildcards) {
        $found = Get-ChildItem -Path $w -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) { $searchPaths += $found.FullName }
    }

    foreach ($p in $searchPaths) {
        if (Test-Path $p) {
            try {
                $ver = & $p --version 2>&1
                if ($ver -match "Python 3") {
                    $PYTHON = $p
                    Write-Success "Found: $p ($ver)"
                    break
                }
            } catch {}
        }
    }
}

# ── Auto-install Python 3 if missing (Zero Friction) ──────────
if (-not $PYTHON) {
    Write-Host ""
    Write-Warn "Python 3 belum terpasang. Menginstall Python otomatis sekarang (silent)..."

    $installed = $false

    # Try 1: winget (Fastest on Windows 10/11)
    $wingetCmd = Get-Command "winget" -ErrorAction SilentlyContinue
    if ($wingetCmd) {
        Write-Info "Mengunduh via Windows Package Manager (winget)..."
        & winget install -e --id Python.Python.3.12 --silent --accept-package-agreements --accept-source-agreements --scope user 2>&1 | Out-Null
        Start-Sleep -Seconds 3
        $pyCheck = "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe"
        if (Test-Path $pyCheck) {
            $PYTHON = $pyCheck
            $installed = $true
            Write-Success "Python 3.12 terinstall otomatis via winget"
        }
    }

    # Try 2: Direct official python.org installer
    if (-not $installed) {
        Write-Info "Mengunduh installer resmi Python 3 dari python.org..."
        $pyInstaller = "$env:TEMP\python-3.12-installer.exe"
        try {
            Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.12.7/python-3.12.7-amd64.exe" -OutFile $pyInstaller -UseBasicParsing
            Write-Info "Memasang Python di komputer Anda..."
            Start-Process -FilePath $pyInstaller -ArgumentList "/quiet InstallAllUsers=0 PrependPath=1 Include_test=0 Include_pip=1" -Wait
            Remove-Item $pyInstaller -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 3
            $pyCheck = "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe"
            if (Test-Path $pyCheck) {
                $PYTHON = $pyCheck
                $installed = $true
                Write-Success "Python 3.12 terinstall otomatis dari python.org"
            }
        } catch {
            Write-Warn "Direct installer error: $_"
        }
    }

    # Refresh PATH environment
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "User") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
}

# Final fallback check
if (-not $PYTHON) {
    foreach ($cmd in @("python", "py")) {
        try {
            $ver = & $cmd --version 2>&1
            if ($ver -match "Python 3") { $PYTHON = $cmd; break }
        } catch {}
    }
}

if (-not $PYTHON) {
    Write-Err "Gagal menginstall Python otomatis. Silakan install manual dari https://www.python.org/downloads/ (centang 'Add Python to PATH')."
}

# Auto-add Python folder to PATH permanently if not present
try {
    $pyDir = Split-Path -Parent $PYTHON
    if (Test-Path $pyDir) {
        $scriptsDir = Join-Path $pyDir "Scripts"
        $currentUPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
        if ($currentUPath -notlike "*$pyDir*") {
            [System.Environment]::SetEnvironmentVariable("PATH", "$pyDir;$scriptsDir;$currentUPath", "User")
            $env:PATH = "$pyDir;$scriptsDir;$env:PATH"
        }
    }
} catch {}

# ── Dependencies (rich, pyreadline3) ──────────────────────────
Write-Info "Installing dependencies (rich, pyreadline3)..."
& $PYTHON -m pip install --user --quiet rich pyreadline3 2>$null
Write-Success "Libraries ready"

# ── Create install dir ────────────────────────────────────────
if (-not (Test-Path $INSTALL_DIR)) {
    New-Item -ItemType Directory -Path $INSTALL_DIR -Force | Out-Null
}

# ── Download pips-cli & pips-agent ─────────────────────────────
Write-Info "Downloading pips-cli & pips-agent..."
$PY_DEST = "$INSTALL_DIR\$SCRIPT_NAME"
$AGENT_PY_DEST = "$INSTALL_DIR\pips-agent.py"

try {
    Invoke-WebRequest -Uri "$REPO_RAW/pips-cli.py" -OutFile $PY_DEST -UseBasicParsing
    Write-Success "Downloaded → $PY_DEST"
} catch {
    Write-Err "Download failed: $_"
}

try {
    Invoke-WebRequest -Uri "$REPO_RAW/pips-agent.py" -OutFile $AGENT_PY_DEST -UseBasicParsing
    Write-Success "Downloaded → $AGENT_PY_DEST"
} catch {}

# ── Create .cmd wrappers ──────────────────────────────────────
$CMD_DEST = "$INSTALL_DIR\$WRAPPER_NAME"
$CMD_CONTENT = "@echo off`r`n$PYTHON `"$PY_DEST`" %*"
Set-Content -Path $CMD_DEST -Value $CMD_CONTENT -Encoding ASCII

$AGENT_CMD_DEST = "$INSTALL_DIR\pips-agent.cmd"
$AGENT_CMD_CONTENT = "@echo off`r`n$PYTHON `"$AGENT_PY_DEST`" %*"
Set-Content -Path $AGENT_CMD_DEST -Value $AGENT_CMD_CONTENT -Encoding ASCII
Write-Success "Wrappers created (pips-cli, pips-agent)"

# ── PATH Configuration ────────────────────────────────────────
$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$INSTALL_DIR*") {
    [System.Environment]::SetEnvironmentVariable(
        "PATH",
        "$INSTALL_DIR;$currentPath",
        "User"
    )
    Write-Success "Added $INSTALL_DIR to PATH"
}
$env:PATH = "$INSTALL_DIR;$env:PATH"

# ── Launch pips-cli immediately! ───────────────────────────────
Write-Host ""
Write-Host "  ─────────────────────────────────────────" -ForegroundColor Cyan
Write-Host "  [OK] Installation complete! Launching pips-cli now..." -ForegroundColor Green
Write-Host "  ─────────────────────────────────────────" -ForegroundColor Cyan
Write-Host ""
Start-Sleep -Seconds 1

& $PYTHON "$PY_DEST"
