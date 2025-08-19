# CRUSH.md - Dotfiles Configuration

## Build & Setup Commands

### Initial Setup
```bash
# Install dependencies (Ubuntu/Debian)
sudo apt update && sudo apt install -y git curl wget build-essential

# Install dependencies (macOS)
brew install git curl wget

# Clone and setup dotfiles
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles
./scripts/shloader.sh
```

### Tmux Management
```bash
# Start tmux with custom config
tmux source-file ~/.config/tmux/tmux.conf

# Install tmux plugins (after first setup)
~/.config/tmux/plugins/tpm/bin/install_plugins

# Reload tmux configuration
tmux source-file ~/.config/tmux/tmux.conf
```

### Neovim Setup
```bash
# Install neovim dependencies
# Ubuntu/Debian:
sudo apt install -y neovim python3-pip nodejs npm

# macOS:
brew install neovim node npm

# Install neovim package manager (lazy.nvim)
git clone --depth 1 https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim

# Open neovim and install plugins
nvim
# Run :Lazy sync in neovim
```

### Shell Configuration
```bash
# Reload zsh configuration
source ~/.zshrc

# Reload environment variables
source ~/.zshenv
```

## Development Workflow

### Common Commands
```bash
# Edit dotfiles
cd ~/.dotfiles
nvim .

# Test tmux configuration
tmux new-session -d -s test && tmux source-file ~/.config/tmux/tmux.conf

# Check shell configuration
zsh -x ~/.zshrc 2>&1 | grep -v "^+" | head -20
```

### Git Operations
```bash
# Add new dotfile
git add <file>
git commit -m "Add <description> configuration"
git push

# Update submodules
git submodule update --init --recursive
```

## Code Style Preferences

### Shell Scripts
- Use 2-space indentation
- Use `#!/usr/bin/env bash` shebang
- Quote variables: `"$variable"`
- Use `[[ ]]` for conditionals
- Prefer `local` variables in functions

### Configuration Files
- Use consistent indentation (2 spaces for JSON/YAML)
- Add comments for complex configurations
- Group related settings together
- Use descriptive variable names

### Tmux Configuration
- Use descriptive session names
- Prefer vim key bindings
- Enable mouse support
- Use gruvbox/tokyo-night themes

## Directory Structure

```
~/.dotfiles/
├── .config/
│   ├── nvim/          # Neovim configuration
│   ├── tmux/          # Tmux configuration
│   ├── wezterm/       # Wezterm terminal config
│   └── ...
├── scripts/           # Utility scripts
├── archive/           # Archived files
└── README.md
```

## Troubleshooting

### Common Issues
1. **Tmux plugins not loading**: Run `~/.config/tmux/plugins/tpm/bin/install_plugins`
2. **Neovim plugins not loading**: Run `:Lazy sync` in neovim
3. **Shell config not loading**: Check file permissions and source order
4. **Colors not displaying**: Ensure terminal supports 256 colors

### Debug Commands
```bash
# Check tmux version
tmux -V

# Check neovim version
nvim --version

# Check shell
echo $SHELL
which zsh

# Check terminal colors
echo $TERM
tput colors
```

## Environment Variables

### Required
- `$EDITOR`: Set to `nvim`
- `$SHELL`: Set to `/usr/bin/zsh` or `/bin/zsh`

### Optional
- `$TMUX_PLUGIN_MANAGER_PATH`: Set to `~/.config/tmux/plugins`
- `$XDG_CONFIG_HOME`: Set to `~/.config`

## Notes
- This is a personal dotfiles repository
- Test changes in a separate tmux session before applying globally
- Keep sensitive data in .env files (gitignored)
- Use symbolic links for configuration files when possible