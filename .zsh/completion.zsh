#!/usr/bin/env zsh
# ZSH Completion Configuration

# Additional completion options
zstyle ':completion:*' preserve-prefix '//$(hostname)'
zstyle ':completion:*' use-cache on                    # Enable completion cache
zstyle ':completion:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
zstyle ':completion:*' detailed'yes'