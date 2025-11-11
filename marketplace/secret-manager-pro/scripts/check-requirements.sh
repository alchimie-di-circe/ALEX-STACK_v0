#!/usr/bin/env bash
# Secret Manager Pro - Requirements Checker
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

print_header() {
  echo
  echo -e "${BLUE}========================================${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}========================================${NC}"
  echo
}

# Check results
all_passed=true

print_header "Secret Manager Pro - Requirements Check"

# Check direnv
echo -n "Checking direnv... "
if command -v direnv &> /dev/null; then
  version=$(direnv version)
  print_success "Installed ($version)"
else
  print_error "Not found"
  echo "  Install: brew install direnv (macOS) or sudo apt-get install direnv (Linux)"
  all_passed=false
fi

# Check 1Password CLI
echo -n "Checking 1Password CLI... "
if command -v op &> /dev/null; then
  version=$(op --version)
  print_success "Installed ($version)"

  # Check authentication
  echo -n "Checking 1Password authentication... "
  if op vault list &> /dev/null; then
    print_success "Authenticated"
  else
    print_warning "Not authenticated"
    echo "  Run: op signin"
  fi
else
  print_warning "Not found (optional but recommended)"
  echo "  Install: brew install 1password-cli (macOS)"
  echo "  Or visit: https://developer.1password.com/docs/cli/get-started/"
fi

# Check shell
echo -n "Checking shell... "
case "$SHELL" in
  */bash|*/zsh|*/fish)
    print_success "Supported ($SHELL)"
    ;;
  *)
    print_warning "Unknown shell: $SHELL"
    echo "  Supported shells: bash, zsh, fish"
    ;;
esac

# Check direnv hook
echo -n "Checking direnv shell hook... "
shell_config=""
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
esac

if [ -n "$shell_config" ] && [ -f "$shell_config" ]; then
  if grep -q "direnv hook" "$shell_config" 2>/dev/null; then
    print_success "Configured in $shell_config"
  else
    print_warning "Not configured in $shell_config"
    echo "  Add to $shell_config:"
    case "$SHELL" in
      */bash)
        echo "    eval \"\$(direnv hook bash)\""
        ;;
      */zsh)
        echo "    eval \"\$(direnv hook zsh)\""
        ;;
      */fish)
        echo "    direnv hook fish | source"
        ;;
    esac
    all_passed=false
  fi
else
  print_warning "Could not check shell config"
fi

# Check Git
echo -n "Checking Git... "
if command -v git &> /dev/null; then
  version=$(git --version | cut -d' ' -f3)
  print_success "Installed ($version)"
else
  print_warning "Not found (recommended for version control)"
fi

# Check if in project directory
echo -n "Checking project directory... "
if [ -d ".git" ]; then
  print_success "In Git repository"
else
  print_info "Not in Git repository (optional)"
fi

# Check for existing .envrc
echo -n "Checking for existing .envrc... "
if [ -f ".envrc" ]; then
  print_info "Found (will need to backup before setup)"
else
  print_success "None found (clean setup possible)"
fi

# Check .gitignore
echo -n "Checking .gitignore... "
if [ -f ".gitignore" ]; then
  if grep -q "\.envrc\.local" .gitignore 2>/dev/null; then
    print_success ".envrc.local is ignored"
  else
    print_warning ".envrc.local not in .gitignore"
    echo "  Add: echo '.envrc.local' >> .gitignore"
  fi
else
  print_info "No .gitignore found (will be created during setup)"
fi

# Platform check
echo -n "Checking platform... "
case "$OSTYPE" in
  darwin*)
    print_success "macOS"
    ;;
  linux*)
    print_success "Linux"
    ;;
  msys*|cygwin*)
    print_info "Windows (WSL or Git Bash)"
    ;;
  *)
    print_warning "Unknown platform: $OSTYPE"
    ;;
esac

# Summary
print_header "Summary"

if $all_passed; then
  print_success "All required checks passed!"
  echo
  echo "You're ready to run: ./scripts/setup.sh"
else
  print_warning "Some required components are missing"
  echo
  echo "Please install missing requirements and run this check again"
  exit 1
fi

echo
print_info "Optional but recommended:"
echo "  - 1Password CLI for secure vault integration"
echo "  - Git for version control"
echo
