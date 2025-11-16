# Claude Code Orchestration System - Technical Guide

## 🎯 System Overview

This is an advanced orchestration system for Claude Code that leverages a 200k context window to manage complex software projects. The system uses a master-agent architecture where Claude acts as the orchestrator, delegating tasks to specialized subagents that work in isolated context windows.

## 📋 PROJECT_ROADMAP.md - Central Coordination

**IMPORTANT**: This project uses `PROJECT_ROADMAP.md` as the **single source of truth** for project state and task coordination.

### Why This Matters

**For ALL agents (orchestrator, coder, planner, tester, etc.):**

1. **ALWAYS read `PROJECT_ROADMAP.md` FIRST** before starting any work
2. This file contains:
   - **Active Tasks**: TodoWrite mirror showing current work
   - **TASKMASTER Tasks**: Complex project breakdowns from planner agent
   - **Parallelization Opportunities**: Tasks that can run simultaneously
   - **Handoff Points**: Entry points for new agents joining mid-project
   - **Progress Overview**: Overall project health and completion status

### Key Benefits

✅ **Prevents Duplicate Work**: See what's already in progress or completed
✅ **Enables Parallelization**: Identify independent tasks for multi-agent work
✅ **Seamless Handoffs**: New agents can join mid-project with full context
✅ **Cross-Session Continuity**: Work persists across conversation sessions
✅ **Clear Coordination**: All agents know what others are doing

**Remember**: If you're an agent working on this project, `PROJECT_ROADMAP.md` is your first stop! 🎯

## 🏗️ Architecture

### Core Principle: Separation of Concerns

```
┌─────────────────────────────────────────────────────────────────────────┐
│  CLAUDE (200k Context) - Master Orchestrator                           │
│  - Maintains project state and todo lists                               │
│  - Delegates individual tasks to subagents                               │
│  - Tracks overall progress                                               │
│  - Makes high-level decisions                                            │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
        ┌───────────┬───────────┬───────────┬───────────┬───────────┬───────────┬───────────┬───────────┐
        ▼           ▼           ▼           ▼           ▼           ▼           ▼           ▼           ▼
    ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐
    │ JINO   │  │ NOTION │  │  REPO  │  │ CODER  │  │ TESTER │  │PLANNER │  │ STUCK  │  │SECRET  │
    │ AGENT  │  │SCRAPER │  │EXPLORER│  │        │  │        │  │        │  │        │  │ XPERT  │
    │(Fresh) │  │(Fresh) │  │(Fresh) │  │(Fresh) │  │(Fresh) │  │(Fresh) │  │(Fresh) │  │(Fresh) │
    │        │  │        │  │        │  │        │  │        │  │        │  │        │  │        │
    │Research│  │ Notion │  │GitHub  │  │Implement│ │Verify  │  │AI Task │  │Human   │  │Secrets │
    │& Web   │  │Extract │  │Repo    │  │One Task│  │w/Play- │  │Break-  │  │Escal-  │  │Mgmt    │
    │Extract │  │& Mgmt  │  │Analysis│  │        │  │wright  │  │down    │  │ation   │  │direnv+ │
    │        │  │        │  │        │  │        │  │        │  │        │  │        │  │1Pass   │
    └────────┘  └────────┘  └────────┘  └────────┘  └────────┘  └────────┘  └────────┘  └────────┘
```

### The Subagent System

Each subagent operates in its own isolated context window, preventing context pollution and ensuring focused execution:

1. **Jino Agent** - Web research specialist
   - Uses Jina.ai Remote MCP for web operations
   - Extracts documentation with Jina Reader
   - Performs AI-powered web searches
   - Returns structured research to orchestrator

2. **Notion Scraper Expert** - Notion workspace specialist
   - Uses Suekou Notion MCP for Notion operations
   - Extracts knowledge from Notion pages/databases
   - Converts Notion content to optimized Markdown
   - Manages Notion content (create, edit, delete with approval)
   - Returns structured documentation to orchestrator

3. **Coder** - Implementation specialist
   - Receives ONE specific todo item
   - Implements clean, functional code
   - Reports completion status
   - Escalates immediately on errors

4. **Tester** - Visual verification specialist
   - Uses Playwright MCP for browser automation
   - Takes screenshots for visual validation
   - Tests interactions and navigation
   - Reports pass/fail results

5. **Planner** - AI-powered project planning specialist
   - Uses TASKMASTER CLI for extreme complexity (8-10/10)
   - Breaks down complex projects into structured tasks
   - Analyzes complexity with AI-powered research
   - Validates task dependencies
   - Returns comprehensive task breakdown to orchestrator

