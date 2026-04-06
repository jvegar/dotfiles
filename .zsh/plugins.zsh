#!/usr/bin/env zsh
# ZSH Plugin Configuration
# Optimized for fast startup with async loading and lazy initialization

# Core zsh functionality (history, completion, etc.)
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::key-bindings.zsh

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

# Load Fast node version manager (fnm) for Node.js management
zinit wait"2" lucid for \
  atload='init_tool_if_exists fnm "noglob eval \"$(fnm env --use-on-cd)\""' \
  zdharma-continuum/null

# Load pyenv for Python version management (conditional)
zinit lucid as'command' pick'bin/pyenv' \
  atclone'./libexec/pyenv init - > zpyenv.zsh' \
  atpull"%atclone" src"zpyenv.zsh" nocompile'!' for \
  pyenv/pyenv

# bun configuration (with existence check)
zinit wait"2" lucid for \
  atload='source_if_exists "$HOME/.bun/_bun"' \
  zdharma-continuum/null

# sdkman configuration (with existence check)
zinit wait"2" lucid for \
  atload='source_if_exists "$HOME/.sdkman/bin/sdkman-init.sh"' \
  zdharma-continuum/null

# cargo configuration (with existence check)
zinit wait"2" lucid for \
  atload='source_if_exists "$HOME/.cargo/env"' \
  zdharma-continuum/null

# zoxide configuration for smart cd (with existence check)
zinit wait"2" lucid for \
  atload='init_tool_if_exists zoxide "eval \"$(zoxide init zsh)\""' \
  zdharma-continuum/null

# tmuxifier configuration (with existence check)
zinit wait"2" lucid for \
  atload='init_tool_if_exists tmuxifier "eval \"$(tmuxifier init -)\""' \
  zdharma-continuum/null

# Initialize fzf if available (improves fuzzy finding)
# Note: This is a backup initialization in case fzf plugin fails
if command -v fzf >/dev/null 2>&1; then
  # Source fzf key bindings and fuzzy completion
  [[ $- == *i* ]] && source <(fzf --bash 2>/dev/null) 2>/dev/null || true
  # Initialize fzf config if exists
  source_if_exists "$HOME/.fzf.zsh"
fi