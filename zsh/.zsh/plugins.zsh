#!/usr/bin/env zsh
# ZSH Plugin Configuration
# Optimized for fast startup with async loading and lazy initialization

# Core zsh functionality (history, completion, etc.)

# Essential plugins with async loading (turbo mode)
# Note: Fast syntax highlighting first, then autosuggestions, then completions
zinit wait lucid for \
	atinit"zicompinit; zicdreplay" \
	zdharma-continuum/fast-syntax-highlighting \
	atload"_zsh_autosuggest_start" \
	zsh-users/zsh-autosuggestions \
	zdharma-continuum/history-search-multi-word \
	zsh-users/zsh-completions

# Git plugin from Oh-My-Zsh (async loading with prompt support)
zinit wait lucid for \
	OMZL::git.zsh \
	OMZP::git

# fzf configuration (download binary) - Important but can wait
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

# load fzf completion + keybindings (async)
zinit wait"1" lucid for \
	OMZP::fzf

# Tool-specific configurations (lazy-loaded or conditional)
# These use helper functions from functions.zsh for cleaner initialization

# bun configuration (with existence check)
zinit wait"2" lucid for \
	atload='source_if_exists "$HOME/.bun/_bun"' \
	zdharma-continuum/null

# cargo configuration (with existence check)
zinit wait"2" lucid for \
	atload='source_if_exists "$HOME/.cargo/env"' \
	zdharma-continuum/null

# tmuxifier configuration (with existence check)
zinit wait"2" lucid for \
	atload='init_tool_if_exists tmuxifier "$(tmuxifier init -)"' \
	zdharma-continuum/null


# zoxide init configuration
zinit ice wait"0" lucid atload'
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zoxide.zsh"
  if [[ ! -s "$cache" || $(command -v zoxide) -nt "$cache" ]]; then
    mkdir -p "${cache:h}"
    zoxide init zsh > "$cache"
  fi
  source "$cache"
'
zinit light zdharma-continuum/null

# mise activate configuration
zinit ice wait"0" lucid atload'
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/mise.zsh"
  if [[ ! -s "$cache" || $(command -v mise) -nt "$cache" ]]; then
    mkdir -p "${cache:h}"
    mise activate zsh > "$cache"
  fi
  source "$cache"
'
zinit light zdharma-continuum/null
