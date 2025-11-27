#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

echo "💻 Setting up host environment..."

# macOS-specific setup
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍺 Setting up Homebrew and packages..."
    ./scripts/brew-setup.sh

    # Set zsh as default shell if not already
    if [[ "$SHELL" != *"zsh"* ]]; then
        echo "🐚 Setting zsh as default shell..."
        chsh -s /bin/zsh
    fi
else
    echo "⚠️  Non-macOS host detected. Skipping Homebrew setup."
fi

# Link host configurations
echo "🔗 Linking host configurations..."
./scripts/link-configs.sh

# Add custom scripts to PATH
echo "🛠️  Setting up custom scripts..."
mkdir -p "$HOME/.local/bin"

# Copy custom scripts to local bin
cp bin/* "$HOME/.local/bin/" 2>/dev/null || true

# Add to PATH if not already there
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc" 2>/dev/null || true
fi

echo "✅ Host environment setup complete!"
echo "🔄 Please restart your terminal or run 'source ~/.zshrc' to apply changes."
