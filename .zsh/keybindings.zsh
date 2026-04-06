#!/usr/bin/env zsh
# ZSH Keybindings Configuration

# Keybindings for better navigation
bindkey "^[[A" history-search-backward  # Up arrow - search history
bindkey "^[[B" history-search-forward       # Down arrow - search forward
bindkey "^R" history-incremental-search-backward  # Ctrl+R - reverse search
bindkey "^S" history-incremental-search-forward      # Ctrl+S - forward search