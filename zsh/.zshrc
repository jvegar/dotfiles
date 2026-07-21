#!/usr/bin/env zsh
#
# Modern Zsh Configuration - Modular Version
# Optimized for fast startup, cross-platform compatibility, and developer productivity
#
# Key Features:
# - Zinit plugin manager with turbo mode for fast loading
# - Modular architecture for maintainability
# - Comprehensive error handling for optional tools
# - Cross-platform support (macOS, Linux, WSL)
# - Modern shell features (enhanced history, completion, globbing)
# - Powerlevel10k prompt with Nerd Fonts
# - Security-focused secrets loading
#
# Author: Generated with improvements
# Version: 3.0 (Modular)

# Enable profiling if ZPROF environment variable is set
[[ -n "$ZPROF" ]] && zmodload zsh/zprof

# Fix PROMPT_EOL_MARK
PROMPT_EOL_MARK=''

# Disable gitstatus to suppress initialization errors (set early for instant prompt)
export POWERLEVEL10K_DISABLE_GITSTATUS=true
export POWERLEVEL9K_DISABLE_GITSTATUS=true
export GITSTATUS_LOG_LEVEL=ERROR

# Exit early if not running interactively
case "$-" in
*i*) ;;      # Interactive shell, continue loading
*) return ;; # Non-interactive shell, exit early
esac


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.zsh
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USER}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USER}.zsh"
fi

# Load Zinit for plugin management
if [[ -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
	source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
else
	# If Zinit is not installed, install it
	print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})...%f"
	command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
	command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" &&
		print -P "%F{33} %F{34}Installation successful.%f%b" ||
		print -P "%F{160} The clone has failed.%f%b"
fi

# Compile and load high-performance binary
zinit module zinit-zsh

# Load modular configuration files
ZSH_CONFIG_DIR="${ZSH_CONFIG_DIR:-${HOME}/.zsh}"

# Load helper functions first (needed for other modules)
if [[ -f "${ZSH_CONFIG_DIR}/functions.zsh" ]]; then
	source "${ZSH_CONFIG_DIR}/functions.zsh"
fi

# Load plugin configurations
if [[ -f "${ZSH_CONFIG_DIR}/plugins.zsh" ]]; then
	source "${ZSH_CONFIG_DIR}/plugins.zsh"
fi

# Load OS-specific configuration
local os_type="${OSTYPE##*:}"
if [[ -f "${ZSH_CONFIG_DIR}/os/${os_type}.zsh" ]]; then
	source "${ZSH_CONFIG_DIR}/os/${os_type}.zsh"
elif [[ -f "${ZSH_CONFIG_DIR}/os/default.zsh" ]]; then
	source "${ZSH_CONFIG_DIR}/os/default.zsh"
fi

# Load remaining modules
if [[ -f "${ZSH_CONFIG_DIR}/aliases.zsh" ]]; then
	source "${ZSH_CONFIG_DIR}/aliases.zsh"
fi
if [[ -f "${ZSH_CONFIG_DIR}/completion.zsh" ]]; then
	source "${ZSH_CONFIG_DIR}/completion.zsh"
fi
if [[ -f "${ZSH_CONFIG_DIR}/history.zsh" ]]; then
	source "${ZSH_CONFIG_DIR}/history.zsh"
fi
if [[ -f "${ZSH_CONFIG_DIR}/options.zsh" ]]; then
	source "${ZSH_CONFIG_DIR}/options.zsh"
fi
if [[ -f "${ZSH_CONFIG_DIR}/keybindings.zsh" ]]; then
	source "${ZSH_CONFIG_DIR}/keybindings.zsh"
fi
# Load secrets securely
if [[ -f "${ZSH_CONFIG_DIR}/secrets.zsh" ]]; then
	source "${ZSH_CONFIG_DIR}/secrets.zsh"
fi
# Load custom scripts (lazy loading)
if [[ -f "${ZSH_CONFIG_DIR}/scripts.zsh" ]]; then
	source "${ZSH_CONFIG_DIR}/scripts.zsh"
fi
# Load Powerlevel10k theme (must be after aliases and options)
if [[ -f "${ZSH_CONFIG_DIR}/theme.zsh" ]]; then
	source "${ZSH_CONFIG_DIR}/theme.zsh"
fi

# Display profiling information if ZPROF is enabled
[[ -n "$ZPROF" ]] && zprof

# Add aube to PATH (interactive-only subprocess, not .zshenv)
if command -v aube >/dev/null 2>&1; then
  local _aube_path
  _aube_path="$(aube bin -g 2>/dev/null)" && PATH="$_aube_path:$PATH"
fi

# Clean exit
return 0
