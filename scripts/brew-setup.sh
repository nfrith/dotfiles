#!/bin/bash

set -e

echo "🍺 Setting up Homebrew..."

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
    echo "📥 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed"
fi

# Update Homebrew
echo "🔄 Updating Homebrew..."
brew update

# Install packages from Brewfile
echo "📦 Installing packages from Brewfile..."
if [[ -f "Brewfile" ]]; then
    brew bundle install
else
    echo "⚠️  Brewfile not found, skipping package installation"
fi

# Cleanup
echo "🧹 Cleaning up Homebrew..."
brew cleanup

echo "✅ Homebrew setup complete!"