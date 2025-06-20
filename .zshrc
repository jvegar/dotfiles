# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
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
# Load Powerlevel10k theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Core zsh functionality (history, completion, etc.)
#zinit snippet OMZL::history.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::key-bindings.zsh

# Essential plugins with async loading (turbo mode)
zinit wait lucid for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  zdharma-continuum/history-search-multi-word

# Git plugin fomr Oh-My-Zsh - loaded when entering a git repository
zinit ice wait lucid
zinit snippet OMZP::git

# Load Fast node version manager (fnm) for Node.js management
zinit wait lucid for \
  atinit="eval \"$(fnm env --use-on-cd)\"" \
  zdharma-continuum/null

# fzf configuration
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

# gvm configuration
zinit wait lucid for \
  atload='[[ -s "$GVM_DIR/scripts/gvm" ]] && source "$GVM_DIR/scripts/gvm"' \
  zdharma-continuum/null

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
  atload='. "$HOME/.cargo/env"' \
  zdharma-continuum/null

# Source aliases from a separate file for better organization
[[ -f "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"

# Configure Powerlevel10k
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_BATTERY_SHOW=false
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time background_jobs)

# To customize prompt, run `p10k configure` or edit ~/.p1k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Alias OS-specific configurations
case "$OSTYPE" in
  darwin*)
    ###################################
    ## macOS specific configurations ##
    ###################################
    # VS Code for macOS
    alias code="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
    ;;
  linux-gnu*)
    #######################################
    ## Linux/WSL specific configurations ##
    #######################################

    # Podman configuration
    alias docker=podman
    alias docker-compose=podman-compose

    # VS Code for Linux WSL
    alias code="'/mnt/c/Users/jvega/AppData/Local/Programs/Microsoft VS Code/bin/code'"

    # Linux-specific copy/paste
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
   ;;
esac

# Fabric aliases configuration
if [ -d "$HOME/.config/fabric/patterns" ]; then
  for pattern_file in $HOME/.config/fabric/patterns/*; do
    if [ -d "$pattern_file" ]; then
      pattern_name=$(basename "$pattern_file")
      unalias "$pattern_name" 2>/dev/null

      eval "
      $pattern_name() {
        local title=\$1
        local date_stamp=\$(date +'%Y-%m-%d')
        local output_path=\"\${obsidian_base}/AI\ Queries/\${date_stamp}-\${title}.md\"

        if [ -n \"\$title\" ]; then
          fabric --pattern \"$pattern_name\" -o \"\$output_path\"
        else
          fabric --pattern \"$pattern_name\" --stream
        fi
      }
    "
    fi
  done
fi

yt() {
	if [ -z "$1" ]; then
    echo "Usage: yt <video_link>"
    return 1
  fi
  local video_link="$1"
  fabric -y "$video_link" --transcript
}

# Custom Fabric alias "yai"
if [[ -f "$HOME/repos/projects/sh-scripts/yai.sh" ]]; then
  alias yai="$HOME/repos/projects/sh-scripts/yai.sh"
fi

# Zsh history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

