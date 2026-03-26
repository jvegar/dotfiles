#!/usr/bin/env zsh
#
# Bitwarden CLI helper: list vault secrets with their types and IDs
# Requires: Bitwarden CLI (bw), jq, and a valid Bitwarden session
# The session is automatically initialized via _bw_init_session if available

# Check for required commands
_bw_check_deps() {
    local missing=()
    command -v bw >/dev/null 2>&1 || missing+=("bw (Bitwarden CLI)")
    command -v jq >/dev/null 2>&1 || missing+=("jq")

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Error: Missing required commands:" >&2
        for cmd in "${missing[@]}"; do
            echo "  - $cmd" >&2
        done
        return 1
    fi
    return 0
}

# Ensure we have a valid Bitwarden session
_bw_ensure_session() {
    # Check if _bw_init_session function exists (from .secrets)
    if typeset -f _bw_init_session >/dev/null; then
        _bw_init_session 2>/dev/null && return 0
    fi

    # Fallback: check if BW_SESSION is set and valid
    if [[ -n "$BW_SESSION" ]]; then
        if bw unlock --check >/dev/null 2>&1; then
            return 0
        fi
    fi

    # No valid session found
    echo "Error: Unable to obtain a valid Bitwarden session." >&2
    echo "Make sure you have a .secrets file with Bitwarden credentials or run 'bw login'." >&2
    return 1
}

# Map numeric type to human-readable string
_bw_type_name() {
    case "$1" in
        1) echo "Login" ;;
        2) echo "Secure Note" ;;
        3) echo "Card" ;;
        4) echo "Identity" ;;
        *) echo "Unknown ($1)" ;;
    esac
}

# Main function to list secrets
bw_list_secrets() {
    # Check dependencies
    if ! _bw_check_deps; then
        return 1
    fi

    # Ensure we have a session
    if ! _bw_ensure_session; then
        return 1
    fi

    # Check if column command is available for pretty formatting
    local has_column=0
    if command -v column >/dev/null 2>&1; then
        has_column=1
    fi

    # Fetch items, sort by name, and format with jq
    local pipeline_output
    pipeline_output=$(bw list items 2>/dev/null | jq -r '
        sort_by(.name) |
        .[] |
        "\(.name)\t\(.type)\t\(.id)"' | while IFS=$'\t' read -r name type id; do
        printf "%s\t%s\t%s\n" "$name" "$(_bw_type_name "$type")" "$id"
    done)

    if (( has_column )); then
        echo "$pipeline_output" | column -t -s $'\t'
    else
        echo "$pipeline_output"
    fi
}

# Alias for convenience
alias bwls='bw_list_secrets'

# If this script is executed directly (not sourced), run bw_list_secrets
if [[ "${ZSH_EVAL_CONTEXT:-}" == "toplevel" ]] && [[ ! -o interactive ]]; then
    bw_list_secrets
fi

# One-liner example (for reference):
# BW_SESSION="$(cat ~/.bw_session 2>/dev/null)" bw list items 2>/dev/null | jq -r '.[] | "\(.name)\t\(.type)\t\(.id)"' | column -t -s $'\t'