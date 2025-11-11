# Claude Code Architecture Research Report
## Marketplace, Plugins, Custom Agents, MCP Servers, and Devcontainers

**Research Date:** 2025-11-11
**Researcher:** Jino Agent
**Environment:** Claude Code v2.0.34 (Remote Cloud Environment)

---

## Executive Summary

After thorough research of the repository structure, documentation, and Claude Code environment, here are the key findings:

**CRITICAL INSIGHT:** There is NO official "Claude Code Marketplace" or "Plugin System" as of Claude Code v2.0.34. The current architecture relies on:
1. **Custom Agents** (markdown files in `.claude/agents/`)
2. **MCP Servers** (external services configured via `.mcp.json`)

The term "plugins" appears to be a FUTURE feature mentioned in forward-looking documentation, not a current capability.

---

## 1. Claude Code Marketplace

### Status: DOES NOT EXIST (as of v2.0.34)

**Research Findings:**
- No official marketplace found in Claude Code documentation
- No marketplace-related commands in Claude CLI
- No marketplace references in local repository documentation
- Anthropic documentation URLs return 404s or no relevant content

**Future Indicator:**
- The Archon research document (line 910) mentions "plugin ecosystem" as a **future** feature
- This suggests it may be planned but not implemented yet

**Current Reality:**
Custom agents and MCP servers serve the role that a marketplace might eventually fulfill.

---

## 2. Claude Code "Plugins" vs Custom Agents

### The Confusion: There Are No "Plugins"

**What People Call "Plugins":**
Actually refers to one of two things:
1. **Custom Agents** - Markdown files defining agent behavior
2. **MCP Servers** - External services providing tools/capabilities

### Custom Agents (`.claude/agents/*.md`)

**What They Are:**
- Markdown files that define specialized AI agent behavior
- Plain text files with instructions and role definitions
- Located in `.claude/agents/` directory

**How They Work:**
- Automatically discovered and loaded by Claude Code
- No installation required - just create/edit `.md` files
- Version controlled with your repository
- Each agent gets its own context window when invoked

**Example Agent Files in This Repo:**
```
.claude/agents/
├── coder.md              # Coding implementation specialist
├── jino-agent.md         # Web research specialist  
├── notion-scraper-expert.md
├── secret-xpert-light.md
├── stuck.md              # Human escalation agent
└── tester.md             # Visual testing with Playwright
```

**Key Characteristics:**
- ✅ Project-specific (not global)
- ✅ Version controlled
- ✅ No installation needed
- ✅ Portable across environments
- ✅ Self-contained in repository

### MCP Servers vs "Plugins"

**MCP (Model Context Protocol) Servers:**
- External services that provide tools to AI agents
- Configured in `.mcp.json` (project root)
- Run as separate processes
- Not "plugins" - they're protocol-based services

**Current MCP Servers in This Repo:**
```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"],
      "env": {}
    },
    "jina-mcp-server": {
      "command": "npx",
      "args": ["mcp-remote", "https://mcp.jina.ai/sse", ...]
    },
    "notion": {
      "command": "npx",
      "args": ["-y", "@suekou/mcp-notion-server"],
      "env": {...}
    }
  }
}
```

**Key Difference:**
- **Custom Agents:** Define WHAT to do (behavior, instructions)
- **MCP Servers:** Define HOW to do it (tools, capabilities)

**Example:**
- `jino-agent.md` (custom agent) says: "You are a research specialist"
- `jina-mcp-server` (MCP server) provides: Tools to actually search the web

---

## 3. MCP Servers - The Real "Extensions"

### What MCP Servers Actually Are

**Definition:**
Model Context Protocol servers are external services that:
- Run as separate processes (via npx, Docker, HTTP, etc.)
- Expose tools/capabilities to AI agents
- Follow the MCP specification
- Can be local or remote

### Installation Locations

**Project-Specific (`.mcp.json`):**
- Located in project root: `/home/user/ALEX-STACK_v0/.mcp.json`
- Only applies to the current project
- Version controlled with project
- ✅ **This is what your repo uses**

