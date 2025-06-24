###############################
## ZSHENV CONFIGURATION FILE ##
###############################
# This file is sourced for all zsh sessions, including login and non-login shells.
# It is a good place to set environment variables and PATH modifications.

case "{$OSTYPE:-$(uname -s)" in
  [Dd]arwin*)
    # Homebrew custom installs
    export PATH="/usr/local/bin:$PATH"
    # Obsidian path for macOS
    export OBSIDIAN_BASE="$HOME/repos/learning/obsidian/obsidian-vault-jevr"
    # Go configuration
    export GOROOT="$(brew --prefix go)/libexec"
    # Texlive configuration
    export PATH="/usr/local/texlive/2024/bin/universal-darwin:$PATH"
    # Maven configuration
    if [ -d '/usr/local/opt/maven' ]; then
        export M2_HOME='/usr/local/opt/maven'
        export PATH="$M2_HOME/bin:$PATH"
    fi
    ;; 
  [Ll]inux-gnu*)
    # Podman configuration
    export CONTAINERS_LOGDRIVER=k8s-file
    # Obsidian path for Linux/WSL
    export OBSIDIAN_BASE="/mnt/d/repos/learning/obsidian/obsidian-vault-jevr/AI Queries"
    # Texlive configuration
    export PATH="/usr/local/texlive/2023/bin/x86_64-linux:$PATH"
    # Trae IDE configuration
    export PATH="/mnt/c/Users/jvega/AppData/Local/Programs/Trae/bin:$PATH"
    # Maven configuration
    if [ -d '/opt/apache-maven-3.9.9' ]; then
      M2_HOME='/opt/apache-maven-3.9.9'
      PATH="$M2_HOME/bin:$PATH"
      export PATH
    fi 
    # Dotnet tools configuration
    export DOTNET_ROOT=/usr/share/dotnet
    export PATH=$PATH:/usr/share/dotnet:$HOME/.dotnet/tools
    ;;
esac

# tmux configuration
export TMUX_CONF="$HOME/.config/tmux/tmux.conf"

# fnm configuration
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
fi

# Golang configuration
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH

# pyenv cofiguration
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# gvm configuration
export GVM_DIR="$HOME/.gvm"

# bun configuration
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun version manager configuration
export BUM_INSTALL="$HOME/.bum"
export PATH="$BUM_INSTALL/bin:$PATH"

# neovim configuration
export PATH="$PATH:/opt/nvim/"

# cargo configuration
export PATH="$HOME/.cargo/bin:$PATH"

# pnpm configuration
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
