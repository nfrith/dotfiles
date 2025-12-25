#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "🔗 Linking host configurations..."

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

# Git configurations
[[ -f "$DOTFILES_DIR/config/host/git/.gitconfig" ]] && \
    safe_link "$DOTFILES_DIR/config/host/git/.gitconfig" "$HOME/.gitconfig"

[[ -f "$DOTFILES_DIR/config/host/git/.gitconfig-shared" ]] && \
    safe_link "$DOTFILES_DIR/config/host/git/.gitconfig-shared" "$HOME/.gitconfig-shared"

[[ -f "$DOTFILES_DIR/config/host/git/.gitignore_global" ]] && \
    safe_link "$DOTFILES_DIR/config/host/git/.gitignore_global" "$HOME/.gitignore_global"

# Aliases and functions
[[ -f "$DOTFILES_DIR/config/host/aliases/.aliases" ]] && \
    safe_link "$DOTFILES_DIR/config/host/aliases/.aliases" "$HOME/.aliases"

[[ -f "$DOTFILES_DIR/config/host/aliases/.functions" ]] && \
    safe_link "$DOTFILES_DIR/config/host/aliases/.functions" "$HOME/.functions"

# Shell configs
[[ -f "$DOTFILES_DIR/config/host/shell/.zshrc" ]] && \
    safe_link "$DOTFILES_DIR/config/host/shell/.zshrc" "$HOME/.zshrc"

[[ -f "$DOTFILES_DIR/config/host/shell/.bashrc" ]] && \
    safe_link "$DOTFILES_DIR/config/host/shell/.bashrc" "$HOME/.bashrc"

# Starship prompt
if [[ -f "$DOTFILES_DIR/config/host/starship/starship.toml" ]]; then
    safe_link "$DOTFILES_DIR/config/host/starship/starship.toml" "$HOME/.config/starship.toml"
fi

# Yazi file manager
if [[ -f "$DOTFILES_DIR/config/host/yazi/yazi.toml" ]]; then
    mkdir -p "$HOME/.config/yazi"
    safe_link "$DOTFILES_DIR/config/host/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"
fi

# Wezterm terminal
if [[ -f "$DOTFILES_DIR/config/host/wezterm.lua" ]]; then
    safe_link "$DOTFILES_DIR/config/host/wezterm.lua" "$HOME/.wezterm.lua"
fi

# Ghostty terminal
if [[ -f "$DOTFILES_DIR/config/host/ghostty/config" ]]; then
    mkdir -p "$HOME/.config/ghostty"
    safe_link "$DOTFILES_DIR/config/host/ghostty/config" "$HOME/.config/ghostty/config"
fi

# Karabiner keyboard customization
if [[ -f "$DOTFILES_DIR/config/host/karabiner/karabiner.json" ]]; then
    mkdir -p "$HOME/.config/karabiner"
    safe_link "$DOTFILES_DIR/config/host/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
fi

# Aerospace tiling window manager
if [[ -f "$DOTFILES_DIR/config/host/aerospace/.aerospace.toml" ]]; then
    safe_link "$DOTFILES_DIR/config/host/aerospace/.aerospace.toml" "$HOME/.aerospace.toml"
fi

# Lazygit
if [[ -f "$DOTFILES_DIR/config/host/lazygit/config.yml" ]]; then
    mkdir -p "$HOME/.config/lazygit"
    safe_link "$DOTFILES_DIR/config/host/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
fi

# Zellij terminal multiplexer
if [[ -f "$DOTFILES_DIR/config/host/zellij/config.kdl" ]]; then
    mkdir -p "$HOME/.config/zellij"
    safe_link "$DOTFILES_DIR/config/host/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
fi

if [[ -d "$DOTFILES_DIR/config/host/zellij/layouts" ]]; then
    mkdir -p "$HOME/.config/zellij"
    safe_link "$DOTFILES_DIR/config/host/zellij/layouts" "$HOME/.config/zellij/layouts"
fi

# SSH configuration
if [[ -f "$DOTFILES_DIR/config/host/ssh/config" ]]; then
    mkdir -p "$HOME/.ssh"
    safe_link "$DOTFILES_DIR/config/host/ssh/config" "$HOME/.ssh/config"
fi

# Ghost (Claude Code context - must clone separately: gh repo clone section-9-technologies/ghost ~/HUB/repos/section-9/ghost)
GHOST_DIR="$HOME/HUB/repos/section-9/ghost"
if [[ -d "$GHOST_DIR" ]]; then
    mkdir -p "$HOME/.claude"
    safe_link "$GHOST_DIR/statusline.sh" "$HOME/.claude/statusline.sh"
else
    echo "⚠️  Ghost repo not found. Clone it for Claude Code statusline:"
    echo "   gh repo clone section-9-technologies/ghost ~/HUB/repos/section-9/ghost"
fi

echo "✅ Configuration linking complete!"
