#!/bin/bash

# Get current timestamp
timestamp=$(date +"%Y%m%d_%H%M%S")

#########################
## ZSH CONFIGURATION ##
#########################

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
    echo "Creating backup of existing .zshrc..."
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup_$timestamp"
fi

# Copy new .zshrc configuration
echo "Installing new .zshrc configuration..."
cp "./config/.zshrc" "$HOME/.zshrc"

echo "Backup and copy for .zshrc completed successfully."

# Backup existing .zsenv if it exists
if [ -f "$HOME/.zshenv" ]; then
    echo "Creating backup of existing .zshenv..."
    cp "$HOME/.zshenv" "$HOME/.zshenv.backup_$timestamp"
fi

# Copy new .zshenv configuration
echo "Installing new .zshenv configuration..."
cp "./config/.zshenv" "$HOME/.zshenv"

echo "Backup and copy for .zshenv completed successfully."

###########################
## WEZTERM CONFIGURATION ##
###########################

# Backup existing wezterm.lua if it exists 
if [ -f "$HOME/.config/wezterm/wezterm.lua" ]; then
    echo "Creating backup of existing wezterm.lua..."
    cp "$HOME/.config/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua.backup_$timestamp"
fi

# Copy new .wezterm.lua configuration
echo "Installing new wezterm.lua configuration..."
# Create the directory if it doesn't exist
if [ ! -d "$HOME/.config/wezterm" ]; then
    mkdir -p "$HOME/.config/wezterm"
fi
cp "./config/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"

echo "Backup and copy for wezterm.lua completed successfully."
