# CLAUDE.md - Dotfiles Setup Guide

## Repository Structure

```
dotfiles/
├── README.md                    # User documentation
├── CLAUDE.md                   # This file - Claude setup guide
├── bootstrap.sh               # Zero-dependency installer for fresh macOS
├── Brewfile                    # macOS package definitions
├── install.sh                 # Main entry point (DevPod auto-detects)
├── install-host.sh            # Host machine setup
├── install-remote.sh          # Remote/DevPod setup
├── bin/                       # Custom executable scripts
│   ├── devpod-connect         # Quick DevPod workspace connection
│   ├── dev-env-status         # Environment health checker
│   ├── setup-remote-session   # Initialize remote development session
│   └── sync-dotfiles          # Update dotfiles in current environment
├── config/
│   ├── host/                  # Host-specific configurations
│   │   ├── git/
│   │   │   └── .gitconfig     # Host git settings
│   │   ├── shell/
│   │   │   └── .zshrc         # Host zsh configuration
│   │   └── wezterm/
│   │       └── wezterm.lua    # Terminal emulator config
│   ├── remote/                # Remote/DevPod configurations
│   │   ├── neovim/
│   │   │   └── init.lua       # Basic neovim setup
│   │   ├── shell/
│   │   │   └── .zshrc         # Remote zsh configuration
│   │   └── zellij/
│   │       └── config.kdl     # Terminal multiplexer config
│   └── shared/                # Shared configurations
│       ├── aliases/
│       │   ├── .aliases       # Common shell aliases
│       │   └── .functions     # Utility functions
│       ├── git/
│       │   ├── .gitconfig-shared  # Shared git settings
│       │   └── .gitignore_global  # Global gitignore
│       └── ssh/
│           └── config         # SSH configuration
└── scripts/                   # Installation utilities
    ├── brew-setup.sh          # Homebrew installation and management
    ├── detect-environment.sh  # Environment detection logic
    ├── install-tools.sh       # Tool installation for remote environments
    ├── link-configs.sh        # Configuration file linking
    └── setup-environment.sh   # Environment-specific setup
```

## Development Flow Overview

This dotfiles setup enables the following development workflow:

**Host Machine** → **DevPod** → **Remote Environment**

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│  Host Machine   │    │     DevPod       │    │  Remote Environment │
│                 │    │                  │    │                     │
│ • Wezterm       │───▶│ • Auto-provision │───▶│ • Zellij sessions   │
│ • Zsh + Starship│    │ • Dotfiles setup │    │ • Development tools │
│ • DevPod CLI    │    │ • SSH access     │    │ • Optimized shell   │
└─────────────────┘    └──────────────────┘    └─────────────────────┘
```

**Flow Details:**
1. **Host**: Use Zsh with Starship prompt in Wezterm terminal
2. **DevPod**: SSH into provisioned development containers with dotfiles pre-installed
3. **Remote**: Run Zellij for terminal multiplexing and session management

## Setup Instructions

### Scenario A: Fresh macOS Setup (Recommended)

**Purpose**: Set up a fresh macOS machine with zero manual dependencies.

**Prerequisites:**
- macOS 10.15+
- Internet connection
- Admin privileges

**Installation (One Command):**
```bash
curl -fsSL https://raw.githubusercontent.com/nfrith/dotfiles/main/bootstrap.sh | bash
```

**What the bootstrap does:**
1. **Automatically installs Xcode Command Line Tools** via Homebrew
2. **Installs Homebrew** and adds it to PATH
3. **Installs Git** via Homebrew
4. **Clones dotfiles repository** to ~/.dotfiles
5. **Runs host installation** automatically

**Time savings:** Eliminates manual Xcode CLT installation and git setup steps.

### Scenario B: Host Machine Setup (Manual)

**Purpose**: Configure your local macOS machine when you already have git installed.

**Prerequisites:**
- macOS 10.15+
- Git already installed
- Admin privileges for Homebrew installation

**Installation:**
```bash
# Clone the repository
git clone https://github.com/nfrith/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run host installation
./install-host.sh
```

**What this installs:**
- **Homebrew** and packages from Brewfile (wezterm, devpod, zellij, etc.)
- **Wezterm** terminal configuration optimized for DevPod workflow
- **Zsh** with Starship prompt, syntax highlighting, and autosuggestions
- **Git** configuration for host development
- **Custom scripts** in `~/.local/bin` for workflow automation
- **Shell aliases** and functions for productivity

**Post-installation:**
1. Restart your terminal or run `source ~/.zshrc`
2. Configure git user details:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```
3. Test DevPod: `devpod provider add docker`

### Scenario C: Remote Machine Setup

**Purpose**: Configure a remote environment (DevPod workspace, SSH server, container).

**Prerequisites:**
- Linux environment with sudo access
- Git installed
- Internet connectivity

