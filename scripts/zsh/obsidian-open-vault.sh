#!/bin/zsh

oo() {
  if [ -z "$OBSIDIAN_BASE" ]; then
    echo "Error: OBSIDIAN_BASE environment variable is not set."
    exit 1
  fi

  cd "$OBSIDIAN_BASE" || exit
}
