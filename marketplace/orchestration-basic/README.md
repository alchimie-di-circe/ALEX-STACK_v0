# Orchestration Basic Plugin

Complete Claude Code orchestration system with 6 specialized agents for managing complex software projects using a master-agent architecture with context isolation, visual verification, and human-in-the-loop escalation.

## 🎯 What's Included

### 6 Core Specialized Agents

1. **🔍 Jino Agent** - Web research & content extraction specialist
   - Uses Jina.ai Remote MCP for web operations
   - Extracts documentation with Jina Reader
   - Performs AI-powered web searches
   - Returns structured research to orchestrator

2. **📓 Notion Scraper Expert** - Notion workspace specialist
   - Uses Suekou Notion MCP for Notion operations
   - Extracts knowledge from Notion pages/databases
   - Converts Notion content to token-efficient Markdown
   - Manages Notion content with user approval

3. **✍️ Coder** - Implementation specialist
   - Receives ONE specific todo item
   - Implements clean, functional code
   - Reports completion status
   - Escalates immediately on errors

4. **👁️ Tester** - Visual verification specialist
   - Uses Playwright MCP for browser automation
   - Takes screenshots for visual validation
   - Tests interactions and navigation
   - Reports pass/fail results

5. **📋 Planner** - AI-powered project planning specialist
   - Uses TASKMASTER CLI for extreme complexity (8-10/10)
   - Breaks down complex projects into structured tasks
   - Analyzes complexity with AI-powered research
   - Validates task dependencies

6. **🆘 Stuck** - Human escalation point
   - ONLY agent allowed to use AskUserQuestion
   - Presents clear options to user
   - Blocks progress until human decision
   - Returns decision to calling agent

## 🚀 Quick Start

### Installation

```bash
# Clone this plugin into your project's marketplace folder
cd your-project
mkdir -p marketplace
cd marketplace
git clone <plugin-repo-url> orchestration-basic

# Or copy the plugin folder manually
```

### Required MCP Servers

This plugin requires three MCP servers to be configured in your `.mcp.json`:

1. **Jina.ai Remote MCP** - For jino-agent
2. **Suekou Notion MCP** - For notion-scraper-expert
3. **Playwright MCP** - For tester

### MCP Configuration Example

Add to your `.mcp.json`:

```json
{
  "mcpServers": {
    "jina-mcp-server": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "https://mcp.jina.ai/sse",
        "--header",
        "Authorization: Bearer ${JINA_API_KEY}"
      ]
    },
    "notion": {
      "command": "npx",
      "args": ["-y", "@suekou/mcp-notion-server"],
      "env": {
        "NOTION_API_TOKEN": "${NOTION_API_TOKEN}",
        "NOTION_MARKDOWN_CONVERSION": "true"
      }
    },
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"],
      "env": {}
    }
  }
}
```

### Environment Variables

Set the following environment variables:

```bash
export JINA_API_KEY="your_jina_api_key"
export NOTION_API_TOKEN="your_notion_token"
```

**Recommended**: Use direnv + 1Password CLI for automatic credential management. See [secret-manager-pro plugin](../secret-manager-pro) for setup.

## 📖 How It Works

### Master-Agent Architecture

```
┌─────────────────────────────────────────────┐
│  CLAUDE (200k Context) - Orchestrator      │
│  - Maintains project state and todo lists   │
│  - Delegates individual tasks to subagents  │
│  - Tracks overall progress                  │
└─────────────────────────────────────────────┘
                    │
        ┌───────┬───────┬───────┬───────┬───────┐
        ▼       ▼       ▼       ▼       ▼       ▼
     JINO   NOTION  CODER  TESTER PLANNER STUCK
```

### Standard Workflow

1. **USER** provides project requirements
2. **CLAUDE** analyzes and creates detailed todo list (TodoWrite)
3. For each todo:
   - If research needed → Invoke **JINO AGENT**
   - If Notion docs needed → Invoke **NOTION-SCRAPER-EXPERT**
   - If extreme complexity (8-10/10) → Invoke **PLANNER**
