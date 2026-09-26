# PIPS CLI & Autonomous VPS Agent

```
 ██████╗ ██╗██████╗ ███████╗
 ██╔══██╗██║██╔══██╗██╔════╝
 ██████╔╝██║██████╔╝███████╗
 ██╔═══╝ ██║██╔═══╝ ╚════██║
 ██║     ██║██║     ███████║
 ╚═╝     ╚═╝╚═╝     ╚══════╝
```

**Personal AI Infrastructure & Autonomous VPS Agent Engine**

GAS CAK NDANG DIGAWE OJOK NYOCOT AE

---

## Fitur Utama

- 🚀 **1-Command Zero-Friction Setup**: Cukup jalankan satu perintah di terminal — sistem otomatis memasang Python (jika belum ada), memasang library yang dibutuhkan, mengatur PATH, dan **langsung membuka `pips-cli` detik itu juga**.
- 🤖 **Autonomous VPS Agent**: Agen AI otonom yang beroperasi langsung di VPS untuk mengeksekusi shell command (`bash_run`), memantau dan me-restart container Docker (`docker_action`), membaca serta mengedit file (`file_read`, `file_write`, `file_edit`), dan memeriksa kesehatan server (`vps_status`).
- ⚡ **Interactive Chat TUI Bebas Glitch**: Chat token-by-token yang mulus dengan model canggih (Gemini 3.8 Flash, Claude Sonnet 4.6, Claude Opus Thinking, Gemini Pro Agent) tanpa token terpotong dan tanpa double render.
- 🌐 **Web Mission Control Dashboard**: Antarmuka web responsif bertema dark cyber di VPS yang dapat diakses langsung dari browser komputer atau ponsel tanpa setup tambahan.
- 🪟 **True Cross-Platform**: Kompatibel penuh dan stabil di Windows (PowerShell/CMD/WSL), Linux, dan macOS.

---

## Cara Install di Komputer Anda (1 Perintah Saja)

### 🪟 Windows (PowerShell)
Buka PowerShell, jalankan:
```powershell
iwr -useb https://pips.dvikara.cloud/install.ps1 | iex
```
> **Catatan:** Jika belum ada Python di Windows Anda, installer akan otomatis mengunduh dan memasangnya di background secara senyap (*silent*). Begitu selesai, `pips-cli` langsung terbuka otomatis!

### 🐧 Linux & 🍎 macOS (Terminal)
Buka terminal, jalankan:
```bash
curl -fsSL https://pips.dvikara.cloud/install.sh | bash
```
> Otomatis memasang dependency dan langsung masuk ke sesi interaktif `pips-cli`.

---

## Cara Pakai

### 1. Mode Autonomous VPS Agent (Kendalikan VPS Anda)
Jalankan tugas atau inspeksi VPS langsung dari terminal komputer Anda:
```bash
# Masuk ke sesi interaktif Agen
pips-cli agent

# Atau berikan instruksi tugas langsung (one-shot)
pips-cli agent "cek status disk dan container docker pemtan di VPS"
pips-cli agent "baca 50 baris terakhir log container pemtan-api"
pips-cli agent "cek pemakaian CPU dan RAM saat ini"
```
> Di dalam sesi chat biasa, Anda juga bisa mengetik `/agent` untuk berpindah ke mode agen kapan saja!

### 2. Mode Chat AI Reguler
```bash
# Mulai chat langsung (Default: Gemini 3.8 Flash)
pips-cli

# Pilih model interaktif di awal
pips-cli --select

# Langsung pilih model berdasarkan nomor (1-9)
pips-cli 4        # Claude Sonnet 4.6
pips-cli 5        # Claude Opus Thinking
pips-cli 6        # Gemini Pro Agent

# Pertanyaan sekali jalan (one-shot query)
pips-cli "jelaskan perbedaan docker run dan docker compose singkat"
```

### 3. Web Mission Control Dashboard
Buka browser di komputer Anda dan buka alamat:
```
http://<IP-VPS-ANDA>:20130/
```
*(Atau via Tailscale IP `http://100.90.156.126:20130/` atau `https://pips.dvikara.cloud/agent` jika Nginx sudah di-reload)*

Fitur Dashboard:
- Status VPS live (Gauges CPU %, RAM %, Disk %, dan daftar Docker aktif).
- Panel chat real-time dengan kartu visual eksekusi tool (*tool execution card*).
- Desain modern, dark mode, dan ringan.

---

## Perintah dalam Chat (Slash Commands)

| Perintah | Fungsi |
|----------|--------|
| `/agent` | Toggle mode Autonomous VPS Agent (aktif / nonaktif) |
| `/model` | Ganti model AI (menampilkan selector) |
| `/models` | Lihat semua model + ID lengkapnya |
| `/clear` | Hapus riwayat chat, mulai sesi baru |
| `/history` | Tampilkan riwayat percakapan saat ini |
| `/status` | Cek status gateway 9Router dan server agen VPS |
| `/help` | Tampilkan panduan semua perintah |
| `/exit` | Keluar dari aplikasi |

---

## Menjalankan Agen Server 24/7 di VPS (Systemd)

Untuk memastikan server agen dan Web Dashboard di VPS selalu aktif melayani request dari komputer Anda:

```bash
# Di server VPS (folder pips-cli):
sudo bash setup-agent-service.sh
```

Perintah ini akan:
1. Mendaftarkan unit systemd `pips-agent.service` (port `20130`).
2. Mengaktifkan autostart saat server reboot.
3. Memperbarui reverse proxy Nginx untuk routing `/agent` dan `/api/agent`.

---

## Daftar Model AI

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

---

## Troubleshooting

- **Windows `ModuleNotFoundError: No module named 'readline'`**:
  Telah diperbaiki dengan mekanisme *safe fallback* — tidak akan crash di Windows.
- **Teks streaming terpotong atau tercetak dobel**:
  Telah diperbaiki — streaming token-by-token langsung dicetak tanpa duplikasi panel Markdown.
- **Akses port agent dari luar**:
  Bisa diakses langsung lewat IP publik VPS port `20130`, Tailscale (`100.90.156.126:20130`), atau via Cloudflare/Nginx di `https://pips.dvikara.cloud/agent`.

---

## License

MIT
