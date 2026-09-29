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

get_ip_address() {
    local prompt="$1"
    local default="${2:-}"
    local ip=""
    while [[ -z "$ip" ]]; do
        if [[ -n "$default" ]]; then
            read -p "${prompt} [${default}]: " ip
            ip="${ip:-$default}"
        else
            read -p "${prompt}: " ip
        fi
        # Basic validation: check if it looks like an IP address
        if [[ -n "$ip" ]] && [[ ! "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            echo "Warning: '$ip' does not look like a valid IP address. Please try again."
            ip=""
        fi
    done
    echo "$ip"
}

detect_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        PLATFORM="macos"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|linuxmint)
                PLATFORM="linux"
                ;;
            arch|manjaro)
                PLATFORM="arch"
                ;;
            fedora|rhel|centos)
                PLATFORM="fedora"
                ;;
            *)
                PLATFORM="linux"
                ;;
        esac
    else
        PLATFORM="unknown"
    fi
    echo "Detected platform: $PLATFORM"
}

install_opencode() {
    echo "=== Installing OpenCode ==="
    
    # Check if already installed
    if command -v opencode &> /dev/null; then
        echo "OpenCode is already installed."
    else
        echo "Installing OpenCode..."
        curl -fsSL https://opencode.ai/v2/install | bash
    fi
    
    if ask_confirm "Install OpenCode personal config?"; then
        echo "Installing OpenCode config from $OPENCODE_CONFIG_URL"
        
        # Create config directory if it doesn't exist
        mkdir -p ~/.config/opencode
        
        # Clone the config repo
        if [[ -d "$OPENCODE_CONFIG_URL" ]]; then
            cp -r "$OPENCODE_CONFIG_URL"/* ~/.config/opencode/
        else
            echo "Cloning config repo..."
            git clone "$OPENCODE_CONFIG_URL" ~/.config/opencode
        fi
        
        # Prompt for local server IP
        echo ""
        echo "Enter your local server IP address for the OpenCode model:"
        SERVER_IP=$(get_ip_address "IP address" "192.168.100.80")
        echo "Using IP: $SERVER_IP"
        
        # Generate config.json from template
        if [[ -f ~/.config/opencode/config.template.json ]]; then
            sed "s/<YOUR_LOCAL_IP>/${SERVER_IP}/g" ~/.config/opencode/config.template.json > ~/.config/opencode/config.json
            echo "Generated ~/.config/opencode/config.json with IP: $SERVER_IP"
        fi
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
        detect_platform
        
        case "$PLATFORM" in
            macos)
                brew install neovim
                ;;
            ubuntu|debian|linux)
                echo "Compiling Neovim from source for Linux..."
                install_neovim_linux
                ;;
            arch)
                sudo pacman -S --noconfirm neovim
                ;;
            *)
                echo "Platform $PLATFORM detected. Install Neovim manually:"
                echo "  macOS: brew install neovim"
                echo "  Ubuntu/Debian: sudo apt install neovim"
                echo "  Arch: sudo pacman -S neovim"
                ;;
        esac
    fi
    
    if ask_confirm "Install Neovim personal config?"; then
        echo "Installing Neovim config from $NEOVIM_CONFIG_URL"
        mkdir -p ~/.config
        rm -rf ~/.config/nvim
        git clone "$NEOVIM_CONFIG_URL" ~/.config/nvim
        echo "Neovim config installed to ~/.config/nvim"
    else
        echo "Skipping Neovim config installation."
    fi
}

install_neovim_linux() {
    # Install build dependencies
    echo "Installing build dependencies..."
    sudo apt-get update
    sudo apt-get install -y ninja-build gettext cmake build-essential curl git unzip
    
    # Clone and build Neovim
    echo "Cloning Neovim repository..."
    TEMP_DIR="/tmp/neovim-build-$$"
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    git clone https://github.com/neovim/neovim.git
    cd neovim
    git checkout stable
    
    echo "Building Neovim..."
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    
    echo "Installing Neovim..."
    sudo make install
    
    # Cleanup
    cd -
    rm -rf "$TEMP_DIR"
    
    echo "Neovim installed successfully!"
    nvim --version | head -1
}

install_tmux() {
    echo "=== Installing tmux ==="
    
    if command -v tmux &> /dev/null; then
        echo "tmux is already installed (version: $(tmux -V))"
    else
        echo "Installing tmux..."
        detect_platform
        
        case "$PLATFORM" in
            macos)
                brew install tmux
                ;;
            linux)
                sudo apt-get update && sudo apt-get install -y tmux
                ;;
            arch)
                sudo pacman -S --noconfirm tmux
                ;;
            fedora)
                sudo dnf install -y tmux
                ;;
            *)
                echo "Platform $PLATFORM detected. Install tmux manually:"
                echo "  macOS: brew install tmux"
                echo "  Ubuntu/Debian: sudo apt install tmux"
                echo "  Arch: sudo pacman -S tmux"
                ;;
        esac
    fi
    
    if ask_confirm "Install tmux config?"; then
        echo "Installing tmux config from $TMUX_CONFIG_URL"
        mkdir -p ~/.tmux-config
        rm -f ~/.tmux.conf
        git clone "$TMUX_CONFIG_URL" ~/.tmux-config
        ln -s ~/.tmux-config/.tmux.conf ~/.tmux.conf
        echo "tmux config installed and symlinked"
    else
        echo "Skipping tmux config."
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
