# Claude Code Agent Orchestration System v2 🚀

A simple yet powerful orchestration system for Claude Code that uses specialized agents to manage complex projects from start to finish, with mandatory human oversight and visual testing.

## 🎯 What Is This?

This is a **custom Claude Code orchestration system** that transforms how you build software projects. Claude Code itself acts as the orchestrator with its 200k context window, managing the big picture while delegating individual tasks to specialized subagents:

- **🧠 Claude (You)** - The orchestrator with 200k context managing todos and the big picture
- **🔍 Jino Agent** - Web research specialist powered by Jina.ai MCP for docs extraction and searches
- **✍️ Coder Subagent** - Implements one todo at a time in its own clean context
- **👁️ Tester Subagent** - Verifies implementations using Playwright in its own context
- **🆘 Stuck Subagent** - Human escalation point when ANY problem occurs

## ⚡ Key Features

- **AI-Powered Research**: Jino Agent proactively fetches docs and extracts web content using Jina.ai
- **No Fallbacks**: When ANY agent hits a problem, you get asked - no assumptions, no workarounds
- **Visual Testing**: Playwright MCP integration for screenshot-based verification
- **Todo Tracking**: Always see exactly where your project stands
- **Smart Flow**: Claude creates todos → Jino researches → coder implements → tester verifies → repeat
- **Human Control**: The stuck agent ensures you're always in the loop

## 🚀 Quick Start

### Prerequisites

