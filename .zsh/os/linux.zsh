#!/usr/bin/env zsh
# Linux/WSL specific configurations

# Podman configuration (commented out)
# alias podman=podman-remote-static-linux_amd64
# alias docker=podman
# alias docker-compose=podman-compose

# VS Code for Linux WSL
alias code="'/mnt/c/Program Files/Microsoft VS Code/bin/code'"

# Linux-specific copy/paste
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'