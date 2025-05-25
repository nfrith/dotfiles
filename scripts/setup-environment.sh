#!/bin/bash

set -e

ENVIRONMENT="${1:-shared}"

echo "🚀 Setting up $ENVIRONMENT environment..."

# Source environment detection
source "$(dirname "${BASH_SOURCE[0]}")/detect-environment.sh"

case "$ENVIRONMENT" in
    "host")
        echo "💻 Configuring host environment..."
        
        # Set up shell enhancements for host
        if is_macos; then
            # macOS-specific setup
            echo "🍎 Configuring macOS-specific settings..."
            
            # Set up zsh as default shell if not already
            if [[ "$SHELL" != *"zsh"* ]]; then
                chsh -s /bin/zsh
            fi
        fi
        ;;
        
    "remote")
        echo "🔧 Configuring remote environment..."
        
        # Create common development directories
        mkdir -p "$HOME/workspace" "$HOME/projects" "$HOME/.local/bin"
        
        # Set up shell for remote development
        echo "🐚 Configuring shell for remote development..."
        
        # Add useful environment variables for remote development
        cat >> "$HOME/.profile" << 'EOF'
# Remote development environment
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS='-R'

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"
EOF
        
        # Set up zellij workspace if config exists
        if command -v zellij >/dev/null 2>&1; then
            echo "🗂️  Setting up zellij workspace..."
            # You can add zellij layout setup here
        fi
        ;;
esac

echo "✅ Environment setup complete!"