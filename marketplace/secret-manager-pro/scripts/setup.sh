#!/usr/bin/env bash
# Secret Manager Pro - Interactive Setup Script
# ============================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
  echo -e "${BLUE}========================================${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}========================================${NC}"
  echo
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
  echo -e "${RED}❌ $1${NC}"
}

print_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

ask_yes_no() {
  local prompt="$1"
  local default="${2:-n}"

  if [ "$default" = "y" ]; then
    prompt="$prompt [Y/n]: "
  else
    prompt="$prompt [y/N]: "
  fi

  read -p "$prompt" answer
  answer=${answer:-$default}

  [[ "$answer" =~ ^[Yy]$ ]]
}

# Main setup
main() {
  clear
  print_header "Secret Manager Pro Setup"

  echo "This wizard will help you set up secure secret management for Claude Code."
  echo
  echo "You can choose between:"
  echo "  1. 1Password CLI integration (recommended)"
  echo "  2. Manual credential management (fallback)"
  echo

  # Check current directory
  if [ ! -d ".git" ]; then
    print_warning "Not in a Git repository root. Continue anyway?"
    if ! ask_yes_no "Continue"; then
      print_error "Setup cancelled"
      exit 1
    fi
  fi

  # Step 1: Choose setup method
  echo
  print_header "Step 1: Choose Setup Method"
  echo

  if ask_yes_no "Do you have 1Password and want to use 1Password CLI integration?" "y"; then
    setup_with_1password
  else
    setup_without_1password
  fi

  # Final steps
  echo
  print_header "Setup Complete!"
  echo
  print_success "Secret Manager Pro is configured"
  echo
  echo "Next steps:"
  echo "  1. Verify secrets are loaded: echo \$JINA_API_KEY"
  echo "  2. Start using Claude Code with MCP servers"
  echo "  3. Check README.md for more information"
  echo
}

setup_with_1password() {
  print_header "1Password CLI Setup"

  # Check if 1Password CLI is installed
  if ! command -v op &> /dev/null; then
    print_warning "1Password CLI not found"
    echo
    echo "Install 1Password CLI:"
    echo "  macOS:  brew install 1password-cli"
    echo "  Linux:  See https://developer.1password.com/docs/cli/get-started/"
    echo

    if ask_yes_no "Open installation page in browser?"; then
      open "https://developer.1password.com/docs/cli/get-started/" 2>/dev/null || \
      xdg-open "https://developer.1password.com/docs/cli/get-started/" 2>/dev/null || \
      print_info "Visit: https://developer.1password.com/docs/cli/get-started/"
    fi

    print_error "Please install 1Password CLI and run this script again"
    exit 1
  fi

  print_success "1Password CLI found"

  # Check authentication
  if ! op vault list &> /dev/null; then
    print_warning "Not authenticated to 1Password"
    echo
    print_info "Running: op signin"
    echo

    if ! op signin; then
      print_error "1Password authentication failed"
      exit 1
    fi
  fi

  print_success "1Password authenticated"

  # List vaults
  echo
  print_info "Available vaults:"
  op vault list
  echo

  read -p "Enter vault name to use (default: Private): " vault_name
  vault_name=${vault_name:-Private}

  # Check direnv
  setup_direnv

  # Copy template
  echo
  print_header "Creating .envrc Configuration"

  local plugin_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

  if [ -f ".envrc" ]; then
    print_warning ".envrc already exists"
    if ask_yes_no "Backup and replace?"; then
      mv .envrc .envrc.backup.$(date +%Y%m%d_%H%M%S)
      print_success "Backed up existing .envrc"
    else
      print_error "Setup cancelled"
      exit 1
    fi
  fi

  # Copy and customize template
  cp "$plugin_dir/templates/.envrc.1password.template" .envrc

  # Replace vault name in template
  # Use a different delimiter for sed to handle special characters in vault_name
  local escaped_vault_name
  escaped_vault_name=$(printf '%s\n' "$vault_name" | sed 's:[\\/&]:\\&:g;$!s/$/\\/')
  escaped_vault_name=${escaped_vault_name%??}

  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s|VAULT_NAME=\"Private\"|VAULT_NAME=\"${escaped_vault_name}\"|" .envrc
  else
    sed -i "s|VAULT_NAME=\"Private\"|VAULT_NAME=\"${escaped_vault_name}\"|" .envrc
  fi

  print_success "Created .envrc with 1Password integration"

  # Create .envrc.local.example
  cp "$plugin_dir/templates/.envrc.local.example" .envrc.local.example
  print_success "Created .envrc.local.example for team"

  # Check .gitignore
  setup_gitignore

  # Allow direnv
  echo
  print_info "Allowing direnv..."
  direnv allow

  print_success "direnv configured"

  # Test 1Password items
  echo
  print_header "Verifying 1Password Items"

  test_1password_item "$vault_name" "Jina.ai" "api_key" "JINA_API_KEY"
  test_1password_item "$vault_name" "Notion MCP Suekou" "token" "NOTION_API_TOKEN"

  echo
  print_success "1Password setup complete!"
}

