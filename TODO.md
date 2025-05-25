# TODO.md - Bootstrap Installation Enhancement

## Objective

Create a **zero-dependency bootstrap script** that allows fresh macOS installations to set up the complete development environment with a single command, without requiring users to manually install Xcode Command Line Tools or Git first.

## Current Problem

**Fresh macOS Setup Friction:**
1. User must manually install Xcode CLT: `xcode-select --install`
2. Wait 5-10 minutes for installation
3. Then clone dotfiles: `git clone ...`
4. Finally run installation: `./install-host.sh`

**Goal:** Reduce to single command: `curl -fsSL https://url/bootstrap.sh | bash`

## Design Concepts

### Core Strategy: Homebrew-First Approach
- **Homebrew installation automatically handles Xcode CLT** installation
- Leverage Homebrew's existing Xcode CLT management instead of reinventing
- Once Homebrew is installed, Git becomes available
- Then proceed with normal dotfiles workflow

### Bootstrap Flow
```
Fresh macOS → Bootstrap Script → Homebrew → Git → Dotfiles → Full Setup
```

## Implementation Plan

### 1. Create Bootstrap Script (`bootstrap.sh`)

**Location:** Repository root (`/bootstrap.sh`)

**Core Logic:**
```bash
#!/bin/bash
# Zero-dependency bootstrap for fresh macOS

# Step 1: Install Homebrew (handles Xcode CLT automatically)
if ! command -v brew >/dev/null 2>&1; then
    echo "🍺 Installing Homebrew (this will install Xcode CLT if needed)..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Step 2: Install Git via Homebrew
if ! command -v git >/dev/null 2>&1; then
    echo "📦 Installing Git..."
    brew install git
fi

# Step 3: Clone dotfiles repository
if [[ -d ~/.dotfiles ]]; then
    echo "⚠️  Backing up existing ~/.dotfiles..."
    mv ~/.dotfiles ~/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)
fi

git clone https://github.com/nfrith/dotfiles.git ~/.dotfiles

# Step 4: Run normal installation
cd ~/.dotfiles && ./install-host.sh
```

### 2. Error Handling & User Experience

**Interactive Prompts:**
- Warn user about Xcode CLT installation time
- Confirm before proceeding with potentially long operations
- Provide clear progress indicators

**Fallback Scenarios:**
- Handle existing installations gracefully
- Backup existing configurations
- Resume if script is interrupted

**Error Recovery:**
```bash
# Check prerequisites at each step
# Provide helpful error messages
# Offer manual recovery steps
```

### 3. Integration Points

**Update README.md:**
```markdown
## Quick Start (Fresh macOS)
```bash
curl -fsSL https://raw.githubusercontent.com/nfrith/dotfiles/main/bootstrap.sh | bash
```

**Update CLAUDE.md:**
- Add bootstrap section to setup instructions
- Document the zero-dependency flow
- Update troubleshooting section

### 4. File Structure Changes

```
dotfiles/
├── bootstrap.sh              # NEW: Zero-dependency installer
├── install.sh                # Existing: DevPod entry point  
├── install-host.sh           # Existing: Host setup
├── install-remote.sh         # Existing: Remote setup
└── TODO.md                   # This file
```

## Technical Details

### Why This Approach Works

**Homebrew's Xcode CLT Handling:**
- Homebrew installer detects missing Xcode CLT
- Automatically prompts user to install
- Handles macOS version compatibility
- No custom Xcode CLT logic needed

**Path Management:**
- Bootstrap script adds Homebrew to PATH
- Subsequent commands can find `brew` and `git`
- Compatible with both Intel and Apple Silicon Macs

### User Journey

**Before (Current):**
1. Fresh macOS
2. Open Terminal
3. `xcode-select --install` (manual step)
4. Wait 5-10 minutes
5. `git clone https://github.com/nfrith/dotfiles.git ~/.dotfiles`
6. `cd ~/.dotfiles && ./install-host.sh`
7. Wait for Homebrew + packages

**After (Bootstrap):**
1. Fresh macOS  
2. Open Terminal
3. `curl -fsSL https://url/bootstrap.sh | bash`
4. Wait for everything (Xcode CLT + Homebrew + packages)
5. Done

**Time Savings:** Eliminates manual steps, reduces from 6 steps to 1 command

## Implementation Tasks

### Phase 1: Core Bootstrap Script
- [ ] Create `bootstrap.sh` with Homebrew-first logic
- [ ] Add error handling and user prompts  
- [ ] Test on fresh macOS installation
- [ ] Add backup logic for existing configurations

### Phase 2: Documentation Updates
- [ ] Update README.md with bootstrap instructions
- [ ] Update CLAUDE.md setup scenarios
- [ ] Add troubleshooting section for bootstrap issues
- [ ] Document the new user journey

### Phase 3: Integration & Polish
- [ ] Test bootstrap script with various macOS versions
- [ ] Add progress indicators and better UX
- [ ] Create fallback for network issues
- [ ] Add option to skip certain steps if already installed

### Phase 4: Advanced Features (Future)
- [ ] Add `--minimal` flag for basic setup only
- [ ] Add `--dry-run` to show what would be installed
- [ ] Create uninstall script
- [ ] Add telemetry/analytics (optional)

## Testing Strategy

### Test Scenarios
1. **Fresh macOS** (primary use case)
2. **Existing Homebrew** (should detect and skip)
3. **Existing dotfiles** (should backup)
4. **Network interruption** (should resume gracefully)
5. **Permission issues** (should provide clear guidance)

### Test Environments  
- macOS Ventura (Intel)
- macOS Sonoma (Apple Silicon)
- macOS with existing development tools
- Corporate/restricted network environments

## Success Criteria

### Primary Goals
- ✅ Single command setup from fresh macOS
- ✅ No manual Xcode CLT installation required
- ✅ Maintains all existing functionality
- ✅ Graceful handling of existing installations

### Secondary Goals  
- ✅ Clear progress indicators
- ✅ Helpful error messages
- ✅ Resume capability after interruption
- ✅ Backup/restore functionality

## Risks & Mitigations

### Potential Issues
1. **Homebrew installation failure**
   - *Mitigation*: Detect and provide manual instructions
2. **Network connectivity issues**
   - *Mitigation*: Add retry logic and offline fallbacks
3. **Permission problems**
   - *Mitigation*: Clear sudo prompts and explanations
4. **Xcode CLT installation hangs**
   - *Mitigation*: Timeout handling and manual override option

### Backwards Compatibility
- Existing installation methods continue to work
- Bootstrap is additive, not replacing current approach
- Users can still use manual method if preferred

## Future Enhancements

### Potential Extensions
1. **Multi-platform support** (Linux bootstrap)
2. **Cloud-based configuration** (sync settings across machines)
3. **Team/organization templates** (company-specific setups)
4. **Integration with CI/CD** (automated environment provisioning)

## Notes

- Bootstrap script should be idempotent (safe to run multiple times)
- Consider adding logging for debugging purposes
- May want to add option to customize GitHub repository URL
- Could integrate with other dotfiles managers (stow, chezmoi) in future