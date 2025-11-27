#!/bin/bash

set -e

echo "🚀 Setting up host environment..."

# macOS-specific setup
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Configuring macOS-specific settings..."

    # Set up zsh as default shell if not already
    if [[ "$SHELL" != *"zsh"* ]]; then
        chsh -s /bin/zsh
    fi
fi

echo "✅ Environment setup complete!"