6. **Stuck** - Human escalation point
   - ONLY agent allowed to use AskUserQuestion
   - Presents clear options to user
   - Blocks progress until human decision
   - Returns decision to calling agent

7. **Secret Xpert Light** - Secrets management specialist (marketplace plugin)
   - Uses direnv + 1Password CLI for secure credential management
   - Manages API keys and tokens for MCP servers
   - Supports cloud and local development workflows
   - Optimized for speed with Haiku model
   - Available as separate marketplace plugin: secret-manager-pro

8. **Repo Explorer** - Repository and codebase analysis specialist
   - Uses DeepWiki Remote MCP for GitHub repository analysis
   - Explores repository structure and documentation
   - Provides AI-powered answers about codebases
   - No authentication required for public repositories
   - Returns comprehensive repository insights to orchestrator

## 🔄 Orchestration Flow

### Standard Workflow

```
0. CLAUDE reads PROJECT_ROADMAP.md (check current state, avoid duplicates)
   ↓
1. USER provides project requirements
   ↓
2. CLAUDE analyzes and creates detailed todo list (TodoWrite)
   ↓
2a. CLAUDE updates PROJECT_ROADMAP.md with TodoWrite mirror
   ↓
3. For each todo:
   ├─ If research needed → Invoke JINO AGENT
   │                        ├─ Uses Jina AI MCP
   │                        ├─ Extracts docs/searches
   │                        └─ Returns research
   ├─ If Notion docs needed → Invoke NOTION-SCRAPER-EXPERT
   │                           ├─ Uses Suekou Notion MCP
   │                           ├─ Extracts Notion content
   │                           └─ Returns optimized Markdown
   ├─ If GitHub repo analysis needed → Invoke REPO EXPLORER
   │                                    ├─ Uses DeepWiki MCP
   │                                    ├─ Analyzes repo structure
   │                                    ├─ Extracts documentation
   │                                    ├─ Answers codebase questions
   │                                    └─ Returns repository insights
   ├─ If extreme complexity (8-10/10) → Invoke PLANNER
   │                                     ├─ Uses TASKMASTER CLI
   │                                     ├─ AI-powered task breakdown
   │                                     └─ Returns structured tasks
   ↓
4. CLAUDE invokes CODER with todo + research/docs
   ├─ Coder implements in fresh context
   ├─ On error → Coder invokes STUCK → Human decides
   └─ Reports completion
   ↓
5. CLAUDE invokes TESTER with implementation
   ├─ Tester verifies with Playwright
   ├─ On failure → Tester invokes STUCK → Human decides
   └─ Reports success
   ↓
6. CLAUDE marks todo complete
   ↓
7. Repeat steps 3-6 for next todo
   ↓
8. CLAUDE reports final results when all todos complete
```

## 🗺️ Project Roadmap - Unified Task Coordination

### The Central Coordination Hub

**File**: `/PROJECT_ROADMAP.md`

This file serves as the **single source of truth** for all project tasks and progress, enabling:
- **Parallelization**: Multiple agents can work simultaneously by seeing what's available
- **Continuity**: Any agent can pick up where others left off
- **Visibility**: All task status, dependencies, and progress at a glance
- **Coordination**: Prevents duplicate work and conflicting changes

### What's Tracked

The roadmap mirrors and consolidates:
1. **TodoWrite Tasks**: Real-time session tasks from the orchestrator
2. **TASKMASTER Tasks**: Strategic planning tasks from the planner agent
3. **Task Status**: pending, in_progress, completed, blocked
4. **Dependencies**: What must complete before a task can start
5. **Session History**: Record of what was done and when

### Usage Protocol

**ALL AGENTS (INCLUDING YOU) MUST:**

1. ✅ **READ `/PROJECT_ROADMAP.md` FIRST** before starting any work
   - Check what tasks exist and their status
   - Identify dependencies before starting
   - See what previous agents completed
   - Avoid duplicate or conflicting work

2. ✅ **UPDATE `/PROJECT_ROADMAP.md`** when appropriate:
   - **Orchestrator**: Updates after TodoWrite changes, task completions
   - **Planner Agent**: Updates after TASKMASTER operations
   - **Other Agents**: Read-only (use for coordination)

3. ✅ **COORDINATE** through the roadmap:
   - Pick up incomplete tasks
   - Respect dependencies
   - Enable seamless handoffs between agents
   - Maintain project continuity across sessions

**This enables true multi-agent parallelization and coordination!**

## 🚨 Critical Design Principles

### 1. No Fallbacks Policy

Traditional AI systems often attempt workarounds when encountering errors, which can lead to:
- Silent failures
- Incorrect implementations
- Assumptions that don't match user intent

