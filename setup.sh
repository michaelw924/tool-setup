#!/bin/bash

# Tool Setup Script
# Installs tools and optionally personal configs

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITHUB_USER="michaelw924"
TOOLS_REPO_URL="https://github.com/${GITHUB_USER}/tool-setup.git"
OPENCODE_CONFIG_URL="https://github.com/${GITHUB_USER}/opencode-config.git"
NEOVIM_CONFIG_URL="https://github.com/${GITHUB_USER}/nvim-config.git"
TMUX_CONFIG_URL="https://github.com/${GITHUB_USER}/tmux-config.git"

ask_confirm() {
    local prompt="$1"
    local default="${2:-n}"
    read -p "${prompt} [y/n]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ "$default" == "y" && -z "$REPLY" ]]; then
        return 0
    else
        return 1
    fi
}

install_opencode() {
    echo "=== Installing OpenCode ==="
    
    # Check if already installed
    if command -v opencode &> /dev/null; then
        echo "OpenCode is already installed."
    else
        echo "Downloading and compiling OpenCode..."
        # Adjust based on actual installation method
        # Example: download binary, compile from source, etc.
        echo "OpenCode installation steps would go here."
    fi
    
    if ask_confirm "Install OpenCode personal config?"; then
        echo "Installing OpenCode config from $OPENCODE_CONFIG_URL"
        # Clone config and symlink files
    else
        echo "Skipping OpenCode config installation."
    fi
}

install_neovim() {
    echo "=== Installing Neovim ==="
    
    if command -v nvim &> /dev/null; then
        echo "Neovim is already installed (version: $(nvim --version | head -1))"
    else
        echo "Installing Neovim..."
        # Ubuntu/Debian example:
        # sudo apt-get update && sudo apt-get install -y neovim
        # Or compile from source
        echo "Neovim installation steps would go here."
    fi
    
    if ask_confirm "Install Neovim personal config?"; then
        echo "Installing Neovim config from $NEOVIM_CONFIG_URL"
        # Clone config and symlink files
    else
        echo "Skipping Neovim config installation."
    fi
}

install_tmux() {
    echo "=== Installing tmux ==="
    
    if command -v tmux &> /dev/null; then
        echo "tmux is already installed (version: $(tmux -V))"
    else
        echo "Installing tmux..."
        # Ubuntu/Debian example:
        # sudo apt-get update && sudo apt-get install -y tmux
        # Or compile from source
        echo "tmux installation steps would go here."
    fi
    
    if ask_confirm "Install tmux config?"; then
        echo "Installing tmux config from $TMUX_CONFIG_URL"
        # Clone config and symlink files
    else
        echo "Skipping tmux config installation."
    fi
}

main() {
    echo "=========================================="
    echo "       Tool Setup Script"
    echo "=========================================="
    echo
    
    if ask_confirm "Install OpenCode?"; then
        install_opencode
    else
        echo "Skipping OpenCode."
    fi
    echo
    
    if ask_confirm "Install Neovim?"; then
        install_neovim
    else
        echo "Skipping Neovim."
    fi
    echo
    
    if ask_confirm "Install tmux?"; then
        install_tmux
    else
        echo "Skipping tmux."
    fi
    echo
    
    echo "=========================================="
    echo "       Setup Complete!"
    echo "=========================================="
}

main "$@"
