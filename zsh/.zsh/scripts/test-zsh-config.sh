#!/usr/bin/env zsh
# Test script for new ZSH configuration

echo "=== Testing ZSH Configuration ==="
echo "Current shell: $(ps -p $$ -o comm=)"
echo "ZSH_VERSION: $ZSH_VERSION"

# Test 1: Source .zshrc
echo -e "\n1. Testing .zshrc sourcing..."
if source ~/.zshrc 2>&1; then
  echo "  ✓ .zshrc sourced successfully"
else
  echo "  ✗ Failed to source .zshrc"
fi

# Test 2: Check essential aliases
echo -e "\n2. Testing essential aliases..."
aliases_to_test=(ls ll tm tma dps)
for alias in "${aliases_to_test[@]}"; do
  if alias "$alias" >/dev/null 2>&1; then
    echo "  ✓ Alias '$alias' exists"
  else
    echo "  ✗ Alias '$alias' not found"
  fi
done

# Test 3: Check functions
echo -e "\n3. Testing helper functions..."
functions_to_test=(init_tool_if_exists source_if_exists get_os_type)
for func in "${functions_to_test[@]}"; do
  if type "$func" >/dev/null 2>&1; then
    echo "  ✓ Function '$func' exists"
  else
    echo "  ✗ Function '$func' not found"
  fi
done

# Test 4: Check plugin availability
echo -e "\n4. Testing plugin availability..."
# Check if zinit is loaded
if type zinit >/dev/null 2>&1; then
  echo "  ✓ Zinit loaded"
else
  echo "  ✗ Zinit not loaded"
fi

# Test 5: Check OS-specific aliases
echo -e "\n5. Testing OS detection..."
os_type=$(get_os_type 2>/dev/null || echo "unknown")
echo "  Detected OS type: $os_type"

# Test 6: Check secrets loading
echo -e "\n6. Testing secrets..."
if [[ -n "$AVANTE_DEEPSEEK_API_KEY" ]]; then
  if [[ "$AVANTE_DEEPSEEK_API_KEY" == "[REDACTED]" ]]; then
    echo "  ✓ Secrets loaded and masked"
  else
    echo "  ⚠ Secrets loaded but not masked"
  fi
else
  echo "  - No secrets loaded (may be normal)"
fi

echo -e "\n=== Test Complete ==="