setup_without_1password() {
  print_header "Manual Credential Setup"

  # Check direnv
  setup_direnv

  # Copy template
  echo
  print_header "Creating .envrc Configuration"

  local plugin_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

  if [ -f ".envrc" ]; then
    print_warning ".envrc already exists"
    if ask_yes_no "Backup and replace?"; then
      mv .envrc .envrc.backup.$(date +%Y%m%d_%H%M%S)
      print_success "Backed up existing .envrc"
    else
      print_error "Setup cancelled"
      exit 1
    fi
  fi

  cp "$plugin_dir/templates/.envrc.manual.template" .envrc
  print_success "Created .envrc template"

  # Check .gitignore
  setup_gitignore

  # Allow direnv
  echo
  print_info "Allowing direnv..."
  direnv allow

  print_success "direnv configured"

  echo
  print_warning "Next steps:"
  echo "  1. Edit .envrc and replace placeholder values with your API keys"
  echo "  2. Save the file (direnv will auto-reload)"
  echo "  3. Verify: echo \$JINA_API_KEY"
  echo
  print_info "Consider upgrading to 1Password CLI for better security!"
  echo "  brew install 1password-cli"
  echo "  Then re-run this setup script"
}

setup_direnv() {
  print_header "Checking direnv"

  if ! command -v direnv &> /dev/null; then
    print_warning "direnv not found"
    echo
    echo "Install direnv:"
    echo "  macOS:  brew install direnv"
    echo "  Linux:  sudo apt-get install direnv"
    echo
    print_error "Please install direnv and run this script again"
    exit 1
  fi

  print_success "direnv found"

  # Check if shell hook is configured
  local shell_config=""
  case "$SHELL" in
    */bash)
      shell_config="$HOME/.bashrc"
      ;;
    */zsh)
      shell_config="$HOME/.zshrc"
      ;;
    */fish)
      shell_config="$HOME/.config/fish/config.fish"
      ;;
    *)
      print_warning "Unknown shell: $SHELL"
      ;;
  esac

  if [ -n "$shell_config" ]; then
    if ! grep -q "direnv hook" "$shell_config" 2>/dev/null; then
      print_warning "direnv hook not configured in $shell_config"
      echo

      if ask_yes_no "Add direnv hook to $shell_config?"; then
        case "$SHELL" in
          */bash)
            echo 'eval "$(direnv hook bash)"' >> "$shell_config"
            ;;
          */zsh)
            echo 'eval "$(direnv hook zsh)"' >> "$shell_config"
            ;;
          */fish)
            echo 'direnv hook fish | source' >> "$shell_config"
            ;;
        esac

        print_success "Added direnv hook to $shell_config"
        print_warning "Restart your shell or run: source $shell_config"
      fi
    else
      print_success "direnv hook configured"
    fi
  fi
}

setup_gitignore() {
  print_header "Configuring .gitignore"

  if [ ! -f ".gitignore" ]; then
    touch .gitignore
    print_success "Created .gitignore"
  fi

  # Check for .envrc.local (should be ignored)
  if ! grep -q "^\.envrc\.local$" .gitignore 2>/dev/null; then
    echo ".envrc.local" >> .gitignore
    print_success "Added .envrc.local to .gitignore"
  else
    print_success ".envrc.local already in .gitignore"
  fi

  # Check for .envrc (manual setup should ignore it)
  if grep -q "^\.envrc$" .gitignore 2>/dev/null; then
    print_info ".envrc is in .gitignore (manual credential mode)"
  else
    print_info ".envrc not in .gitignore (1Password mode - safe to commit)"
  fi
}

test_1password_item() {
  local vault="$1"
  local item="$2"
  local field="$3"
  local env_var="$4"

  echo -n "Checking $item... "

  if op item get "$item" --vault "$vault" &> /dev/null; then
    if op read "op://$vault/$item/$field" &> /dev/null; then
      print_success "OK"
    else
      print_warning "Item exists but field '$field' not found"
      echo "  Create field: op item edit \"$item\" $field=\"your_value\" --vault $vault"
    fi
  else
    print_warning "Not found"
    echo "  Create item:"
    echo "    op item create --category=login \\"
    echo "      --title=\"$item\" \\"
    echo "      --vault=$vault \\"
    echo "      $field=\"your_value_here\""
  fi
}

# Run main function
main "$@"
