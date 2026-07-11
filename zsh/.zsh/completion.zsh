#!/usr/bin/env zsh
# ZSH Completion Configuration

# Additional completion options
zstyle ':completion:*' preserve-prefix '//$(hostname)'
zstyle ':completion:*' use-cache on # Enable completion cache
zstyle ':completion:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
zstyle ':completion:*' detailed 'yes'

# Oh-my-pi completions
zinit ice as"completion" id-as"omp-completions" has"omp" \
	atclone"omp completions zsh > _omp" \
	atpull"%atclone"
zinit light zdharma-continuum/null
