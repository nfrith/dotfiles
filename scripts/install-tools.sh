#!/bin/bash

set -e

echo "📦 Installing essential development tools..."

# Source environment detection
source "$(dirname "${BASH_SOURCE[0]}")/detect-environment.sh"

# Update package manager
if is_linux; then
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        
        # Essential packages
        sudo apt-get install -y \
            curl \
            wget \
            git \
            build-essential \
            unzip \
            tree \
            htop
            
        # Install neovim
        if ! command -v nvim >/dev/null 2>&1; then
            echo "📥 Installing Neovim..."
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
            chmod u+x nvim.appimage
            sudo mv nvim.appimage /usr/local/bin/nvim
        fi
        
        # Install fzf
        if ! command -v fzf >/dev/null 2>&1; then
            echo "📥 Installing fzf..."
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
        
    elif command -v yum >/dev/null 2>&1; then
        sudo yum update -y
        sudo yum install -y curl wget git gcc make unzip tree htop
    elif command -v apk >/dev/null 2>&1; then
        sudo apk update
        sudo apk add curl wget git build-base unzip tree htop
    fi
fi

echo "✅ Development tools installation complete!"