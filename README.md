# Tool Setup

Automated setup script for common development tools.

## Quick Start

Run this command on a new machine to install tools interactively:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/michaelw924/tool-setup/main/setup.sh)"
```

Or clone and run locally:

```bash
git clone git@github.com:michaelw924/tool-setup.git
cd tool-setup
./setup.sh
```

## What It Installs

The script will prompt you for each tool:

1. **OpenCode** - AI coding assistant (local LLM)
2. **Neovim** - Code editor
3. **tmux** - Terminal multiplexer

After each tool installation, you can choose to install your personal config from the respective config repos.

## Config Repos

- `nvim-config` - Neovim configuration
- `tmux-config` - tmux configuration  
- `opencode-config` - OpenCode configuration (private, contains local IP)

## Requirements

- Git
- curl (for remote execution)
- sudo access (for tool installation)
