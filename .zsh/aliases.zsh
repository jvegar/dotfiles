#!/usr/bin/env zsh
# ZSH Aliases Configuration
# Categorized aliases for better organization

# General aliases
alias ls="eza --icons=always --color-scale"
alias ll="ls -lh"
alias md="mkdir"
alias yai="$HOME/repos/projects/dotfiles/scripts/yai.sh"

# Tmux aliases
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