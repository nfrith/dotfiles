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

---

## Design Issues

### 3. Scripts copied instead of symlinked
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

---

## Recommendations

### High Priority

- [ ] Fix `mkdir` logic bug in `install-host.sh`
- [ ] Fix PATH duplication issue

### Medium Priority

- [ ] Review `config/host/aliases/.aliases` for optimal developer/AI workflow
  - Note to future self: "workflow" = the daily flow you move through (terminal, git, navigation, tools)
  - Consider: which aliases enhance vs break AI tooling (e.g., `cat='bat'` breaks heredocs when bat missing)
  - Consider: which aliases are actually used vs cruft
  - Consider: ask Opus in extended thinking mode to analyze and draft optimal solutions
  - Consider: use mixed sampling prompt technology for diverse solution exploration
- [ ] Add `--dry-run` flag to install scripts
- [ ] Symlink `bin/` scripts instead of copying

### Low Priority

- [ ] Add version tracking (write version to `~/.dotfiles-version`)
- [ ] Add `uninstall.sh` script
- [ ] Add selective installation flags (`--no-brew`, `--no-tools`, etc.)
- [ ] Add rollback/cleanup on failure

---

## Final Step

- [ ] **Test full installation** - Run complete install-host.sh on clean environment after all TODOs are addressed

---

## Architecture Tradeoffs (Reference)

| Aspect | Pro | Con |
|--------|-----|-----|
| bootstrap.sh one-liner | Great UX for fresh machines | Hardcoded repo URL, not forkable |
| Scripts copy to ~/.local/bin | Works offline after install | Scripts drift from repo |
| `set -e` everywhere | Fails fast on errors | No partial rollback |
| Homebrew as gatekeeper | Handles Xcode CLT auto | 5-15 min blocking, heavy dep |
