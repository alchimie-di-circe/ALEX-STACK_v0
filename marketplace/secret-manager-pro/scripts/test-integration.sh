#!/usr/bin/env bash
# Secret Manager Pro - Integration Test Script
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

# Test results
tests_passed=0
tests_failed=0

run_test() {
  local test_name="$1"
  local test_command="$2"

  echo -n "Testing $test_name... "

  if eval "$test_command" &> /dev/null; then
    print_success "PASS"
    ((tests_passed++))
    return 0
  else
    print_error "FAIL"
    ((tests_failed++))
    return 1
  fi
}

print_header "Secret Manager Pro - Integration Test"

# Test 1: direnv is installed
run_test "direnv installation" "command -v direnv"

# Test 2: direnv hook is configured
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
    shell_config=""
    ;;
esac

if [ -n "$shell_config" ]; then
  run_test "direnv shell hook" "grep -q 'direnv hook' $shell_config"
else
  print_warning "Unknown shell, skipping hook test"
fi

# Test 3: .envrc exists
run_test ".envrc file exists" "test -f .envrc"

# Test 4: .envrc is allowed
run_test ".envrc is allowed" "direnv status | grep -q 'Found RC allowed true'"

# Test 5: Check for 1Password CLI (optional)
echo -n "Testing 1Password CLI... "
if command -v op &> /dev/null; then
  print_success "FOUND (optional)"

  # Test 6: 1Password authentication
  echo -n "Testing 1Password auth... "
  if op vault list &> /dev/null 2>&1; then
    print_success "AUTHENTICATED"

    # Test 7: Read vault name from .envrc
    if grep -q "VAULT_NAME=" .envrc 2>/dev/null; then
      vault_name=$(grep "VAULT_NAME=" .envrc | head -1 | cut -d'"' -f2)
      print_info "Using vault: $vault_name"

      # Test 8: Check Jina.ai item
      echo -n "Testing Jina.ai item... "
      if op item get "Jina.ai" --vault "$vault_name" &> /dev/null; then
        print_success "EXISTS"

        # Test 9: Read api_key field
        echo -n "Testing Jina.ai api_key field... "
        if op read "op://$vault_name/Jina.ai/api_key" &> /dev/null; then
          print_success "READABLE"
        else
          print_error "MISSING"
          echo "  Create field: op item edit \"Jina.ai\" api_key=\"your_key\" --vault $vault_name"
        fi
      else
        print_warning "NOT FOUND"
        echo "  Create item: op item create --category=login --title=\"Jina.ai\" --vault=$vault_name api_key=\"your_key\""
      fi

      # Test 10: Check Notion item
      echo -n "Testing Notion MCP Suekou item... "
      if op item get "Notion MCP Suekou" --vault "$vault_name" &> /dev/null; then
        print_success "EXISTS"

        # Test 11: Read token field
        echo -n "Testing Notion token field... "
        if op read "op://$vault_name/Notion MCP Suekou/token" &> /dev/null; then
          print_success "READABLE"
        else
          print_error "MISSING"
          echo "  Create field: op item edit \"Notion MCP Suekou\" token=\"your_token\" --vault $vault_name"
        fi
      else
        print_warning "NOT FOUND"
        echo "  Create item: op item create --category=login --title=\"Notion MCP Suekou\" --vault=$vault_name token=\"your_token\""
      fi
    fi
  else
    print_warning "NOT AUTHENTICATED"
    echo "  Run: op signin"
  fi
else
  print_info "NOT FOUND (optional)"
  echo "  Using manual credentials mode"
fi

# Test 12: Environment variables are set
print_header "Environment Variables Check"

required_vars=(
  "JINA_API_KEY"
  "NOTION_API_TOKEN"
)

vars_set=0
vars_missing=0

for var in "${required_vars[@]}"; do
  echo -n "Checking $var... "
  if [ -n "${!var}" ]; then
    # Check if it's not a placeholder
    if [[ "${!var}" == *"xxxx"* ]] || [[ "${!var}" == *"your_"* ]]; then
      print_warning "PLACEHOLDER"
      echo "  Replace with real value in .envrc"
      ((vars_missing++))
    else
      # Show first 10 chars only for security
      value_preview="${!var:0:10}..."
      print_success "SET ($value_preview)"
      ((vars_set++))
    fi
  else
    print_error "NOT SET"
    echo "  Check .envrc or .envrc.local configuration"
    ((vars_missing++))
  fi
done

# Test 13: .gitignore configuration
print_header ".gitignore Configuration"

echo -n "Checking .envrc.local in .gitignore... "
if [ -f ".gitignore" ]; then
  if grep -q "^\.envrc\.local$" .gitignore 2>/dev/null; then
    print_success "IGNORED"
  else
    print_warning "NOT IGNORED"
    echo "  Add: echo '.envrc.local' >> .gitignore"
  fi
else
  print_warning "NO .gitignore"
  echo "  Create: echo '.envrc.local' > .gitignore"
fi

# Test 14: File permissions
print_header "Security Check"

if [ -f ".envrc" ]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    perms=$(stat -f "%OLp" .envrc)
  else
    perms=$(stat -c "%a" .envrc)
  fi
  echo -n "Checking .envrc permissions... "
  print_info "$perms"
fi

if [ -f ".envrc.local" ]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    perms=$(stat -f "%OLp" .envrc.local)
  else
    perms=$(stat -c "%a" .envrc.local)
  fi
  echo -n "Checking .envrc.local permissions... "
  if [ "$perms" = "600" ] || [ "$perms" = "400" ]; then
    print_success "$perms (secure)"
  else
    print_warning "$perms (consider: chmod 600 .envrc.local)"
  fi
fi

# Summary
print_header "Test Summary"

total_tests=$((tests_passed + tests_failed))
echo "Tests run: $total_tests"
print_success "Passed: $tests_passed"

if [ $tests_failed -gt 0 ]; then
  print_error "Failed: $tests_failed"
fi

if [ $vars_set -gt 0 ]; then
  print_success "Environment variables set: $vars_set"
fi

if [ $vars_missing -gt 0 ]; then
  print_warning "Environment variables missing/placeholder: $vars_missing"
fi

echo

if [ $tests_failed -eq 0 ] && [ $vars_missing -eq 0 ]; then
  print_success "All tests passed! Secret Manager Pro is configured correctly."
  echo
  echo "Your secrets are ready for use with Claude Code MCP servers!"
  exit 0
else
  print_warning "Some tests failed or configuration is incomplete"
  echo
  echo "Review the output above and fix any issues"
  echo "Then run this test again"
  exit 1
fi
