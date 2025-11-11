#!/usr/bin/env bash
# ALEX-STACK - Plugin Installer
# ============================================
#
# This script installs marketplace plugins into your project or Claude Code config.
#
# Usage:
#   ./scripts/install-plugin.sh <plugin-name> [destination]
#   ./scripts/install-plugin.sh secret-manager-pro          # Install to current directory
#   ./scripts/install-plugin.sh secret-manager-pro ~/my-project  # Install to specific location
#   ./scripts/install-plugin.sh --list                      # List available plugins

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

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MARKETPLACE_DIR="$REPO_ROOT/marketplace"

# Parse arguments
PLUGIN_NAME=""
DEST_DIR=""
LIST_PLUGINS=false

if [ "$1" = "--list" ]; then
  LIST_PLUGINS=true
elif [ "$1" = "--help" ] || [ -z "$1" ]; then
  echo "ALEX-STACK Plugin Installer"
  echo
  echo "Usage:"
  echo "  $0 <plugin-name> [destination]"
  echo "  $0 --list"
  echo "  $0 --help"
  echo
  echo "Arguments:"
  echo "  plugin-name       Name of plugin from marketplace/"
  echo "  destination       Installation directory (default: current directory)"
  echo
  echo "Options:"
  echo "  --list            List available plugins"
  echo "  --help            Show this help message"
  echo
  echo "Examples:"
  echo "  $0 secret-manager-pro"
  echo "  $0 secret-manager-pro ~/my-project"
  echo "  $0 --list"
  exit 0
else
  PLUGIN_NAME="$1"
  DEST_DIR="${2:-.}"
fi

# List plugins
if $LIST_PLUGINS; then
  print_header "Available Marketplace Plugins"

  if [ ! -d "$MARKETPLACE_DIR" ] || [ -z "$(ls -A "$MARKETPLACE_DIR" 2>/dev/null)" ]; then
    print_warning "No plugins found in marketplace"
    exit 0
  fi

  for plugin_dir in "$MARKETPLACE_DIR"/*; do
    if [ ! -d "$plugin_dir" ]; then
      continue
    fi

    plugin_name="$(basename "$plugin_dir")"
    package_json="$plugin_dir/package.json"

    echo "📦 $plugin_name"

    if [ -f "$package_json" ]; then
      # Extract description and version
      if command -v jq &> /dev/null; then
        description=$(jq -r '.description // "No description"' "$package_json")
        version=$(jq -r '.version // "unknown"' "$package_json")
        echo "   Version: $version"
        echo "   $description"
      else
        echo "   (install jq for more details)"
      fi
    fi

    echo
  done

  exit 0
fi

# Verify plugin exists
PLUGIN_DIR="$MARKETPLACE_DIR/$PLUGIN_NAME"

if [ ! -d "$PLUGIN_DIR" ]; then
  print_error "Plugin not found: $PLUGIN_NAME"
  echo
  echo "Available plugins:"
  ls -1 "$MARKETPLACE_DIR" 2>/dev/null || echo "  (none)"
  echo
  echo "Run '$0 --list' for more details"
  exit 1
fi

# Verify destination
if [ ! -d "$DEST_DIR" ]; then
  print_error "Destination directory does not exist: $DEST_DIR"
  exit 1
fi

print_header "Installing Plugin: $PLUGIN_NAME"

# Resolve absolute paths
DEST_DIR="$(cd "$DEST_DIR" && pwd)"
PLUGIN_INSTALL_DIR="$DEST_DIR/$PLUGIN_NAME"

print_info "Source: $PLUGIN_DIR"
print_info "Destination: $PLUGIN_INSTALL_DIR"
echo

# Check if already installed
if [ -d "$PLUGIN_INSTALL_DIR" ]; then
  print_warning "Plugin already installed at: $PLUGIN_INSTALL_DIR"
  read -p "Overwrite? [y/N]: " answer
  if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    print_info "Installation cancelled"
    exit 0
  fi
  echo
  print_info "Backing up existing installation..."
  if ! mv "$PLUGIN_INSTALL_DIR" "${PLUGIN_INSTALL_DIR}.backup.$(date +%Y%m%d_%H%M%S)"; then
    print_error "Failed to back up existing installation. Aborting."
    exit 1
  fi
  print_success "Backup created"
fi

# Copy plugin
print_info "Copying plugin files..."
cp -r "$PLUGIN_DIR" "$PLUGIN_INSTALL_DIR"
print_success "Plugin files copied"

# Make scripts executable
if [ -d "$PLUGIN_INSTALL_DIR/scripts" ]; then
  print_info "Making scripts executable..."
  chmod +x "$PLUGIN_INSTALL_DIR/scripts"/*.sh 2>/dev/null || true
  print_success "Scripts configured"
fi

# Show next steps
print_header "Installation Complete!"

print_success "Plugin installed to: $PLUGIN_INSTALL_DIR"
echo

# Check for README
if [ -f "$PLUGIN_INSTALL_DIR/README.md" ]; then
  print_info "Read the documentation: $PLUGIN_INSTALL_DIR/README.md"
fi

# Check for setup script
if [ -f "$PLUGIN_INSTALL_DIR/scripts/setup.sh" ]; then
  echo
  print_info "Next steps:"
  echo "  1. Navigate to plugin: cd $PLUGIN_INSTALL_DIR"
  echo "  2. Run setup script: ./scripts/setup.sh"
  echo "  3. Follow on-screen instructions"
  echo
  read -p "Run setup now? [Y/n]: " answer
  if [[ ! "$answer" =~ ^[Nn]$ ]]; then
    cd "$PLUGIN_INSTALL_DIR"
    ./scripts/setup.sh
  else
    echo
    print_info "Run setup manually later:"
    echo "  cd $PLUGIN_INSTALL_DIR && ./scripts/setup.sh"
  fi
else
  # No setup script, show manual instructions
  if [ -f "$PLUGIN_INSTALL_DIR/package.json" ]; then
    echo
    print_info "Plugin details:"

    if command -v jq &> /dev/null; then
      jq -r '.description // "No description available"' "$PLUGIN_INSTALL_DIR/package.json"
      echo

      # Show required dependencies
      requires=$(jq -r '.claude.requires // empty | to_entries[] | "  - \(.key): \(.value)"' "$PLUGIN_INSTALL_DIR/package.json" 2>/dev/null)
      if [ -n "$requires" ]; then
        echo "Required:"
        echo "$requires"
        echo
      fi
    fi
  fi

  echo "Check README.md for usage instructions"
fi

echo
print_success "Installation successful!"

exit 0
