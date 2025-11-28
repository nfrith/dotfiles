# CLAUDE.md - Dotfiles Guide

macOS host configuration with integrated Hyper key system (Karabiner + Aerospace + Zellij).

## Quick Start

```bash
# Fresh macOS (zero dependencies)
curl -fsSL https://raw.githubusercontent.com/nfrith/dotfiles/main/bootstrap.sh | bash

# Or manual install
git clone https://github.com/nfrith/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install-host.sh
```

## Repository Structure

```
dotfiles/
├── bootstrap.sh           # Zero-dependency macOS installer
├── install-host.sh        # Main installer
├── Brewfile               # Homebrew packages
├── bin/
│   └── dev-env-status     # Environment health checker
├── config/host/
│   ├── aerospace/         # Tiling window manager
│   ├── aliases/           # Shell aliases and functions
│   ├── ghostty/           # Terminal emulator
│   ├── git/               # Git configuration
│   ├── karabiner/         # Keyboard customization (Hyper key)
│   ├── lazygit/           # Git TUI
│   ├── shell/             # Zsh configuration
│   ├── starship/          # Shell prompt
│   ├── wezterm.lua        # Terminal emulator (alt)
│   ├── yazi/              # File manager
│   └── zellij/            # Terminal multiplexer
└── scripts/
    ├── brew-setup.sh      # Homebrew installation
    └── link-configs.sh    # Symlink configs to ~
```

## What Gets Installed

| Category | Tools |
|----------|-------|
| Terminal | Ghostty, Wezterm, Zellij, Starship |
| Development | Neovim, Git, gh, Lazygit, fzf, ripgrep, fd |
| Window Management | Aerospace (tiling WM) |
| Keyboard | Karabiner (Hyper key = Caps Lock) |
| Files | Yazi (TUI file manager), Zoxide |
| Apps | Bitwarden, Discord, OBS, OrbStack |

## Hyper Key System

Caps Lock becomes a "Hyper key" (Ctrl+Opt+Cmd) via Karabiner, enabling unified keybindings across:
- **Aerospace**: Window/workspace navigation (`Hyper+HJKL`, `Hyper+1-9`)
- **Zellij**: Pane/tab management (`Hyper+Shift+...`)
- **Apps**: Context-aware shortcuts

See [HYPER-CHEATSHEET.md](HYPER-CHEATSHEET.md) for full keybinding reference.

## Customization

```bash
# Add Homebrew packages
# Edit Brewfile, then:
brew bundle install

# Modify configs
# Edit files in config/host/, then:
./scripts/link-configs.sh

# Check environment
dev-env-status
```

## Post-Install

```bash
# Set git identity
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Restart terminal or:
source ~/.zshrc
```

## Known Issues

See [TODO.md](TODO.md) for bugs and planned improvements.
