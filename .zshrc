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

# Disable gitstatus to suppress initialization errors (set early for instant prompt)
export POWERLEVEL10K_DISABLE_GITSTATUS=true
export POWERLEVEL9K_DISABLE_GITSTATUS=true
export GITSTATUS_LOG_LEVEL=ERROR

# Fix PROMPT_EOL_MARK
PROMPT_EOL_MARK=''

# Exit early if not running interactively
case "$-" in
  *i*) ;; # Interactive shell, continue loading
  *) return ;; # Non-interactive shell, exit early
esac

# Set up safe environment for loading
emulate -L zsh

# Attempt to set monitor option (for job control) to avoid errors from plugins
setopt monitor 2>/dev/null || true

# Exit early if not a shell that supports zsh features
if [[ -z "$ZSH_VERSION" ]]; then
  echo "Error: This configuration is designed for Zsh" >&2
  return 1
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.zsh
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Zinit for plugin management
if [[ -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
else
  # If Zinit is not installed, install it
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})...%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi

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
OS_TYPE=$(get_os_type)
if [[ -f "${ZSH_CONFIG_DIR}/os/${OS_TYPE}.zsh" ]]; then
  source "${ZSH_CONFIG_DIR}/os/${OS_TYPE}.zsh"
elif [[ -f "${ZSH_CONFIG_DIR}/os/default.zsh" ]]; then
  source "${ZSH_CONFIG_DIR}/os/default.zsh"
fi

# Load aliases
if [[ -f "${ZSH_CONFIG_DIR}/aliases.zsh" ]]; then
  source "${ZSH_CONFIG_DIR}/aliases.zsh"
fi

# Load completion settings
if [[ -f "${ZSH_CONFIG_DIR}/completion.zsh" ]]; then
  source "${ZSH_CONFIG_DIR}/completion.zsh"
fi

# Load history settings
if [[ -f "${ZSH_CONFIG_DIR}/history.zsh" ]]; then
  source "${ZSH_CONFIG_DIR}/history.zsh"
fi

# Load Zsh options
if [[ -f "${ZSH_CONFIG_DIR}/options.zsh" ]]; then
  source "${ZSH_CONFIG_DIR}/options.zsh"
fi

# Load keybindings
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

# Performance optimization: reduce path check frequency
# These can speed up shell responsiveness
zstyle -t zsh_reactive auto >/dev/null 2>&1 && zstyle ':zsh_reactive:cmd' max-window 200

# Display profiling information if ZPROF is enabled
[[ -n "$ZPROF" ]] && zprof

# Initialize zoxide (must be at the end of configuration as recommended)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Clean exit
return 0