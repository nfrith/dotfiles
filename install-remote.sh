#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

echo "🔧 Setting up remote environment..."

# Source utilities
source scripts/detect-environment.sh

# Install essential tools for remote development
echo "📦 Installing remote development tools..."
./scripts/install-tools.sh

# Link remote configurations
echo "🔗 Linking remote configurations..."
./scripts/link-configs.sh remote

# Set up zellij
echo "🗂️  Setting up zellij..."
if command -v zellij >/dev/null 2>&1; then
    echo "✅ Zellij is installed"
else
    echo "📥 Installing zellij..."
    if is_linux; then
        # Install zellij on Linux
        ZELLIJ_VERSION="v0.39.2"
        curl -L "https://github.com/zellij-org/zellij/releases/download/${ZELLIJ_VERSION}/zellij-x86_64-unknown-linux-musl.tar.gz" | tar xz -C /tmp
        sudo mv /tmp/zellij /usr/local/bin/
        chmod +x /usr/local/bin/zellij
    fi
fi

# Set up development environment
echo "🚀 Setting up development environment..."
./scripts/setup-environment.sh remote

echo "✅ Remote environment setup complete!"
echo "💡 Run 'zellij' to start your terminal multiplexer"