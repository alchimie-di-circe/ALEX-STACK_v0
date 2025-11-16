# TASKMASTER CLI Integration Guide

## Overview

TASKMASTER is an AI-powered task management system integrated with ALEX-STACK orchestrator to handle **extremely complex** task breakdown and dependency analysis.

> **🎯 IMPORTANT FOR ORCHESTRATOR**: Instead of using TASKMASTER CLI directly, invoke the **planner agent** which encapsulates all TASKMASTER operations and provides a clean, robust interface. The planner agent handles PRD creation, parsing, complexity analysis, task expansion, and dependency validation automatically. See `.claude/agents/planner.md` for details.
>
> This guide documents the underlying CLI commands for reference and understanding, but you should delegate to the planner agent rather than executing these commands yourself.

## Installation Status

✅ **Installed**: `task-master-ai` (global npm package)
✅ **Configured**: Uses `claude-code` provider (no API key needed)
✅ **Location**: `.taskmaster/` directory with `tasks.json` in project root

## When to Use TASKMASTER

### Use TASKMASTER CLI When:
- **Task complexity 8-10/10**: Extremely complex multi-step implementations
- **PRD parsing needed**: Formal Product Requirements Documents to convert
- **Deep dependency analysis**: Complex task interdependencies to map
- **Structured breakdown required**: Need AI-powered task expansion with subtasks
- **Large project initialization**: Starting a major new feature or module

### Use TodoWrite (Standard) When:
- **Normal orchestration**: Most day-to-day tasks (complexity 1-7/10)
- **Clear requirements**: Task is already well-defined
- **Real-time tracking**: Monitoring ongoing implementation progress
- **User communication**: Showing status updates to user
- **Simple task lists**: Straightforward todo management

## Architecture Integration

```
┌───────────────────────────────────────────────────────┐
│  ORCHESTRATOR (Claude 200k Context)                   │
│  ├─ TodoWrite: Standard task tracking (90% of cases) │
│  └─ TASKMASTER: Complex analysis (10% of cases)      │
└───────────────────────────────────────────────────────┘
                    │
        ┌───────────┴──────────┐
        ▼                      ▼
  ┌──────────────┐      ┌──────────────┐
  │  TodoWrite   │      │  TASKMASTER  │
  │              │      │     CLI      │
  │ • Fast       │      │ • Deep AI    │
  │ • Real-time  │      │ • Complexity │
  │ • Simple     │      │ • Dependencies│
  └──────────────┘      └──────────────┘
```

## Key Commands

### Project Management
```bash
# View current tasks
task-master list

# View next task to work on
task-master next

# Show task details
task-master show <id>

# View model configuration
task-master models
```

### PRD-Based Workflow
```bash
# 1. Create PRD in .taskmaster/docs/
# 2. Parse PRD into tasks
task-master parse-prd docs/<filename>.txt

# 3. Analyze task complexity
task-master analyze-complexity

# 4. Expand complex tasks (uses AI)
task-master expand --all

# 5. View generated tasks
task-master list
```

### Task Creation & Management
```bash
# Add task with AI prompt
task-master add-task --prompt="Implement feature X with Y dependencies"

# Add task with research
task-master add-task --prompt="..." --research

# Update task
task-master update-task --id=<id> --prompt="Updated requirements"

# Set task status
task-master set-status --id=<id> --status=<pending|in-progress|done|review>

# Remove task
task-master remove-task --id=<id>
```

### Complexity Analysis
```bash
# Analyze all tasks, score 1-10, recommend subtask counts
task-master analyze-complexity

# With research (uses fresh web info)
task-master analyze-complexity --research

# Output: scripts/task-complexity-report.json
```

### Task Expansion (AI-Powered Breakdown)
```bash
# Expand single task into subtasks
task-master expand --id=<id>

# Expand with specific subtask count
task-master expand --id=<id> --num=7

# Expand with custom prompt context
task-master expand --id=<id> --prompt="Focus on security and performance"

# Expand with research
task-master expand --id=<id> --research

# Expand all tasks (uses complexity report)
task-master expand --all

# Force re-expansion
task-master expand --all --force
```

