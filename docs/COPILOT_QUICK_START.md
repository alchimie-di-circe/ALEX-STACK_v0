# Quick Start: GitHub Copilot CLI in E2B Sandbox

Get started with GitHub Copilot CLI in a secure E2B sandbox in under 5 minutes.

## 🚀 One-Command Setup

### Using the Launch Script (Recommended)

```bash
# Make the script executable (first time only)
chmod +x start-e2b-sandbox.sh

# Start the sandbox
./start-e2b-sandbox.sh
```

### Manual Setup

```bash
# Build and run the E2B sandbox
docker build -f ../e2b/Dockerfile.e2b -t alex-stack-e2b:latest . && \
docker run -it --rm \
  -v $(pwd):/workspace \
  -e GITHUB_TOKEN=$GITHUB_TOKEN \
  -e JINA_API_KEY=$JINA_API_KEY \
  -p 8080:8080 \
  alex-stack-e2b:latest
```

## 📝 Essential Commands

### Inside the Sandbox

```bash
# Authenticate Copilot CLI
copilot /login

# Start interactive session
copilot

# Run one-off commands
copilot -p "list uncommitted changes"
copilot -p "create a feature branch named 'new-feature'"
copilot -p "show me the last 5 commits"
```

## 🔧 MCP Servers

### Start Awesome Copilot MCP Server

**In a separate terminal:**

```bash
# Using Docker
git clone https://github.com/BrettOJ/awesome-copilot-custom-mcp-server.git
cd awesome-copilot-custom-mcp-server
docker build -t awesome-copilot:latest .
docker run -i --rm -p 8080:8080 awesome-copilot:latest
```

**Then enable in .mcp.json:**

```json
{
  "mcpServers": {
    "awesome-copilot": {
      "disabled": false
    }
  }
}
```

## 🎯 Common Use Cases

### 1. Code Analysis

```bash
copilot -p "analyze this repository and suggest improvements"
```

### 2. Git Operations

```bash
copilot -p "show uncommitted changes"
copilot -p "create a commit message for these changes"
```

### 3. Code Generation

```bash
copilot -p "create a React component for a user profile card"
copilot -p "write unit tests for the current file"
```

### 4. Documentation

```bash
copilot -p "generate documentation for this function"
copilot -p "explain what this code does"
```

## 🔐 Environment Variables

Set these before running:

```bash
export GITHUB_TOKEN="ghp_your_token_here"
export JINA_API_KEY="jina_your_key_here"  # Optional
```

## ✅ Verify Setup

```bash
# Check Node.js version (should be 22+)
node --version

# Check npm version (should be 10+)
npm --version

# Check Copilot CLI
copilot --version

# List available MCP servers
# In Claude Code: use the command palette
```

## 🐛 Quick Troubleshooting

**Can't authenticate?**
```bash
rm -rf ~/.config/github-copilot/
copilot /login
```

**Port already in use?**
```bash
# Change ports in docker run
docker run -p 8082:8080 ...
```

**Need to update Copilot?**
```bash
npm update -g @github/copilot
```

## 📚 Next Steps

- Read the full [E2B Setup Guide](./E2B_SETUP_GUIDE.md)
- Explore [Awesome Copilot prompts](https://github.com/github/awesome-copilot)
- Check [MCP documentation](https://modelcontextprotocol.io/)

---

**Happy coding with AI! 🤖✨**
