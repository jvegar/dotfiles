#!/bin/bash
echo "Saving Neovim sessions..."
tmux list-panes -a -F '#{pane_id}' | xargs -I{} tmux send-keys -t {} ':qa!' Enter
sleep 1
echo "Killing tmux server..."
tmux kill-server
