#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENVIRONMENT="${1:-shared}"  # Default to shared if no environment specified

echo "🔗 Linking $ENVIRONMENT configurations..."

# Function to safely create symlink
safe_link() {
    local source="$1"
    local target="$2"
    
    if [[ ! -e "$source" ]]; then
        echo "⚠️  Source file doesn't exist: $source"
        return 1
    fi
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Remove existing file/symlink
    if [[ -L "$target" ]]; then
        rm "$target"
    elif [[ -f "$target" ]]; then
        mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "📦 Backed up existing file: $target"
    fi
    
    # Create symlink
    ln -sf "$source" "$target"
    echo "✅ Linked: $source -> $target"
}

# Link shared configurations first
if [[ -d "$DOTFILES_DIR/config/shared" ]]; then
    echo "🔗 Linking shared configurations..."
    
    # Git configurations
    [[ -f "$DOTFILES_DIR/config/shared/git/.gitconfig-shared" ]] && \
        safe_link "$DOTFILES_DIR/config/shared/git/.gitconfig-shared" "$HOME/.gitconfig-shared"
    
    [[ -f "$DOTFILES_DIR/config/shared/git/.gitignore_global" ]] && \
        safe_link "$DOTFILES_DIR/config/shared/git/.gitignore_global" "$HOME/.gitignore_global"
    
    # SSH config
    [[ -f "$DOTFILES_DIR/config/shared/ssh/config" ]] && \
        safe_link "$DOTFILES_DIR/config/shared/ssh/config" "$HOME/.ssh/config"
    
    # Aliases and functions
    [[ -f "$DOTFILES_DIR/config/shared/aliases/.aliases" ]] && \
        safe_link "$DOTFILES_DIR/config/shared/aliases/.aliases" "$HOME/.aliases"
    
    [[ -f "$DOTFILES_DIR/config/shared/aliases/.functions" ]] && \
        safe_link "$DOTFILES_DIR/config/shared/aliases/.functions" "$HOME/.functions"
    
    # Yazi configuration
    if [[ -f "$DOTFILES_DIR/config/shared/yazi/yazi.toml" ]]; then
        mkdir -p "$HOME/.config/yazi"
        safe_link "$DOTFILES_DIR/config/shared/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"
    fi
    
    # Neovim configuration (shared across all environments)
    if [[ -f "$DOTFILES_DIR/config/shared/nvim/init.lua" ]]; then
        mkdir -p "$HOME/.config/nvim"
        safe_link "$DOTFILES_DIR/config/shared/nvim/init.lua" "$HOME/.config/nvim/init.lua"
    fi
fi

# Link environment-specific configurations
if [[ "$ENVIRONMENT" != "shared" && -d "$DOTFILES_DIR/config/$ENVIRONMENT" ]]; then
    echo "🔗 Linking $ENVIRONMENT-specific configurations..."
    
    case "$ENVIRONMENT" in
        "host")
            # Wezterm (goes in home directory root)
            if [[ -f "$DOTFILES_DIR/config/host/wezterm.lua" ]]; then
                safe_link "$DOTFILES_DIR/config/host/wezterm.lua" "$HOME/.wezterm.lua"
            fi
            
            # Starship (goes in ~/.config/)
            if [[ -f "$DOTFILES_DIR/config/shared/starship/starship.toml" ]]; then
                mkdir -p "$HOME/.config"
                safe_link "$DOTFILES_DIR/config/shared/starship/starship.toml" "$HOME/.config/starship.toml"
            fi
            
            # Host git config
            [[ -f "$DOTFILES_DIR/config/host/git/.gitconfig" ]] && \
                safe_link "$DOTFILES_DIR/config/host/git/.gitconfig" "$HOME/.gitconfig"
            
            # Ghostty terminal config
            if [[ -f "$DOTFILES_DIR/config/host/ghostty/config" ]]; then
                mkdir -p "$HOME/.config/ghostty"
                safe_link "$DOTFILES_DIR/config/host/ghostty/config" "$HOME/.config/ghostty/config"
            fi
            
            # Lazygit
            if [[ -f "$DOTFILES_DIR/config/host/lazygit/config.yml" ]]; then
                mkdir -p "$HOME/.config/lazygit"
                safe_link "$DOTFILES_DIR/config/host/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
            fi
            
            # DevPod configuration
            if [[ -f "$DOTFILES_DIR/config/host/devpod/config.yaml" ]]; then
                mkdir -p "$HOME/.devpod"
                safe_link "$DOTFILES_DIR/config/host/devpod/config.yaml" "$HOME/.devpod/config.yaml"
            fi
            
            # Host shell configs
            [[ -f "$DOTFILES_DIR/config/host/shell/.zshrc" ]] && \
                safe_link "$DOTFILES_DIR/config/host/shell/.zshrc" "$HOME/.zshrc"
            
            [[ -f "$DOTFILES_DIR/config/host/shell/.bashrc" ]] && \
                safe_link "$DOTFILES_DIR/config/host/shell/.bashrc" "$HOME/.bashrc"
            ;;
            
        "remote")
            # Zellij
            if [[ -f "$DOTFILES_DIR/config/remote/zellij/config.kdl" ]]; then
                mkdir -p "$HOME/.config/zellij"
                safe_link "$DOTFILES_DIR/config/remote/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
            fi
            
            # Neovim
            if [[ -f "$DOTFILES_DIR/config/remote/neovim/init.lua" ]]; then
                mkdir -p "$HOME/.config/nvim"
                safe_link "$DOTFILES_DIR/config/remote/neovim/init.lua" "$HOME/.config/nvim/init.lua"
            fi
            
            # Lazygit
            if [[ -f "$DOTFILES_DIR/config/remote/lazygit/config.yml" ]]; then
                mkdir -p "$HOME/.config/lazygit"
                safe_link "$DOTFILES_DIR/config/remote/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
            fi
            
            # Remote shell configs
            [[ -f "$DOTFILES_DIR/config/remote/shell/.zshrc" ]] && \
                safe_link "$DOTFILES_DIR/config/remote/shell/.zshrc" "$HOME/.zshrc"
            
            [[ -f "$DOTFILES_DIR/config/remote/shell/.bashrc" ]] && \
                safe_link "$DOTFILES_DIR/config/remote/shell/.bashrc" "$HOME/.bashrc"
            ;;
    esac
fi

echo "✅ Configuration linking complete!"