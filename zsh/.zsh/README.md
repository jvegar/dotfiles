# Modular ZSH Configuration

This directory contains modular ZSH configuration files optimized for performance, maintainability, and security.

## Structure

- `.zshrc` - Main loader file (sources all modules)
- `.zshenv` - Environment variables and PATH settings
- `aliases.zsh` - Shell aliases (categorized)
- `completion.zsh` - ZSH completion settings
- `functions.zsh` - Helper functions and utilities
- `history.zsh` - History configuration
- `keybindings.zsh` - Keybindings configuration
- `options.zsh` - ZSH options and settings
- `plugins.zsh` - Plugin configurations (Zinit)
- `scripts.zsh` - Custom script loading (lazy loading)
- `secrets.zsh` - Secure secrets loading
- `theme.zsh` - Powerlevel10k theme configuration
- `scripts/` - Utility scripts
  - `bw-list-secrets.sh` - Bitwarden secrets listing
  - `compare-zsh-performance.sh` - Compare Zsh startup performance
  - `load-fabric-patterns.sh` - Load Fabric AI patterns
  - `obsidian-git-backup.sh` - Obsidian vault git backup
  - `obsidian-new-note.sh` - Create new Obsidian notes
  - `obsidian-open-vault.sh` - Open Obsidian vault
  - `rename.sh` - Batch file renaming
  - `shloader.sh` - Terminal loading spinner (shloader)
  - `test-zsh-config.sh` - Zsh config validation
  - `tmux-killserver.sh` - Kill tmux server
  - `tmuxifier_cp_session.sh` - Copy tmuxifier session layouts
  - `toggle_tmux_popup.sh` - Toggle tmux popup windows
  - `yai.sh` - YAI (Yet Another Intelligence) integration
  - `zsh-benchmark.sh` - Zsh startup benchmark
- `os/` - OS-specific configurations
  - `darwin.zsh` - macOS specific settings
  - `linux.zsh` - Linux specific settings
  - `wsl.zsh` - WSL (Windows Subsystem for Linux) settings

## Optimization Features

1. **Modular Architecture**: Configurations split by concern for easier maintenance
2. **Async Plugin Loading**: Zinit turbo mode with staggered wait times
3. **Lazy Loading**: Custom scripts load on first use, not at startup
4. **Conditional Tool Initialization**: Tools only initialized if present in PATH
5. **Secure Secrets**: Permission validation and masking for sensitive data
6. **Performance Profiling**: ZPROF support for startup time analysis
7. **Cross-Platform**: OS detection and appropriate configurations

## Usage

### Performance Profiling

Enable detailed startup profiling:

```bash
ZPROF=1 zsh
# After shell loads, run:
zprof | head -20
```

### Benchmarking

Run the benchmark script to measure startup time:

```bash
~/.zsh/scripts/zsh-benchmark.sh
```

### Adding New Configurations

1. **Aliases**: Add to `aliases.zsh` (categorize appropriately)
2. **Functions**: Add to `functions.zsh`
3. **OS-specific**: Add to `os/darwin.zsh` or `os/linux.zsh`
4. **Plugins**: Add to `plugins.zsh` with appropriate wait time
5. **Scripts**: Place in `~/.zsh/scripts/` and update `scripts.zsh`

### Security

- Secrets are loaded from `~/.secrets` with permission validation (must be 600)
- Sensitive environment variables are masked in shell display
- Consider migrating API keys to password manager or keychain

## Performance Tips

1. Use `wait"2"` or higher for non-essential plugins
2. Implement lazy loading for heavy scripts/tools
3. Regularly audit plugins and remove unused ones
4. Use `ZPROF=1` to identify slow-loading components

## Cross-Platform Compatibility

The configuration automatically detects:
- macOS (`darwin`)
- Linux (`linux`)
- WSL (`wsl` via detection in `/proc/version`)

OS-specific configurations are loaded from the `os/` directory.

## Rollback

If issues occur after the modular configuration update, you can revert:

### Option 1: Restow with Stow
```bash
cd ~/dotfiles
stow -D zsh   # Unlink zsh
stow zsh      # Relink
```

### Option 2: Restore from git
```bash
cd ~/dotfiles
git checkout -- zsh/
stow -R zsh
```

### Option 3: Manual reversion
1. Remove symlinks: `stow -D zsh`
2. Copy the modular configs manually if needed
3. Edit `.zshrc` to revert to a previous non-modular version

### Backup locations
- `~/.zshrc.old` - Backup of original `.zshrc` (if created during setup)
- `~/.zsh.old` - Backup of original `.zsh` directory (if created during setup)
- The dotfiles git repository contains the full history of all changes

### Troubleshooting
- If shell fails to start, use `zsh -f` to start without loading configs, then fix
- Check symlinks with `ls -la ~/.zsh ~/.zshrc ~/.zshenv`
- Verify file permissions on secrets file: `chmod 600 ~/.secrets`

### Known Issues

1. **`zsh -i -c` warnings**: When using `zsh -i -c 'command'`, you may see warnings about `setopt: can't change option: monitor`. This is because job control (monitor option) cannot be enabled in shells created with the `-c` flag. These warnings are harmless and do not affect normal interactive shell usage.

2. **Gitstatus initialization**: Gitstatus may fail to initialize in some environments (WSL, certain Linux setups). This has been disabled by default (`POWERLEVEL10K_DISABLE_GITSTATUS=true`) to suppress errors. Git information in the prompt will use a slower fallback method. To re-enable gitstatus, remove this setting from `theme.zsh` and ensure your system meets gitstatus requirements.

3. **Non-interactive testing**: The configuration exits early for non-interactive shells (performance optimization). Test scripts that source `.zshrc` directly may not see aliases or functions. Use `zsh -i -c 'command'` for testing (despite the monitor warning) or run tests within an interactive shell.

4. **Performance profiling**: When `ZPROF=1` is set, startup time increases significantly due to profiling overhead. Use only for debugging, not for normal shell operation.