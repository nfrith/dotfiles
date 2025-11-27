# Dotfiles Architecture TODO

## Bugs

### 1. Logic error in `install-host.sh:27-29`
```bash
# Current (broken):
if [[ -d "$HOME/.local/bin" ]]; then  # checks if EXISTS
    mkdir -p "$HOME/.local/bin"        # then creates it (no-op)
fi

# Should be:
if [[ ! -d "$HOME/.local/bin" ]]; then
    mkdir -p "$HOME/.local/bin"
fi
```

### 2. PATH duplication on repeated runs
**File:** `install-host.sh:35-38`

The check happens against runtime `$PATH`, but appends unconditionally to files. Running `install-host.sh` multiple times adds duplicate PATH entries.

```bash
# Current:
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# Should check if line exists in file:
if ! grep -q 'export PATH="\$HOME/.local/bin:\$PATH"' "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi
```

### 3. Hardcoded x86_64 architecture
**File:** `install-remote.sh:30`

ARM64 containers (Apple Silicon DevPods, AWS Graviton) will get wrong binary.

```bash
# Current:
curl -L ".../zellij-x86_64-unknown-linux-musl.tar.gz"

# Should detect architecture:
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  ZELLIJ_ARCH="x86_64-unknown-linux-musl" ;;
    aarch64|arm64) ZELLIJ_ARCH="aarch64-unknown-linux-musl" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac
curl -L ".../zellij-${ZELLIJ_ARCH}.tar.gz"
```

---

## Design Issues

### 4. SSH detection is overly aggressive
**File:** `scripts/detect-environment.sh:25-28`

SSH'ing into your own Mac triggers remote configs instead of host configs. This conflates "remote access method" with "environment type."

**Options:**
- Add explicit override: `DOTFILES_ENV=host` environment variable
- Create `~/.dotfiles-env` file that takes precedence
- Only use SSH detection as a fallback, not primary signal

### 5. Duplicate Zellij installation paths
- `scripts/install-tools.sh` may install Zellij
- `install-remote.sh:26-33` also installs Zellij

Consolidate to single location to avoid version conflicts.

### 6. Hardcoded Zellij version
**File:** `install-remote.sh:29`

```bash
ZELLIJ_VERSION="v0.39.2"  # Will become stale
```

**Options:**
- Fetch latest from GitHub API
- Pin version in a central `versions.sh` config file
- Use package manager where available

### 7. bootstrap.sh bypasses install.sh router
```
bootstrap.sh → install-host.sh (direct call)
install.sh   → detect-environment → install-host.sh OR install-remote.sh
```

Two entry points to `install-host.sh`. Changes to routing logic in `install.sh` don't affect bootstrap path. Consider having `bootstrap.sh` call `install.sh` instead.

### 8. Scripts copied instead of symlinked
**File:** `install-host.sh:32`

```bash
cp bin/* "$HOME/.local/bin/"
```

Scripts can drift from repo. Updates require re-running installer. Symlinks would make changes immediate.

---

## Missing Capabilities

| Feature | Description | Priority |
|---------|-------------|----------|
| **Idempotency** | Multiple runs cause duplicates, side effects | High |
| **Dry-run mode** | Preview changes before applying (`--dry-run`) | Medium |
| **Versioning** | Track which dotfiles version is installed | Medium |
| **Rollback** | Failed install leaves partial state, no cleanup | Medium |
| **Uninstall** | No way to cleanly remove dotfiles | Low |
| **Selective install** | All-or-nothing; can't skip Homebrew, tools, etc. | Low |
| **Environment override** | Force host/remote regardless of detection | High |

---

## Recommendations

### High Priority

- [ ] Fix `mkdir` logic bug in `install-host.sh`
- [ ] Fix PATH duplication issue
- [ ] Add architecture detection for binary downloads
- [ ] Add `DOTFILES_ENV` override for environment detection

### Medium Priority

- [ ] Review `config/shared/aliases/.aliases` for optimal developer/AI workflow
  - Note to future self: "workflow" = the daily flow you move through (terminal, git, navigation, tools)
  - Consider: which aliases enhance vs break AI tooling (e.g., `cat='bat'` breaks heredocs when bat missing)
  - Consider: which aliases are actually used vs cruft
- [ ] Consolidate Zellij installation to single location
- [ ] Extract tool versions to central config file
- [ ] Add `--dry-run` flag to install scripts
- [ ] Symlink `bin/` scripts instead of copying
- [ ] Have `bootstrap.sh` call `install.sh` instead of `install-host.sh` directly

### Low Priority

- [ ] Add version tracking (write version to `~/.dotfiles-version`)
- [ ] Add `uninstall.sh` script
- [ ] Add selective installation flags (`--no-brew`, `--no-tools`, etc.)
- [ ] Add rollback/cleanup on failure

---

## Architecture Tradeoffs (Reference)

| Aspect | Pro | Con |
|--------|-----|-----|
| Environment detection | Automatic, zero-config | False positives (SSH, CI on macOS) |
| bootstrap.sh one-liner | Great UX for fresh machines | Hardcoded repo URL, not forkable |
| Shared/host/remote split | Clean separation, DRY | 3 places to look for any config |
| Scripts copy to ~/.local/bin | Works offline after install | Scripts drift from repo |
| `set -e` everywhere | Fails fast on errors | No partial rollback |
| Homebrew as gatekeeper | Handles Xcode CLT auto | 5-15 min blocking, heavy dep |
