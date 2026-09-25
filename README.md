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

## Cara Install

### 1. One-liner (Linux / macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
```

Installer akan otomatis:
- Cek Python 3
- Install library `rich` (jika belum ada)
- Download `pips-cli` ke `~/.local/bin/`
- Minta API key dan simpan ke `~/.bashrc`

### 2. Setelah install, reload shell

```bash
source ~/.bashrc
```

> Kalau pakai **zsh**: `source ~/.zshrc`

### 3. Set API key (jika skip saat install)

```bash
export PIPS_API_KEY="your-api-key"
```

Supaya permanen, tambahkan ke `~/.bashrc`:

```bash
echo 'export PIPS_API_KEY="your-api-key"' >> ~/.bashrc
source ~/.bashrc
```

### Requirements

| Kebutuhan | Keterangan |
|-----------|-----------|
| Python 3.8+ | `python3 --version` |
| pip | `pip3 --version` |
| curl atau wget | untuk download installer |

---

## Cara Pakai

### Mulai chat

```bash
pips-cli
```

### Pilih model di awal

```bash
pips-cli --select
```

### Langsung pakai model tertentu

```bash
pips-cli -m ag/claude-sonnet-4-6
```

### Lihat semua opsi

```bash
pips-cli --help
```

---

## Perintah dalam Chat (Slash Commands)

Ketik langsung di prompt chat:

| Perintah | Fungsi |
|---------|--------|
| `/model` | Ganti model AI |
| `/models` | Lihat semua model yang tersedia |
| `/clear` | Hapus riwayat chat |
| `/history` | Tampilkan percakapan saat ini |
| `/status` | Cek status koneksi ke gateway |
| `/help` | Tampilkan bantuan |
| `/exit` | Keluar dari pips-cli |

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

Gunakan `/model` di dalam chat untuk ganti model kapan saja.

---

## Konfigurasi

### Environment variable

```bash
export PIPS_API_KEY="your-api-key"
export PIPS_BASE_URL="https://pips.dvikara.cloud/v1"  # opsional
```

### Config file (alternatif)

Buat file `~/.pips/pips.env`:

```env
PIPS_API_KEY=your-api-key
PIPS_BASE_URL=https://pips.dvikara.cloud/v1
```

pips-cli akan otomatis membaca file ini saat startup.

---

## Update

Jalankan ulang installer untuk update ke versi terbaru:

```bash
curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
```

---

## Uninstall

```bash
rm ~/.local/bin/pips-cli
```

---

## Troubleshooting

**`pips-cli: command not found`**
```bash
source ~/.bashrc
# atau tambahkan manual ke PATH:
export PATH="$HOME/.local/bin:$PATH"
```

**`Error: 'rich' library not found`**
```bash
pip3 install rich
```

**`Connection error` / tidak bisa konek**
```bash
pips-cli /status   # cek status gateway
# atau set URL custom:
export PIPS_BASE_URL="https://pips.dvikara.cloud/v1"
```

---

## License

MIT
