#!/bin/bash

# Get current timestamp
timestamp=$(date +"%Y%m%d_%H%M%S")

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
    echo "Creating backup of existing .zshrc..."
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup_$timestamp"
fi

# Copy new .zshrc configuration
echo "Installing new .zshrc configuration..."
cp "./config/.zshrc" "$HOME/.zshrc"

echo "Backup and copy for .zshrc completed successfully."