# Dotfiles

Personal dotfiles repository supporting both host machine and remote development environments, optimized for the workflow: **Wezterm (host) → DevPod → SSH → Zellij**.

## Quick Start

### Fresh macOS (Zero Dependencies)
```bash
curl -fsSL https://raw.githubusercontent.com/nfrith/dotfiles/main/bootstrap.sh | bash
```
*One command to install everything from scratch - no manual setup required!*

### For DevPod (Automatic)
```bash
devpod up <workspace> --dotfiles https://github.com/nfrith/dotfiles
```

### For Host Machine (Manual)
```bash
git clone https://github.com/nfrith/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install-host.sh
```

### For Remote/Manual Installation
```bash
git clone https://github.com/nfrith/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install-remote.sh
```

## Repository Structure

```
dotfiles/
├── .devcontainer/               # DevContainer for developing dotfiles
├── bootstrap.sh                 # Zero-dependency installer for fresh macOS
├── install.sh                   # Main entry point (DevPod auto-detects)
├── install-host.sh              # Host machine installation  
├── install-remote.sh            # Remote/DevPod installation
├── Brewfile                     # macOS package management
├── config/
│   ├── host/                    # Host-specific configs
│   │   ├── wezterm/             # Terminal emulator config
│   │   ├── git/                 # Host git configuration
│   │   └── shell/               # Host shell configs
│   ├── remote/                  # Remote/DevPod configs
│   │   ├── zellij/              # Terminal multiplexer config
│   │   ├── neovim/              # Editor configuration
│   │   └── shell/               # Remote shell configs
│   └── shared/                  # Shared configurations
│       ├── git/                 # Shared git settings
│       ├── ssh/                 # SSH configuration
│       └── aliases/             # Shell aliases and functions
├── scripts/                     # Installation utilities
│   ├── detect-environment.sh   # Environment detection
│   ├── install-tools.sh        # Tool installation
│   ├── link-configs.sh         # Configuration linking
│   ├── setup-environment.sh    # Environment setup
│   └── brew-setup.sh           # Homebrew management
└── bin/                         # Custom executable scripts
    ├── devpod-connect          # Quick DevPod workspace connection
    ├── setup-remote-session    # Initialize remote dev session
    ├── sync-dotfiles           # Update dotfiles
    └── dev-env-status          # Environment health check
```

## Environment Detection

The installation automatically detects your environment:

- **Host**: Local macOS/Linux machine
- **Remote**: DevPod workspaces, containers, SSH connections

## Key Features

### Host Environment (macOS)
- **Homebrew** package management via `Brewfile`
- **Wezterm** terminal configuration optimized for DevPod
- **Custom scripts** for quick workspace management
- **Shell enhancements** with fzf, starship, etc.

### Remote Environment
- **Zellij** terminal multiplexer for session management  
- **Development tools** installation (neovim, git, etc.)
- **Optimized shell** configuration for remote development
- **No GUI dependencies** - terminal-focused setup

### Shared Configurations
- **Git** settings and aliases
- **SSH** configuration
- **Shell aliases** and utility functions
- **Development shortcuts**

## Custom Scripts

After installation, these scripts are available in your PATH:

### `devpod-connect <workspace>`
Quick connection to DevPod workspaces with dotfiles:
```bash
devpod-connect my-project                    # Connect with VS Code
devpod-connect my-project --ide goland       # Connect with GoLand  
devpod-connect my-project --reset            # Reset and reconnect
```

### `setup-remote-session`
Initialize remote development environment:
```bash
setup-remote-session  # Sets up directories, starts zellij
```

### `sync-dotfiles`
Update dotfiles in current environment:
```bash
sync-dotfiles          # Pull latest changes and reinstall
sync-dotfiles --force  # Force complete reinstall
```

### `dev-env-status`
Check development environment health:
```bash
dev-env-status  # Shows installed tools, configs, and status
```

## Workflow Integration

### Host → DevPod → Remote
1. **Host**: Use Wezterm with DevPod integration
2. **DevPod**: Automatic dotfiles installation  
3. **Remote**: Zellij for terminal multiplexing

### Shell Configuration
- **Host**: Enhanced with Homebrew tools, starship prompt
- **Remote**: Lightweight with zellij integration, development focus
- **Shared**: Common aliases, functions, and git settings

## Customization

### Adding Tools
- **Host**: Add to `Brewfile` and run `brew bundle install`
- **Remote**: Add to `scripts/install-tools.sh`

### Configuration Changes
- **Environment-specific**: Edit files in `config/host/` or `config/remote/`
- **Shared**: Edit files in `config/shared/`
- **Re-run**: `./scripts/link-configs.sh [host|remote]`

### Custom Scripts
Add executable scripts to `bin/` directory - they'll be automatically added to PATH.

## Git Configuration

The setup includes:
- **Shared settings**: Common git configuration and aliases
- **Host-specific**: User details for host machine
- **Remote-optimized**: Development workflow settings

Set your git user details:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Troubleshooting

### Permission Errors
```bash
chmod +x ~/.dotfiles/install.sh
```

### Path Issues
Restart terminal or run:
```bash
source ~/.zshrc  # or ~/.bashrc
```

### DevPod Issues
Check DevPod provider:
```bash
devpod provider list
devpod provider add docker  # if needed
```

### Environment Check
```bash
dev-env-status  # Comprehensive environment health check
```

## Requirements

### Fresh macOS (Bootstrap)
- macOS 10.15+
- Internet connection
- Admin access (for Homebrew/Xcode CLT installation)
- *No other dependencies - bootstrap handles everything!*

### Host (macOS Manual)
- macOS 10.15+
- Git (for cloning)
- Admin access (for Homebrew)

### Remote (Linux)
- Git
- Curl/wget
- Sudo access (for package installation)

## Contributing

See [CLAUDE.md](CLAUDE.md) for detailed development workflow and instructions.

## License

MIT License - feel free to fork and customize for your own use.
