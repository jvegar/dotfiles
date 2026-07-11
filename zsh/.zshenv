###############################
## ZSHENV CONFIGURATION FILE ##
###############################
# This file is sourced for all zsh sessions, including login and non-login shells.
# It is a good place to set environment variables and PATH modifications.

case "${OSTYPE:-$(uname -s)}" in
[Dd]arwin*)
	# Homebrew custom installs
	export PATH="/usr/local/bin:$PATH"
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
	if [[ -n "$WSL_DISTRO_NAME" ]]; then
		# Podman configuration
		export CONTAINERS_LOGDRIVER=k8s-file
		export DOCKER_HOST="unix:///mnt/wsl/podman-sockets/podman-machine-default/podman-user.sock"
		# Trae IDE configuration
		export PATH="/mnt/c/Users/jvega/AppData/Local/Programs/Trae/bin:$PATH"
		# Cursor configuration
		export PATH="/mnt/c/Users/jvega/AppData/Local/Programs/cursor/resources/app/bin:$PATH"
	fi
	# Golang configuration
	export PATH=$PATH:/usr/local/go/bin
	# Texlive configuration
	export PATH="/usr/local/texlive/2023/bin/x86_64-linux:$PATH"
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

# Obsidian path
export OBSIDIAN_BASE="$HOME/repos/projects/obsidian-vault-jevr"

# tmux configuration
export TMUX_CONF="$HOME/.config/tmux/tmux.conf"

# tmuxifier configuration
export PATH="$HOME/.config/tmux/plugins/tmuxifier/bin:$PATH"

# golang configuration
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH

# gvm configuration
export GVM_DIR="$HOME/.gvm"

# neovim configuration
export PATH="$PATH:/opt/nvim/"

# set editor
export EDITOR="nvim"

# cargo configuration
export PATH="$HOME/.cargo/bin:$PATH"

# aube configuration
export PATH="$(aube bin -g):$PATH"

# eza configuration
export EZA_CONFIG_DIR="$HOME/.config/eza"

# Mason bin configuration
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# SSH auth sock
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Added by Antigravity CLI installer
export PATH="/home/josevegar/.local/bin:$PATH"
