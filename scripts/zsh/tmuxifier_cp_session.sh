#!/bin/zsh

# Configuration
TMUXIFIER_LAYOUTS_PATH="${HOME}/.config/tmux/plugins/tmuxifier/layouts/"
DEFAULT_TEMPLATE_NAME="dotfiles.session.sh"
DEFAULT_TEMPLATE_PATH="${TMUXIFIER_LAYOUTS_PATH}${DEFAULT_TEMPLATE_NAME}"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_error() {
  echo -e "${RED}❌ Error: $1${NC}" >&2
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  Warning: $1${NC}"
}

print_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

# Function to validate layout name
validate_layout_name() {
  local name="$1"

  # Check if name is provided
  if [[ -z "$name" ]]; then
    print_error "Layout name is required"
    return 1
  fi

  # Check for invalid characters
  if [[ "$name" =~ [^a-zA-Z0-9_-] ]]; then
    print_error "Layout name can only contain letters, numbers, hyphens, and underscores"
    return 1
  fi

  # Check if name is too long
  if [[ ${#name} -gt 50 ]]; then
    print_error "Layout name is too long (max 50 characters)"
    return 1
  fi

  return 0
}

# Function to check if paths exist
check_paths() {
  # Check if tmuxifier layouts directory exists
  if [[ ! -d "$TMUXIFIER_LAYOUTS_PATH" ]]; then
    print_error "Tmuxifier layouts directory not found: $TMUXIFIER_LAYOUTS_PATH"
    print_info "Make sure tmuxifier is installed and configured properly"
    return 1
  fi

  # Check if default template exists
  if [[ ! -f "$DEFAULT_TEMPLATE_PATH" ]]; then
    print_error "Default template not found: $DEFAULT_TEMPLATE_PATH"
    print_info "Expected template file: $DEFAULT_TEMPLATE_NAME"
    return 1
  fi

  return 0
}

# Function to check if target file already exists
check_target_file() {
  local target_path="$1"

  if [[ -f "$target_path" ]]; then
    print_warning "Target file already exists: $target_path"
    read -q "REPLY?Overwrite existing file? (y/N): "
    echo
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
      print_info "Operation cancelled"
      return 1
    fi
  fi

  return 0
}

# Main function to copy tmuxifier session template
tcps() {
  local layout_name="$1"
  local target_filename="${layout_name}.session.sh"
  local target_path="${TMUXIFIER_LAYOUTS_PATH}${target_filename}"

  # Print header
  echo "📝 Tmuxifier Session Template Copier"
  echo "=================================="

  # Validate layout name
  if ! validate_layout_name "$layout_name"; then
    print_info "Usage: tcps <layout_name>"
    print_info "Example: tcps myproject"
    return 1
  fi

  # Check paths
  if ! check_paths; then
    return 1
  fi

  # Check if target file exists
  if ! check_target_file "$target_path"; then
    return 1
  fi

  # Copy the template
  print_info "Copying template to: $target_filename"

  if cp "$DEFAULT_TEMPLATE_PATH" "$target_path"; then
    print_success "Successfully created: $target_filename"
    print_info "Template copied from: $DEFAULT_TEMPLATE_NAME"
    print_info "You can now edit: $target_path"

    # Optional: Make the new file executable
    if chmod +x "$target_path" 2>/dev/null; then
      print_info "Made executable: $target_filename"
    fi

    return 0
  else
    print_error "Failed to copy template"
    return 1
  fi
}

# If script is run directly (not sourced), execute the function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]] || [[ "${ZSH_EVAL_CONTEXT}" == "toplevel" ]]; then
  tcps "$@"
fi
