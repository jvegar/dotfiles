#!/usr/bin/env zsh
#
# Modern Zsh Configuration
# Optimized for fast startup, cross-platform compatibility, and developer productivity
#
# Key Features:
# - Zinit plugin manager with turbo mode for fast loading
# - Comprehensive error handling for optional tools
# - Cross-platform support (macOS, Linux, WSL)
# - Modern shell features (enhanced history, completion, globbing)
# - Powerlevel10k prompt with Nerd Fonts
#
# Author: Generated with improvements
# Version: 2.0

# Exit early if not running interactively
case "$-" in
  *i*) ;; # Interactive shell, continue loading
  *) return ;; # Non-interactive shell, exit early
esac

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
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi

zinit module zinit-zsh

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

# Load Fast node version manager (fnm) for Node.js management
zinit wait lucid for \
  atload='if command -v fnm >/dev/null 2>&1; then noglob eval "$(fnm env --use-on-cd)"; fi' \
  zdharma-continuum/null

# Load pyenv for Python version management
zinit lucid as'command' pick'bin/pyenv' \
  atclone'./libexec/pyenv init - > zpyenv.zsh' \
  atpull"%atclone" src"zpyenv.zsh" nocompile'!' for \
  pyenv/pyenv

# fzf configuration (download binary)
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

# load fzf completion + keybindings
zinit snippet OMZP::fzf

# bun configuration (with existence check)
zinit wait lucid for \
  atload='if [[ -s "$HOME/.bun/_bun" ]]; then source "$HOME/.bun/_bun"; fi' \
  zdharma-continuum/null

# sdkman configuration (with existence check)
zinit wait lucid for \
  atload='if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then source "$HOME/.sdkman/bin/sdkman-init.sh"; fi' \
  zdharma-continuum/null

# cargo configuration (with existence check)
zinit wait lucid for \
  atload='if [[ -s "$HOME/.cargo/env" ]]; then . "$HOME/.cargo/env"; fi' \
  zdharma-continuum/null

# zoxide configuration for smart cd (with existence check)
zinit wait lucid for \
  atload='if command -v zoxide >/dev/null 2>&1; then eval "$(zoxide init zsh)"; fi' \
  zdharma-continuum/null

# tmuxifier configuration (with existence check)
zinit wait lucid for \
  atload='if command -v tmuxifier >/dev/null 2>&1; then eval "$(tmuxifier init -)"; fi' \
  zdharma-continuum/null

# Aliases
alias ls="eza --icons=always --color-scale"
alias ll="ls -lh"
alias md="mkdir"
alias yai="$HOME/repos/projects/dotfiles/scripts/yai.sh"
alias tm="tmux"
alias tma="tmux attach-session"
alias tmat="tmux attach-session -t"
alias tml="tmux list-sessions"
alias tmn="tmux new-session"
alias tmns="tmux new -s"
alias tms="tmux new-session -s"

# Tmuxifier aliases
alias tf="tmuxifier"
alias tfl="tmuxifier list"
alias tfs="tmuxifier start"
alias tfc="tmuxifier create"
alias tfe="tmuxifier edit"
alias tfd="tmuxifier delete"
alias tfload="tmuxifier load-session"
alias tfedit="tmuxifier edit-session"

# Docker aliases
alias d='docker'
alias dc='docker compose'
alias dcl='docker compose logs -f'
alias dcb='docker compose build'
alias dcd='docker compose down'
alias dcu='docker compose up -d'
alias dcul='docker compose up -d && docker compose logs -f'
alias dex='docker exec -it'
alias di='docker images'
alias dl='docker logs -f'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias drm='docker rm'
alias drmi='docker rmi'
alias drmf='docker rm -f'
alias dst='docker stats'
alias dstp='docker system prune -af'
alias dvol='docker volume ls'
alias dvolp='docker volume prune -f'

# OS-specific aliases
case "$OSTYPE" in
  darwin*)
    ###################################
    ## macOS specific configurations ##
    ###################################
    # VS Code for macOS
    alias code="'/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'"
    ;;
  linux-gnu*)
    #######################################
    ## Linux/WSL specific configurations ##
    #######################################

    # Podman configuration
    alias podman=podman-remote-static-linux_amd64
    alias docker=podman
    alias docker-compose=podman-compose

    # VS Code for Linux WSL
    alias code="'/mnt/c/Program Files/Microsoft VS Code/bin/code'"

    # Linux-specific copy/paste
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
    ;;
esac

# Configure Powerlevel10k (Nerd Fonts mode)
POWERLEVEL10K_PROMPT_ON_NEWLINE=true
POWERLEVEL10K_MODE='nerdfont-complete'
POWERLEVEL10K_BATTERY_SHOW=false
POWERLEVEL10K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL10K_RIGHT_PROMPT_ELEMENTS=(status time background_jobs)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zinit ice depth"1" atinit'[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh'
zinit light romkatv/powerlevel10k

# Load all custom scripts from ~/scripts/zsh/ if directory exists
if [[ -d "$HOME/scripts/zsh" ]]; then
  for script in "$HOME/scripts/zsh/"*.sh; do
    # Lazy-load each script with zinit (only if file exists and is readable)
    if [[ -r "$script" ]]; then
      zinit ice wait"1" silent
      zinit snippet "$script"
    fi
  done
fi

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

# Improve tab completion behavior
# setopt always_to_bottom        # Move cursor to bottom on completion (not available in all zsh versions)
setopt complete_in_word       # Complete in the middle of word
setopt magic_equal_subst        # Enable =value expansion

# Better globbing and pattern handling
setopt brace_ccl              # Expand brace ranges (e.g., {1..5})
setopt extended_glob          # Enable extended glob patterns (^, ~, #, etc.)

# Improve directory navigation
setopt auto_pushd             # Auto add directories to pushd
setopt pushd_ignore_dups    # Don't push duplicates
setopt pushd_silent            # Don't print directory on pushd/popd
# setopt pushd_to_first       # 'pushd dir' goes to second dir if no arg (not available in all zsh versions)

# Safety and compatibility options
setopt no_beep                 # Disable all beeps
setopt no_hist_beep           # Don't beep on history expansion
setopt no_list_beep           # Don't beep on ambiguous completion
# setopt no_mobile            # Optimize for desktop environments (not available in all zsh versions)

# Enable term colors and true color support
if [[ -r ~/.zsh_colors.zsh ]]; then
  source ~/.zsh_colors.zsh 2>/dev/null || true
fi

# Initialize fzf if available (improves fuzzy finding)
if command -v fzf >/dev/null 2>&1; then
  # Source fzf key bindings and fuzzy completion
  [[ $- == *i ]] && source <(fzf --bash 2>/dev/null) 2>/dev/null || true
  # Initialize fzf config if exists
  [[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh" 2>/dev/null || true
fi

# Performance optimization: reduce path check frequency
# These can speed up shell responsiveness
zstyle -t zsh_reactive auto >/dev/null 2>&1 && zstyle ':zsh_reactive:cmd' max-window 200

# Keybindings for better navigation
bindkey "^[[A" history-search-backward  # Up arrow - search history
bindkey "^[[B" history-search-forward       # Down arrow - search forward
bindkey "^R" history-incremental-search-backward  # Ctrl+R - reverse search
bindkey "^S" history-incremental-search-forward      # Ctrl+S - forward search

# Additional completion options
zstyle ':completion:*' preserve-prefix '//$(hostname)'
zstyle ':completion:*' use-cache on                    # Enable completion cache
zstyle ':completion:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
zstyle ':completion:*' detailed'yes'


