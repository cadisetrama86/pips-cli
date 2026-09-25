# PIPS CLI

```
  ██████╗ ██╗██████╗ ███████╗
  ██╔══██╗██║██╔══██╗██╔════╝
  ██████╔╝██║██████╔╝███████╗
  ██╔═══╝ ██║██╔═══╝ ╚════██║
  ██║     ██║██║     ███████║
  ╚═╝     ╚═╝╚═╝     ╚══════╝
```

**Personal AI Infrastructure & Pipeline Server** — CLI chat client untuk gateway AI [pips.dvikara.cloud](https://pips.dvikara.cloud).

Akses model-model AI (Gemini, Claude, GPT, dan lainnya) langsung dari terminal, dengan tampilan rich TUI dan streaming response.

---

## Install (one-liner)

```bash
curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
```

Setelah install:

```bash
source ~/.bashrc   # atau ~/.zshrc
pips-cli
```

### Requirements

- Python 3.8+
- `rich` library (diinstall otomatis oleh installer)

---

## Usage

```bash
pips-cli                  # Start chat, default model
pips-cli --select         # Pilih model di awal
pips-cli -m ag/claude-sonnet-4-6   # Langsung pakai model tertentu
pips-cli --help           # Semua opsi
```

### Slash Commands (dalam chat)

| Command | Fungsi |
|---------|--------|
| `/model` | Ganti model AI |
| `/models` | List semua model |
| `/clear` | Bersihkan chat history |
| `/history` | Lihat percakapan |
| `/status` | Cek status gateway |
| `/help` | Bantuan |
| `/exit` | Keluar |

---

## Models

| # | Model ID | Nama | Keterangan |
|---|----------|------|-----------|
| 1 | `ag/gemini-3.8-flash` | Gemini 3.8 Flash | Coding Default ⚡ |
| 2 | `ag/gemini-3.8-flash-high` | Gemini 3.8 Flash High | High Quality |
| 3 | `ag/gemini-3.8-flash-low` | Gemini 3.8 Flash Low | Low Quota 🪶 |
| 4 | `ag/claude-sonnet-4-6` | Claude Sonnet 4.6 | Reasoning 🧠 |
| 5 | `ag/claude-opus-4-6-thinking` | Claude Opus Thinking | Deep Reasoning 💡 |
| 6 | `ag/gemini-pro-agent` | Gemini Pro Agent | Agentic 🤖 |
| 7 | `ag/gpt-oss-120b-medium` | GPT OSS 120B | Open Source |
| 8 | `ag/gemini-3-flash` | Gemini 3 Flash | Light Tasks 🌀 |
| 9 | `ag/gemini-3-flash-agent` | Gemini 3 Flash Agent | Agent Light |

---

## Configuration

### Environment variables

```bash
export PIPS_API_KEY="your-api-key"
export PIPS_BASE_URL="https://pips.dvikara.cloud/v1"   # optional
```

### Config file (opsional)

Buat `~/.pips/pips.env`:

```env
PIPS_API_KEY=your-api-key
PIPS_BASE_URL=https://pips.dvikara.cloud/v1
```

---

## Update

```bash
curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
```

---

## Uninstall

```bash
rm ~/.local/bin/pips-cli
```

---

## License

MIT
