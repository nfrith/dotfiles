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

        # Set zsh as default shell if available and not already set
        if command -v zsh >/dev/null 2>&1 && [[ "$SHELL" != *"zsh"* ]]; then
            echo "🐚 Setting zsh as default shell..."
            ZSH_PATH=$(which zsh)
            # Add zsh to /etc/shells if not present
            if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
                echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
            fi
            sudo chsh -s "$ZSH_PATH" "$(whoami)" 2>/dev/null || chsh -s "$ZSH_PATH" 2>/dev/null || true
        fi
        
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