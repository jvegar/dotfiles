# Modular ZSH Configuration

This directory contains modular ZSH configuration files optimized for performance, maintainability, and security.

## Structure

- `.zshrc` - Main loader file (sources all modules)
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
- `os/` - OS-specific configurations
  - `darwin.zsh` - macOS specific settings
  - `linux.zsh` - Linux/WSL specific settings

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
~/repos/projects/dotfiles/scripts/zsh-benchmark.sh
```

### Adding New Configurations

1. **Aliases**: Add to `aliases.zsh` (categorize appropriately)
2. **Functions**: Add to `functions.zsh`
3. **OS-specific**: Add to `os/darwin.zsh` or `os/linux.zsh`
4. **Plugins**: Add to `plugins.zsh` with appropriate wait time
5. **Scripts**: Place in `~/scripts/zsh/` and update `scripts.zsh`

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

If issues occur after the modular configuration update, you can revert to the previous state:

### Option 1: Restore from backups
1. Restore the original `.zshrc`:
   ```bash
   cp ~/.zshrc.old ~/.zshrc
   ```
2. Remove the symlink and restore the original `.zsh` directory:
   ```bash
   rm ~/.zsh
   mv ~/.zsh.old ~/.zsh
   ```
3. If you have a backup of `.zshenv`, restore it similarly.

### Option 2: Re-run GNU Stow
If using stow for dotfile management, you can restow the configurations:
```bash
cd ~/repos/projects/dotfiles
stow -D .  # Unlink all
stow .     # Restow
```

### Option 3: Manual reversion
1. Remove the `.zsh` symlink: `rm ~/.zsh`
2. Copy the modular configs from the dotfiles repository manually if needed.
3. Edit `.zshrc` to revert to the previous non-modular version.

### Backup locations
- `~/.zshrc.old` - Backup of original `.zshrc`
- `~/.zsh.old` - Backup of original `.zsh` directory (if created)
- The dotfiles repository contains timestamped backups of previous configurations.

### Troubleshooting
- If shell fails to start, use `zsh -f` to start without loading configs, then fix.
- Check symlinks with `ls -la ~/.zsh`.
- Verify file permissions on secrets file: `chmod 600 ~/.secrets`