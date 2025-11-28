# Dotfiles

macOS host configuration with Hyper key system (Karabiner + Aerospace + Zellij).

## Quick Start

### Fresh macOS (Zero Dependencies)
```bash
curl -fsSL https://raw.githubusercontent.com/nfrith/dotfiles/main/bootstrap.sh | bash
```
*One command - handles Xcode CLT, Homebrew, and all setup automatically.*

### Manual Install
```bash
git clone https://github.com/nfrith/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install-host.sh
```

## What's Included

```
dotfiles/
├── bootstrap.sh           # Zero-dependency installer
├── install-host.sh        # Main installer
├── Brewfile               # Homebrew packages
├── config/host/           # All configurations
│   ├── aerospace/         # Tiling window manager
│   ├── aliases/           # Shell aliases & functions
│   ├── ghostty/           # Terminal emulator
│   ├── git/               # Git config
│   ├── karabiner/         # Keyboard (Hyper key)
│   ├── lazygit/           # Git TUI
│   ├── shell/             # Zsh config
│   ├── starship/          # Prompt
│   ├── wezterm.lua        # Alt terminal
│   ├── yazi/              # File manager
│   └── zellij/            # Terminal multiplexer
├── bin/                   # Custom scripts
└── scripts/               # Install utilities
```

## Hyper Key System

Caps Lock = Hyper key (Ctrl+Opt+Cmd). See [HYPER-CHEATSHEET.md](HYPER-CHEATSHEET.md) for bindings.

| Keys | Action |
|------|--------|
| `Hyper+HJKL` | Focus window (Aerospace) |
| `Hyper+1-9` | Switch workspace |
| `Hyper+Shift+HJKL` | Focus pane (Zellij) |
| `Hyper+Enter` | Open Ghostty |

## Post-Install

```bash
# Set git identity
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Restart terminal or:
source ~/.zshrc
```

## Customization

```bash
# Add packages: edit Brewfile, then
brew bundle install

# Update configs: edit config/host/*, then
./scripts/link-configs.sh

# Check status
dev-env-status
```

## Troubleshooting

```bash
# Permission errors
chmod +x ~/.dotfiles/install-host.sh

# Path not updated
source ~/.zshrc

# Check environment
dev-env-status
```

## Requirements

- macOS 10.15+
- Internet connection
- Admin access (for Homebrew)

## More Info

- [CLAUDE.md](CLAUDE.md) - Detailed documentation
- [TODO.md](TODO.md) - Known issues
- [HYPER-CHEATSHEET.md](HYPER-CHEATSHEET.md) - Keybindings

## License

MIT
