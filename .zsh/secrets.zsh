#!/usr/bin/env zsh
# Secure Secrets Loading Configuration
# Provides secure methods for loading API keys and sensitive data

# Function: load_secrets
# Description: Securely load secrets file with permission validation
# Usage: load_secrets [secrets_file_path]
load_secrets() {
  local secrets_file="${1:-$HOME/.secrets}"
  local required_perms="600"

  # Check if secrets file exists
  if [[ ! -f "$secrets_file" ]]; then
    # echo "Note: No secrets file found at $secrets_file" >&2
    return 1
  fi

  # Validate file permissions
  local actual_perms
  if command -v stat >/dev/null 2>&1; then
    # Linux stat
    actual_perms=$(stat -c '%a' "$secrets_file" 2>/dev/null)
  else
    # macOS stat
    actual_perms=$(stat -f '%A' "$secrets_file" 2>/dev/null)
  fi

  if [[ "$actual_perms" != "$required_perms" ]]; then
    echo "Warning: $secrets_file has insecure permissions $actual_perms (should be $required_perms)" >&2
    echo "  Run: chmod $required_perms '$secrets_file'" >&2
    return 2
  fi

  # Check file ownership (optional)
  if [[ "$(uname)" == "Linux" ]] && command -v stat >/dev/null 2>&1; then
    local file_owner=$(stat -c '%U' "$secrets_file")
    local current_user=$(whoami)
    if [[ "$file_owner" != "$current_user" ]]; then
      echo "Warning: $secrets_file is owned by $file_owner, not $current_user" >&2
      return 3
    fi
  fi

  # Load the secrets file
  source "$secrets_file" 2>/dev/null || true

  # Note: Environment variables loaded above are now available for use
  # For true security, consider using a password manager or keychain integration

  return 0
}

# Function: mask_secret_vars
# Description: WARNING: This function overwrites secret values with "[REDACTED]"
# Use only if you want to deliberately hide values (will break functionality)
mask_secret_vars() {
  local secret_vars=(
    AVANTE_DEEPSEEK_API_KEY
    BW_CLIENTID
    BW_CLIENTSECRET
    BW_PASSWORD
    DEEPSEEK_API_KEY
    GH_TOKEN
    ANTHROPIC_AUTH_TOKEN
    OPEN_ROUTER_API_KEY
    GEMINI_API_KEY
  )

  for var in "${secret_vars[@]}"; do
    if [[ -n "${(P)var}" ]]; then
      export $var="[REDACTED]"
    fi
  done
}

# Main secrets loading
if [[ -z "$ZSH_SECURE_SEcrets_DISABLED" ]]; then
  load_secrets
fi

# Optional: Uncomment to mask secrets in shell display
# mask_secret_vars