# Host zsh configuration

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# Zsh options
setopt AUTO_CD
setopt CORRECT
setopt COMPLETE_ALIASES

# Initialize completion system
autoload -Uz compinit && compinit

# Homebrew setup (macOS)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Zsh plugins (if installed via Homebrew)
if command -v brew >/dev/null 2>&1; then
    # Auto-suggestions
    if [[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
        source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    fi
    
    # Syntax highlighting
    if [[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
        source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    fi
fi

# Starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# Load shared configurations
[[ -f ~/.gitconfig-shared ]] && git config --global include.path ~/.gitconfig-shared
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions ]] && source ~/.functions

# FZF setup
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
    
    # FZF configuration
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    
    # FZF theme
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796'
fi

# Zoxide setup (interactive shells only - non-interactive shells like Claude Code don't support hooks)
if [[ -o interactive ]] && command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# DevPod shortcuts
if command -v devpod >/dev/null 2>&1; then
    alias dp='devpod'
    alias dpu='devpod up'
    alias dpl='devpod list'
    alias dps='devpod ssh'
    alias dpd='devpod delete'
fi

# Environment variables
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS='-R'

# API keys via 1Password (cached for fast startup)
# TODO: Fix path during dotfiles merge - op-cache.sh needs to be in PATH or use proper dotfiles path variable
export ANTHROPIC_API_KEY=$(op-cache.sh anthropic-api-key "op://2501-workstation/zsh/anthropic-api-key" 2>/dev/null || op read "op://2501-workstation/zsh/anthropic-api-key" 2>/dev/null)

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Ghost worktree scripts
export PATH="$HOME/worktrees/main/scripts/worktree:$PATH"

# Host-specific environment variables (customize per host)
export PATH="$HOME/Library/Python/3.9/bin:$PATH"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# PHP paths
export PATH="/opt/homebrew/opt/php@8.1/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.1/sbin:$PATH"

# .NET tools
export PATH="$PATH:$HOME/.dotnet/tools"

# Go
export PATH="$HOME/go/bin:$PATH"

# XDG Config Home for consistent config paths (especially for lazygit)
export XDG_CONFIG_HOME="$HOME/.config"

# Host-specific customizations
export DEVELOPMENT_HOST=true
# pnpm
export PNPM_HOME="/Users/0xnfrith/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
