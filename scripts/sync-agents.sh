#!/usr/bin/env bash
# ALEX-STACK - Sync Agents to Marketplace Plugins
# ============================================
#
# This script synchronizes agent files from .claude/agents/
# to marketplace plugins that use them.
#
# Usage:
#   ./scripts/sync-agents.sh              # Sync all agents
#   ./scripts/sync-agents.sh --dry-run    # Show what would be synced
#   ./scripts/sync-agents.sh --agent=name # Sync specific agent only

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

# Parse arguments
DRY_RUN=false
SPECIFIC_AGENT=""

for arg in "$@"; do
  case $arg in
    --dry-run)
      DRY_RUN=true
      ;;
    --agent=*)
      SPECIFIC_AGENT="${arg#*=}"
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo
      echo "Options:"
      echo "  --dry-run         Show what would be synced without actually syncing"
      echo "  --agent=NAME      Sync specific agent only (without .md extension)"
      echo "  --help            Show this help message"
      echo
      echo "Examples:"
      echo "  $0                                  # Sync all agents"
      echo "  $0 --dry-run                        # Dry run"
      echo "  $0 --agent=secret-xpert-light       # Sync specific agent"
      exit 0
      ;;
  esac
done

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Paths
AGENTS_DIR="$REPO_ROOT/.claude/agents"
MARKETPLACE_DIR="$REPO_ROOT/marketplace"

# Verify directories exist
if [ ! -d "$AGENTS_DIR" ]; then
  print_error "Agents directory not found: $AGENTS_DIR"
  exit 1
fi

if [ ! -d "$MARKETPLACE_DIR" ]; then
  print_error "Marketplace directory not found: $MARKETPLACE_DIR"
  exit 1
fi

print_header "ALEX-STACK Agent Sync"

if $DRY_RUN; then
  print_warning "DRY RUN MODE - No files will be modified"
fi

# Counters
total_synced=0
total_skipped=0
total_errors=0

# Function to get agents used by a plugin
get_plugin_agents() {
  local plugin_dir="$1"
  local package_json="$plugin_dir/package.json"

  if [ ! -f "$package_json" ]; then
    echo ""
    return
  fi

  # Extract agents array from package.json
  if command -v jq &> /dev/null; then
    jq -r '.claude.agents[]? // empty' "$package_json" 2>/dev/null
  else
    # Fallback if jq not available
    grep -o '"agents":\s*\[.*\]' "$package_json" | \
      sed 's/.*\[\(.*\)\].*/\1/' | \
      tr ',' '\n' | \
      sed 's/[" ]//g'
  fi
}

# Function to sync an agent to a plugin
sync_agent_to_plugin() {
  local agent_name="$1"
  local plugin_dir="$2"
  local plugin_name="$(basename "$plugin_dir")"

  local source_file="$AGENTS_DIR/${agent_name}.md"
  local dest_file="$plugin_dir/.claude/agents/${agent_name}.md"

  if [ ! -f "$source_file" ]; then
    print_warning "Source agent not found: $agent_name"
    ((total_errors++))
    return 1
  fi

  # Create destination directory if needed
  if ! $DRY_RUN; then
    mkdir -p "$(dirname "$dest_file")"
  fi

  # Check if files are identical
  if [ -f "$dest_file" ]; then
    if cmp -s "$source_file" "$dest_file"; then
      print_info "Skipped $agent_name → $plugin_name (already up-to-date)"
      ((total_skipped++))
      return 0
    fi
  fi

  # Sync file
  if $DRY_RUN; then
    print_success "[DRY RUN] Would sync: $agent_name → $plugin_name"
  else
    cp "$source_file" "$dest_file"
    print_success "Synced: $agent_name → $plugin_name"
  fi

  ((total_synced++))
  return 0
}

# Main sync logic
print_info "Scanning marketplace plugins..."
echo

plugin_count=0
for plugin_dir in "$MARKETPLACE_DIR"/*; do
  if [ ! -d "$plugin_dir" ]; then
    continue
  fi

  plugin_name="$(basename "$plugin_dir")"
  ((plugin_count++))

  echo "📦 Plugin: $plugin_name"

  # Get agents used by this plugin
  plugin_agents=$(get_plugin_agents "$plugin_dir")

  if [ -z "$plugin_agents" ]; then
    print_info "  No agents specified in package.json"
    echo
    continue
  fi

  # Sync each agent
  while IFS= read -r agent; do
    if [ -z "$agent" ]; then
      continue
    fi

    # If specific agent requested, skip others
    if [ -n "$SPECIFIC_AGENT" ] && [ "$agent" != "$SPECIFIC_AGENT" ]; then
      continue
    fi

    echo -n "  "
    sync_agent_to_plugin "$agent" "$plugin_dir"
  done <<< "$plugin_agents"

  echo
done

# Summary
print_header "Sync Summary"

echo "Plugins scanned: $plugin_count"
print_success "Agents synced: $total_synced"

if [ $total_skipped -gt 0 ]; then
  print_info "Agents skipped (up-to-date): $total_skipped"
fi

if [ $total_errors -gt 0 ]; then
  print_error "Errors: $total_errors"
fi

echo

if $DRY_RUN; then
  print_warning "This was a dry run. Run without --dry-run to actually sync files."
  exit 0
fi

if [ $total_synced -gt 0 ]; then
  print_success "Sync complete!"
  echo
  echo "Next steps:"
  echo "  1. Review changes: git diff"
  echo "  2. Test affected plugins"
  echo "  3. Commit: git add marketplace/ && git commit -m 'sync: Update agents in marketplace plugins'"
  echo "  4. Push: git push"
else
  print_info "All agents already up-to-date!"
fi

exit 0
