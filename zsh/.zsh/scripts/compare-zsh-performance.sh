#!/usr/bin/env zsh
# Compare ZSH performance between old and new configurations

set -e

echo "=== ZSH Performance Comparison ==="
echo "Comparing old vs new configuration"
echo ""

# Backup current .zshrc
if [[ -f "$HOME/.zshrc" ]]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.current"
fi

# Test 1: Old configuration
echo "1. Testing OLD configuration (~/.zshrc.old):"
if [[ -f "$HOME/.zshrc.old" ]]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.newbackup"
  cp "$HOME/.zshrc.old" "$HOME/.zshrc"

  # Run benchmark
  for i in {1..2}; do
    { time (zsh -i -c "exit" >/dev/null 2>&1) } 2>&1 | awk '/real/ {printf "  Run %d: %s\n", i, $0}' i=$i
  done
else
  echo "  No old configuration found at ~/.zshrc.old"
fi

echo ""

# Test 2: New configuration
echo "2. Testing NEW configuration (current modular):"
if [[ -f "$HOME/.zshrc.newbackup" ]]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.oldtest"
  cp "$HOME/.zshrc.newbackup" "$HOME/.zshrc"
fi

for i in {1..2}; do
  { time (zsh -i -c "exit" >/dev/null 2>&1) } 2>&1 | awk '/real/ {printf "  Run %d: %s\n", i, $0}' i=$i
done

echo ""

# Restore original configuration
if [[ -f "$HOME/.zshrc.current" ]]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.tmp"
  cp "$HOME/.zshrc.current" "$HOME/.zshrc"
  rm -f "$HOME/.zshrc.current" "$HOME/.zshrc.newbackup" "$HOME/.zshrc.oldtest" "$HOME/.zshrc.tmp"
  echo "Original configuration restored."
fi

echo "=== Comparison Complete ==="