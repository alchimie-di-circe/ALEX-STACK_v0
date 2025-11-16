# Claude Code Agent Orchestration System v2 🚀

A simple yet powerful orchestration system for Claude Code that uses specialized agents to manage complex projects from start to finish, with mandatory human oversight and visual testing.

## 🎯 What Is This?

This is a **custom Claude Code orchestration system** that transforms how you build software projects. Claude Code itself acts as the orchestrator with its 200k context window, managing the big picture while delegating individual tasks to specialized subagents:

- **🧠 Claude (You)** - The orchestrator with 200k context managing todos and the big picture
- **📚 Notion Scraper Expert** - Notion workspace specialist powered by Suekou MCP for knowledge extraction
- **📋 Planner Agent** - AI-powered project planning using TASKMASTER CLI for complex breakdowns
- **✍️ Coder Subagent** - Implements one todo at a time with self-service docs (Context7 + ctxkit)
- **👁️ Tester Subagent** - Verifies implementations using Playwright in its own context
- **🆘 Stuck Subagent** - Human escalation point when ANY problem occurs

## ⚡ Key Features

- **Self-Service Documentation**: Coder uses Context7 + ctxkit for instant docs (no API keys needed!)
- **No Fallbacks**: When ANY agent hits a problem, you get asked - no assumptions, no workarounds
- **Visual Testing**: Playwright MCP integration for screenshot-based verification
- **Todo Tracking**: Always see exactly where your project stands
- **Smart Flow**: Claude creates todos → coder implements (with self-service docs) → tester verifies → repeat
- **Human Control**: The stuck agent ensures you're always in the loop
- **🆕 Local E2B Sandbox**: Secure Docker container for running GitHub Copilot CLI with MCP integrations
- **🆕 E2B Cloud Sandbox**: Cloud-powered sandboxes with Docker MCP Gateway (200+ tools)
- **🆕 Awesome Copilot MCP**: Access community prompts and instructions directly

## 📦 Using in Other Projects

Want to use this orchestration system in your own projects? It's **super easy**!

### Quick Import (Recommended)

From any project, just ask Claude:

```bash
cd /path/to/your-project
claude

# Then use the slash command:
/import-orchestration from /path/to/ALEX-STACK_v0

# Or simply ask:
"Import the orchestration plugin from /path/to/ALEX-STACK_v0"
```

Claude will automatically:
- ✅ Copy all orchestration files (`.claude/`, `PROJECT_ROADMAP.md`, `.taskmaster/`)
- ✅ Verify installation
- ✅ Switch to orchestrator mode
- ✅ Be ready to build!

**That's it!** Claude is now your orchestrator in the new project.

### After import, your project has:
- **Orchestrator** - Claude with 200k context managing everything
- **Agent delegation** - coder, tester, planner, notion-scraper-expert, stuck
- **Self-service docs** - Coder uses Context7 + ctxkit (no API keys needed)
- **PROJECT_ROADMAP.md** - Unified task tracking for multi-agent coordination
- **TASKMASTER** - AI-powered breakdown for extreme complexity (8-10/10)
- **Parallelization** - Multiple coder agents work on independent tasks

### Learn More

📖 **See [QUICKSTART.md](./QUICKSTART.md)** for detailed import instructions, troubleshooting, and examples.

---

## 🚀 Quick Start

### Prerequisites

