#!/bin/bash

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
LOADER_PATH="$SCRIPT_DIR/shloader.sh"

# Use OBSIDIAN_BASE environment variable, or exit if not set.
# Example: export OBSIDIAN_BASE="/path/to/your/vault"
if [ -z "$OBSIDIAN_BASE" ]; then
    echo "Error: OBSIDIAN_BASE environment variable is not set." >&2
    echo "Please set it to your Obsidian AI Queries directory." >&2
    exit 1
fi
OBSIDIAN_DIR="$OBSIDIAN_BASE"

# Verify and source the loader
if [ -f "$LOADER_PATH" ]; then
    source "$LOADER_PATH"
else
    echo "Error: Could not find shloader.sh" >&2
    echo "Searched in: $LOADER_PATH" >&2
    echo "Please ensure the file exists at the expected location" >&2
    exit 1
fi

# Function to process the query and pipe it to fabric
main() {
  # Input strings
  local query_string="$1"
  local title_string="${2:-}"

  # Process the query
  if [ -n "$title_string" ]; then
    local time_stamp
    time_stamp=$(date +'%Y-%m-%d')
    local output_path="$OBSIDIAN_DIR/${time_stamp}-${title_string}.md"
    # Directly execute the command, avoiding eval
    echo "$query_string" | fabric -p raw_query -o "$output_path" | glow -
  else
    # Directly execute the command, avoiding eval
    echo "$query_string" | fabric -p raw_query --stream | glow -
  fi
}

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <query_string> [optional_title]" >&2
  exit 1
fi

# Call the function with the input string
shloader -l dots2 -m "Running raw query..." -e "Done!"

main "$1" "${2:-}"

# end_shloader
