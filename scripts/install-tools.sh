#!/bin/bash

set -e

echo "📦 Installing essential development tools..."

# Source environment detection
source "$(dirname "${BASH_SOURCE[0]}")/detect-environment.sh"

# Update package manager
if is_linux; then
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        
        # Fix locale issues
        sudo apt-get install -y locales
        echo 'en_US.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen
        sudo locale-gen en_US.UTF-8
        sudo update-locale LANG=en_US.UTF-8 || true  # Don't fail if locale update has issues
        
        # Essential packages
        sudo apt-get install -y \
            curl \
            wget \
            git \
            build-essential \
            unzip \
            tree \
            htop \
            zsh
            
        # Install neovim
        if ! command -v nvim >/dev/null 2>&1; then
            echo "📥 Installing Neovim..."
            # Use package manager for easier ARM64 compatibility
            sudo apt-get install -y neovim
        fi
        
        # Install fzf
        if ! command -v fzf >/dev/null 2>&1; then
            echo "📥 Installing fzf..."
            if [ -d ~/.fzf ]; then
                rm -rf ~/.fzf
            fi
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            ~/.fzf/install --all
        fi
        
        # Install ripgrep
        if ! command -v rg >/dev/null 2>&1; then
            echo "📥 Installing ripgrep..."
            RG_VERSION="14.1.0"
            curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz"
            tar xzf "ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz"
            sudo mv "ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl/rg" /usr/local/bin/
            rm -rf "ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl"*
        fi
        
        # Install bat
        if ! command -v bat >/dev/null 2>&1; then
            echo "📥 Installing bat..."
            BAT_VERSION="0.24.0"
            curl -LO "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz"
            tar xzf "bat-v${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz"
            sudo mv "bat-v${BAT_VERSION}-x86_64-unknown-linux-musl/bat" /usr/local/bin/
            rm -rf "bat-v${BAT_VERSION}-x86_64-unknown-linux-musl"*
        fi
        
        # Install fd
        if ! command -v fd >/dev/null 2>&1; then
            echo "📥 Installing fd..."
            FD_VERSION="9.0.0"
            curl -LO "https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz"
            tar xzf "fd-v${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz"
            sudo mv "fd-v${FD_VERSION}-x86_64-unknown-linux-musl/fd" /usr/local/bin/
            rm -rf "fd-v${FD_VERSION}-x86_64-unknown-linux-musl"*
        fi
        
        # Install starship
        if ! command -v starship >/dev/null 2>&1; then
            echo "📥 Installing starship..."
            curl -sS https://starship.rs/install.sh | sudo sh -s -- --yes
        fi
        
        # Install yazi file manager with optional dependencies
        if ! command -v yazi >/dev/null 2>&1; then
            echo "📥 Installing Yazi file manager and dependencies..."
            
            # Install Yazi optional dependencies via apt
            sudo apt-get install -y \
                ffmpeg \
                p7zip-full \
                jq \
                poppler-utils \
                imagemagick \
                file
            
            # Install Yazi binary (latest release for ARM64 - musl for compatibility)
            echo "📥 Downloading Yazi latest release for ARM64 (musl)..."
            curl -LO "https://github.com/sxyazi/yazi/releases/latest/download/yazi-aarch64-unknown-linux-musl.zip"
            unzip "yazi-aarch64-unknown-linux-musl.zip"
            sudo mv "yazi-aarch64-unknown-linux-musl/yazi" /usr/local/bin/
            sudo mv "yazi-aarch64-unknown-linux-musl/ya" /usr/local/bin/
            sudo chmod +x /usr/local/bin/yazi /usr/local/bin/ya
            rm -rf "yazi-aarch64-unknown-linux-musl"*
            echo "✅ Yazi installed successfully"
        fi
        
        # Install zoxide for yazi historical directory navigation
        if ! command -v zoxide >/dev/null 2>&1; then
            echo "📥 Installing zoxide..."
            curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
            sudo mv ~/.local/bin/zoxide /usr/local/bin/ 2>/dev/null || true
        fi
        
        # Install Node.js via nvm (required for Claude Code)
        if ! command -v node >/dev/null 2>&1; then
            echo "📥 Setting up Node.js..."
            
            # Check if nvm is already installed
            export NVM_DIR="$HOME/.nvm"
            if [ -s "$NVM_DIR/nvm.sh" ]; then
                echo "✅ nvm already installed, sourcing and setting up Node.js..."
                \. "$NVM_DIR/nvm.sh"
            elif command -v nvm >/dev/null 2>&1; then
                echo "✅ nvm already available in PATH..."
            else
                echo "📥 Installing nvm..."
                curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            fi
            
            # Install/use latest LTS Node.js if not already available
            if ! command -v node >/dev/null 2>&1; then
                echo "📥 Installing Node.js LTS..."
                nvm install --lts
                nvm use --lts
                nvm alias default node
            else
                echo "✅ Node.js already available"
            fi
        fi
        
        # Install Claude Code
        if ! command -v claude-code >/dev/null 2>&1; then
            echo "📥 Installing Claude Code..."
            npm install -g @anthropic-ai/claude-code
        fi
        
        # Install GitHub CLI
        if ! command -v gh >/dev/null 2>&1; then
            echo "📥 Installing GitHub CLI..."
            (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
                && sudo mkdir -p -m 755 /etc/apt/keyrings \
                && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
                && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
                && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
                && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
                && sudo apt update \
                && sudo apt install gh -y
        fi
        
    elif command -v yum >/dev/null 2>&1; then
        sudo yum update -y
        sudo yum install -y curl wget git gcc make unzip tree htop
    elif command -v apk >/dev/null 2>&1; then
        sudo apk update
        sudo apk add curl wget git build-base unzip tree htop
    fi
fi

echo "✅ Development tools installation complete!"