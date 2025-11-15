# Archon by Cole Medin - Comprehensive Research Report

**Research Date:** November 5, 2025
**Researched by:** Jino Agent (Web Research Specialist)
**Primary Sources:** GitHub, Community Forums, Technical Documentation, YouTube Content

---

## 📋 Table of Contents

1. [Executive Summary](#executive-summary)
2. [What is Archon?](#what-is-archon)
3. [How Archon Improves AI-Assisted Coding Workflows](#how-archon-improves-ai-assisted-coding-workflows)
4. [Power User Workflows & Best Practices](#power-user-workflows--best-practices)
5. [Configuration Examples](#configuration-examples)
6. [Archon MCP Implementation in Claude Code](#archon-mcp-implementation-in-claude-code)
7. [Installation Guide](#installation-guide)
8. [Known Issues & Limitations](#known-issues--limitations)
9. [Community & Resources](#community--resources)
10. [Conclusion](#conclusion)

---

## Executive Summary

**Archon OS** is a revolutionary open-source project created by **Cole Medin** that serves as the world's first "command center" specifically designed for AI coding assistants. It acts as both a sleek web interface for developers and a powerful Model Context Protocol (MCP) server for AI assistants, creating a unified knowledge ecosystem that elevates AI-driven coding workflows.

**Key Highlights:**
- ⭐ **Status:** Beta (actively maintained)
- 👨‍💻 **Creator:** Cole Medin (@coleam00) - AI agent expert with 100,000+ YouTube subscribers
- 🏗️ **Architecture:** True microservices architecture
- 🔌 **Integration:** Works with Claude Code, Cursor, Windsurf, Kilo, and other AI coding assistants
- 🌐 **Community:** Backed by vibrant Dynamous AI community

---

## What is Archon?

### Overview

Archon OS represents a paradigm shift in AI-assisted development by providing:

**For Developers:**
- A sleek web interface to manage knowledge, context, and tasks for projects
- Centralized project management hub
- Document version control and collaborative editing
- Real-time progress tracking

**For AI Coding Assistants:**
- A Model Context Protocol (MCP) server to access and leverage the same knowledge base
- Structured context delivery
- Task management capabilities
- RAG (Retrieval-Augmented Generation) integration

### Core Philosophy

> "Context engineering is the new vibe coding - it's the way to actually make AI coding assistants work."
> — Cole Medin

Archon's approach centers on **structured knowledge management** rather than ad-hoc prompting, enabling AI assistants to:
- Access curated project context
- Understand hierarchical task structures
- Leverage documentation and code examples
- Maintain consistency across coding sessions

---

## How Archon Improves AI-Assisted Coding Workflows

### 1. **Knowledge Management Revolution**

#### Smart Web Crawling
- **Automatic Documentation Discovery:** Detects and crawls entire documentation sites
- **Sitemap Processing:** Intelligently navigates sitemaps for comprehensive coverage
- **Individual Page Extraction:** Handles single-page documentation efficiently
- **Multi-Format Support:** Accepts PDFs, Word documents, Markdown, and plain text
- **Intelligent Chunking:** Processes documents for optimal AI retrieval

**Impact:** No more manual copy-pasting of documentation. Archon crawls, indexes, and serves documentation automatically to your AI assistant.

### 2. **Hierarchical Project Organization**

```
Project (e.g., "E-commerce Platform")
  ├── Feature (e.g., "User Authentication")
  │   ├── Task: "Implement JWT tokens"
  │   ├── Task: "Create login form"
  │   └── Task: "Add password reset flow"
  ├── Feature (e.g., "Payment Integration")
  │   ├── Task: "Stripe API integration"
  │   └── Task: "Payment confirmation emails"
  └── Documents
      ├── Architecture Overview
      ├── API Documentation
      └── Security Guidelines
```

**Benefits:**
- AI understands project structure
- Tasks are properly scoped
- Context is automatically provided based on current work
- Progress tracking across features

### 3. **RAG-Powered Context Delivery**

Archon uses sophisticated RAG strategies:
- **Hybrid Search:** Combines keyword and semantic search
- **Result Reranking:** Prioritizes most relevant context
- **Embeddings:** Multi-LLM support (OpenAI, Ollama, Google Gemini)
- **Real-Time Streaming:** Low-latency context delivery

**Result:** AI assistants receive precisely the context they need, reducing hallucinations and improving code accuracy.

### 4. **Multi-LLM Support**

Archon is LLM-agnostic, supporting:
- **OpenAI** (GPT-4, GPT-3.5)
- **Ollama** (Local models)
- **Google Gemini**
- **Future models** (extensible architecture)

**Advantage:** Choose the best model for each task without losing your knowledge base.

### 5. **Collaborative Features**

- **Multi-User Support:** Teams can build knowledge bases together
- **Live Updates:** WebSocket-based real-time collaboration
- **Version Control:** Document history and rollback
- **Background Processing:** Asynchronous operations don't block workflow

---

## Power User Workflows & Best Practices

### Cole Medin's Golden Rules for AI Coding

#### Rule #1: Keep Files Under 500 Lines
```
✅ GOOD: Multiple focused files
❌ BAD: 2000-line monolithic file

Why? AI hallucinates beyond ~500 lines per file
```

#### Rule #2: One Task Per Request
```
✅ GOOD: "Add error handling to the login function"
❌ BAD: "Refactor auth, add tests, update docs, fix bugs"

Why? AI performs better with single, focused requests
```

#### Rule #3: Use Structured Documents
```
✅ GOOD: Architecture.md, Tasks.md, API_Spec.md in Archon
❌ BAD: Verbal explanations in every prompt

Why? Prevents AI from making erroneous assumptions
```

#### Rule #4: Be Specific in Initial Prompts
```
✅ GOOD: "Create a React component using TypeScript,
         styled-components, and following the patterns
         in our architecture doc"
❌ BAD: "Make a button component"

Why? Initial prompt determines entire project direction
```

#### Rule #5: Manage Conversations Effectively
```
✅ GOOD: Start fresh conversation when switching context
❌ BAD: One mega-conversation for entire project

Why? Context drift and confusion accumulate over time
```

### Power User Workflow: The Archon Method

#### Phase 1: Project Setup (One-Time)
1. **Create Project in Archon**
   - Define project name and description
   - Set up hierarchical structure

2. **Crawl Documentation**
   - Add documentation URLs (React, Next.js, Tailwind, etc.)
   - Let Archon crawl and index automatically
   - Upload custom documents (architecture, specs)

3. **Define Global Rules**
   - Create `GLOBAL_RULES.md` with coding standards
   - Define naming conventions
   - Specify tech stack preferences

4. **Structure Features & Tasks**
   - Break project into features
   - AI-assisted task generation
   - Prioritize and organize

#### Phase 2: Development Loop (Ongoing)
```
1. Open AI Assistant (Claude Code, Cursor, etc.)
   ↓
2. AI automatically connects to Archon MCP server
   ↓
3. AI loads relevant context (docs, tasks, rules)
   ↓
4. You: "Implement the next authentication task"
   ↓
5. AI: Accesses task details, architecture docs, code examples
   ↓
6. AI: Generates code following your standards
   ↓
7. You review, refine with specific feedback
   ↓
8. Mark task complete in Archon
   ↓
9. Repeat with next task
```

#### Phase 3: Refinement (Advanced)
```
You: "refine"
   ↓
Archon kicks off multi-agent workflow:
   ├── Prompt Refiner Agent
   ├── Tools Refiner Agent
   └── Agent Definition Refiner Agent
   ↓
Parallel improvements to agent capabilities
```

### Real-World Power User Examples

#### Example 1: Building a SaaS Application
```
Project: "TaskMaster SaaS"
├── Documents Crawled:
│   ├── Next.js 14 App Router docs
│   ├── Prisma documentation
│   ├── Stripe API reference
│   └── Custom architecture guide
├── Features:
│   ├── User Management (8 tasks)
│   ├── Project Management (12 tasks)
│   ├── Billing System (6 tasks)
│   └── Team Collaboration (10 tasks)
└── Global Rules:
    ├── TypeScript strict mode
    ├── Server components by default
    ├── Prisma for all DB access
    └── tRPC for API layer

Result: AI builds feature by feature with consistent
        architecture, proper error handling, and best practices
```

#### Example 2: Documentation-Heavy Integration
```
Project: "Enterprise API Integration"
├── Crawled: Entire 200-page vendor API documentation
├── AI can now:
│   ├── Answer questions about API endpoints
│   ├── Generate correct request formats
│   ├── Handle edge cases mentioned in docs
│   └── Follow authentication patterns
└── Developer: Focuses on business logic, not docs

Time Saved: 80% reduction in documentation lookups
```

---

## Configuration Examples

### Environment Configuration (.env)

```bash
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9... # Use LEGACY key

# For Local Supabase
# SUPABASE_URL=http://host.docker.internal:8000

# Port Configuration
ARCHON_MCP_PORT=8051
FRONTEND_PORT=3000
BACKEND_PORT=8000

# LLM Configuration (Optional)
OPENAI_API_KEY=sk-...
GOOGLE_API_KEY=...

# Development Mode
NODE_ENV=development
```

### Docker Compose (Hybrid Mode - Recommended)

```yaml
# Automatically handled by `make dev` command
# Backend in Docker, Frontend local with hot reload

services:
  archon-backend:
    ports:
      - "8000:8000"
      - "8051:8051"
    environment:
      - SUPABASE_URL=${SUPABASE_URL}
      - SUPABASE_SERVICE_KEY=${SUPABASE_SERVICE_KEY}
```

### Project Structure Example

```
archon-project/
├── .env                          # Environment configuration
├── docker-compose.yml           # Docker services
├── frontend/
│   ├── src/
│   │   ├── components/         # React components
│   │   ├── pages/              # Next.js pages
│   │   └── lib/                # Utilities
│   └── package.json
├── backend/
│   ├── src/
│   │   ├── mcp/                # MCP server implementation
│   │   ├── rag/                # RAG engine
│   │   └── api/                # REST API endpoints
│   └── requirements.txt
└── migration/
    └── complete_setup.sql      # Database schema
```

---

## Archon MCP Implementation in Claude Code

### Overview

Archon exposes an MCP (Model Context Protocol) server that allows Claude Code and other AI assistants to:
- Query project knowledge base
- Access task information
- Retrieve documentation
- Execute project operations

### MCP Server Endpoint

**Default Configuration:**
- **Protocol:** HTTP with SSE (Server-Sent Events)
- **Port:** 8051
- **Endpoint:** `http://localhost:8051/mcp`

### Configuration Methods for Claude Code

#### Method 1: Command Line (Recommended for Testing)

```bash
# Add Archon MCP server
claude mcp add archon --url http://localhost:8051/mcp

# Verify it's added
claude mcp list
```

Expected output:
```
archon: http://127.0.0.1:8051
```

#### Method 2: .mcp.json Configuration (Recommended for Permanent Setup)

**Location:** `/root/workspace/.mcp.json`

**Option A: SSE Transport (Direct Connection)**
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
      "args": [
        "mcp-remote",
        "https://mcp.jina.ai/sse",
        "--header",
        "Authorization: Bearer ${JINA_API_KEY}"
      ]
    },
    "archon": {
      "url": "http://localhost:8051/mcp",
      "transport": "sse",
      "disabled": false
    }
  }
}
```

**Option B: STDIO with mcp-remote Proxy**
```json
{
  "mcpServers": {
    "archon": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "http://localhost:8051/mcp"
      ]
    }
  }
}
```

**Option C: Windows-Specific (cmd wrapper)**
```json
{
  "mcpServers": {
    "archon": {
      "command": "cmd",
      "args": [
        "/c",
        "npx",
        "-y",
        "mcp-remote",
        "http://localhost:8051/mcp"
      ]
    }
  }
}
```

#### Method 3: Claude Desktop Config (For Reference)

**Location:** `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS)

```json
{
  "mcpServers": {
    "archon": {
      "transport": "sse",
      "serverUrl": "http://localhost:8051/sse"
    }
  }
}
```

### Verification Steps

1. **Start Archon:**
   ```bash
   cd archon
   make dev  # or make dev-docker
   ```

2. **Verify Archon is Running:**
   ```bash
   curl http://localhost:8051/health
   # Should return: {"status": "healthy"}
   ```

3. **Check MCP Endpoint:**
   ```bash
   curl http://localhost:8051/mcp
   # Should return MCP protocol response
   ```

4. **Restart Claude Code:**
   ```bash
   # Close and reopen Claude Code terminal
   claude
   ```

5. **Test MCP Connection in Claude Code:**
   ```
   You: "List my Archon projects"
   Claude: [Should query Archon MCP and return projects]
   ```

### Available MCP Tools

Once connected, Claude Code can use these Archon tools:

```typescript
// Query knowledge base
archon_query_rag({
  query: "How do I implement authentication?",
  project_id: "uuid"
})

// Get tasks
archon_get_tasks({
  project_id: "uuid",
  feature_id: "uuid" // optional
})

// Get project info
archon_get_project({
  project_id: "uuid"
})

// Create task
archon_create_task({
  project_id: "uuid",
  feature_id: "uuid",
  title: "Implement login form",
  description: "Create React component for login"
})

// Update task status
archon_update_task({
  task_id: "uuid",
  status: "completed"
})
```

### Integration Workflow

```
User opens Claude Code
    ↓
Claude Code loads .mcp.json
    ↓
Connects to Archon MCP server (localhost:8051)
    ↓
User: "What's my next task for the auth feature?"
    ↓
Claude Code: Calls archon_get_tasks()
    ↓
Archon: Returns task list with context
    ↓
Claude Code: "Your next task is: Implement JWT validation.
              I can see from your architecture docs that
              you're using jose library. Let me help you
              implement this following your patterns..."
    ↓
User: "Yes, do it"
    ↓
Claude generates code with full context
    ↓
User reviews and accepts
    ↓
Claude: Calls archon_update_task(status="completed")
    ↓
Task marked complete in Archon ✅
```

---

## Installation Guide

### Prerequisites

- **Docker Desktop** (required)
- **Node.js 18+** (required)
- **Supabase Account** (free tier works)
  - OR Local Supabase installation

### Step-by-Step Installation

#### 1. Clone Repository (Stable Branch)

```bash
# Clone stable branch (recommended)
git clone -b stable https://github.com/coleam00/archon.git
cd archon
```

**Why stable branch?**
The `main` branch may have experimental features. The `stable` branch is tested and reliable.

#### 2. Setup Supabase

**Option A: Cloud Supabase (Easiest)**

1. Go to [supabase.com](https://supabase.com)
2. Create a new project (free tier is sufficient)
3. Navigate to Project Settings → API
4. Copy:
   - Project URL (e.g., `https://xxx.supabase.co`)
   - Service Role Key (⚠️ Use the **LEGACY** key - the longer one)

**Option B: Local Supabase**

```bash
# Install Supabase CLI
npm install -g supabase

# Initialize local Supabase
supabase init
supabase start

# Use these values:
# URL: http://host.docker.internal:8000
# Key: (provided in CLI output)
```

#### 3. Configure Environment

```bash
# Copy example environment file
cp .env.example .env

# Edit .env with your favorite editor
nano .env
```

**Required variables:**
```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Optional (for local Supabase)
# SUPABASE_URL=http://host.docker.internal:8000
```

#### 4. Setup Database Schema

```bash
# 1. Open your Supabase project
# 2. Go to SQL Editor
# 3. Open migration/complete_setup.sql
# 4. Copy entire contents
# 5. Paste into SQL Editor
# 6. Click "Run"
```

This creates all necessary tables, functions, and RLS policies.

#### 5. Start Archon

**Option A: Hybrid Mode (Recommended for Development)**
```bash
make dev
```
- Backend runs in Docker
- Frontend runs locally with hot reload
- Best for active development

**Option B: Full Docker Mode**
```bash
make dev-docker
```
- Everything runs in Docker
- Consistent environment
- Best for production-like testing

#### 6. Access Archon

Open browser to: `http://localhost:3000`

You should see the Archon web interface!

#### 7. Create Your First Project

1. Click "New Project"
2. Enter project name and description
3. Add documentation URLs to crawl
4. Create features and tasks
5. Upload any custom documents

#### 8. Connect AI Assistant

Add Archon to your `.mcp.json` (see configuration section above)

### Troubleshooting Installation

#### Issue: Docker Container Won't Start

```bash
# Check Docker is running
docker ps

# Check logs
docker-compose logs

# Restart clean
docker-compose down -v
make dev
```

#### Issue: Database Migration Fails

- Ensure you copied the **entire** `complete_setup.sql`
- Check Supabase project is active
- Verify service key is correct (use LEGACY key)

#### Issue: Frontend Can't Connect to Backend

```bash
# Check backend is running
curl http://localhost:8000/health

# Check ports in .env match
# Default: BACKEND_PORT=8000

# Restart services
docker-compose restart
```

#### Issue: MCP Server Not Responding

```bash
# Check MCP port
curl http://localhost:8051/mcp

# Check ARCHON_MCP_PORT in .env
# Default: 8051

# Restart backend
docker-compose restart archon-backend
```

---

## Known Issues & Limitations

### Current Beta Limitations

⚠️ **Important:** Archon is currently in **beta**. Expect some rough edges.

#### 1. MCP Connection Issues

**Symptoms:**
- "Missing session ID" errors
- "Connection closed" in AI assistant
- MCP server constantly restarting

**Status:** Known issue being addressed
**Workaround:**
- Use stable branch
- Ensure Archon is fully started before connecting AI assistant
- Check logs: `docker-compose logs -f`

**Community Discussion:** [GitHub Issue #497](https://github.com/coleam00/Archon/issues/497)

#### 2. Claude Code Specific Issues

**Symptom:** Claude Code queries Archon multiple times then gives up

**Status:** Under investigation
**Potential Causes:**
- Session handling differences between Claude Desktop and Claude Code
- Timeout issues
- SSE connection stability

**Workaround:**
- Try `mcp-remote` proxy approach (see Configuration Method B)
- Increase timeout in Claude Code config (if available)

#### 3. Performance Considerations

**Large Documentation Crawls:**
- Crawling huge sites (e.g., entire AWS docs) can take time
- Background processing helps but initial crawl is intensive

**Recommendation:**
- Start with specific documentation sections
- Use targeted URLs rather than entire domains
- Monitor backend logs during crawls

#### 4. Multi-User Concurrency

**Current Status:** Basic multi-user support exists
**Limitations:**
- Real-time conflict resolution is basic
- Complex merge scenarios not fully handled

**Best Practice:**
- Coordinate with team on who's editing what
- Use features/tasks to divide work

### Compatibility Matrix

| AI Assistant | Status | Notes |
|-------------|--------|-------|
| Claude Desktop | ✅ Working | Primary tested platform |
| Claude Code | ⚠️ Partial | Connection issues reported |
| Cursor | ✅ Working | MCP support confirmed |
| Windsurf | ✅ Working | Compatible |
| Kilo Code | ⚠️ Issues | Session ID problems |

### Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| macOS | ✅ Full | Primary development platform |
| Linux | ✅ Full | Docker tested |
| Windows | ⚠️ Partial | May need WSL2 for Docker |

---

## Community & Resources

### Official Resources

**GitHub Repository:**
- Main: [github.com/coleam00/Archon](https://github.com/coleam00/Archon)
- Stable Branch: `git clone -b stable https://github.com/coleam00/archon.git`

**Cole Medin's Channels:**
- YouTube: [@coleam00](https://youtube.com/@coleam00) - 100,000+ subscribers
  - Tutorials on AI coding
  - Archon demos and walkthroughs
  - Best practices videos
- GitHub: [@coleam00](https://github.com/coleam00)
- Twitter/X: [@cole_medin](https://twitter.com/cole_medin)

### Related Projects by Cole Medin

**mcp-crawl4ai-rag:**
- [github.com/coleam00/mcp-crawl4ai-rag](https://github.com/coleam00/mcp-crawl4ai-rag)
- Web crawling and RAG capabilities for AI agents
- Powers Archon's documentation crawling
- Can be used standalone as MCP server

### Community Forums

**oTTomator Community (Archon Section):**
- [thinktank.ottomator.ai](https://thinktank.ottomator.ai)
- Active discussions on Archon
- Troubleshooting help
- Feature requests
- Community workflows

**GitHub Discussions:**
- [github.com/coleam00/Archon/discussions](https://github.com/coleam00/Archon/discussions)
- Q&A
- Show and tell
- Ideas and feature requests

### Dynamous AI Community

Archon is developed within the vibrant Dynamous AI community:
- Collaborative development
- Shared learnings
- Beta testing
- Feature ideation

**Join the community** to stay updated on Archon development and connect with other power users.

### Recommended YouTube Videos

**By Cole Medin:**
1. "Introducing Archon - an AI Agent that BUILDS AI Agents"
2. "Code 100x Faster with AI, Here's How (No Hype, FULL Process)"
3. Various tutorials on AI-assisted coding best practices

**Search for:** "Cole Medin Archon" on YouTube for latest content

### Alternative Archon Versions

**Archon v5 (Community Fork):**
- [github.com/CCwithAi/Archon-v5](https://github.com/CCwithAi/Archon-v5)
- Community-maintained fork
- May have different features

**Decentralised-AI/Archon-agent-builder:**
- Different project with similar name
- Focused on agent creation framework
- Not the same as Cole Medin's Archon OS

**Note:** This research focuses on Cole Medin's official Archon OS.

---

## Conclusion

### Key Takeaways

1. **Archon is Revolutionary:** First-of-its-kind command center for AI coding assistants
2. **Context is King:** Structured knowledge management beats ad-hoc prompting
3. **Active Development:** Beta status means exciting features but expect some issues
4. **Strong Community:** Backed by Dynamous AI and Cole Medin's expertise
5. **MCP Integration:** Seamless connection with modern AI coding assistants

### Who Should Use Archon?

**Ideal For:**
- ✅ Developers using AI coding assistants regularly (Claude, Cursor, Windsurf)
- ✅ Teams wanting to centralize project knowledge
- ✅ Projects with extensive documentation requirements
- ✅ Power users seeking reproducible AI coding workflows
- ✅ Those willing to work with beta software

**Maybe Not For:**
- ❌ Quick one-off scripts (overhead too high)
- ❌ Users wanting 100% stability (it's beta!)
- ❌ Those uncomfortable with Docker and technical setup
- ❌ Projects without significant documentation needs

### Future Outlook

**Archon is positioned to become:**
- Standard tool for professional AI-assisted development
- Knowledge backbone for development teams
- Platform for AI coding agent ecosystems

**Watch for:**
- Stable v1.0 release
- Enhanced MCP stability
- More LLM integrations
- Enterprise features (teams, permissions)
- Plugin ecosystem

### Getting Started Recommendation

**Week 1: Learn**
- Watch Cole Medin's YouTube tutorials
- Understand context engineering principles
- Review this documentation

**Week 2: Setup**
- Install Archon (stable branch)
- Create a test project
- Crawl some documentation
- Connect to Claude Desktop (most stable)

**Week 3: Experiment**
- Try the workflow with a small feature
- Iterate on your process
- Join community forums
- Share your learnings

**Week 4: Scale**
- Apply to real projects
- Optimize your configurations
- Contribute back to community

### Final Thoughts

Archon represents the future of AI-assisted development: **structured, reproducible, and context-aware**. While currently in beta, the fundamentals are solid and the vision is clear.

The key insight from Cole Medin stands:

> "Context engineering is the new vibe coding"

By mastering Archon, you're not just learning a tool—you're learning a methodology for working effectively with AI coding assistants.

---

## Appendix: Quick Reference

### Essential Commands

```bash
# Installation
git clone -b stable https://github.com/coleam00/archon.git
cd archon
cp .env.example .env
# Edit .env with Supabase credentials
make dev

# Start/Stop
make dev          # Hybrid mode
make dev-docker   # Full Docker mode
docker-compose down

# Logs
docker-compose logs -f
docker-compose logs archon-backend

# Health Check
curl http://localhost:8051/health
```

### Essential URLs

- **Frontend:** http://localhost:3000
- **Backend:** http://localhost:8000
- **MCP Server:** http://localhost:8051/mcp
- **GitHub:** https://github.com/coleam00/Archon
- **Documentation:** See README in repository

### Essential Environment Variables

```bash
SUPABASE_URL=          # Your Supabase project URL
SUPABASE_SERVICE_KEY=  # LEGACY service role key
ARCHON_MCP_PORT=8051   # MCP server port
FRONTEND_PORT=3000     # Web interface port
BACKEND_PORT=8000      # API port
```

### MCP Configuration Template

```json
{
  "mcpServers": {
    "archon": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "http://localhost:8051/mcp"]
    }
  }
}
```

---

**Report Compiled:** November 5, 2025
**Research Method:** Web search, documentation analysis, community forums
**Sources:** GitHub, YouTube, Technical Blogs, Community Discussions
**Confidence Level:** High (Multiple corroborating sources)

**Note:** Archon is actively developed. Check official repository for latest updates.

---

*This research was conducted using web research techniques and represents information available as of November 2025. For the most current information, always refer to the official Archon GitHub repository and Cole Medin's channels.*