### Dependency Management
```bash
# Add dependency (task X depends on task Y)
task-master add-dependency --id=<X> --depends-on=<Y>

# Remove dependency
task-master remove-dependency --id=<X> --depends-on=<Y>

# Validate dependency graph (detect circular refs)
task-master validate-dependencies

# Fix broken dependencies
task-master fix-dependencies
```

### Research Tool
```bash
# AI-powered web research with fresh info
task-master research "Next.js 15 authentication best practices"

# Research with task context
task-master research "API optimization" --id=15 --files=src/api.js

# Save research to task
task-master research "OAuth 2.0 patterns" --save-to=15.2
```

### Tagged Task Lists (Multi-Context)
```bash
# Create tag for isolated task context
task-master add-tag feature-auth

# Create tag from git branch
task-master add-tag --from-branch

# Switch to tag context
task-master use-tag feature-auth

# List all tags
task-master tags

# Copy tag
task-master copy-tag master feature-backup

# Delete tag
task-master delete-tag feature-auth
```

### Task Reorganization
```bash
# Move task to different position
task-master move --from=<id> --to=<id>

# Examples:
# Convert task to subtask
task-master move --from=5 --to=7.1

# Promote subtask to task
task-master move --from=5.2 --to=7

# Reorder subtasks
task-master move --from=5.2 --to=5.4

# Bulk move
task-master move --from=10,11,12 --to=16,17,18
```

## Workflow: TASKMASTER + TodoWrite Synergy

### Scenario 1: PRD-Driven Development

```bash
# User provides: "Build e-commerce platform with cart, checkout, payments"

# Step 1: Orchestrator creates PRD
cat > .taskmaster/docs/ecommerce-prd.txt <<EOF
# E-Commerce Platform PRD
## Features
- Product catalog with search/filtering
- Shopping cart with persistence
- Multi-step checkout flow
- Payment processing (Stripe)
- Order management system
EOF

# Step 2: Parse PRD with TASKMASTER
task-master parse-prd docs/ecommerce-prd.txt
# Output: tasks.json with initial task structure

# Step 3: Analyze complexity
task-master analyze-complexity --research
# Output: Scores each task 1-10, recommends subtask counts

# Step 4: Expand complex tasks (8-10/10)
task-master expand --all
# Output: Detailed subtasks with dependencies

# Step 5: Read tasks.json and convert to TodoWrite
# Orchestrator reads tasks.json, populates TodoWrite for tracking

# Step 6: Delegate to subagents
# Use coder/tester as normal, track progress with TodoWrite
```

### Scenario 2: On-Demand Complexity Analysis

```bash
# User: "This seems really complex, can you break it down better?"

# Current TodoWrite has task: "Implement real-time collaboration system"

# Step 1: Create focused task in TASKMASTER
task-master add-task --prompt="Implement real-time collaboration with WebRTC, CRDT sync, presence, and conflict resolution" --research

# Step 2: Analyze complexity
task-master analyze-complexity --research
# Output: Complexity 9/10, recommends 8 subtasks

# Step 3: Expand with research
task-master expand --id=1 --research
# Output: 8 detailed subtasks with WebRTC setup, CRDT implementation, etc.

# Step 4: Transfer to TodoWrite
# Read subtasks, create todos in TodoWrite for execution tracking

# Step 5: Normal delegation
# Coder gets clear, researched subtasks
```

### Scenario 3: Dependency-Heavy Project

```bash
# Complex project with many interdependent tasks

# Step 1: Define all high-level tasks
task-master add-task --prompt="Database schema design"
task-master add-task --prompt="API layer implementation"
task-master add-task --prompt="Frontend components"
task-master add-task --prompt="Integration tests"

# Step 2: Define dependencies
task-master add-dependency --id=2 --depends-on=1  # API depends on DB
task-master add-dependency --id=3 --depends-on=2  # Frontend depends on API
task-master add-dependency --id=4 --depends-on=3  # Tests depend on Frontend

# Step 3: Validate
task-master validate-dependencies
# Output: ✓ No circular dependencies

# Step 4: Expand each in dependency order
task-master expand --id=1 --research
task-master expand --id=2 --research
task-master expand --id=3 --research
task-master expand --id=4 --research

# Step 5: Execute with TodoWrite
# Orchestrator reads dependency order, creates TodoWrite tasks
# Ensures coder never works on dependent task before prerequisite
```