1. **Claude Code CLI** installed ([get it here](https://docs.claude.com/en/docs/claude-code))
2. **Node.js** (for MCP servers)
3. **Jina AI API Key** (optional but recommended) - Get it free at [jina.ai](https://jina.ai/)

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
- ✅ Claude Code CLI (official Anthropic feature)
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
2. Check if research is needed - if yes, invoke **Jino Agent** to fetch docs/search
3. Delegate the first todo to the **coder** subagent (with research if available)
4. The coder implements in its own clean context window
5. Delegate verification to the **tester** subagent (Playwright screenshots)
6. If ANY problem occurs, the **stuck** subagent asks you what to do
7. Mark todo complete and move to the next one
8. Repeat until project complete

### The Workflow

```
USER: "Build X with latest best practices"
    ↓
CLAUDE: Creates detailed todos with TodoWrite
    ↓
    ├─→ Need docs? → JINO AGENT (own context): Uses Jina AI MCP
    │                  ├─→ Extracts clean documentation
    │                  ├─→ Searches web for best practices
    │                  └─→ Returns structured research
    ↓
CLAUDE: Invokes coder subagent for todo #1 (+ research from Jino)
    ↓
CODER (own context): Implements feature with best practices
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

### Jino Agent (Research Specialist)
**Fresh Context Per Research Task**

- Gets invoked proactively when web research or documentation is needed
- Works in its own clean context window
- Uses **Jina AI Remote MCP Server** for powerful web capabilities:
  - **Jina Reader**: Extracts clean markdown from any URL
  - **Web Search**: AI-powered search for current information
  - **Image Search**: Finds and analyzes images
  - **Embeddings & Reranker**: Semantic search and ranking
- **Preferred over native WebSearch** for documentation and deep content extraction
- **Never uses fallbacks** - invokes stuck agent immediately on errors
- Reports clean, formatted research back to Claude

**When it's used**:
- Fetching documentation (React docs, API references, tutorials)
- Extracting content from URLs (articles, blog posts, guides)
- Web research requiring current best practices
- Finding code examples or technical resources
- Any task where Jina AI's extraction is superior to basic web fetch

### Coder Subagent
**Fresh Context Per Task**

- Gets invoked with ONE specific todo item
- Works in its own clean context window
- Writes clean, functional code
- **Never uses fallbacks** - invokes stuck agent immediately
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
  [ ] Research React + Tailwind best practices
  [ ] Set up project with Vite
  [ ] Create hero section component
  [ ] Add contact form with validation
  [ ] Implement responsive design
  [ ] Test all components

Claude invokes jino-agent(todo #1: "Research React + Tailwind best practices")

Jino Agent (own context): Uses Jina AI MCP
  - Uses Jina Reader to extract React 19 docs
  - Uses Jina Reader to extract Tailwind v4 docs
  - Uses Jina Web Search for "React Tailwind 2025 best practices"
  - Synthesizes findings into clean guide
Jino: Reports comprehensive research to Claude

Claude: Marks todo #1 complete ✓

Claude invokes coder(todo #2: "Set up project with Vite" + research from Jino)

Coder (own context): Creates Vite project with React + Tailwind
  - Follows best practices from Jino's research
  - Configures Tailwind v4 correctly
Coder: Reports completion to Claude

Claude invokes tester("Verify project setup and dev server runs")

Tester (own context): Uses Playwright
  - Starts dev server
  - Navigates to localhost
  - Takes screenshot
  - Verifies React app renders
Tester: Reports success to Claude

Claude: Marks todo #2 complete ✓

Claude invokes coder(todo #3: "Create hero section component")

Coder (own context): Implements hero section
Coder: ERROR - Need hero image
Coder: Invokes stuck subagent

Stuck (own context): Asks YOU:
  "Hero section needs an image. How to proceed?"
  Options:
  - Search with Jino Agent for free stock images
  - Use placeholder from placeholder.com
  - Skip image for now

You choose: "Search with Jino Agent for free stock images"

Stuck: Returns your decision to Claude

Claude invokes jino-agent("Search for hero section stock images")

Jino Agent: Uses Jina Image Search
  - Finds relevant hero images
  - Provides URLs and metadata
Jino: Reports image options to Claude

Claude invokes coder(todo #3 continued: "Create hero with image from Jino")

Coder: Implements hero section with selected image
Coder: Reports completion to Claude

... and so on until all todos done
```

## 📁 Repository Structure

```
.
├── .claude/
│   ├── CLAUDE.md              # Orchestration instructions for main Claude
│   └── agents/
│       ├── jino-agent.md     # Jino Agent - Web research specialist (Jina.ai MCP)
│       ├── coder.md          # Coder subagent definition
│       ├── tester.md         # Tester subagent definition
│       └── stuck.md          # Stuck subagent definition
├── .devcontainer/
│   └── devcontainer.json      # DevContainer configuration (Anthropic official)
├── .mcp.json                  # MCP servers configuration (Playwright + Jina AI)
├── .env.example               # Environment variables template
├── .gitignore
└── README.md
```

## 🔌 MCP Servers Configuration

This system uses two powerful MCP servers to enhance agent capabilities:

### 1. Jina AI Remote MCP Server ⭐
**Purpose:** Web search, content extraction, and AI-powered research

**Used by:** Jino Agent for intelligent web research

**Features:**
- **Jina Reader:** Convert any URL to clean, LLM-friendly markdown
  - Removes ads, popups, navigation clutter
  - Extracts main content with perfect formatting
  - Perfect for documentation and articles
- **Web Search:** AI-powered web search with intelligent results
  - Natural language queries
  - Ranked, relevant results
  - Current information
- **Image Search:** Find and analyze images across the web
- **Embeddings & Reranker:** Semantic search and content ranking

**API Key Setup:**
1. Get a free API key from [jina.ai](https://jina.ai/)
2. Set the environment variable: `export JINA_API_KEY="your-api-key-here"`
3. Or add it to your shell profile for persistence:
   ```bash
   echo 'export JINA_API_KEY="your-api-key-here"' >> ~/.bashrc
   source ~/.bashrc
   ```

**Note:** Some Jina AI tools work without an API key but have rate limits. Using an API key provides higher limits and better performance.

### 2. Playwright MCP
**Purpose:** Visual testing and browser automation

**Used by:** Tester Agent for visual verification

- Takes screenshots of rendered pages
- Tests UI interactions (clicks, forms, navigation)
- Verifies responsive design
- Checks console errors

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
   - **Playwright MCP** for visual testing
   - **Jina AI MCP** for web search, content extraction, and embeddings

The magic happens because:
- **Claude (200k context)** = Maintains big picture, manages todos
- **Coder (fresh context)** = Implements one task at a time
- **Tester (fresh context)** = Verifies one implementation at a time with Playwright + Jina AI
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

Powered by Claude Code's agent system, Playwright MCP, and Jina AI MCP.

---

**Ready to build something amazing?** Just run `claude` in this directory and tell it what you want to create! 🚀
