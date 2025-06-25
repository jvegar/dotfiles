#!/bin/bash

# Get the directory from the first argument, default to current directory if not provided
target_dir="${1:-.}"

# Check if the directory exists
if [ ! -d "$target_dir" ]; then
    echo "Error: Directory '$target_dir' does not exist"
    exit 1
fi

# Loop through all files matching the pattern lesson*.mp4 in the target directory
for file in "$target_dir"/lesson*.mp4; do
    # Skip if no files match the pattern
    [ -e "$file" ] || continue
    
    # Get the basename without extension
    filename=$(basename "$file" .mp4)
    
    # Extract the number from the filename (only between 'lesson' and end of string)
    number=$(echo "$filename" | sed 's/^lesson//')
    
    # Skip if no number found or if it's not a valid number
    if ! [[ "$number" =~ ^[0-9]+$ ]]; then
        continue
    fi
    
    # Create new filename with padded number
    new_name="lesson$(printf "%03d" "$number").mp4"
    
    # Only rename if the new name is different
    if [ "$(basename "$file")" != "$new_name" ]; then
        echo "Renaming $(basename "$file") to $new_name"
        mv "$file" "$target_dir/$new_name"
    fi
done