1. **Claude Code CLI** installed ([get it here](https://docs.claude.com/en/docs/claude-code))
2. **Node.js** (for MCP servers)
3. **No API keys required** - Context7 and ctxkit work out of the box!

### Installation

```bash
# Clone this repository
git clone https://github.com/IncomeStreamSurfer/claude-code-agents-wizard-v2.git
cd claude-code-agents-wizard-v2

# Start Claude Code in this directory
claude
```

That's it! The agents are automatically loaded from the `.claude/` directory.

### 🐳 Using with DevContainer (Recommended for Local Development)

This repository includes an official Anthropic DevContainer configuration for safe, isolated development on your local machine.

**Benefits:**
- 🔒 **Isolated environment** - Protects your Mac/system from bash commands and file operations
- 🌐 **Consistent setup** - Same environment in cloud (Claude web) and local (IDE)
- 📦 **Pre-configured** - Node.js, Claude Code CLI, and all dependencies ready to go
- 🚀 **Zero setup** - One-click "Reopen in Container" from VS Code/IDE

**Setup:**

1. **Prerequisites:**
   - [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and running
   - [VS Code](https://code.visualstudio.com/) with [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
   - Or any IDE with DevContainer support

2. **Clone and open:**
   ```bash
   git clone https://github.com/alchimie-di-circe/ALEX-STACK_v0.git
   cd ALEX-STACK_v0
   code .
   ```

3. **Reopen in Container:**
   - VS Code will prompt: "Reopen in Container" → Click it
   - Or: Command Palette (⌘+Shift+P) → "Dev Containers: Reopen in Container"

4. **Set up environment variables:**
   ```bash
   # Inside the container terminal
   cp .env.example .env
   # Edit .env and add your API keys
   ```

5. **Start Claude Code:**
   ```bash
   claude
   ```

**What's included in the DevContainer:**
- ✅ Ubuntu base image
- ✅ Node.js 20 LTS
- ✅ Claude Code CLI (official Anthropic feature with auto-update)
- ✅ DevContainers CLI
- ✅ Auto-configured MCP environment variables
- ✅ Port forwarding (3000, 5173, 8080)
- ✅ VS Code Claude Code extension

## 📖 How to Use

### Starting a Project

When you want to build something, just tell Claude your requirements:

```
You: "Build a todo app with React and TypeScript"
```

Claude will automatically:
1. Create a detailed todo list using TodoWrite
2. Delegate the first todo to the **coder** subagent
3. The coder implements in its own clean context window (uses Context7 + ctxkit for docs)
4. Delegate verification to the **tester** subagent (Playwright screenshots)
5. If ANY problem occurs, the **stuck** subagent asks you what to do
6. Mark todo complete and move to the next one
7. Repeat until project complete

### The Workflow

```
USER: "Build X with latest best practices"
    ↓
CLAUDE: Creates detailed todos with TodoWrite
    ↓
CLAUDE: Invokes coder subagent for todo #1
    ↓
CODER (own context):
    ├─→ Uses Context7 (try FIRST) for popular framework docs
    ├─→ Uses ctxkit (fallback) for llm.txt discovery
    └─→ Implements feature with best practices from docs
    ↓
    ├─→ Problem? → Invokes STUCK → You decide → Continue
    ↓
CODER: Reports completion
    ↓
CLAUDE: Invokes tester subagent
    ↓
TESTER (own context): Playwright screenshots & verification
    ↓
    ├─→ Test fails? → Invokes STUCK → You decide → Continue
    ↓
TESTER: Reports success
    ↓
CLAUDE: Marks todo complete, moves to next
    ↓
Repeat until all todos done ✅
```

## 🛠️ How It Works

### Claude (The Orchestrator)
**Your 200k Context Window**

- Creates and maintains comprehensive todo lists
- Sees the complete project from A-Z
- Delegates individual todos to specialized subagents
- Tracks overall progress across all tasks
- Maintains project state and context

**How it works**: Claude IS the orchestrator - it uses its 200k context to manage everything

### Notion Scraper Expert (Knowledge Extraction)
**Fresh Context Per Notion Task**

- Gets invoked when Notion workspace content needs to be extracted
- Works in its own clean context window
- Uses **Suekou Notion MCP Server** for Notion operations:
  - **Page Retrieval**: Get Notion pages with properties and content
  - **Database Queries**: Query databases with filters and sorts
  - **Markdown Conversion**: Auto-convert to token-efficient Markdown
  - **Content Management**: Create, edit, delete with user approval
- **Preferred over manual Notion API** for knowledge extraction
- **Never uses fallbacks** - invokes stuck agent immediately on errors
- Returns clean, optimized Markdown to Claude

**When it's used**:
- Extracting documentation from Notion pages
- Querying Notion databases for project information
- Converting Notion content to implementation specs
- Organizing Notion workspace programmatically
- When user provides Notion URLs in requirements

### Planner Agent (Strategic Planning)
**Fresh Context Per Planning Session**

- Gets invoked for extreme complexity projects (8-10/10)
- Works in its own clean context window
- Uses **TASKMASTER CLI** for AI-powered task breakdown:
  - **PRD Parsing**: Convert requirements to structured tasks
  - **Complexity Analysis**: AI scores tasks with web research
  - **Task Expansion**: Break down high-complexity tasks automatically
  - **Dependency Validation**: Ensure proper task ordering
- Returns comprehensive task breakdown to orchestrator
- Updates PROJECT_ROADMAP.md with strategic tasks

**When it's used**:
- Multi-layered, complex projects requiring strategic planning
- Large-scale feature implementations
- When intelligent task breakdown with dependencies is needed

### Coder Subagent
**Fresh Context Per Task**

- Gets invoked with ONE specific todo item
- Works in its own clean context window
- **Self-service documentation** via:
  - **Context7 (try FIRST)**: Popular frameworks/libraries (React, Next.js, TypeScript, Tailwind, etc.)
  - **ctxkit (fallback)**: llm.txt file discovery for any website
  - **No API keys required** - both tools are free and secure for Claude Code Web
- Writes clean, functional code using latest best practices from docs
- **Never uses fallbacks** - invokes stuck agent immediately if docs unavailable
- Reports completion back to Claude

**When it's used**: Claude delegates each coding todo to this subagent

### Tester Subagent
**Fresh Context Per Verification**

- Gets invoked after each coder completion
- Works in its own clean context window
- Uses **Playwright MCP** to see rendered output
- Takes screenshots to verify layouts
- Tests interactions (clicks, forms, navigation)
- **Never marks failing tests as passing**
- Reports pass/fail back to Claude

**When it's used**: Claude delegates testing after every implementation

### Stuck Subagent
**Fresh Context Per Problem**

- Gets invoked when coder or tester hits a problem
- Works in its own clean context window
- **ONLY subagent** that can ask you questions
- Presents clear options for you to choose
- Blocks progress until you respond
- Returns your decision to the calling agent
- Ensures no blind fallbacks or workarounds

**When it's used**: Whenever ANY subagent encounters ANY problem

## 🚨 The "No Fallbacks" Rule

**This is the key differentiator:**

Traditional AI: Hits error → tries workaround → might fail silently
**This system**: Hits error → asks you → you decide → proceeds correctly

Every agent is **hardwired** to invoke the stuck agent rather than use fallbacks. You stay in control.

## 💡 Example Session

```
You: "Build a modern landing page with React and Tailwind using latest best practices"

Claude creates todos:
  [ ] Set up project with Vite
  [ ] Create hero section component
  [ ] Add contact form with validation
  [ ] Implement responsive design
  [ ] Test all components

Claude invokes coder(todo #1: "Set up project with Vite using latest React + Tailwind best practices")

Coder (own context):
  - Uses Context7 to fetch React 19 documentation
  - Uses Context7 to fetch Tailwind v4 documentation
  - Creates Vite project with React + Tailwind
  - Configures Tailwind v4 correctly following latest best practices
Coder: Reports completion to Claude

Claude invokes tester("Verify project setup and dev server runs")

Tester (own context): Uses Playwright
  - Starts dev server
  - Navigates to localhost
  - Takes screenshot
  - Verifies React app renders
Tester: Reports success to Claude

Claude: Marks todo #1 complete ✓

Claude invokes coder(todo #2: "Create hero section component")

Coder (own context):
  - Uses Context7 for React component best practices
  - Implements hero section
  - ERROR - Need hero image
  - Invokes stuck subagent

Stuck (own context): Asks YOU:
  "Hero section needs an image. How to proceed?"
  Options:
  - Use placeholder from placeholder.com
  - Use a specific image URL
  - Skip image for now

You choose: "Use placeholder from placeholder.com"

Stuck: Returns your decision to Coder

Coder: Implements hero section with placeholder image
Coder: Reports completion to Claude

Claude invokes tester("Verify hero section renders correctly")

Tester: Reports success with screenshot
Claude: Marks todo #2 complete ✓

... and so on until all todos done
```

## 📁 Repository Structure

```
.
├── .claude/
│   ├── CLAUDE.md              # Orchestration instructions for main Claude
│   └── agents/
│       ├── notion-scraper-expert.md # Notion Scraper - Notion workspace specialist (Suekou MCP)
│       ├── planner.md        # Planner - AI-powered planning (TASKMASTER CLI)
│       ├── coder.md          # Coder subagent definition (Context7 + ctxkit self-service)
│       ├── tester.md         # Tester subagent definition
│       └── stuck.md          # Stuck subagent definition
├── .devcontainer/
│   └── devcontainer.json      # DevContainer configuration (Anthropic official)
├── .mcp.json                  # MCP servers configuration (Context7 + ctxkit + Playwright + Notion)
├── .env.example               # Environment variables template
├── e2b/                       # E2B sandbox implementation files
│   ├── Dockerfile.e2b         # Docker configuration for E2B sandbox
│   ├── Dockerfile.e2b.local   # Local development Dockerfile
│   ├── docker-entrypoint.sh   # Entry point script for E2B container
│   ├── e2b-sandbox.config.json # E2B sandbox configuration
│   ├── start-e2b-sandbox.sh   # One-command launcher script
│   └── src/
│       └── e2b-cloud-sandbox.js # E2B cloud sandbox implementation
├── docs/                      # Documentation organized by topic
│   ├── E2B/                   # E2B sandbox documentation
│   ├── MCP/                   # MCP servers documentation
│   ├── SECURITY/              # Secrets and security guides
│   ├── COPILOT_QUICK_START.md
│   └── SETUP-LOCAL.md
├── .gitignore
└── README.md
```

## 🔌 MCP Servers Configuration

This system uses powerful MCP servers to enhance agent capabilities:

### 1. Context7 MCP Server ⭐
**Purpose:** Self-service documentation for popular frameworks and libraries

**Used by:** Coder Agent for instant documentation access during implementation

**Features:**
- **Popular Frameworks:** React, Next.js, Vue, Svelte, Angular, and more
- **Libraries:** TypeScript, Tailwind CSS, shadcn/ui, and more
- **No API Key Required:** Free and secure for Claude Code Web
- **Fast Access:** Pre-indexed documentation for instant retrieval
- **Always Current:** Documentation is regularly updated

**Setup:**
- Already configured in `.mcp.json`
- No API keys or environment variables needed
- Works out of the box!

### 2. ctxkit MCP Server
**Purpose:** llm.txt file discovery for any website

**Used by:** Coder Agent as fallback when Context7 doesn't have specific docs

**Features:**
- **llm.txt Discovery:** Automatically finds llm.txt files on any website
- **No API Key Required:** Free and secure for Claude Code Web
- **Universal Coverage:** Works with any site that provides llm.txt
- **Lightweight:** Simple, fast documentation retrieval

**Setup:**
- Already configured in `.mcp.json`
- No API keys or environment variables needed
- Works out of the box!

### 3. Playwright MCP
**Purpose:** Visual testing and browser automation

**Used by:** Tester Agent for visual verification

- Takes screenshots of rendered pages
- Tests UI interactions (clicks, forms, navigation)
- Verifies responsive design
- Checks console errors

### 4. Suekou Notion MCP Server
**Purpose:** Notion workspace extraction and management

**Used by:** Notion Scraper Expert for knowledge extraction

**Features:**
- **Page Retrieval:** Get Notion pages with properties and content
- **Database Queries:** Query databases with filters and sorts  
- **Markdown Conversion:** Auto-convert to token-efficient Markdown
- **Content Management:** Create, edit, delete pages (with approval)
- **Workspace Search:** Search across entire Notion workspace
- **Token Optimization:** Dramatically reduces token usage

**API Key Setup:**
1. Create a Notion integration at [notion.so/my-integrations](https://www.notion.so/my-integrations)
2. Set the environment variable: `export NOTION_API_TOKEN="your-api-key-here"`
3. Enable Markdown conversion: `export NOTION_MARKDOWN_CONVERSION="true"`

### 5. Awesome Copilot MCP Server
**Purpose:** Community prompts and instructions discovery

**Used by:** Developers and AI agents for enhanced Copilot capabilities

**Features:**
- **Search Instructions:** Find community-contributed prompts
- **Load Instructions:** Import prompts directly into your workflow
- **Browse Categories:** Explore organized collections
- **Preview Content:** Review instruction details before use

**Setup:**
See [E2B_SETUP_GUIDE.md](./E2B_SETUP_GUIDE.md) for detailed installation instructions.

**Quick Start:**
```bash
# Using Docker
docker run -i --rm -p 8080:8080 awesome-copilot:latest

# Enable in .mcp.json
"awesome-copilot": {
  "disabled": false
}
```

## 🔒 E2B Sandboxes for Secure Code Execution

### What is E2B?

E2B (Execute to Build) provides secure, isolated sandbox environments for running AI-generated code safely. We offer **two deployment options**:

#### Option 1: Local Docker Container 🐳
Self-hosted Docker container on your machine with manual MCP configuration.

**Best for:** Development, testing, offline work

```bash
# Quick start with launcher script
./e2b/start-e2b-sandbox.sh

# Or build manually
docker build -f e2b/Dockerfile.e2b -t alex-stack-e2b:latest .
docker run -it --rm -v $(pwd):/workspace alex-stack-e2b:latest
```

#### Option 2: E2B Cloud Sandbox ☁️
Cloud-managed sandboxes with automatic Docker MCP Gateway integration.

**Best for:** Production, collaboration, scaling

```bash
# Install dependencies
npm install

# Configure credentials in .env
cp .env.example .env
# Edit .env with your E2B_API_KEY and GITHUB_TOKEN

# Create cloud sandbox
npm run create-sandbox
```

### Feature Comparison

| Feature | Local Docker | E2B Cloud |
|---------|-------------|-----------|
| **Setup** | Minutes | Seconds |
| **MCP Tools** | 3 servers (manual) | 200+ servers (auto) |
| **Cost** | Free | Free tier + paid |
| **Scalability** | Limited | Unlimited |
| **GitHub Copilot CLI** | ✅ Manual install | ✅ Pre-installed |
| **Docker MCP Gateway** | ❌ | ✅ Automatic |

### Documentation

Choose your path:

**Local Docker Container:**
- 📖 [E2B Setup Guide](./E2B_SETUP_GUIDE.md) - Docker container setup
- ⚡ [Quick Start Guide](./COPILOT_QUICK_START.md) - 5-minute local setup

**E2B Cloud Sandbox:**
- ☁️ [E2B Cloud Guide](./E2B_CLOUD_GUIDE.md) - Cloud sandbox with MCP Gateway
- 🏗️ [Architecture Docs](./E2B_ARCHITECTURE.md) - System architecture

### Use Cases

1. **Safe Code Testing**: Execute Copilot-generated code in isolation
2. **Experimentation**: Try new tools and configurations without risk
3. **CI/CD Integration**: Run automated tests in clean environments
4. **Team Development**: Share consistent development environments
5. **Security**: Prevent untrusted code from accessing sensitive systems
6. **Production Workloads**: Scale with cloud sandboxes (E2B Cloud only)

## 🎓 Learn More

### Resources

- **[SEO Grove](https://seogrove.ai)** - AI-powered SEO automation platform
- **[ISS AI Automation School](https://www.skool.com/iss-ai-automation-school-6342/about)** - Join our community to learn AI automation
- **[Income Stream Surfers YouTube](https://www.youtube.com/incomestreamsurfers)** - Tutorials, breakdowns, and AI automation content

### Support

Have questions or want to share what you built?
- Join the [ISS AI Automation School community](https://www.skool.com/iss-ai-automation-school-6342/about)
- Subscribe to [Income Stream Surfers on YouTube](https://www.youtube.com/incomestreamsurfers)
- Check out [SEO Grove](https://seogrove.ai) for automated SEO solutions

## 🤝 Contributing

This is an open system! Feel free to:
- Add new specialized agents
- Improve existing agent prompts
- Share your agent configurations
- Submit PRs with enhancements

## 📝 How It Works Under the Hood

This system leverages Claude Code's [subagent system](https://docs.claude.com/en/docs/claude-code/sub-agents):

1. **CLAUDE.md** instructs main Claude to be the orchestrator
2. **Subagents** are defined in `.claude/agents/*.md` files
3. **Each subagent** gets its own fresh context window
4. **Main Claude** maintains the 200k context with todos and project state
5. **MCP Servers** are configured in `.mcp.json` for enhanced capabilities:
   - **Context7 MCP** for self-service documentation (coder)
   - **ctxkit MCP** for llm.txt discovery (coder fallback)
   - **Playwright MCP** for visual testing (tester)
   - **Notion MCP** for workspace extraction (optional)

The magic happens because:
- **Claude (200k context)** = Maintains big picture, manages todos
- **Coder (fresh context)** = Implements one task at a time with self-service docs (Context7 + ctxkit)
- **Tester (fresh context)** = Verifies one implementation at a time with Playwright
- **Stuck (fresh context)** = Handles one problem at a time with human input
- **Each subagent** has specific tools and hardwired escalation rules

## 🎯 Best Practices

1. **Trust Claude** - Let it create and manage the todo list
2. **Review screenshots** - The tester provides visual proof of every implementation
3. **Make decisions when asked** - The stuck agent needs your guidance
4. **Don't interrupt the flow** - Let subagents complete their work
5. **Check the todo list** - Always visible, tracks real progress

## 🔥 Pro Tips

- Use `/agents` command to see all available subagents
- Claude maintains the todo list in its 200k context - check anytime
- Screenshots from tester are saved and can be reviewed
- Each subagent has specific tools - check their `.md` files
- Subagents get fresh contexts - no context pollution!

## 📜 License

MIT - Use it, modify it, share it!

## 🙏 Credits

Built by [Income Stream Surfer](https://www.youtube.com/incomestreamsurfers)

Powered by Claude Code's agent system, Context7 MCP, ctxkit MCP, and Playwright MCP.

---

**Ready to build something amazing?** Just run `claude` in this directory and tell it what you want to create! 🚀
