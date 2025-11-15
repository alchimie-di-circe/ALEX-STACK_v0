#!/bin/bash
# Verification script for 1Password + direnv configuration
# Tests that credentials are correctly loaded for MCP servers

echo "======================================"
echo "1Password + direnv Configuration Test"
echo "======================================"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

VAULT_NAME="AI DEV"
ERRORS=0

# 1. Check if 1Password CLI is installed
echo "1. Checking 1Password CLI installation..."
if command -v op >/dev/null 2>&1; then
    OP_VERSION=$(op --version 2>&1)
    echo -e "${GREEN}✓${NC} 1Password CLI installed: $OP_VERSION"
else
    echo -e "${RED}✗${NC} 1Password CLI not found"
    echo "   Install with: brew install 1password-cli"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 2. Check if authenticated
echo "2. Checking 1Password authentication..."
if op vault list >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} 1Password CLI authenticated"
else
    echo -e "${RED}✗${NC} 1Password CLI not authenticated"
    echo "   Run: op signin"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 3. Check if vault exists
echo "3. Checking for '${VAULT_NAME}' vault..."
if op vault list 2>/dev/null | grep -q "${VAULT_NAME}"; then
    echo -e "${GREEN}✓${NC} Vault '${VAULT_NAME}' found"
else
    echo -e "${RED}✗${NC} Vault '${VAULT_NAME}' not found"
    echo "   Available vaults:"
    op vault list 2>/dev/null | awk '{print "     - " $1}'
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 4. Check if Jina item exists
echo "4. Checking Jina API key item..."
JINA_ITEM="JINA.AI API key"
if op item get "${JINA_ITEM}" --vault "${VAULT_NAME}" >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Item '${JINA_ITEM}' found"
    
    # Try to read the credential field
    JINA_VALUE=$(op read "op://${VAULT_NAME}/${JINA_ITEM}/credential" 2>/dev/null)
    if [ -n "${JINA_VALUE}" ]; then
        echo -e "${GREEN}✓${NC} Field 'credential' exists and has value"
        echo "   Preview: ${JINA_VALUE:0:20}..."
    else
        echo -e "${RED}✗${NC} Field 'credential' not found or empty"
        echo "   Available fields:"
        op item get "${JINA_ITEM}" --vault "${VAULT_NAME}" --format json 2>/dev/null | jq -r '.fields[] | "     - \(.label // .id)"'
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "${RED}✗${NC} Item '${JINA_ITEM}' not found"
    echo "   Create with: op item create --category=login --title=\"${JINA_ITEM}\" --vault=\"${VAULT_NAME}\" credential[text]=\"your_key\""
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 5. Check if Notion item exists
echo "5. Checking Notion API token item..."
NOTION_ITEM="NOTION SUEKOU MCP server"
if op item get "${NOTION_ITEM}" --vault "${VAULT_NAME}" >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Item '${NOTION_ITEM}' found"
    
    # Try to read the TOKEN field
    NOTION_VALUE=$(op read "op://${VAULT_NAME}/${NOTION_ITEM}/TOKEN" 2>/dev/null)
    if [ -n "${NOTION_VALUE}" ]; then
        echo -e "${GREEN}✓${NC} Field 'TOKEN' exists and has value"
        echo "   Preview: ${NOTION_VALUE:0:20}..."
    else
        echo -e "${RED}✗${NC} Field 'TOKEN' not found or empty"
        echo "   Available fields:"
        op item get "${NOTION_ITEM}" --vault "${VAULT_NAME}" --format json 2>/dev/null | jq -r '.fields[] | "     - \(.label // .id)"'
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "${RED}✗${NC} Item '${NOTION_ITEM}' not found"
    echo "   Create with: op item create --category=login --title=\"${NOTION_ITEM}\" --vault=\"${VAULT_NAME}\" TOKEN[text]=\"your_token\""
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 6. Check direnv installation
echo "6. Checking direnv installation..."
if command -v direnv >/dev/null 2>&1; then
    DIRENV_VERSION=$(direnv version 2>&1)
    echo -e "${GREEN}✓${NC} direnv installed: $DIRENV_VERSION"
else
    echo -e "${RED}✗${NC} direnv not installed"
    echo "   Install with: brew install direnv"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 7. Check direnv shell hook
echo "7. Checking direnv shell hook..."
SHELL_RC=""
if [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
fi

if [ -n "$SHELL_RC" ] && [ -f "$SHELL_RC" ]; then
    if grep -q "direnv hook" "$SHELL_RC"; then
        echo -e "${GREEN}✓${NC} direnv hook found in $SHELL_RC"
    else
        echo -e "${YELLOW}⚠${NC} direnv hook not found in $SHELL_RC"
        echo "   Add with: echo 'eval \"\$(direnv hook bash)\"' >> $SHELL_RC"
        echo "   Then: source $SHELL_RC"
    fi
else
    echo -e "${YELLOW}⚠${NC} Could not determine shell config file"
fi
echo ""

# 8. Check if .envrc is allowed
echo "8. Checking direnv allow status..."
if [ -f ".envrc" ]; then
    if direnv status 2>/dev/null | grep -q "Found RC allowed true"; then
        echo -e "${GREEN}✓${NC} .envrc is allowed"
    else
        echo -e "${YELLOW}⚠${NC} .envrc needs to be allowed"
        echo "   Run: direnv allow"
    fi
else
    echo -e "${RED}✗${NC} .envrc file not found"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 9. Check environment variables
echo "9. Checking environment variables..."
if [ -n "${JINA_API_KEY}" ]; then
    echo -e "${GREEN}✓${NC} JINA_API_KEY is set"
    echo "   Preview: ${JINA_API_KEY:0:20}..."
else
    echo -e "${RED}✗${NC} JINA_API_KEY is not set"
    echo "   Run: direnv allow"
    ERRORS=$((ERRORS + 1))
fi

if [ -n "${NOTION_API_TOKEN}" ]; then
    echo -e "${GREEN}✓${NC} NOTION_API_TOKEN is set"
    echo "   Preview: ${NOTION_API_TOKEN:0:20}..."
else
    echo -e "${RED}✗${NC} NOTION_API_TOKEN is not set"
    echo "   Run: direnv allow"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 10. Check .mcp.json configuration
echo "10. Checking .mcp.json configuration..."
if [ -f ".mcp.json" ]; then
    echo -e "${GREEN}✓${NC} .mcp.json found"
    
    # Check if Jina MCP server is configured
    if grep -q "jina-mcp-server" .mcp.json; then
        echo -e "${GREEN}✓${NC} Jina MCP server configured"
    else
        echo -e "${RED}✗${NC} Jina MCP server not configured in .mcp.json"
        ERRORS=$((ERRORS + 1))
    fi
    
    # Check if Notion MCP server is configured
    if grep -q "notion" .mcp.json; then
        echo -e "${GREEN}✓${NC} Notion MCP server configured"
    else
        echo -e "${RED}✗${NC} Notion MCP server not configured in .mcp.json"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "${RED}✗${NC} .mcp.json not found"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Summary
echo "======================================"
echo "Summary"
echo "======================================"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo ""
    echo "Your configuration is ready. MCP servers should work correctly."
    echo ""
    echo "Next steps:"
    echo "  1. Start your IDE or terminal with Claude Code"
    echo "  2. Test Jina MCP server for web research"
    echo "  3. Test Notion MCP server for workspace integration"
else
    echo -e "${RED}✗ Found $ERRORS issue(s)${NC}"
    echo ""
    echo "Please address the issues above before using MCP servers."
fi
echo ""
