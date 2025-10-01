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
zinit wait lucid for \
  atinit"zicompinit; zicdreplay" \
  zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions \
  zdharma-continuum/history-search-multi-word

# Additional syntax highlighting and completions
zinit wait lucid for \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-completions

# Git plugin from Oh-My-Zsh
zinit snippet OMZL::async_prompt.zsh
zinit wait lucid for \
  OMZL::git.zsh \
  OMZP::git

# Load Fast node version manager (fnm) for Node.js management
zinit wait lucid for \
  atload='noglob eval "$(fnm env --use-on-cd)"' \
  zdharma-continuum/null

# Load pyenv for Python version management
zinit lucid as'command' pick'bin/pyenv' \
  atclone'./libexec/pyenv init - > zpyenv.zsh' \
  atpull"%atclone" src"zpyenv.zsh" nocompile'!' for \
  pyenv/pyenv

# fzf configuration
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

# bun configuration
zinit wait lucid for \
  atload='[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"' \
  zdharma-continuum/null

# sdkman configuration
zinit wait lucid for \
  atload='[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' \
  zdharma-continuum/null

# cargo configuration
zinit wait lucid for \
  atload='[[ -s "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"' \
  zdharma-continuum/null

# zoxide configuration for smart cd
zinit wait lucid for \
  atload='eval "$(zoxide init zsh)"' \
  zdharma-continuum/null

# tmuxifier configuration
zinit wait lucid for \
  atload='eval "$(tmuxifier init -)"' \
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

# Configure Powerlevel10k
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_BATTERY_SHOW=false
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time background_jobs)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zinit ice depth"1" atinit'[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh'
zinit light romkatv/powerlevel10k

# Load all custom scripts from ~/.config/zsh/scripts
for script in ~/scripts/zsh/*.sh; do
  # Lazy-load each script with zinit
  zinit ice wait"1" silent
  zinit snippet "$script"
done

# Zsh history setup
HISTSIZE=100000
HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt append_history
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward


