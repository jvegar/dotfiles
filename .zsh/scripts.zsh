#!/usr/bin/env zsh
# Custom Scripts Loading Configuration
# Implements lazy loading for performance optimization

ZSH_SCRIPTS_DIR="${ZSH_SCRIPTS_DIR:-$HOME/scripts/zsh}"

# Function: lazy_load_script
# Description: Create a wrapper function that sources a script on first use
# Usage: lazy_load_script <script_name> <function_name> [alias1 alias2...]
lazy_load_script() {
  local script_name="$1"
  local function_name="$2"
  shift 2
  local aliases=("$@")

  # Create wrapper function
  eval "${function_name}() {
    # Source the script
    source \"${ZSH_SCRIPTS_DIR}/${script_name}\" 2>/dev/null || true
    # Execute the function
    ${function_name} \"\$@\"
  }"

  # Create aliases if provided
  for alias_name in "${aliases[@]}"; do
    alias "${alias_name}"="${function_name}"
  done
}

# Function: load_script_delayed
# Description: Load a script with zinit delayed loading
# Usage: load_script_delayed <script_path> <delay>
load_script_delayed() {
  local script_path="$1"
  local delay="${2:-1}"

  if [[ -r "$script_path" ]]; then
    zinit ice wait"${delay}" silent
    zinit snippet "$script_path"
  fi
}

# Load all scripts with lazy loading if directory exists
if [[ -d "$ZSH_SCRIPTS_DIR" ]]; then
  # Define lazy loading mappings
  # Format: script_name function_name [aliases...]

  # tmuxifier_cp_session.sh - main function: tcps
  lazy_load_script "tmuxifier_cp_session.sh" "tcps"

  # bw-list-secrets.sh - main function: bw_list_secrets
  lazy_load_script "bw-list-secrets.sh" "bw_list_secrets" "bwls"

  # load-fabric-patterns.sh - creates pattern functions, load on demand
  # This script creates functions dynamically, so we load it with a delay
  load_script_delayed "${ZSH_SCRIPTS_DIR}/load-fabric-patterns.sh" "2"

  # obsidian-git-backup.sh - main function: obsidian_git_backup
  lazy_load_script "obsidian-git-backup.sh" "obsidian_git_backup" "ogb"

  # obsidian-new-note.sh - main function: obsidian_new_note
  lazy_load_script "obsidian-new-note.sh" "obsidian_new_note" "onn"

  # obsidian-open-vault.sh - main function: obsidian_open_vault
  lazy_load_script "obsidian-open-vault.sh" "obsidian_open_vault" "oov"

  # Note: The lazy_load_script function creates wrappers that will source
  # the script on first invocation. This defers loading until the function
  # is actually used.
fi

# Legacy loading (commented out for reference)
# if [[ -d "$HOME/scripts/zsh" ]]; then
#   for script in "$HOME/scripts/zsh/"*.sh; do
#     # Lazy-load each script with zinit (only if file exists and is readable)
#     if [[ -r "$script" ]]; then
#       zinit ice wait"1" silent
#       zinit snippet "$script"
#     fi
#   done
# fi