**Global Configuration (User-Level):**
- **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Linux:** `~/.config/claude/claude_desktop_config.json`
- **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`
- Applies to all Claude Code sessions for that user
- ❌ **Not found in current environment**

### Can MCP Servers Be Containerized?

**YES - Multiple Approaches:**

**1. Remote MCP Servers (Already Used):**
```json
{
  "jina-mcp-server": {
    "command": "npx",
    "args": ["mcp-remote", "https://mcp.jina.ai/sse", ...]
  }
}
```
- Runs on external server (Jina AI cloud)
- Container only needs network access
- ✅ Works in any environment

**2. Local MCP Servers via NPX:**
```json
{
  "playwright": {
    "command": "npx",
    "args": ["@playwright/mcp@latest"]
  }
}
```
- Runs locally via npx (downloads on demand)
- Needs Node.js in container
- ✅ Works if Node.js available

**3. Docker-Based MCP Servers:**
```json
{
  "archon": {
    "command": "docker",
    "args": ["run", "-p", "8051:8051", "archon-mcp"]
  }
}
```
- Runs MCP server in separate Docker container
- Container needs Docker socket access
- ⚠️ Requires special devcontainer configuration

---

## 4. Devcontainer Integration

### Current Status: NO DEVCONTAINER

**Research Findings:**
- No `.devcontainer/` directory in repository
- No `devcontainer.json` configuration
- Running in Claude Code's cloud remote environment

**Current Environment:**
```bash
CLAUDE_CODE_VERSION=2.0.34
CLAUDE_CODE_REMOTE=true
CLAUDE_CODE_REMOTE_ENVIRONMENT_TYPE=cloud_default
CLAUDE_CODE_CONTAINER_ID=container_011CUwzd3NvUYk3exNe4vheW...
```

### Do Custom Agents Need Devcontainers?

**NO - Custom agents do NOT require devcontainers**

**Why:**
- Custom agents are just markdown files
- Claude Code reads them directly from `.claude/agents/`
- No installation, compilation, or runtime needed
- Work in any environment (local, cloud, devcontainer)

### Do MCP Servers Need Devcontainers?

**NO - But devcontainers can help**

**MCP Servers Work Without Devcontainers:**
- Remote MCP servers (like Jina AI) work from anywhere
- NPX-based servers work if Node.js is available
- No special container configuration needed

**Devcontainers Can Provide:**
- ✅ Consistent Node.js version for NPX-based MCP servers
- ✅ Pre-installed dependencies
- ✅ Isolated environment
- ✅ Reproducible setup for team members

### Can Marketplace Items Be Installed in Devcontainers?

**N/A - No marketplace exists**

But IF a marketplace existed in the future:
- Custom agents (markdown): Yes, just files in repo
- MCP servers: Depends on implementation
  - Remote servers: Always work
  - Local servers: Need Node.js or Docker in container

---

## 5. Relationship Between Components

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│  CLAUDE CODE (Orchestrator)                                 │
│  - Reads .claude/CLAUDE.md for orchestrator instructions    │
│  - Loads .mcp.json for MCP server configurations            │
│  - Maintains 200k context window                            │
└─────────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┴──────────────────┐
        │                                     │
        ▼                                     ▼
┌────────────────────┐              ┌──────────────────────┐
│  CUSTOM AGENTS     │              │  MCP SERVERS         │
│  (.claude/agents/) │              │  (.mcp.json)         │
│                    │              │                      │
│  - jino-agent.md   │◄────────────►│  - playwright        │
│  - coder.md        │   Use tools  │  - jina-mcp-server   │
│  - tester.md       │   from MCP   │  - notion            │
│  - stuck.md        │              │                      │
│                    │              │  (Run as external    │
│  (Define behavior) │              │   processes)         │
└────────────────────┘              └──────────────────────┘
         │                                   │
         └───────────────┬───────────────────┘
                         │
                         ▼
              ┌──────────────────┐
              │  PROJECT TASKS   │
              │                  │
              │  Research →      │
              │  Implement →     │
              │  Test →          │
              │  Iterate         │
              └──────────────────┘
```

### Component Relationships

