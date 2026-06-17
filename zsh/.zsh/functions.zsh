#!/usr/bin/env zsh
# ZSH Helper Functions
# Provides utility functions for tool initialization, lazy loading, and configuration

# Function: init_tool_if_exists
# Description: Initialize a tool if it exists in PATH or at a specific location
# Usage: init_tool_if_exists <tool_name> <init_command> [path_check]
init_tool_if_exists() {
  local tool_name="$1"
  local init_command="$2"
  local path_check="${3:-$tool_name}"

  if command -v "$path_check" >/dev/null 2>&1; then
    eval "$init_command"
    return 0
  else
    return 1
  fi
}

# Function: lazy_load
# Description: Create a wrapper function that loads a plugin/script on first use
# Usage: lazy_load <function_name> <load_command> [aliases...]
lazy_load() {
  local function_name="$1"
  local load_command="$2"
  shift 2

  # Create the wrapper function
  eval "${function_name}() {
    unfunction ${function_name}
    ${load_command}
    \"\$@\"
  }"

  # Create aliases if provided
  for alias_name in "$@"; do
    alias "${alias_name}"="${function_name}"
  done
}

# Function: source_if_exists
# Description: Source a file if it exists and is readable
# Usage: source_if_exists <file_path>
source_if_exists() {
  local file_path="$1"
  if [[ -r "$file_path" ]]; then
    source "$file_path" 2>/dev/null || true
    return 0
  else
    return 1
  fi
}

# Function: get_os_type
# Description: Get normalized OS type (darwin, linux, wsl)
# Usage: os_type=$(get_os_type)
get_os_type() {
  case "$OSTYPE" in
    darwin*) echo "darwin" ;;
    linux-gnu*)
      if [[ -f /proc/version ]] && grep -qi microsoft /proc/version; then
        echo "wsl"
      else
        echo "linux"
      fi
      ;;
    *) echo "unknown" ;;
  esac
}

# Function: secure_source
# Description: Securely source a file with permission checks
# Usage: secure_source <file_path> [required_permissions]
secure_source() {
  local file_path="$1"
  local required_perms="${2:-600}"

  if [[ ! -f "$file_path" ]]; then
    return 1
  fi

  # Check file permissions
  local actual_perms=$(stat -c '%a' "$file_path" 2>/dev/null || stat -f '%A' "$file_path" 2>/dev/null)
  if [[ "$actual_perms" != "$required_perms" ]]; then
    echo "Warning: $file_path has permissions $actual_perms (should be $required_perms)" >&2
    return 2
  fi

  # Source the file
  source "$file_path" 2>/dev/null || true
  return 0
}

# Function: benchmark_startup
# Description: Measure shell startup time
# Usage: Add to end of .zshrc: benchmark_startup
benchmark_startup() {
  if [[ -n "$ZSH_STARTUP_TIME" ]]; then
    local end_time=$(date +%s.%N)
    local duration=$(echo "$end_time - $ZSH_STARTUP_TIME" | bc -l)
    echo "ZSH startup time: ${duration}s" >&2
  fi
}

# Initialize startup time tracking
if [[ -n "$ZPROF" || -n "$BENCHMARK_STARTUP" ]]; then
  export ZSH_STARTUP_TIME=$(date +%s.%N)
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd benchmark_startup
fi