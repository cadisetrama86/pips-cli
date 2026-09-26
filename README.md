<div align="center">

```
        ╱████████████████████╲
  ╱████      🔥      🔥      ████╲
 ╱████████████████████████████████╲
╱██████████████████████████████████╲
       ╲████████████████████╱
             ╲████████╱
                ╲██╱

† † †        ╔══════════════════╗        † † †
CRIMSON      ║     PIPS  AI     ║       SHADOW
† † †        ╚══════════════════╝        † † †

     ██████╗ ██╗██████╗ ███████╗
     ██╔══██╗██║██╔══██╗██╔════╝
     ██████╔╝██║██████╔╝███████╗
     ██╔═══╝ ██║██╔═══╝ ╚════██║
     ██║     ██║██║     ███████║
     ╚═╝     ╚═╝╚═╝     ╚══════╝

  †         †         †         †         †
 /|\       /|\       /|\       /|\       /|\
/_|_\     /_|_\     /_|_\     /_|_\     /_|_\
```

# PIPS CLI
### AI Development Companion & Autonomous Agent Engine

[![Version](https://img.shields.io/badge/version-2.0.0-crimson.svg)](https://github.com/cadisetrama86/pips-cli)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-black.svg)](https://github.com/cadisetrama86/pips-cli)
[![Gateway](https://img.shields.io/badge/router-9Router%20Dynamic-red.svg)](https://github.com/cadisetrama86/pips-cli)
[![License](https://img.shields.io/badge/license-MIT-darkred.svg)](https://github.com/cadisetrama86/pips-cli)

*A powerful, lightweight, pure terminal AI coding companion & autonomous agent with dynamic model discovery, local web preview, and instant self-updating.*

---

</div>

## ⚡ Mengenal PIPS CLI

**PIPS CLI** adalah asisten pengembang berbasis terminal (TUI) yang cepat dan dirancang untuk interaksi AI tanpa hambatan (*zero-friction*). Didukung oleh gateway terintegrasi, PIPS menghubungkan Anda langsung dengan berbagai model AI modern tanpa konfigurasi rumit.

### 🌟 Fitur Unggulan

- 🖥️ **Pure Terminal Interface**: Antarmuka TUI bergaya *dark crimson gothic* yang bersih, responsif, dan ringan tanpa dependensi GUI.
- 🤖 **Autonomous Coding Agent**: Mampu membaca file, menulis kode, memodifikasi berkas dengan *unified diff*, mengeksekusi perintah shell, dan menguji hasil secara mandiri.
- 🔄 **Dynamic Model Discovery**: Temukan dan ganti model AI (Gemini, Claude, GPT, DeepSeek, dsb.) secara interaktif langsung dari gateway tanpa *hardcode*.
- 🌐 **Instant Local Preview Server**: Sajikan file proyek HTML/CSS/JS secara instan di `http://localhost:3000` dengan 1 perintah.
- 🧠 **Persistent Session Memory**: Percakapan dan konteks agen tersimpan aman lintas sesi di folder kerja aktif Anda.
- 🔄 **1-Command Self Updater**: Perbarui aplikasi secara instan kapan saja langsung dari terminal.

---

## 🚀 Cara Download & Instalasi (1 Perintah Saja)

Pilih sistem operasi Anda dan jalankan perintah di bawah ini:

### 🪟 Windows (PowerShell)

Buka PowerShell, lalu salin dan jalankan:

```powershell
irm https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.ps1 | iex
```

> **Catatan**: Jika Python belum terpasang di komputer Anda, installer akan otomatis menyiapkan semuanya di latar belakang. Begitu instalasi selesai, PIPS CLI akan langsung terbuka otomatis.

---

### 🐧 Linux & 🍎 macOS (Terminal)

Buka terminal, lalu salin dan jalankan:

```bash
curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
```

---

## 💡 Cara Pakai Cepat

Setelah terpasang, perintah `pips-cli` dapat dijalankan dari folder mana saja di terminal Anda:

```bash
# 1. Buka Menu Utama Interaktif
pips-cli

# 2. Mulai Sesi Chat Langsung
pips-cli chat

# 3. Jalankan Autonomous Agent
pips-cli agent

# 4. Preview Web Project di Folder Ini (http://localhost:3000)
pips-cli preview

# 5. Tanya Cepat (One-shot prompt)
pips-cli "apa fungsi docker compose?"

# 6. Update ke Versi Rilis Terbaru
pips-cli update
```

---

## ⌨️ Perintah Interaktif (Slash Commands)

Saat berada di dalam sesi chat, ketik perintah berikut kapan saja:

| Perintah | Fungsi |
| :--- | :--- |
| `/agent` | Mengaktifkan / menonaktifkan mode Autonomous Agent |
| `/model` | Membuka selektor model interaktif |
| `/model <nama>` | Mencari atau langsung beralih ke model tertentu |
| `/preview` `[path]` | Menyalakan server preview web lokal di latar belakang |
| `/update` | Memperbarui PIPS CLI & Agent ke versi terbaru |
| `/clear` | Membersihkan riwayat chat dan memori agen |
| `/history` | Menampilkan riwayat percakapan sesi ini |
| `/status` | Memeriksa status koneksi gateway |
| `/help` | Menampilkan ringkasan panduan bantuan |
| `/exit` | Keluar dari aplikasi |

---

## 📄 Lisensi

Didistribusikan di bawah lisensi MIT.
