# PIPS CLI

```
  ██████╗ ██╗██████╗ ███████╗
  ██╔══██╗██║██╔══██╗██╔════╝
  ██████╔╝██║██████╔╝███████╗
  ██╔═══╝ ██║██╔═══╝ ╚════██║
  ██║     ██║██║     ███████║
  ╚═╝     ╚═╝╚═╝     ╚══════╝
```

**Personal AI Infrastructure & Pipeline Server**

CLI chat client untuk gateway AI **pips.dvikara.cloud** — akses Gemini, Claude, GPT dan model lainnya langsung dari terminal, dengan streaming response dan tampilan rich TUI.

---

## Install

### 🐧 Linux

```bash
curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
source ~/.bashrc
pips-cli
```

### 🍎 macOS

```bash
curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
source ~/.zshrc    # atau ~/.bash_profile
pips-cli
```

> Kalau belum ada Python: `brew install python3`

### 🪟 Windows — PowerShell

Buka **PowerShell** (Run as Administrator untuk pertama kali):

```powershell
# Izinkan script execution (sekali saja)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install
iwr -useb https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.ps1 | iex
```

Setelah install, **restart terminal** lalu:

```powershell
pips-cli
```

> Kalau belum ada Python: download dari https://www.python.org/downloads/ — centang **"Add Python to PATH"** saat install.

### 🪟 Windows — WSL (Windows Subsystem for Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
source ~/.bashrc
pips-cli
```

---

## Cara Pakai

```bash
pips-cli                          # Start chat, default model
pips-cli --select                 # Pilih model di awal
pips-cli -m ag/claude-sonnet-4-6  # Langsung pakai model tertentu
pips-cli --help                   # Semua opsi
```

### Perintah dalam Chat

| Perintah | Fungsi |
|----------|--------|
| `/model` | Ganti model AI |
| `/models` | Lihat semua model |
| `/clear` | Hapus riwayat chat |
| `/history` | Tampilkan percakapan |
| `/status` | Cek koneksi gateway |
| `/help` | Bantuan |
| `/exit` | Keluar |

---

## Daftar Model

| # | Model | Keterangan |
|---|-------|-----------|
| 1 | `ag/gemini-3.8-flash` | Default — Coding & General ⚡ |
| 2 | `ag/gemini-3.8-flash-high` | Kualitas tinggi |
| 3 | `ag/gemini-3.8-flash-low` | Hemat kuota 🪶 |
| 4 | `ag/claude-sonnet-4-6` | Reasoning & Analisis 🧠 |
| 5 | `ag/claude-opus-4-6-thinking` | Deep reasoning 💡 |
| 6 | `ag/gemini-pro-agent` | Agentic tasks 🤖 |
| 7 | `ag/gpt-oss-120b-medium` | Open source model |
| 8 | `ag/gemini-3-flash` | Tugas ringan 🌀 |
| 9 | `ag/gemini-3-flash-agent` | Agent ringan |

---

## Konfigurasi

### API Key

**Linux / macOS:**
```bash
export PIPS_API_KEY="your-api-key"
echo 'export PIPS_API_KEY="your-api-key"' >> ~/.bashrc
```

**Windows PowerShell:**
```powershell
$env:PIPS_API_KEY = "your-api-key"
# Permanen:
[System.Environment]::SetEnvironmentVariable("PIPS_API_KEY", "your-api-key", "User")
```

### Config file (semua OS)

Buat `~/.pips/pips.env`:
```env
PIPS_API_KEY=your-api-key
PIPS_BASE_URL=https://pips.dvikara.cloud/v1
```

---

## Update

Jalankan ulang installer sesuai OS masing-masing.

---

## Uninstall

**Linux / macOS:**
```bash
rm ~/.local/bin/pips-cli
```

**Windows:**
```powershell
Remove-Item "$env:USERPROFILE\.local\bin\pips-cli.py"
Remove-Item "$env:USERPROFILE\.local\bin\pips-cli.cmd"
```

---

## Troubleshooting

**`pips-cli: command not found`**
```bash
source ~/.bashrc          # Linux
source ~/.zshrc           # macOS
# Atau: export PATH="$HOME/.local/bin:$PATH"
```

**`Error: 'rich' library not found`**
```bash
pip3 install rich         # Linux / macOS
pip install rich          # Windows
```

**Tidak bisa konek / connection error**
```bash
pips-cli           # lalu ketik /status
```

---

## Requirements

| | Linux | macOS | Windows |
|-|-------|-------|---------|
| Python | 3.8+ | 3.8+ | 3.8+ |
| pip | ✓ | ✓ | ✓ |
| rich | auto-install | auto-install | auto-install |
| curl/wget | ✓ | ✓ (built-in) | PowerShell |

---

## License

MIT
