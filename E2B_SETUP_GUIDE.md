# E2B Sandbox Setup Guide for GitHub Copilot CLI

This guide explains how to set up an E2B (Execute to Build) sandbox environment with GitHub Copilot CLI and the awesome-copilot MCP server for secure, isolated AI-assisted development.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Installation Methods](#installation-methods)
  - [Method 1: Using Docker](#method-1-using-docker)
  - [Method 2: Using E2B Cloud](#method-2-using-e2b-cloud)
  - [Method 3: Local Setup](#method-3-local-setup)
- [GitHub Copilot CLI Setup](#github-copilot-cli-setup)
- [Awesome Copilot MCP Server Setup](#awesome-copilot-mcp-server-setup)
- [MCP Servers Configuration](#mcp-servers-configuration)
- [Usage Examples](#usage-examples)
- [Troubleshooting](#troubleshooting)

---

## Overview

This setup creates a secure, isolated sandbox environment where you can:

- **Safely run GitHub Copilot CLI** with limited access to your system
- **Use MCP (Model Context Protocol) servers** to enhance Copilot capabilities
- **Access community prompts and instructions** via the awesome-copilot MCP server
- **Execute AI-generated code** in an isolated environment
- **Integrate with existing Claude Code orchestration system**

### What is E2B?

E2B is an open-source cloud runtime for AI agents that provides:
- **Secure sandboxing**: Isolated environments preventing accidental system changes
- **Fast startup**: Sandboxes spin up in <200ms
- **Pre-installed tools**: Common development packages ready to use
- **File operations**: Safe upload/download within the sandbox

---

## Prerequisites

Before starting, ensure you have:

1. **GitHub Copilot Subscription**
   - Individual, Business, Enterprise, or Pro+ plan
   - Access to GitHub Copilot CLI (check with your organization if using a team account)

2. **System Requirements**
   - Node.js 22 or later
   - npm 10 or later
   - Docker Desktop (for containerized setup)
   - Git

3. **Optional but Recommended**
   - E2B account (free tier available at [e2b.dev](https://e2b.dev))
   - .NET 9 SDK (for awesome-copilot MCP server)
   - JINA_API_KEY environment variable (for Jina MCP server)

---

## Quick Start

### Method 1: Using the Launch Script (Easiest)

```bash
# Make the script executable (first time only)
chmod +x start-e2b-sandbox.sh

# Start the sandbox - it will auto-build if needed
./start-e2b-sandbox.sh

# Inside the container, install and authenticate Copilot CLI
npm install -g @github/copilot
copilot /login
copilot
```

### Method 2: Using Docker (Manual)

```bash
# 1. Build the E2B sandbox Docker image
docker build -f Dockerfile.e2b -t alex-stack-e2b:latest .

# 2. Run the container
docker run -it --rm \
  -v $(pwd):/workspace \
  -e GITHUB_TOKEN=$GITHUB_TOKEN \
  -e JINA_API_KEY=$JINA_API_KEY \
  -p 8080:8080 \
  -p 8081:8081 \
  alex-stack-e2b:latest

# 3. Inside the container, install and authenticate Copilot CLI
npm install -g @github/copilot
copilot /login

# 4. Start using Copilot
copilot
```

---

## Installation Methods

### Method 1: Using Docker

This method provides the most isolation and is recommended for security.

**Step 1: Build the Image**

```bash
docker build -f Dockerfile.e2b -t alex-stack-e2b:latest .
```

**Step 2: Run the Container**

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -e GITHUB_TOKEN=$GITHUB_TOKEN \
  -e JINA_API_KEY=$JINA_API_KEY \
  -p 8080:8080 \
  -p 8081:8081 \
  --name alex-copilot-sandbox \
  alex-stack-e2b:latest
```

**Environment Variables:**
- `GITHUB_TOKEN`: Your GitHub personal access token (for Copilot authentication)
- `JINA_API_KEY`: Your Jina AI API key (optional, for enhanced web search)

**Ports:**
- `8080`: Awesome Copilot MCP server
- `8081`: Additional MCP services

### Method 2: Using E2B Cloud

**Step 1: Install E2B CLI**

```bash
npm install -g @e2b/cli
```

**Step 2: Login to E2B**

```bash
e2b login
```

**Step 3: Create a Custom Sandbox Template**

```bash
# Initialize E2B template
e2b template init

# Build and deploy
e2b template build
```

**Step 4: Start the Sandbox**

```python
# Using Python SDK
from e2b import Sandbox

sandbox = Sandbox(template="alex-stack-copilot-sandbox")

# Install Copilot CLI
sandbox.process.start_and_wait("npm install -g @github/copilot")

# Run Copilot
process = sandbox.process.start("copilot")
```

### Method 3: Local Setup

For development without containerization:

**Step 1: Install GitHub Copilot CLI**

```bash
npm install -g @github/copilot
```

**Step 2: Authenticate**

```bash
copilot /login
```

**Step 3: Verify Installation**

```bash
copilot --version
```

---

## GitHub Copilot CLI Setup

### Authentication

**Option 1: Interactive Login**

```bash
copilot /login
```

Follow the browser prompt to authenticate with your GitHub account.

**Option 2: Using GitHub Token**

```bash
export GITHUB_TOKEN="your_github_token_here"
copilot
```

### Basic Usage

**Start Interactive Session:**

```bash
copilot
```

**Run One-off Commands:**

```bash
copilot -p "list uncommitted changes"
copilot --prompt "create a new feature branch"
```

**Common Commands:**

```bash
# Git operations
copilot -p "show me the last 5 commits"
copilot -p "create a branch for new feature"

# Code generation
copilot -p "create a React component for a todo list"
copilot -p "write unit tests for this file"

# Repository navigation
copilot -p "find all TypeScript files"
copilot -p "show me files that haven't been committed"
```

---

## Awesome Copilot MCP Server Setup

The Awesome Copilot MCP server provides access to community-contributed prompts, instructions, and chat modes from the [github/awesome-copilot](https://github.com/github/awesome-copilot) repository.

### Installation

**Option 1: Using Docker**

```bash
# Clone the repository
git clone https://github.com/BrettOJ/awesome-copilot-custom-mcp-server.git
cd awesome-copilot-custom-mcp-server

# Build the Docker image
docker build -t awesome-copilot:latest .

# Run the server
docker run -i --rm -p 8080:8080 awesome-copilot:latest
```

**Option 2: Using .NET**

```bash
# Clone the repository
git clone https://github.com/BrettOJ/awesome-copilot-custom-mcp-server.git
cd awesome-copilot-custom-mcp-server

# Run the server
dotnet run --project ./src/McpSamples.AwesomeCopilot.HybridApp -- --http
```

### Enabling in Claude Code

After starting the Awesome Copilot MCP server:

1. Edit `.mcp.json`:

```json
{
  "mcpServers": {
    "awesome-copilot": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "http://localhost:8080"
      ],
      "env": {},
      "disabled": false
    }
  }
}
```

2. Restart Claude Code to load the server

### Available Tools

The Awesome Copilot MCP server provides:

- `search_instructions`: Search for prompts and instructions
- `load_instruction`: Load a specific instruction into your workflow
- `list_categories`: Browse available categories
- `preview_instruction`: Preview instruction content

---

## MCP Servers Configuration

The sandbox includes three MCP servers configured in `.mcp.json`:

### 1. Playwright MCP Server

**Purpose:** Visual testing and browser automation

```json
"playwright": {
  "command": "npx",
  "args": ["@playwright/mcp@latest"],
  "env": {}
}
```

**Usage:**
- Take screenshots of web pages
- Test UI interactions
- Verify responsive design
- Check console errors

### 2. Jina MCP Server

**Purpose:** Web search and content extraction

```json
"jina-mcp-server": {
  "command": "npx",
  "args": [
    "mcp-remote",
    "https://mcp.jina.ai/sse",
    "--header",
    "Authorization: Bearer ${JINA_API_KEY}"
  ]
}
```

**Features:**
- Jina Reader: Convert URLs to clean markdown
- Web Search: AI-powered web search
- Image Search: Find and analyze images
- Semantic search and content ranking

### 3. Awesome Copilot MCP Server

**Purpose:** Community prompts and instructions

```json
"awesome-copilot": {
  "command": "npx",
  "args": [
    "mcp-remote",
    "http://localhost:8080"
  ],
  "env": {},
  "disabled": true,
  "description": "Awesome Copilot MCP server. Enable after starting locally."
}
```

---

## Usage Examples

### Example 1: Using Copilot CLI with Claude Code Orchestration

```bash
# In your E2B sandbox
cd /workspace

# Start Claude Code
claude

# Ask Claude to use Copilot CLI
You: "Use the copilot CLI to analyze uncommitted changes and suggest improvements"

# Claude will orchestrate the coder subagent to use copilot CLI
```

### Example 2: Searching Community Prompts

With Awesome Copilot MCP server running:

```bash
# In Claude Code or directly via MCP
# Search for React prompts
search_instructions query="React best practices"

# Load a specific instruction
load_instruction id="react-component-template"
```

### Example 3: Safe Code Execution

```bash
# Generate code with Copilot
copilot -p "create a Python script to process CSV files"

# Execute in sandbox (isolated)
python generated_script.py

# Changes only affect sandbox, not your host system
```

---

## Troubleshooting

### Issue: Copilot CLI Won't Authenticate

**Solution:**

```bash
# Clear existing credentials
rm -rf ~/.config/github-copilot/

# Try login again
copilot /login

# Or use token directly
export GITHUB_TOKEN="your_token"
copilot
```

### Issue: MCP Server Connection Failed

**Solution:**

```bash
# Check if server is running
curl http://localhost:8080

# Verify ports are exposed in Docker
docker ps

# Check .mcp.json configuration
cat .mcp.json
```

### Issue: Node.js Version Too Old

**Solution:**

```bash
# Update Node.js to version 22+
nvm install 22
nvm use 22

# Or in Docker, rebuild with correct base image
# See Dockerfile.e2b
```

### Issue: Permission Denied in Sandbox

**Solution:**

```bash
# Check file permissions
ls -la /workspace

# Fix permissions
chmod +x /workspace/script.sh

# Or run Docker with user mapping
docker run --user $(id -u):$(id -g) ...
```

### Issue: Awesome Copilot MCP Server Not Responding

**Solution:**

```bash
# Check if .NET 9 SDK is installed
dotnet --version

# Install if missing
wget https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --version 9.0

# Restart the server
dotnet run --project ./src/McpSamples.AwesomeCopilot.HybridApp -- --http
```

---

## Security Best Practices

1. **Always use sandboxes for AI-generated code**: Never run untrusted code directly on your host
2. **Limit mounted directories**: Only mount necessary project directories
3. **Use read-only mounts when possible**: Add `:ro` to volume mounts
4. **Rotate GitHub tokens regularly**: Use tokens with minimal required scopes
5. **Review Copilot suggestions**: Always review before executing commands
6. **Keep sandbox updated**: Rebuild Docker images regularly for security patches

---

## Integration with Existing Claude Code System

This E2B sandbox integrates seamlessly with your existing Claude Code orchestration:

### In CLAUDE.md

Add E2B sandbox awareness:

```markdown
## Using E2B Sandbox for Code Execution

When the coder subagent generates code that needs testing:

1. Delegate to E2B sandbox for execution
2. Use copilot CLI for code analysis
3. Verify with tester subagent using Playwright
4. Return results safely isolated
```

### In coder.md

```markdown
## Code Execution Safety

When implementing code:

1. Generate code as usual
2. If execution testing needed, request E2B sandbox
3. Execute in isolated environment
4. Report results without system access
```

---

## Additional Resources

- [E2B Documentation](https://e2b.dev/docs)
- [GitHub Copilot CLI Docs](https://docs.github.com/copilot/how-tos/set-up/install-copilot-cli)
- [Awesome Copilot Repository](https://github.com/github/awesome-copilot)
- [Awesome Copilot MCP Server](https://github.com/BrettOJ/awesome-copilot-custom-mcp-server)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Jina AI MCP Server](https://jina.ai/mcp)

---

## Contributing

To improve this setup:

1. Fork the repository
2. Create a feature branch
3. Test your changes in an E2B sandbox
4. Submit a pull request

---

## License

This configuration is part of the ALEX-STACK_v0 project and follows the same license terms.

---

**Ready to start?** Run `docker build -f Dockerfile.e2b -t alex-stack-e2b:latest .` and begin your secure AI-assisted development journey! 🚀
