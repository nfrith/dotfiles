# Remote/DevPod zsh configuration

# Locale configuration - fix fzf perl warnings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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

# Fix backspace/delete key bindings for DevPod/Docker environments
bindkey "^H" backward-delete-char  # Backspace (Ctrl+H)
bindkey "^?" backward-delete-char  # Backspace (DEL)
bindkey "^[[3~" delete-char        # Delete key

# Ensure proper terminal settings for containers
# Force a compatible TERM for containers
if [[ "$TERM" == "xterm-ghostty" || -z "$TERM" ]]; then
    export TERM="xterm-256color"
fi

# Set backspace character (escape the special character)
stty erase '^?'

# Load shared configurations
[[ -f ~/.gitconfig-shared ]] && git config --global include.path ~/.gitconfig-shared
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions ]] && source ~/.functions
[[ -f ~/.profile ]] && source ~/.profile

# Starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
else
    # Fallback prompt for remote environments
    PROMPT='%F{cyan}%n@%m%f:%F{blue}%~%f%# '
fi

# FZF setup (if available)
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
    
    # FZF configuration
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    
    # FZF theme (Catppuccin Mocha)
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796'
fi

# Zellij integration
if command -v zellij >/dev/null 2>&1; then
    # Auto-start zellij on initial DevPod connection
    # Only start if: not already in zellij, not nested shell (SHLVL=1), and not in tmux
    if [[ -z "$ZELLIJ" && -z "$ZELLIJ_SESSION_NAME" && "$SHLVL" -eq 1 && -z "$TMUX" ]]; then
        # Check if there are existing sessions
        if zellij list-sessions 2>/dev/null | grep -q .; then
            # Attach to the first available session
            exec zellij attach
        else
            # Start a new session
            exec zellij
        fi
    fi
    
    # Zellij aliases
    alias zj='zellij'
    alias zja='zellij attach'
    alias zjl='zellij list-sessions'
    alias zjk='zellij kill-session'
    alias zjn='zellij -s'
fi

# Git configuration for remote development
git config --global user.name "nfrith" 2>/dev/null || true
git config --global user.email "your-email@example.com" 2>/dev/null || true

# Development shortcuts
alias dev='cd ~/workspace || cd ~/projects || cd ~'

# Environment variables
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS='-R'

# Remote environment indicator
export DEVELOPMENT_REMOTE=true
export DEVPOD_ENVIRONMENT=true

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# XDG Config Home for consistent config paths (especially for lazygit)
export XDG_CONFIG_HOME="$HOME/.config"

# Auto-completion
autoload -Uz compinit
compinit

# Better completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Welcome message for remote environment
echo "🚀 Remote development environment ready!"
if command -v zellij >/dev/null 2>&1; then
    echo "💡 Run 'zellij' to start your terminal multiplexer"
fi