**This system enforces**: Error → Escalate → Human Decision → Proceed Correctly

Every subagent is hardwired to invoke the stuck agent rather than guessing or using fallbacks.

### 2. Context Isolation

Each subagent gets a fresh context window for its specific task:
- **Prevents context pollution** from previous tasks
- **Maintains focus** on single objective
- **Reduces token waste** on irrelevant history
- **Enables parallel evolution** of different components

### 3. Proactive Research

The Jino Agent is invoked BEFORE coding when:
- Documentation needs to be fetched
- Best practices need to be researched
- Web content needs extraction
- Current information is required

This ensures implementations follow latest standards and best practices.

### 4. Visual Verification

Every implementation is verified with Playwright MCP:
- **Screenshot proof** of rendered output
- **Interaction testing** (clicks, forms, navigation)
- **Responsive design** verification
- **Console error** detection

No implementation is marked complete without visual verification.

## 🛠️ Tool Stack

### Core Tools Used by Orchestrator

- **TodoWrite**: Maintains project todo list
- **Task**: Invokes subagents with specific tasks
- **Read/Write/Edit**: File operations
- **Bash**: Terminal operations for git, npm, etc.

### Subagent-Specific Tools

**Jino Agent:**
- Task (for delegation)
- Read/Bash/Glob/Grep (for code exploration)
- Access to Jina AI Remote MCP:
  - jina_reader_search (extract clean markdown from URLs)
  - jina_web_search (AI-powered web search)
  - jina_image_search (find and analyze images)
  - jina_embeddings/reranker (semantic search)

**Notion Scraper Expert:**
- Task (for delegation)
- Read/Bash/Glob/Grep (for code exploration)
- Access to Suekou Notion MCP:
  - notion_retrieve_page (get page info, format: "markdown")
  - notion_retrieve_block_children (get content, format: "markdown")
  - notion_query_database (query with filters, format: "markdown")
  - notion_search (search workspace)
  - notion_create_database_item (create entries, requires approval)
  - notion_update_page_properties (update metadata, requires approval)
  - notion_delete_block (delete content, requires approval)

**Coder:**
- Read/Write/Edit (file operations)
- Glob/Grep (code search)
- Bash (build tools, package managers)
- Task (can delegate subtasks)

**Tester:**
- Task (for delegation)
- Read (view files)
- Bash (start servers, run tests)
- Access to Playwright MCP:
  - playwright_navigate (load pages)
  - playwright_screenshot (capture visuals)
  - playwright_click (test interactions)
  - playwright_evaluate (run JS in browser)

**Planner:**
- Task (for delegation)
- Read/Write/Edit (for PRD creation)
- Bash (for TASKMASTER CLI commands)
- Glob/Grep (for code exploration)
- Access to TASKMASTER CLI:
  - task-master parse-prd (convert PRD to tasks)
  - task-master analyze-complexity (AI complexity scoring)
  - task-master expand (break down complex tasks)
  - task-master research (web research for tasks)

**Stuck:**
- AskUserQuestion (ONLY agent with this tool)
- Read/Bash/Glob/Grep (for investigation)

**Secret Xpert Light** (marketplace plugin):
- Read/Write/Edit (for .envrc management)
- Bash (for direnv/1Password CLI commands)
- Glob/Grep (for finding config files)

## 📋 Best Practices for Using This System

### As an Orchestrator (Claude)

1. **Check PROJECT_ROADMAP.md first** before starting any work
2. **Always create detailed todo lists** immediately when given a project
3. **Update PROJECT_ROADMAP.md** when creating/completing tasks
4. **Delegate strategically**:
   - Simple features (1-3/10): Single coder agent
   - Moderate features (4-7/10): Break into 4-8 tasks, parallelize independent ones
   - Complex features (8-10/10): Invoke planner agent for TASKMASTER breakdown
5. **Parallelize when possible**: Invoke multiple coder agents for independent tasks
6. **Test every implementation** before marking complete
7. **Never skip the research phase** when docs/best practices are needed
8. **Maintain todo list accuracy** - update in real-time
9. **Never implement code yourself** - always delegate to coder
10. **Create all pages referenced in navigation** - prevent 404s
11. **Preserve existing patterns**: Minimal changes, follow project architecture

### As a User

1. **Trust the process** - let the system work through todos systematically
2. **Review screenshots** from tester for visual verification
3. **Respond to stuck agent** when decisions are needed
4. **Don't interrupt workflow** - let subagents complete their tasks
5. **Check todo list** to monitor progress at any time

### For Integration with Other Systems

