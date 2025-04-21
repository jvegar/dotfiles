# Start timing
start_time=$(date +%s%N)

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

# OS-specific configurations
case "$OSTYPE" in
  darwin*)
    # macOS specific configurations
    export PATH="/usr/local/bin:$PATH"
    # VS Code for macOS
    alias code="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
    # Obsidian path for macOS
    obsidian_base="$HOME/Documents/Obsidian/AI Queries"
    ;;
  linux-gnu*)
    # Linux/WSL specific configurations
    export CONTAINERS_LOGDRIVER=k8s-file
    alias docker=podman
    alias docker-compose=podman-compose
    alias code="'/mnt/c/Users/jvega/AppData/Local/Programs/Microsoft VS Code/bin/code'"
    # Obsidian path for Linux
    obsidian_base="/mnt/d/repos/learning/obsidian/obsidian-vault-jevr/AI Queries"
    # Linux-specific copy/paste
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
    ;;
esac

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Texlive configuration
export PATH=/usr/local/texlive/2023/bin/x86_64-linux:$PATH

# Lazy load nvm
export NVM_DIR="$HOME/.nvm"
nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}

# Lazy load pyenv
pyenv() {
    unset -f pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(command pyenv init --path)"
    eval "$(command pyenv init -)"
    pyenv "$@"
}

# Lazy load gvm
gvm() {
    unset -f gvm
    [[ -s "/home/jvegar/.gvm/scripts/gvm" ]] && source "/home/jvegar/.gvm/scripts/gvm"
    gvm "$@"
}

# Lazy load sdkman
sdk() {
    unset -f sdk
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk "$@"
}

# Tool configurations and PATH exports
export DOTNET_ROOT=/usr/share/dotnet
export PATH=$PATH:/usr/share/dotnet:$HOME/.dotnet/tools

# Maven configuration
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -d '/usr/local/opt/maven' ]; then
        export M2_HOME='/usr/local/opt/maven'
        export PATH="$M2_HOME/bin:$PATH"
    fi
else
    if [ -d '/opt/apache-maven-3.9.9' ]; then
        M2_HOME='/opt/apache-maven-3.9.9'
        PATH="$M2_HOME/bin:$PATH"
        export PATH
    fi
fi

# Go Version Manager
[[ -s "/home/jvegar/.gvm/scripts/gvm" ]] && source "/home/jvegar/.gvm/scripts/gvm"

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
              local output_path=\"\$obsidian_base/\${date_stamp}-\${title}.md\"

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

# Copy & Paste alias
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'


# bun completions
[ -s "/home/jvegar/.bun/_bun" ] && source "/home/jvegar/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bum
export BUM_INSTALL="$HOME/.bum"
export PATH="$BUM_INSTALL/bin:$PATH"

# Set Trae IDE configuration
export PATH="/mnt/c/Users/jvega/AppData/Local/Programs/Trae/bin:$PATH"

# Set fabric AI alias
alias yai="/home/jvegar/repos/projects/sh-scripts/yai.sh"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# neovim configuration
export PATH="$PATH:/opt/nvim/"

# pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# End timing and calculate duration
end_time=$(date +%s%N)
duration=$(( (end_time - start_time) / 1000000 )) # Convert nanoseconds to milliseconds
echo "Load time: ${duration} ms"


