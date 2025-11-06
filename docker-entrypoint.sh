#!/bin/bash
set -e

echo "========================================="
echo "E2B Sandbox - GitHub Copilot CLI"
echo "========================================="
echo ""

# Display versions
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"
echo "Copilot CLI installed: $(which copilot || echo 'Not found')"
echo ""

# Check if GitHub token is set
if [ -z "$GITHUB_TOKEN" ]; then
    echo "⚠️  GITHUB_TOKEN not set. You'll need to authenticate Copilot CLI."
    echo "   Run: copilot /login"
    echo ""
fi

# Start MCP servers if configured
echo "Starting MCP servers..."

# Start Playwright MCP server in background (if needed)
if command -v npx &> /dev/null; then
    echo "Playwright MCP server available via: npx @playwright/mcp@latest"
fi

# Display Awesome Copilot MCP server info
echo ""
echo "To start Awesome Copilot MCP server:"
echo "  1. Clone the repo: git clone https://github.com/BrettOJ/awesome-copilot-custom-mcp-server.git"
echo "  2. Run: dotnet run --project ./src/McpSamples.AwesomeCopilot.HybridApp -- --http"
echo "  3. Or use Docker: docker run -i --rm -p 8080:8080 awesome-copilot:latest"
echo ""

# Display Jina MCP info
if [ -n "$JINA_API_KEY" ]; then
    echo "✅ Jina API Key is set"
    echo "   Jina MCP server available via: npx mcp-remote https://mcp.jina.ai/sse"
else
    echo "⚠️  JINA_API_KEY not set. Jina MCP features will be limited."
fi

echo ""
echo "========================================="
echo "Sandbox ready! Type 'copilot' to start."
echo "========================================="
echo ""

# Execute the main command
exec "$@"
