# PIPS CLI

> Interactive AI chat for the terminal — powered by [PIPS](https://pips.dvikara.cloud) personal AI gateway.

```
╭──────────────────────────────────────────────────────────╮
│ PIPS — Personal AI Infrastructure & Pipeline Server      │
│ Gateway: https://pips.dvikara.cloud/v1                   │
│ Model:   Gemini 3.8 Flash — Coding Default ⚡            │
│ Type /help for commands • /model to switch • /exit       │
╰──────────────────────────────────────────────────────────╯

  ❯ explain what a closure is in javascript
  
  ● Gemini 3.8 Flash
  A closure is a function that retains access to variables
  from its outer scope even after that scope has closed...
```

## Features

- **Streaming responses** — tokens appear in real-time
- **Thinking indicator** — spinner while model processes
- **Markdown rendering** — code blocks, bold, lists formatted
- **Model switcher** — switch between Gemini, Claude, GPT OSS
- **Chat history** — context maintained across turns
- **Input history** — ↑↓ arrow keys to navigate previous inputs
- **Slash commands** — `/model`, `/clear`, `/status`, `/help`

## Requirements

- Python 3.8+
- `rich` library
- PIPS API key (get from your PIPS gateway admin)

## Install

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/cadisetrama86/pips-cli/main/install.sh | bash
```

### Manual

```bash
# Clone repo
git clone https://github.com/cadisetrama86/pips-cli.git
cd pips-cli

# Install rich
pip install rich

# Install
chmod +x bin/pips-cli
cp bin/pips-cli ~/.local/bin/pips-cli
```

## Configuration

Set environment variables in your `~/.bashrc` or `~/.zshrc`:

```bash
export PIPS_API_KEY="your-api-key-here"

# Optional: override gateway URL (default: https://pips.dvikara.cloud/v1)
# For local VM usage:
# export PIPS_BASE_URL="http://127.0.0.1:20128/v1"
```

## Usage

```bash
# Start chat with default model (Gemini 3.8 Flash)
pips-cli

# Choose model at startup
pips-cli --select

# Set model directly
pips-cli --model ag/claude-sonnet-4-6

# Override gateway URL
pips-cli --url http://127.0.0.1:20128/v1

# Show help
pips-cli --help
```

## Available Models

| # | Model ID | Description |
|---|----------|-------------|
| 1 | `ag/gemini-3.8-flash` | Coding Default ⚡ |
| 2 | `ag/gemini-3.8-flash-high` | High Quality |
| 3 | `ag/gemini-3.8-flash-low` | Low Quota 🪶 |
| 4 | `ag/claude-sonnet-4-6` | Reasoning 🧠 |
| 5 | `ag/claude-opus-4-6-thinking` | Deep Reasoning 💡 |
| 6 | `ag/gemini-pro-agent` | Agentic 🤖 |
| 7 | `ag/gpt-oss-120b-medium` | Open Source |
| 8 | `ag/gemini-3-flash` | Light Tasks 🌀 |
| 9 | `ag/gemini-3-flash-agent` | Agent Light |

## Slash Commands

| Command | Description |
|---------|-------------|
| `/model` | Switch AI model interactively |
| `/models` | List all available models |
| `/clear` | Clear chat history |
| `/history` | Show conversation history |
| `/status` | Check gateway connection status |
| `/help` | Show help |
| `/exit` | Quit |

## Architecture

```
pips-cli (your computer)
    │
    │  HTTPS
    ▼
pips.dvikara.cloud
    │
    │  Cloudflare Tunnel
    ▼
9Router (VM)  :20128
    │
    │  Antigravity
    ▼
AI Providers (Gemini, Claude, GPT OSS...)
```

## Local VM Usage

If you have your own PIPS setup running locally:

```bash
export PIPS_BASE_URL="http://127.0.0.1:20128/v1"
export PIPS_API_KEY="your-local-key"
pips-cli
```
