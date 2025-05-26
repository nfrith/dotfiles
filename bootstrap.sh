#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Repository configuration
DOTFILES_REPO="https://github.com/nfrith/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}⚠️  Warning:${NC} $1"
}

error() {
    echo -e "${RED}❌ Error:${NC} $1" >&2
}

success() {
    echo -e "${GREEN}✅${NC} $1"
}

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        error "This bootstrap script is designed for macOS only."
        error "For other systems, please use the manual installation method:"
        error "  git clone $DOTFILES_REPO $DOTFILES_DIR"
        error "  cd $DOTFILES_DIR && ./install.sh"
        exit 1
    fi
}

# Check internet connectivity
check_connectivity() {
    log "Checking internet connectivity..."
    if ! curl -s --head --max-time 5 https://github.com > /dev/null; then
        error "No internet connection detected."
        error "Please check your network connection and try again."
        exit 1
    fi
    success "Internet connectivity confirmed"
}

# Install Homebrew (which handles Xcode CLT automatically)
install_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        success "Homebrew is already installed"
        return 0
    fi

    log "Installing Homebrew..."
    warn "This will install Xcode Command Line Tools if they're not already installed."
    warn "This process may take 5-15 minutes depending on your internet connection."
    
    echo -n "Do you want to continue? (y/N): "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        error "Installation cancelled by user"
        exit 1
    fi

    log "Downloading and installing Homebrew (this may prompt for sudo password)..."
    if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        error "Failed to install Homebrew"
        error "Please visit https://brew.sh for manual installation instructions"
        exit 1
    fi

    # Add Homebrew to PATH for current session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        # Apple Silicon
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    elif [[ -f "/usr/local/bin/brew" ]]; then
        # Intel
        eval "$(/usr/local/bin/brew shellenv)"
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    else
        error "Homebrew installation completed but brew command not found"
        error "Please restart your terminal and run this script again"
        exit 1
    fi

    success "Homebrew installed successfully"
}

# Install Git via Homebrew
install_git() {
    if command -v git >/dev/null 2>&1; then
        success "Git is already installed"
        return 0
    fi

    log "Installing Git via Homebrew..."
    if ! brew install git; then
        error "Failed to install Git"
        error "Please try running: brew install git"
        exit 1
    fi

    success "Git installed successfully"
}

# Backup existing dotfiles if they exist
backup_existing_dotfiles() {
    if [[ -d "$DOTFILES_DIR" ]]; then
        local backup_dir="${DOTFILES_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
        warn "Existing dotfiles directory found at $DOTFILES_DIR"
        log "Creating backup at $backup_dir"
        
        if ! mv "$DOTFILES_DIR" "$backup_dir"; then
            error "Failed to backup existing dotfiles"
            exit 1
        fi
        
        success "Existing dotfiles backed up to $backup_dir"
    fi
}

# Clone dotfiles repository
clone_dotfiles() {
    log "Cloning dotfiles repository..."
    
    if ! git clone "$DOTFILES_REPO" "$DOTFILES_DIR"; then
        error "Failed to clone dotfiles repository"
        error "Please check your internet connection and try again"
        exit 1
    fi

    success "Dotfiles repository cloned to $DOTFILES_DIR"
}

# Run the host installation
run_installation() {
    log "Running dotfiles installation..."
    
    cd "$DOTFILES_DIR" || {
        error "Failed to change to dotfiles directory"
        exit 1
    }

    if [[ ! -f "./install-host.sh" ]]; then
        error "install-host.sh not found in dotfiles directory"
        exit 1
    fi

    if ! ./install-host.sh; then
        error "Dotfiles installation failed"
        error "Please check the output above for specific errors"
        exit 1
    fi

    success "Dotfiles installation completed successfully!"
}

# Main bootstrap function
main() {
    echo "🚀 macOS Dotfiles Bootstrap"
    echo "============================"
    echo ""
    log "Starting zero-dependency dotfiles installation..."
    
    # Perform all checks and installations
    check_macos
    check_connectivity
    install_homebrew
    install_git
    backup_existing_dotfiles
    clone_dotfiles
    run_installation
    
    echo ""
    echo "🎉 Bootstrap completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Restart your terminal or run: source ~/.zshrc"
    echo "2. Configure Git user details:"
    echo "   git config --global user.name \"Your Name\""
    echo "   git config --global user.email \"your.email@example.com\""
    echo ""
    echo "Your development environment is now ready! 🚀"
}

# Error handling
trap 'error "Bootstrap script interrupted. You may need to clean up partial installations."' INT TERM

# Run main function
main "$@"