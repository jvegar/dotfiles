# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up ZSH and theme
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Load plugins conditionally
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

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

# fzf configuration
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
  
  # Use fd instead of fzf
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

  _fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
  }

  _fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
  }
fi
