# Dotfiles

This repository contains my personal dotfiles and configuration files for various tools and applications.

## Contents

- `.config/` - Configuration files for various applications
  - `nvim/` - Neovim configuration files
  - `tmux/` - Tmux configuration
  - `wezterm/` - WezTerm terminal emulator configuration
- `scripts/` - Utility scripts for various tasks
- `.zshrc` - Zsh shell configuration
- `.zshenv` - Zsh environment variables

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
   cd ~/dotfiles
   ```

3. Use Stow to create the symlinks:

   ```bash
   # Stow all configurations
   stow .

   # Or stow specific configurations
   stow nvim
   stow tmux
   stow wezterm
   ```

To unlink configurations, use:

```bash
stow -D .
```

## Structure

### Shell Configuration

The root directory contains shell configuration files:

- `.zshrc` - Main Zsh configuration file
- `.zshenv` - Environment variables and path settings

### Application Configurations

The `.config/` directory contains configurations for various applications:

#### Neovim Configuration

- Custom keybindings
- Plugin configurations
- Color schemes
- LSP settings

#### Tmux Configuration

- Session management
- Key bindings
- Status bar customization

#### WezTerm Configuration

- Terminal emulator settings
- Color schemes
- Key bindings

### Utility Scripts

The `scripts/` directory contains various utility scripts for system management and automation.

## Requirements

- macOS (tested on macOS 24.5.0)
- zsh shell
- Neovim
- Tmux
- WezTerm

## Contributing

Feel free to fork this repository and customize it to your needs. If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is open source and available under the MIT License.
