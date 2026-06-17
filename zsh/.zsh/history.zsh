#!/usr/bin/env zsh
# ZSH History Configuration

# Zsh history setup
HISTSIZE=100000
HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# Enhanced history settings for better behavior
setopt append_history          # Append to history instead of overwriting
setopt share_history             # Share history between sessions
setopt hist_ignore_space        # Don't save commands starting with space
setopt hist_ignore_all_dups    # Ignore all duplicate commands
setopt hist_save_no_dups         # Don't save duplicates
setopt hist_ignore_dups        # Ignore duplicates
setopt hist_verify             # Show command before sourcing from history
setopt extended_history       # Save timestamp and duration
setopt hist_expire_dups_first  # Remove duplicates when saving