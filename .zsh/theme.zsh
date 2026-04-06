#!/usr/bin/env zsh
# Powerlevel10k Theme Configuration

# Configure Powerlevel10k (Nerd Fonts mode)
POWERLEVEL10K_PROMPT_ON_NEWLINE=true
POWERLEVEL10K_MODE='nerdfont-complete'
POWERLEVEL10K_BATTERY_SHOW=false
POWERLEVEL10K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL10K_RIGHT_PROMPT_ELEMENTS=(status time background_jobs)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zinit ice depth"1" atinit'[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh'
zinit light romkatv/powerlevel10k