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

1. **OpenCode** - AI coding assistant (via official installer)
2. **Neovim** - Code editor (via package manager)
3. **tmux** - Terminal multiplexer (via package manager)

After each tool installation, you can choose to install your personal config from the respective config repos.

## Platform Support

| Platform | Package Manager |
|----------|----------------|
| macOS | Homebrew |
| Ubuntu/Debian | apt |
| Arch Linux | pacman |

## Config Repos

- `nvim-config` - Neovim configuration
- `tmux-config` - tmux configuration  
- `opencode-config` - OpenCode configuration

## Requirements

- Git
- curl (for remote execution)
- sudo access (for tool installation on Linux)
- Homebrew (on macOS, for package installation)
