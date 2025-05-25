#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

echo "💻 Setting up host environment..."

# Source utilities
source scripts/detect-environment.sh

# macOS-specific setup
if is_macos; then
    echo "🍺 Setting up Homebrew and packages..."
    ./scripts/brew-setup.sh
else
    echo "⚠️  Non-macOS host detected. Skipping Homebrew setup."
fi

# Link host configurations
echo "🔗 Linking host configurations..."
./scripts/link-configs.sh host

# Add custom scripts to PATH
echo "🛠️  Setting up custom scripts..."
if [[ -d "$HOME/.local/bin" ]]; then
    mkdir -p "$HOME/.local/bin"
fi

# Copy custom scripts to local bin
cp bin/* "$HOME/.local/bin/" 2>/dev/null || true

# Add to PATH if not already there
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

echo "✅ Host environment setup complete!"
echo "🔄 Please restart your terminal or run 'source ~/.zshrc' to apply changes."