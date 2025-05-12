###############################
## ZSHENV CONFIGURATION FILE ##
###############################
# This file is sourced for all zsh sessions, including login and non-login shells.
# It is a good place to set environment variables and PATH modifications.

case "$OSTYPE" in
  darwin*)
    # Homebrew custom installs
    export PATH="/usr/local/bin:$PATH"
    # Obsidian path for macOS
    export OBSIDIAN_BASE="$HOME/repos/learning/obsidian/obsidian-vault-jevr"
    # Texlive configuration
    export PATH="/usr/local/texlive/2024/bin/universal-darwin:$PATH"
    # Golang configuration
    export GOROOT=/usr/local/go
    # Maven configuration
    if [ -d '/usr/local/opt/maven' ]; then
        export M2_HOME='/usr/local/opt/maven'
        export PATH="$M2_HOME/bin:$PATH"
    fi
    ;; 
  linux-gnu*)
    # Podman configuration
    export CONTAINERS_LOGDRIVER=k8s-file
    # Obsidian path for Linux/WSL
    export OBSIDIAN_BASE="/mnt/d/repos/learning/obsidian/obsidian-vault-jevr/AI Queries"
    # Texlive configuration
    export PATH="/usr/local/texlive/2023/bin/x86_64-linux:$PATH"
    # Trae IDE configuration
    export PATH="/mnt/c/Users/jvega/AppData/Local/Programs/Trae/bin:$PATH"
    # Golang configuration
    export GOROOT=$HOME/.gvm/gos/go1.22/bin/go
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

# Golang configuration
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH

# nvm configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Lazy load pyenv
pyenv() {
  unset -f pyenv
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(command pyenv init --path)"
  eval "$(command pyenv init -)"
  pyenv "$@"
}

# gvm configuration
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# Lazy load sdkman
sdk() {
  unset -f sdk
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk "$@"
}

# bun configuration
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun version manager configuration
export BUM_INSTALL="$HOME/.bum"
export PATH="$BUM_INSTALL/bin:$PATH"

# neovim configuration
export PATH="$PATH:/opt/nvim/"

# pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