This orchestration pattern can be adapted for:
- **Other AI CLIs** (Aider, Cursor, etc.) - use AGENTS.md
- **Custom automation** - follow the delegation pattern
- **Team workflows** - adapt subagent roles to team members
- **Educational purposes** - learn orchestration principles

## 🔌 MCP Integration

### Jina AI Remote MCP Server

**Configuration**: Set `JINA_API_KEY` environment variable

**Capabilities:**
- **Jina Reader**: Converts any URL to clean, LLM-friendly markdown
  - Removes ads, clutter, navigation
  - Extracts main content with formatting
  - Perfect for documentation scraping
- **Web Search**: Natural language search with ranked results
- **Image Search**: Find and analyze images across the web
- **Embeddings & Reranker**: Semantic search and content ranking

**Usage Pattern:**
```
Claude identifies need for research
  → Invokes jino-agent with research query
  → Jino uses Jina AI MCP to extract/search
  → Returns clean, formatted results to Claude
  → Claude provides research to coder for implementation
```

### Playwright MCP Server

**Installation**: Automatically configured via `.mcp.json`

**Capabilities:**
- Browser automation (Chromium, Firefox, WebKit)
- Screenshot capture
- Element interaction (click, type, select)
- JavaScript evaluation in browser context
- Console log monitoring

**Usage Pattern:**
```
Coder completes implementation
  → Claude invokes tester with verification task
  → Tester uses Playwright to render and capture
  → Returns screenshots and test results
  → Claude marks todo complete or escalates to stuck
```

### Suekou Notion MCP Server

**Configuration**: Set `NOTION_API_TOKEN` environment variable, enable `NOTION_MARKDOWN_CONVERSION: "true"`

**Capabilities:**
- **Page Retrieval**: Get Notion pages with properties and content
- **Database Queries**: Query databases with filters and sorts
- **Markdown Conversion**: Auto-convert to token-efficient Markdown (default)
- **Content Creation**: Create pages, databases, and database items
- **Content Management**: Update properties, delete blocks, add comments
- **Workspace Search**: Search across entire Notion workspace
- **Token Optimization**: Dramatically reduces token usage via Markdown format

**Usage Pattern:**
```
Claude identifies need for Notion documentation
  → Invokes notion-scraper-expert with Notion URL or query
  → Notion scraper uses Suekou Notion MCP to extract/convert
  → Returns clean, optimized Markdown to Claude
  → Claude provides documentation to coder for implementation
```

**Available Operations:**
- `notion_retrieve_page` - Get page info and properties
- `notion_retrieve_block_children` - Get page content (use format: "markdown")
- `notion_query_database` - Query database with filters/sorts
- `notion_search` - Search workspace by title
- `notion_create_database_item` - Add database entries (with user approval)
- `notion_update_page_properties` - Modify page metadata (with user approval)
- `notion_delete_block` - Delete blocks/pages (with user approval)

**Critical**: All write operations require user approval via stuck agent!

### DeepWiki Remote MCP Server

**Configuration**: No authentication required for public repositories

**Capabilities:**
- **Repository Structure Discovery**: Get complete documentation topics for any GitHub repo
- **Documentation Extraction**: View full documentation from GitHub repositories
- **AI-Powered Q&A**: Ask questions about codebases with context-grounded responses
- **Public Repository Access**: Free access to all public GitHub repositories
- **No Rate Limits**: Unlimited queries for public repos

**Usage Pattern:**
```
Claude identifies need for GitHub repository analysis
  → Invokes repo-explorer with repository name (owner/repo)
  → Repo Explorer uses DeepWiki MCP to analyze/extract
  → Returns repository structure, docs, and AI insights to Claude
  → Claude provides insights to coder for implementation
```

**Available Operations:**
- `read_wiki_structure` - Get list of documentation topics for a GitHub repository
- `read_wiki_contents` - View documentation about a GitHub repository
- `ask_question` - Ask AI-powered questions about repository with context-grounded answers

**When to Use:**
- Analyzing remote GitHub repositories (not local files)
- Understanding codebase architecture and patterns
- Extracting documentation from GitHub repos
- Getting AI-powered explanations about implementations
- Researching library/framework usage examples

**Note**: For local codebase analysis, use Grep/Glob tools instead. DeepWiki MCP is for remote GitHub repository exploration.

## 🎯 Example Scenarios

### Scenario 1: Building a Feature with Unknown Best Practices

