#!/bin/bash

# Function to backup Obsidian vault to git
backup_obsidian_vault() {
    # Check if OBSIDIAN_BASE is set
    if [ -z "$OBSIDIAN_BASE" ]; then
        echo "Error: OBSIDIAN_BASE environment variable is not set"
        return 1
    fi

    # Check if the vault directory exists
    if [ ! -d "$OBSIDIAN_BASE" ]; then
        echo "Error: Obsidian vault directory '$OBSIDIAN_BASE' does not exist"
        return 1
    fi

    # Change to the vault directory
    cd "$OBSIDIAN_BASE" || return 1

    # Check if it's a git repository
    if [ ! -d ".git" ]; then
        echo "Error: '$OBSIDIAN_BASE' is not a git repository"
        return 1
    fi

    # Check for changes
    if ! git diff --quiet || ! git diff --cached --quiet; then
        # There are changes (staged or unstaged)
        echo "Found changes in Obsidian vault, creating backup..."
        
        # Add all changes to staging
        git add .
        
        # Create commit message with timestamp
        commit_message="vault backup: $(date '+%Y-%m-%d %H:%M:%S')"
        
        # Commit the changes
        git commit -m "$commit_message"
        
        echo "Backup completed: $commit_message"
        return 0
    else
        echo "No changes found in Obsidian vault"
        return 0
    fi
}

# If script is executed directly (not sourced), run the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    backup_obsidian_vault
fi