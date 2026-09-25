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

GAS CAK NDANG DIGAWE OJOK NYOCOT AE

---

## Cara Install

### 🐧 Linux

```bash
curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
source ~/.bashrc
pips-cli
```

### 🍎 macOS

```bash
curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
source ~/.zshrc
pips-cli
```

> Belum ada Python? Install dulu: `brew install python3`

### 🪟 Windows — PowerShell

```powershell
# Izinkan script (sekali saja)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install
iwr -useb https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.ps1 | iex
```

Setelah selesai, **restart terminal** lalu jalankan `pips-cli`.

> Belum ada Python? Download di https://www.python.org/downloads/  
> Saat install, centang **"Add Python to PATH"**.

### 🪟 Windows — WSL

```bash
curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
source ~/.bashrc
pips-cli
```

### Requirements

- Python 3.8+
- Library `rich` — diinstall otomatis oleh installer

---

## Cara Pakai

### Mulai chat

```bash
pips-cli
```

Langsung masuk ke chat dengan model default (Gemini 3.8 Flash).

### Pilih model di awal

```bash
pips-cli --select
```

Menampilkan daftar model untuk dipilih sebelum mulai chat.

### Langsung set model tertentu

```bash
pips-cli ag/claude-sonnet-4-6
```

### Contoh sesi chat

```
❯ jelaskan apa itu REST API
❯ buatkan contoh kode Python untuk membuat REST API
❯ /model          ← ganti model
❯ /clear          ← hapus riwayat
❯ /exit           ← keluar
```

---

## Perintah dalam Chat

| Perintah | Fungsi |
|----------|--------|
| `/model` | Ganti model AI (tampil selector) |
| `/models` | Lihat semua model + ID-nya |
| `/clear` | Hapus riwayat chat, mulai baru |
| `/history` | Tampilkan percakapan saat ini |
| `/status` | Cek status koneksi ke gateway |
| `/help` | Tampilkan semua perintah |
| `/exit` | Keluar dari pips-cli |

> Tips: gunakan tombol ↑↓ untuk navigasi riwayat input.

---

## Daftar Model

| # | Model ID | Nama | Keterangan |
|---|----------|------|-----------|
| 1 | `ag/gemini-3.8-flash` | Gemini 3.8 Flash | Default — Coding & General ⚡ |
| 2 | `ag/gemini-3.8-flash-high` | Gemini 3.8 Flash High | Kualitas lebih tinggi |
| 3 | `ag/gemini-3.8-flash-low` | Gemini 3.8 Flash Low | Hemat kuota 🪶 |
| 4 | `ag/claude-sonnet-4-6` | Claude Sonnet 4.6 | Reasoning & Analisis 🧠 |
| 5 | `ag/claude-opus-4-6-thinking` | Claude Opus Thinking | Deep Reasoning 💡 |
| 6 | `ag/gemini-pro-agent` | Gemini Pro Agent | Agentic 🤖 |
| 7 | `ag/gpt-oss-120b-medium` | GPT OSS 120B | Open Source Model |
| 8 | `ag/gemini-3-flash` | Gemini 3 Flash | Tugas Ringan 🌀 |
| 9 | `ag/gemini-3-flash-agent` | Gemini 3 Flash Agent | Agent Ringan |

Gunakan `/model` di dalam chat untuk ganti model kapan saja.

---

## Konfigurasi

Tidak perlu setup — API key dan gateway URL sudah terisi otomatis.

Kalau ingin override (opsional):

```bash
# Linux / macOS
export PIPS_BASE_URL="https://pips.dvikara.cloud/v1"
export PIPS_API_KEY="your-api-key"
```

```powershell
# Windows PowerShell
$env:PIPS_BASE_URL = "https://pips.dvikara.cloud/v1"
$env:PIPS_API_KEY = "your-api-key"
```

Atau buat file `~/.pips/pips.env`:

```env
PIPS_BASE_URL=https://pips.dvikara.cloud/v1
PIPS_API_KEY=your-api-key
```

---

## Update

Jalankan ulang installer sesuai OS:

```bash
# Linux / macOS
curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
```

```powershell
# Windows
iwr -useb https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.ps1 | iex
```

---

## Uninstall

```bash
# Linux / macOS
rm ~/.local/bin/pips-cli
```

```powershell
# Windows
Remove-Item "$env:USERPROFILE\.local\bin\pips-cli.py"
Remove-Item "$env:USERPROFILE\.local\bin\pips-cli.cmd"
```

---

## Troubleshooting

**`pips-cli: command not found`**
```bash
source ~/.bashrc    # Linux
source ~/.zshrc     # macOS
```

**`ModuleNotFoundError: No module named 'rich'`**
```bash
pip3 install rich
```

**Connection error / tidak bisa konek**
```bash
# Cek status gateway
pips-cli   # lalu ketik /status
```

---

## License

MIT
