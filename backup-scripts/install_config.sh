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
case "$OSTYPE" in
  darwin*)
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
    ;;
  linux-gnu*)
    HOME_DIR="/mnt/c/Users/jvega"
    # Backup existing wezterm.lua if it exists 
    if [ -f "$HOME_DIR/.config/wezterm/wezterm.lua" ]; then
        echo "Creating backup of existing wezterm.lua..."
        cp "$HOME_DIR/.config/wezterm/wezterm.lua" "$HOME_DIR/.config/wezterm/wezterm.lua.backup_$timestamp"
    fi

    # Copy new .wezterm.lua configuration
    echo "Installing new wezterm.lua configuration..."
    # Create the directory if it doesn't exist
    if [ ! -d "$HOME_DIR/.config/wezterm" ]; then
        mkdir -p "$HOME_DIR/.config/wezterm"
    fi
    cp "./config/wezterm/wezterm-win32.lua" "$HOME_DIR/.config/wezterm/wezterm.lua"

    echo "Backup and copy for wezterm.lua completed successfully."
  ;;  
esac

##########################
## TMUX CONFIGURATION ##
##########################
# Backup existing .tmux.conf if it exists
if [ -f "$HOME/.tmux.conf" ]; then
    echo "Creating backup of existing .tmux.conf..."
    cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup_$timestamp"
fi
# Copy new .tmux.conf configuration
echo "Installing new .tmux.conf configuration..."
cp "./config/tmux/.tmux.conf" "$HOME/.tmux.conf"

echo "Backup and copy for .tmux.conf completed successfully."
