#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

echo "🚀 Starting dotfiles installation..."
echo "📁 Dotfiles directory: $DOTFILES_DIR"

# Source environment detection
source scripts/detect-environment.sh

# Detect environment and route to appropriate installer
if is_remote_environment; then
    echo "🔧 Detected remote/DevPod environment"
    ./install-remote.sh
else
    echo "💻 Detected host environment"
    ./install-host.sh
fi

echo "✅ Dotfiles installation complete!"