```
User: "Add authentication to my Next.js app using latest 2025 patterns"

Claude:
- Creates todos: [Research auth patterns, Implement auth, Test auth flow]
- Invokes jino-agent("Latest Next.js 15 authentication patterns")
  → Jino extracts Next.js docs, searches for 2025 best practices
  → Returns comprehensive guide with code examples
- Invokes coder("Implement auth following [research]")
  → Coder implements using latest patterns
- Invokes tester("Verify login flow, protected routes")
  → Tester validates with screenshots
- Marks complete ✓
```

### Scenario 2: Handling Errors Gracefully

```
Coder attempts to implement feature
  → Encounters ambiguous requirement
  → Invokes stuck("Need clarification: should users be able to...")
    → Stuck presents options to user
    → User chooses option
  → Returns decision to coder
  → Coder proceeds with clarity
```

### Scenario 3: Complex Multi-Page Application

```
User: "Build a portfolio site with Home, About, Projects, Contact pages"

Claude:
- Creates comprehensive todos for all pages AND navigation
- Ensures every link in header/footer has corresponding page created
- Invokes coder for each page sequentially
- Invokes tester to verify ALL navigation links work (no 404s)
- Marks complete only when entire flow is verified
```

### Scenario 4: Extracting Specs from Notion

```
User: "Implement the feature described in this Notion doc: https://www.notion.so/..."

Claude:
- Creates todos: [Extract Notion specs, Implement feature, Test implementation]
- Invokes notion-scraper-expert("Extract content from Notion URL")
  → Notion scraper uses Suekou MCP to retrieve page
  → Converts to clean Markdown with feature specifications
  → Returns structured requirements
- Invokes coder("Implement feature following [specs from Notion]")
  → Coder implements based on extracted documentation
- Invokes tester("Verify feature works as specified")
  → Tester validates with screenshots
- Marks complete ✓
```

### Scenario 5: Analyzing GitHub Repository Architecture

```
User: "Implement authentication similar to how it's done in the shadcn/ui repository"

Claude:
- Creates todos: [Analyze shadcn/ui auth, Implement auth pattern, Test implementation]
- Invokes repo-explorer("Analyze authentication in shadcn-ui/ui repository")
  → Repo Explorer uses DeepWiki MCP
  → Uses read_wiki_structure to get repo documentation structure
  → Uses ask_question: "How is authentication implemented in shadcn/ui?"
  → Returns AI-powered analysis with code patterns and architecture
- Invokes coder("Implement auth following [shadcn/ui patterns]")
  → Coder implements using analyzed patterns
- Invokes tester("Verify authentication flow")
  → Tester validates with screenshots
- Marks complete ✓
```

## 🚀 Advanced Patterns

### Parallel Research and Implementation

When multiple independent research tasks exist:
```
Claude can invoke multiple jino-agent instances for different topics
→ Collects all research
→ Delegates implementations with combined knowledge
```

### Iterative Refinement

When tests reveal issues:
```
Tester reports failure
→ Claude invokes stuck with failure details
→ User decides: fix, redesign, or skip
→ Claude re-delegates to coder with decision
→ Retests until pass
```

### Proactive Documentation Fetching

Before any modern framework usage:
```
Claude automatically invokes jino-agent to fetch latest docs
→ Ensures implementations use current APIs and patterns
→ Prevents deprecated code
```

## 🔐 Security Considerations

1. **Human oversight required** for security-sensitive operations
2. **No automatic credentials** committed to git
3. **Stuck agent validates** before destructive operations
4. **Code review opportunity** at each todo completion
5. **Playwright sandboxing** for safe browser testing

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

## 🎓 Learning Resources

- **Project Roadmap**: `/PROJECT_ROADMAP.md` - **CHECK THIS FIRST!** Single source of truth for all tasks
- **Repository**: `.claude/CLAUDE.md` - Full orchestrator instructions
- **Agents**: `.claude/agents/*.md` - Individual subagent definitions
- **MCP Config**: `.mcp.json` - Server configurations
- **TASKMASTER**: `.taskmaster/tasks/tasks.json` - Strategic planning tasks
- **Examples**: `README.md` - User-friendly examples and walkthroughs

## 🔄 Adapting This System

To adapt for other AI systems or workflows:

1. **Extract the pattern**: Master orchestrator + specialized subagents
2. **Define roles clearly**: Each agent has specific tools and boundaries
3. **Enforce escalation**: No fallbacks, always escalate problems
4. **Maintain state**: Orchestrator tracks progress, agents are stateless
5. **Use appropriate tools**: MCP servers or equivalent for specialized tasks

This orchestration pattern is framework-agnostic and can be implemented in any system that supports:
- Agent delegation
- Context management
- Tool usage
- Human-in-the-loop interaction

---

**This system transforms Claude Code from a simple assistant into a project management system with specialized teams working in harmony.** 🚀