**Manual Installation:**
```bash
# Clone the repository
git clone https://github.com/nfrith/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run remote installation
./install-remote.sh
```

**DevPod Automatic Installation:**
```bash
# DevPod will automatically detect and run install.sh
devpod up <workspace> --dotfiles https://github.com/nfrith/dotfiles
```

**What this installs:**
- **Development tools** (neovim, git, fzf, ripgrep, bat, fd, yazi, zoxide)
- **Node.js** and **Claude Code** for AI-assisted development
- **Zellij** terminal multiplexer for session management
- **Zsh** configuration optimized for remote development
- **Git** configuration for development workflow
- **Shell environment** with aliases and development shortcuts

**Post-installation:**
1. Run `setup-remote-session` to initialize your development environment
2. Start zellij: `zellij` or use the auto-start in zsh config
3. Configure git user details if needed
4. Use `claude-code` for AI-assisted development in your terminal

## Key Scripts and Usage

### Custom Commands (Available after installation)

**`devpod-connect <workspace>`** - Quick DevPod connection:
```bash
devpod-connect my-project                    # Connect with VS Code
devpod-connect github.com/user/repo         # Connect to repo
devpod-connect my-project --ide goland       # Use JetBrains IDE
devpod-connect my-project --reset            # Reset workspace
```

**`setup-remote-session`** - Initialize remote environment:
```bash
setup-remote-session  # Creates directories, starts zellij
```

**`sync-dotfiles`** - Update dotfiles:
```bash
sync-dotfiles          # Pull and apply updates
sync-dotfiles --force  # Force complete reinstall
```

**`dev-env-status`** - Health check:
```bash
dev-env-status  # Check tools, configs, environment
```

## Configuration Management

### Environment Detection
The system automatically detects your environment:
- **Host**: Local machine (macOS/Linux)
- **Remote**: DevPod, containers, SSH connections

### Configuration Layering
1. **Shared**: Common settings used everywhere (`config/shared/`)
2. **Environment-specific**: Host or remote overrides (`config/host/`, `config/remote/`)
3. **Automatic linking**: Appropriate configs are symlinked based on environment

### Customization
- **Host tools**: Edit `Brewfile` and run `brew bundle install`
- **Remote tools**: Edit `scripts/install-tools.sh`
- **Configurations**: Modify files in appropriate `config/` subdirectories
- **Re-apply**: Run `./scripts/link-configs.sh [host|remote]`

## Workflow Commands

### Common Development Tasks

**Start development session:**
```bash
# On host - connect to DevPod workspace
devpod-connect my-project

# In remote - start terminal multiplexer
zellij
```

**Environment management:**
```bash
# Check environment health
dev-env-status

# Update dotfiles across environments  
sync-dotfiles

# AI-assisted development with Claude Code
claude-code    # Start Claude Code CLI

# Quick git operations (aliases available)
gs        # git status
ga .      # git add .
gc "msg"  # git commit -m "msg"
```

**Zellij session management (in remote):**
```bash
zj        # Start zellij
zja dev   # Attach to 'dev' session
zjl       # List sessions
```

## Troubleshooting

### Bootstrap Issues

**Homebrew installation fails:**
```bash
# Check macOS version compatibility
sw_vers

# Try manual Homebrew installation
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then run manual host setup
git clone https://github.com/nfrith/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install-host.sh
```

**Network connectivity problems:**
```bash
# Test internet connection
curl -I https://github.com

# Try with different DNS
sudo dscacheutil -flushcache

# Use manual installation as fallback
```

**Xcode CLT installation hangs:**
```bash
# Cancel and try manual installation
xcode-select --install

# Then run bootstrap again - it will skip completed steps
curl -fsSL https://raw.githubusercontent.com/nfrith/dotfiles/main/bootstrap.sh | bash
```

### Permission Issues
```bash
chmod +x ~/.dotfiles/install.sh
chmod +x ~/.dotfiles/bootstrap.sh
chmod +x ~/.dotfiles/scripts/*.sh
chmod +x ~/.dotfiles/bin/*
```

### DevPod Connection Problems
```bash
# Check providers
devpod provider list

# Add Docker provider
devpod provider add docker

# Test connection
devpod-connect --help
```

### Environment Detection Issues
```bash
# Manually run environment-specific installer
./install-host.sh    # For host
./install-remote.sh  # For remote
```

### Path Not Updated
```bash
# Reload shell configuration
source ~/.zshrc      # or ~/.bashrc

# Check PATH
echo $PATH | grep -o '[^:]*' | grep local
```

## Testing Commands

```bash
# Test environment detection
./scripts/detect-environment.sh

# Test configuration linking
./scripts/link-configs.sh host    # or remote

# Test tool installation (remote)
./scripts/install-tools.sh

# Check overall status
dev-env-status
```