4. **CLAUDE** invokes **CODER** with todo + research/docs
5. **CLAUDE** invokes **TESTER** with implementation
6. **CLAUDE** marks todo complete
7. Repeat until all todos done
8. **CLAUDE** reports final results

### Error Handling

Every subagent is hardwired to invoke the **stuck agent** rather than guessing or using fallbacks:

- Error → Escalate → Human Decision → Proceed Correctly

**No fallbacks. No assumptions. No silent failures.**

## 🎯 Key Features

### Context Isolation

Each subagent gets a fresh context window for its specific task:
- **Prevents context pollution** from previous tasks
- **Maintains focus** on single objective
- **Reduces token waste** on irrelevant history
- **Enables parallel evolution** of different components

### Proactive Research

The Jino Agent and Notion Scraper Expert are invoked BEFORE coding when:
- Documentation needs to be fetched
- Best practices need to be researched
- Notion content needs extraction
- Web content needs extraction
- Current information is required

### Visual Verification

Every implementation is verified with Playwright MCP:
- **Screenshot proof** of rendered output
- **Interaction testing** (clicks, forms, navigation)
- **Responsive design** verification
- **Console error** detection

### AI-Powered Planning

The Planner agent uses TASKMASTER CLI for extreme complexity:
- **Intelligent task breakdown** with AI research
- **Complexity scoring** (1-10 scale)
- **Dependency validation** for task chains
- **PRD parsing** for structured requirements

## 📋 Usage Examples

### Example 1: Building an App

```
User: "Build a React todo app"

Claude:
- Creates todo list with TodoWrite
- Invokes coder for each feature sequentially
- Invokes tester after each implementation
- Marks todos complete
- Reports final results
```

### Example 2: Research + Implementation

```
User: "Implement authentication using latest Next.js patterns"

Claude:
- Creates todo list
- Invokes jino-agent to fetch Next.js auth docs
- Invokes coder with extracted documentation
- Invokes tester to verify auth flow
- Marks complete
```

### Example 3: Extracting from Notion

```
User: "Build the feature in this Notion doc: https://notion.so/..."

Claude:
- Invokes notion-scraper-expert to extract specs
- Invokes coder with Markdown from Notion
- Invokes tester to verify implementation
- Marks complete
```

## 🔧 Customization

### Agent Modification

All agent definitions are in `.claude/agents/`. You can customize:

- Agent prompts and instructions
- Tool access and permissions
- Error handling behavior
- Escalation triggers

### Adding New Agents

1. Create new agent file in `.claude/agents/`
2. Follow the YAML frontmatter format
3. Define tools, model, and description
4. Update orchestrator guide in `.claude/CLAUDE.md`

## 📊 Success Metrics

A successful orchestration session exhibits:
- ✅ Detailed todo list created immediately
- ✅ Research performed before implementation when needed
- ✅ Each todo implemented → tested → completed sequentially
- ✅ Human consulted via stuck agent for ambiguities
- ✅ All navigation links functional (zero 404s)
- ✅ Visual proof (screenshots) of all implementations
- ✅ Zero fallbacks or workarounds used
- ✅ Clean, maintainable code following best practices

## 🔗 Related Plugins

- **[secret-manager-pro](../secret-manager-pro)** - Fast secrets management with direnv + 1Password CLI

## 📚 Documentation

- `.claude/CLAUDE.md` - Full orchestrator instructions
- `.claude/agents/*.md` - Individual subagent definitions
- `docs/INSTALLATION.md` - Detailed installation guide
- `docs/QUICK_START.md` - Quick start tutorial
- `docs/EXAMPLES.md` - Comprehensive examples

## 🤝 Contributing

This plugin is part of the ALEX-STACK ecosystem. Contributions welcome!

## 📄 License

MIT License - See main repository for details

---

**Transform Claude Code into a project management system with specialized teams working in harmony.** 🚀