## File Structure

```
ALEX-STACK_v0/
├─ .taskmaster/
│  ├─ config.json           # Model & provider configuration
│  ├─ state.json            # Current tag & runtime state
│  ├─ docs/
│  │  └─ prd.txt            # Product requirements documents
│  ├─ templates/
│  │  └─ example_prd.txt    # PRD template
│  └─ research/             # Saved research conversations
├─ tasks.json               # Main task database (TASKMASTER)
├─ tasks/                   # Individual task files
│  ├─ task_001.txt
│  └─ task_002.txt
└─ scripts/
   └─ task-complexity-report.json  # Complexity analysis output
```

## Configuration Details

### Model Configuration (`.taskmaster/config.json`)

```json
{
  "models": {
    "main": {
      "provider": "claude-code",
      "modelId": "sonnet",
      "maxTokens": 64000,
      "temperature": 0.2
    },
    "research": {
      "provider": "claude-code",
      "modelId": "sonnet",
      "maxTokens": 8192,
      "temperature": 0.1
    },
    "fallback": {
      "provider": "claude-code",
      "modelId": "haiku",
      "maxTokens": 64000,
      "temperature": 0.2
    }
  },
  "global": {
    "defaultTag": "master",
    "defaultNumTasks": 10,
    "defaultSubtasks": 5,
    "defaultPriority": "medium"
  }
}
```

**Why `claude-code` provider?**
- ✅ No API key required (uses current Claude Code session)
- ✅ Free (no per-token costs)
- ✅ High performance (Sonnet 72.7% SWE score)
- ✅ Integrated with orchestrator context

## Best Practices

### 1. Use TASKMASTER Selectively
- **Don't** use for every task (adds overhead)
- **Do** use for genuinely complex scenarios (8-10/10 complexity)
- **Do** keep TodoWrite as primary tracking system

### 2. PRD-First for Large Projects
- Create `.taskmaster/docs/project-prd.txt` for major features
- Use `parse-prd` to generate initial structure
- Expand complex tasks, keep simple ones as-is

### 3. Research Before Implementation
- Use `--research` flag for current best practices
- Saves time vs outdated patterns
- Ensures modern, idiomatic implementations

### 4. Validate Dependencies
- Run `validate-dependencies` before starting work
- Fix circular dependencies early
- Use dependency order for TodoWrite sequence

### 5. Tag-Based Isolation
- Use tags for parallel feature development
- Create tag from branch: `add-tag --from-branch`
- Switch contexts: `use-tag <name>`

### 6. Hybrid Workflow
```
TASKMASTER (Planning) → TodoWrite (Execution) → Subagents (Implementation)
```

## Example: Full Integration Workflow

```bash
# ═══════════════════════════════════════════════════════
# PLANNING PHASE (TASKMASTER)
# ═══════════════════════════════════════════════════════

# 1. User provides complex project
# "Build a multi-tenant SaaS with auth, billing, and analytics"

# 2. Orchestrator creates PRD
cat > .taskmaster/docs/saas-platform-prd.txt <<EOF
# Multi-Tenant SaaS Platform
## Core Features
1. Multi-tenant architecture with data isolation
2. Authentication (OAuth, MFA, SSO)
3. Billing system (Stripe, subscriptions, usage-based)
4. Analytics dashboard (real-time metrics)
5. Admin panel (tenant management, monitoring)
EOF

# 3. Parse PRD
task-master parse-prd docs/saas-platform-prd.txt
# Output: 5 high-level tasks created

# 4. Analyze complexity
task-master analyze-complexity --research
# Output:
#   Task 1 (Multi-tenant arch): 9/10 → 8 subtasks
#   Task 2 (Auth): 8/10 → 6 subtasks
#   Task 3 (Billing): 9/10 → 7 subtasks
#   Task 4 (Analytics): 7/10 → 5 subtasks
#   Task 5 (Admin): 6/10 → 4 subtasks

# 5. Expand high-complexity tasks (8-10/10)
task-master expand --id=1 --research  # Multi-tenant
task-master expand --id=2 --research  # Auth
task-master expand --id=3 --research  # Billing

# Keep tasks 4-5 as-is (complexity < 8/10)

# 6. Read generated structure
task-master show 1
task-master show 2
task-master show 3

# ═══════════════════════════════════════════════════════
# EXECUTION PHASE (TodoWrite + Subagents)
# ═══════════════════════════════════════════════════════

# 7. Orchestrator reads tasks.json
cat tasks.json

# 8. Create TodoWrite based on TASKMASTER output
# TodoWrite: [All 30 subtasks from expanded tasks + 2 non-expanded]

# 9. Delegate first todo to coder
# "Implement tenant schema with foreign keys and RLS policies"

# 10. Test with tester
# Verify tenant isolation works

# 11. Mark complete, move to next
# Continue through all 32 todos

# 12. Report completion to user
# All tasks done, tested, verified
```