**1. Custom Agents ↔ .claude/agents/*.md**
- **Relationship:** 1:1 mapping
- **Storage:** Version controlled markdown files
- **Loading:** Automatic by Claude Code
- **Scope:** Project-specific

**2. MCP Servers ↔ .mcp.json**
- **Relationship:** 1:1 configuration
- **Storage:** JSON configuration file
- **Loading:** On Claude Code startup
- **Scope:** Project-specific (can be global)

**3. Custom Agents ↔ MCP Servers**
- **Relationship:** Agents USE tools provided by MCP servers
- **Example:** 
  - `jino-agent.md` (agent) uses `jina-mcp-server` (MCP) for web search
  - `tester.md` (agent) uses `playwright` (MCP) for browser automation

**4. Marketplace ↔ Everything**
- **Relationship:** DOES NOT EXIST (yet)
- **Future:** May provide discovery/installation of agents and MCP servers

**5. Devcontainer ↔ Everything**
- **Relationship:** OPTIONAL container for environment
- **Purpose:** Provides consistent runtime for MCP servers
- **Not Required:** System works without it

---

## 6. Best Practices - Self-Contained Repository

### Can You Bundle Everything for Portability?

**YES - Your Current Setup Already Does This!**

### What's Portable (Already Included)

✅ **Custom Agents:**
- Location: `.claude/agents/*.md`
- Portable: YES (just files)
- Version controlled: YES

✅ **MCP Configuration:**
- Location: `.mcp.json`
- Portable: YES (configuration is portable)
- Version controlled: YES

✅ **Orchestrator Instructions:**
- Location: `.claude/CLAUDE.md`
- Portable: YES
- Version controlled: YES

✅ **Documentation:**
- Location: `CLAUDE.md`, `AGENTS.md`, `README.md`
- Portable: YES
- Version controlled: YES

### What's NOT Portable (External Dependencies)

⚠️ **MCP Server Runtimes:**
- Node.js (for npx-based MCP servers)
- Network access (for remote MCP servers)
- API Keys (JINA_API_KEY, NOTION_API_TOKEN, etc.)

⚠️ **Environment Variables:**
- Need to be set in deployment environment
- Not stored in repository (for security)

### Making It Fully Self-Contained

**Option 1: Use Remote MCP Servers (Current Approach)**
```json
{
  "jina-mcp-server": {
    "command": "npx",
    "args": ["mcp-remote", "https://mcp.jina.ai/sse", ...]
  }
}
```
**Pros:**
- ✅ No local setup needed
- ✅ Works in any environment
- ✅ Automatically portable

**Cons:**
- ❌ Requires internet connectivity
- ❌ Depends on external service availability

**Option 2: Add Devcontainer**

Create `.devcontainer/devcontainer.json`:
```json
{
  "name": "Claude Code + Custom Agents",
  "image": "mcr.microsoft.com/devcontainers/typescript-node:20",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "version": "20"
    }
  },
  "customizations": {
    "vscode": {
      "extensions": []
    }
  },
  "forwardPorts": [3000, 8000, 8051],
  "postCreateCommand": "npm install -g @playwright/mcp @suekou/mcp-notion-server",
  "remoteEnv": {
    "JINA_API_KEY": "${localEnv:JINA_API_KEY}",
    "NOTION_API_TOKEN": "${localEnv:NOTION_API_TOKEN}"
  }
}
```

**Pros:**
- ✅ Consistent Node.js environment
- ✅ Pre-installed MCP dependencies
- ✅ Reproducible across machines
- ✅ Team-friendly

**Cons:**
- ❌ Adds complexity
- ❌ Larger initial download
- ❌ Still needs API keys

### Recommended Approach: Hybrid

**Current Setup (Keep):**
- ✅ Custom agents in `.claude/agents/`
- ✅ MCP configuration in `.mcp.json`
- ✅ Remote MCP servers where possible (Jina AI)

**Add for Better Portability:**
- ✅ `SETUP.md` with environment setup instructions
- ✅ `.env.example` for required environment variables
- ✅ OPTIONAL `.devcontainer/` for teams wanting consistency

**Example .env.example:**
```bash
# Required API Keys
JINA_API_KEY=your_key_here
NOTION_API_TOKEN=your_token_here

# Optional: Claude Code Configuration
CLAUDE_CODE_DEBUG=true
```

---

## 7. Architecture Summary - The Truth

### What This System Actually Is

**NOT:**
- ❌ A marketplace-based plugin system
- ❌ A traditional IDE extension system
- ❌ Dependent on proprietary plugins

**ACTUALLY:**
- ✅ A file-based custom agent system
- ✅ Uses MCP servers for external capabilities
- ✅ Self-contained and version-controlled
- ✅ Portable across environments

### Component Layers

**Layer 1: Claude Code (Base)**
- Official Anthropic CLI
- 200k context window
- Agent orchestration capabilities
- MCP protocol support

**Layer 2: Custom Agents (Your Code)**
- `.claude/agents/*.md` files
- Define specialized behaviors
- No installation required
- Version controlled

**Layer 3: MCP Servers (External Tools)**
- Configured in `.mcp.json`
- Provide capabilities (web, browser, etc.)
- Can be local or remote
- Standardized protocol

**Layer 4: Orchestrator (Your Instructions)**
- `.claude/CLAUDE.md`
- Defines workflow and rules
- Coordinates agents
- Maintains project state

### The Power of This Architecture

**No Marketplace Needed:**
- Share agents: Just share markdown files
- Share configs: Just share `.mcp.json`
- Share workflows: Just share documentation

**True Portability:**
- Git clone → Works immediately
- No installation steps
- No dependency hell
- No proprietary lock-in

**Maximum Flexibility:**
- Edit agents: Just edit markdown
- Add capabilities: Update `.mcp.json`
- Change workflow: Edit `.claude/CLAUDE.md`
- No compilation, no builds

---

## 8. Questions Answered

### Q1: What is Claude Code Marketplace?

**A:** It doesn't exist. No official marketplace for Claude Code as of v2.0.34. Future development may include one.

### Q2: What are Claude Code plugins vs custom agents?

**A:** "Plugins" is not an official term. People may use it to refer to:
- Custom agents (markdown files)
- MCP servers (external services)

Custom agents are behavior definitions; MCP servers provide tools.

### Q3: How are plugins different from MCP servers?

**A:** "Plugins" don't exist as a formal concept. MCP servers ARE the extensibility mechanism.

### Q4: Installation location (global vs project-specific)?

**A:**
- **Custom Agents:** Project-specific (`.claude/agents/`)
- **MCP Config:** Can be both:
  - Project: `.mcp.json` (current repo uses this)
  - Global: `~/.config/claude/claude_desktop_config.json` (not used)

### Q5: Can plugins be containerized?

**A:** N/A (no plugins), but MCP servers can be:
- Remote servers: Always work
- Local servers: Need appropriate runtime in container

### Q6: Do custom agents in `.claude/agents/*.md` need plugins?

**A:** NO. Custom agents are standalone markdown files. They may USE MCP servers for tools, but don't need "plugins."

### Q7: Do MCP servers in `.mcp.json` need plugins?

**A:** NO. MCP servers are the "plugin" equivalent. They provide capabilities directly.

### Q8: Can marketplace items be installed in devcontainers?

**A:** N/A (no marketplace), but custom agents work anywhere (they're just files).

### Q9: What's the relationship between everything?

**A:** See architecture diagram in Section 5. Summary:
- Claude Code orchestrates
- Custom agents define behaviors
- MCP servers provide tools
- Devcontainers (optional) provide runtime environment

### Q10: Self-contained repo with custom agents + MCP - does it need marketplace/plugins?

**A:** NO. Your current setup is already self-contained:
- Custom agents: In repo
- MCP config: In repo
- Documentation: In repo
- Only external dependency: MCP server runtimes (Node.js) and API keys

### Q11: Can you bundle everything in devcontainer for portability?

**A:** YES, and your repo is already 90% portable:
- ✅ Agents are portable (files)
- ✅ MCP config is portable (configuration)
- ⚠️ MCP runtimes need Node.js (add devcontainer for this)
- ⚠️ API keys need to be configured (use `.env.example`)

---

## 9. Recommendations

### For Your Current Repository

**Immediate Actions (No Changes Needed):**
1. ✅ **Keep current structure** - it's already optimal
2. ✅ **Continue using remote MCP servers** - maximum portability
3. ✅ **Keep agents in `.claude/agents/`** - version controlled and portable

**Optional Improvements for Team Use:**

**1. Add Environment Setup Documentation:**
```bash
# Create setup guide
touch .claude/SETUP.md
```

**2. Add Environment Variable Template:**
```bash
# Create .env.example
cat > .env.example << 'EOF'
# Required API Keys
JINA_API_KEY=your_jina_api_key_here
NOTION_API_TOKEN=your_notion_token_here

# Optional Configuration
CLAUDE_CODE_DEBUG=true
