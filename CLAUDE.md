# Claude Code Orchestration System - Technical Guide

## 🎯 System Overview

This is an advanced orchestration system for Claude Code that leverages a 200k context window to manage complex software projects. The system uses a master-agent architecture where Claude acts as the orchestrator, delegating tasks to specialized subagents that work in isolated context windows.

## 🏗️ Architecture

### Core Principle: Separation of Concerns

```
┌─────────────────────────────────────────────────────────────┐
│  CLAUDE (200k Context) - Master Orchestrator               │
│  - Maintains project state and todo lists                   │
│  - Delegates individual tasks to subagents                   │
│  - Tracks overall progress                                   │
│  - Makes high-level decisions                                │
└─────────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┬──────────────┐
        ▼                  ▼                  ▼              ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ JINO AGENT   │  │ CODER        │  │ TESTER       │  │ STUCK        │
│ (Fresh)      │  │ (Fresh)      │  │ (Fresh)      │  │ (Fresh)      │
│              │  │              │  │              │  │              │
│ Research &   │  │ Implements   │  │ Verifies     │  │ Human        │
│ Web Extract  │  │ One Task     │  │ w/Playwright │  │ Escalation   │
└──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘
```

### The Subagent System

Each subagent operates in its own isolated context window, preventing context pollution and ensuring focused execution:

1. **Jino Agent** - Web research specialist
   - Uses Jina.ai Remote MCP for web operations
   - Extracts documentation with Jina Reader
   - Performs AI-powered web searches
   - Returns structured research to orchestrator

2. **Coder** - Implementation specialist
   - Receives ONE specific todo item
   - Implements clean, functional code
   - Reports completion status
   - Escalates immediately on errors

3. **Tester** - Visual verification specialist
   - Uses Playwright MCP for browser automation
   - Takes screenshots for visual validation
   - Tests interactions and navigation
   - Reports pass/fail results

4. **Stuck** - Human escalation point
   - ONLY agent allowed to use AskUserQuestion
   - Presents clear options to user
   - Blocks progress until human decision
   - Returns decision to calling agent

## 🔄 Orchestration Flow

### Standard Workflow

```
1. USER provides project requirements
   ↓
2. CLAUDE analyzes and creates detailed todo list (TodoWrite)
   ↓
3. For each todo:
   ├─ If research needed → Invoke JINO AGENT
   │                        ├─ Uses Jina AI MCP
   │                        ├─ Extracts docs/searches
   │                        └─ Returns research
   ↓
4. CLAUDE invokes CODER with todo + research
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

**Stuck:**
- AskUserQuestion (ONLY agent with this tool)
- Read/Bash/Glob/Grep (for investigation)

## 📋 Best Practices for Using This System

### As an Orchestrator (Claude)

1. **Always create detailed todo lists** immediately when given a project
2. **Delegate one todo at a time** - no batch processing
3. **Test every implementation** before marking complete
4. **Never skip the research phase** when docs/best practices are needed
5. **Maintain todo list accuracy** - update in real-time
6. **Never implement code yourself** - always delegate to coder
7. **Create all pages referenced in navigation** - prevent 404s

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

- **Repository**: `.claude/CLAUDE.md` - Full orchestrator instructions
- **Agents**: `.claude/agents/*.md` - Individual subagent definitions
- **MCP Config**: `.mcp.json` - Server configurations
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
