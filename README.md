# Dotfiles

This repository contains my personal dotfiles and configuration files for various tools and applications.

## Contents

Each directory is a [GNU Stow](https://www.gnu.org/software/stow/) package that symlinks its contents into `$HOME`:

- `zsh/` - Shell configuration
  - `.zshrc` - Main Zsh configuration (modular, fast startup)
  - `.zshenv` - Environment variables and PATH settings
  - `.zsh/` - Modular configs (aliases, plugins, theme, scripts, etc.)
- `nvim/` - Neovim configuration (`.config/nvim/`)
- `tmux/` - Tmux configuration (`.config/tmux/`)
  - `tmux.conf` - Tmux keybindings and settings
  - Tmuxifier session layouts are git-tracked; other plugins are excluded
- `wezterm/` - WezTerm terminal emulator (`.config/wezterm/`)
- `git/` - Global git configuration (`.config/git/`)
- `eza/` - Eza file lister theme (`.config/eza/`)
- `claude/` - Claude Code settings (`.claude/`)
- `opencode/` - Opencode AI configuration (`.config/opencode/`)
- `.secrets.sample` - Template for secrets file

## Installation

This repository uses [GNU Stow](https://www.gnu.org/software/stow/) to manage dotfiles. Stow creates symlinks from the repository files to their appropriate locations in your home directory.

1. First, install GNU Stow:

   ```bash
   # On macOS using Homebrew
   brew install stow
   ```

2. Clone this repository to your home directory:

   ```bash
   git clone https://github.com/jvegar/dotfiles.git ~/dotfiles

   # Note: tmux plugins are git-ignored by default.
   # Install them after stowing with `prefix + I` in tmux (TPM).
   # Tmuxifier session layouts in tmux/.config/tmux/plugins/tmuxifier/layouts/
   # are tracked and can be committed directly.
   cd ~/dotfiles
   ```

3. Use Stow to create the symlinks:

   ```bash
   # Stow all configurations
   stow .

   # Or stow specific packages
   stow zsh
   stow nvim
   stow tmux
   stow wezterm
   stow git
   stow eza
   stow claude
   stow opencode
   ```

To unlink configurations, use:

```bash
stow -D .
```

## Structure

### How Stow works

Each top-level directory (`zsh/`, `nvim/`, etc.) is a **stow package**. Running `stow zsh` creates symlinks in `$HOME` that mirror the directory's internal structure. For example:

- `zsh/.zshrc` → `~/.zshrc`
- `zsh/.zsh/aliases.zsh` → `~/.zsh/aliases.zsh`
- `nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`

### Shell Configuration (`zsh/`)

Modular Zsh config designed for fast startup and cross-platform use:

- `.zshrc` - Main loader (sources all modules, Zinit turbo mode)
- `.zshenv` - Environment variables and PATH for all shells
- `.zsh/aliases.zsh` - Categorized shell aliases
- `.zsh/functions.zsh` - Helper functions
- `.zsh/plugins.zsh` - Zinit plugin definitions with async loading
- `.zsh/theme.zsh` - Powerlevel10k prompt configuration
- `.zsh/secrets.zsh` - Secure secrets loading with permission checks
- `.zsh/scripts/` - Utility scripts (lazy-loaded on first use)
- `.zsh/os/` - Platform-specific configs (`darwin.zsh`, `linux.zsh`, `wsl.zsh`)

### Neovim Configuration (`nvim/`)

Lua-based Neovim config using lazy.nvim:

- LSP, DAP, Treesitter, and formatter configurations
- Custom keybindings and autocmds
- Plugin configs: telescope, harpoon, neo-tree, copilot, avante, obsidian, and more

### Tmux Configuration (`tmux/`)

- Tmux keybindings, status bar (gruvbox theme), and vim-tmux-navigator
- [Tmuxifier](https://github.com/jimeh/tmuxifier) session layouts tracked in git (plugins excluded via `.gitignore`)
- Plugins managed by TPM and installed at runtime

### Other Configurations

- **git/** - Global `.gitignore` rules
- **eza/** - Eza theme symlinked from a separate theme repo
- **claude/** - Claude Code settings (`settings.local.json`)
- **opencode/** - Opencode provider configuration
- **wezterm/** - WezTerm terminal emulator with Nerd Fonts and color schemes

### Utility Scripts

Scripts in `zsh/.zsh/scripts/` are lazy-loaded on first use. Includes helpers for:
- Tmux session management and popup toggles
- Obsidian vault operations
- Zsh benchmark and performance testing
- Tmuxifier session copying
- Fabric pattern loading

## Requirements

- Cross-platform: macOS, Linux, and WSL (Windows Subsystem for Linux)
- zsh shell (with [Zinit](https://github.com/zdharma-continuum/zinit) plugin manager)
- Neovim (with [lazy.nvim](https://github.com/folke/lazy.nvim))
- Tmux (with [TPM](https://github.com/tmux-plugins/tpm) and [Tmuxifier](https://github.com/jimeh/tmuxifier))
- WezTerm or any Nerd Font-compatible terminal
- [GNU Stow](https://www.gnu.org/software/stow/)

## Contributing

Feel free to fork this repository and customize it to your needs. If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is open source and available under the MIT License.
