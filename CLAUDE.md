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
        ┌───────────┬───────────┬───────────┬───────────┬───────────┬───────────┐
        ▼           ▼           ▼           ▼           ▼           ▼           ▼
    ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐
    │ NOTION │  │ CODER  │  │ TESTER │  │PLANNER │  │ STUCK  │  │SECRET  │
    │SCRAPER │  │        │  │        │  │        │  │        │  │ XPERT  │
    │(Fresh) │  │(Fresh) │  │(Fresh) │  │(Fresh) │  │(Fresh) │  │(Fresh) │
    │        │  │        │  │        │  │        │  │        │  │        │
    │ Notion │  │Implement│ │Verify  │  │AI Task │  │Human   │  │Secrets │
    │Extract │  │w/Ctx7  │  │w/Play- │  │Break-  │  │Escal-  │  │Mgmt    │
    │& Mgmt  │  │+ctxkit │  │wright  │  │down    │  │ation   │  │direnv+ │
    │        │  │        │  │        │  │        │  │        │  │1Pass   │
    └────────┘  └────────┘  └────────┘  └────────┘  └────────┘  └────────┘
```

### The Subagent System

Each subagent operates in its own isolated context window, preventing context pollution and ensuring focused execution:

1. **Notion Scraper Expert** - Notion workspace specialist
   - Uses Suekou Notion MCP for Notion operations
   - Extracts knowledge from Notion pages/databases
   - Converts Notion content to optimized Markdown
   - Manages Notion content (create, edit, delete with approval)
   - Returns structured documentation to orchestrator

2. **Coder** - Implementation specialist
   - Receives ONE specific todo item
   - Has self-service documentation via Context7 + ctxkit MCP
   - Implements clean, functional code
   - Reports completion status
   - Escalates immediately on errors

3. **Tester** - Visual verification specialist
   - Uses Playwright MCP for browser automation
   - Takes screenshots for visual validation
   - Tests interactions and navigation
   - Reports pass/fail results

4. **Planner** - AI-powered project planning specialist
   - Uses TASKMASTER CLI for extreme complexity (8-10/10)
   - Breaks down complex projects into structured tasks
   - Analyzes complexity with AI-powered research
   - Validates task dependencies
   - Returns comprehensive task breakdown to orchestrator

5. **Stuck** - Human escalation point
   - ONLY agent allowed to use AskUserQuestion
   - Presents clear options to user
   - Blocks progress until human decision
   - Returns decision to calling agent

6. **Secret Xpert Light** - Secrets management specialist (marketplace plugin)
   - Uses direnv + 1Password CLI for secure credential management
   - Manages API keys and tokens for MCP servers
   - Supports cloud and local development workflows
   - Optimized for speed with Haiku model
   - Available as separate marketplace plugin: secret-manager-pro

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
   ├─ If Notion docs needed → Invoke NOTION-SCRAPER-EXPERT
   │                           ├─ Uses Suekou Notion MCP
   │                           ├─ Extracts Notion content
   │                           └─ Returns optimized Markdown
   ├─ If extreme complexity (8-10/10) → Invoke PLANNER
   │                                     ├─ Uses TASKMASTER CLI
   │                                     ├─ AI-powered task breakdown
   │                                     └─ Returns structured tasks
   ↓
4. CLAUDE invokes CODER with todo (+ Notion docs if applicable)
   ├─ Coder uses Context7 (try FIRST) for self-service documentation
   ├─ Coder uses ctxkit (fallback) for llm.txt discovery
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

### 3. Self-Service Documentation

The Coder Agent has built-in documentation access:
- **Context7 (try FIRST)**: Popular frameworks and libraries
- **ctxkit (fallback)**: llm.txt discovery for any website
- **No API keys required**: Free and secure for Claude Code Web
- **During implementation**: Coder fetches docs as needed

This ensures implementations follow latest standards and best practices without preliminary research phase.

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
- Access to Context7 MCP (self-service docs, try FIRST)
- Access to ctxkit MCP (llm.txt discovery, fallback)

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

### Context7 MCP Server

**Configuration**: No configuration needed - works out of the box!

**Capabilities:**
- **Popular Frameworks**: React, Next.js, Vue, Svelte, Angular, and more
- **Libraries**: TypeScript, Tailwind CSS, shadcn/ui, and more
- **Pre-indexed Docs**: Fast, instant access to documentation
- **No API Key Required**: Free and secure for Claude Code Web

**Usage Pattern:**
```
Coder receives implementation task
  → Coder uses Context7 to fetch framework/library docs
  → Implements feature using latest best practices from docs
  → Reports completion to orchestrator
```

### ctxkit MCP Server

**Configuration**: No configuration needed - works out of the box!

**Capabilities:**
- **llm.txt Discovery**: Finds llm.txt files on any website
- **Universal Coverage**: Works with any site that provides llm.txt
- **Lightweight**: Simple, fast documentation retrieval
- **No API Key Required**: Free and secure for Claude Code Web

**Usage Pattern:**
```
Coder needs docs not in Context7
  → Coder uses ctxkit to discover llm.txt
  → Fetches documentation from llm.txt file
  → Implements feature using retrieved docs
  → Reports completion to orchestrator
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

## 🎯 Example Scenarios

### Scenario 1: Building a Feature with Unknown Best Practices

```
User: "Add authentication to my Next.js app using latest 2025 patterns"

Claude:
- Creates todos: [Implement auth structure, Add login page, Add protected routes, Test auth flow]
- Invokes coder("Implement auth structure using latest Next.js 15 patterns")
  → Coder uses Context7 to fetch Next.js 15 auth documentation
  → Coder implements using latest patterns from docs
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

## 🚀 Advanced Patterns

### Iterative Refinement

When tests reveal issues:
```
Tester reports failure
→ Claude invokes stuck with failure details
→ User decides: fix, redesign, or skip
→ Claude re-delegates to coder with decision
→ Retests until pass
```

### Self-Service Documentation

During implementation:
```
Coder automatically fetches docs via Context7 + ctxkit
→ Ensures implementations use current APIs and patterns
→ Prevents deprecated code
→ No preliminary research phase needed
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
- ✅ Coder uses self-service docs (Context7 + ctxkit) during implementation
- ✅ Each todo implemented → tested → completed sequentially
- ✅ Human consulted via stuck agent for ambiguities
- ✅ All navigation links functional (zero 404s)
- ✅ Visual proof (screenshots) of all implementations
- ✅ Zero fallbacks or workarounds used
- ✅ Clean, maintainable code following latest best practices

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
