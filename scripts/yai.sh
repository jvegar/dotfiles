#!/bin/bash

# Determine home directory using multiple fallback methods
get_home_dir() {
    # Try $HOME first
    if [ -n "$HOME" ]; then
        echo "$HOME"
        return
    fi
    
    # Try getent if available
    if command -v getent >/dev/null 2>&1; then
        HOME=$(getent passwd "$(whoami)" | cut -d: -f6)
        if [ -n "$HOME" ]; then
            echo "$HOME"
            return
        fi
    fi
    
    # Fallback to ~ expansion
    echo ~
}

HOME_DIR=$(get_home_dir)
SCRIPT_DIR="$HOME_DIR/repos/projects/dotfiles/scripts"
LOADER_PATH="$SCRIPT_DIR/shloader.sh"
OBSIDIAN_DIR="/mnt/d/repos/learning/obsidian/obsidian-vault-jevr/AI Queries"

# Verify and source the loader
if [ -f "$LOADER_PATH" ]; then
    source "$LOADER_PATH"
else
    echo "Error: Could not find shloader.sh"
    echo "Searched in: $LOADER_PATH"
    echo "Please ensure the file exists at the expected location"
    exit 1
fi

# Function to concatenate strings and evaluate the result
main() {
  # Input strings
  local query_string="$1"
  local title_string="${2:-}"
  
  # Concatenate raw query 
  if [ -n "$title_string" ]; then
    local time_stamp=$(date +'%Y-%m-%d')
    local output_path="$OBSIDIAN_DIR/${time_stamp}-${title_string}.md" 
    raw_query="echo '$query_string' | fabric -p raw_query -o '$output_path'"  
  else 
    raw_query="echo '$query_string' | fabric -p raw_query --stream"
  fi

  eval "$raw_query" | glow -
}



# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <input_string>"
  exit 1
fi

# Call the function with the input string
shloader -l dots2 -m "Running raw query..." -e "Done!"

main "$1" "${2:-}"

# end_shloader