## Troubleshooting

### Issue: "No API key found"
**Solution**: Config already uses `claude-code` provider (no key needed)

### Issue: Complex task not breaking down well
**Solution**: Use `--research` flag for better context:
```bash
task-master expand --id=X --research
```

### Issue: Circular dependencies
**Solution**: Validate and fix:
```bash
task-master validate-dependencies
task-master fix-dependencies
```

### Issue: Tasks not showing up
**Solution**: Check current tag context:
```bash
task-master tags
task-master use-tag master
```

### Issue: Want to use different AI model
**Solution**: Change provider in `.taskmaster/config.json`:
```bash
task-master models --set-main claude-code:opus
task-master models --set-research claude-code:sonnet
```

## Advanced Features

### Cost Tracking
TASKMASTER tracks token usage and estimates costs (free for `claude-code`)

### Multiple Providers
Can configure fallback to other providers if needed:
- OpenAI (requires `OPENAI_API_KEY`)
- Google Gemini (requires `GOOGLE_API_KEY`)
- Perplexity (requires `PERPLEXITY_API_KEY`)
- 100+ models supported

### Offline Mode
Use Ollama provider for completely local operation:
```bash
task-master models --set-main ollama:qwen3
```

### MCP Integration (Not Used)
TASKMASTER can run as MCP server, but we use CLI to avoid token overhead:
- MCP mode: 5,000-21,000 token overhead
- CLI mode: 0 token overhead ✓

## Integration with ALEX-STACK Components

### With Coder Agent (Context7 + ctxkit)
Both provide documentation capabilities:
- **Coder Agent**: Self-service docs via Context7 and ctxkit MCP servers
- **TASKMASTER Research**: AI web search for planning, fresh information
- **Use together**: Coder handles implementation docs, TASKMASTER for complex planning

### With Coder Agent
- TASKMASTER: Generates detailed implementation tasks
- Coder: Executes individual tasks from breakdown
- **Flow**: TASKMASTER → TodoWrite → Coder

### With Tester Agent
- TASKMASTER: Defines test strategies in task breakdown
- Tester: Validates implementations with Playwright
- **Flow**: TASKMASTER defines tests → Tester executes

### With Orchestrator
- Orchestrator: Maintains big picture (200k context)
- TASKMASTER: Handles extreme complexity analysis
- **Division**: Orchestrator decides WHEN to use TASKMASTER

## Quick Reference

| Feature | TodoWrite | TASKMASTER CLI |
|---------|-----------|----------------|
| **Use Case** | Normal tasks | Extreme complexity |
| **Speed** | Instant | AI-powered (slower) |
| **Complexity** | 1-7/10 | 8-10/10 |
| **Overhead** | None | Bash + AI calls |
| **Dependency Tracking** | Manual | Automatic |
| **Research** | Via Coder self-service | Built-in `--research` |
| **Subtask Expansion** | Manual | AI-powered |
| **Best For** | Real-time tracking | Planning phase |

## Documentation & Resources

- **Official Docs**: https://docs.task-master.dev
- **GitHub**: https://github.com/eyaltoledano/claude-task-master
- **Discord**: https://discord.gg/taskmasterai
- **Integration Guide**: This file (`.claude/tools/TASKMASTER.md`)
- **Orchestrator Docs**: `.claude/CLAUDE.md`

---

**Remember**: TASKMASTER is a specialized tool for extreme complexity. Most tasks should still use TodoWrite for simplicity and speed. Use TASKMASTER only when the complexity truly warrants AI-powered breakdown and dependency analysis.
