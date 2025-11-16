---
description: Import Claude Code Orchestration System into current project
---

# Import Orchestration System

You are being asked to import the **Claude Code Orchestration System** into this project.

## What This System Provides

Once imported, you will operate as the **orchestrator** with:
- **200k context window** for project state management
- **TodoWrite** for task tracking
- **Agent delegation** (coder, tester, planner, jino-agent, stuck)
- **PROJECT_ROADMAP.md** for multi-agent coordination
- **TASKMASTER** for extreme complexity breakdown (8-10/10)
- **Feature implementation guidelines** for parallelized execution

## Source Location

The user will specify the source path. Common locations:
- Local: `/home/user/ALEX-STACK_v0`
- GitHub: `https://github.com/alchimie-di-circe/ALEX-STACK_v0`

If not specified, ask: "What is the path to the ALEX-STACK_v0 orchestration system?"

---

## Import Process

Follow this checklist systematically. Mark each item as you complete it.

### Step 1: Verify Source

- [ ] Read source `.claude/CLAUDE.md` to verify it's the orchestration system
- [ ] Check source has `.claude/agents/` directory with multiple agent files
- [ ] Confirm source has `PROJECT_ROADMAP.md` template
- [ ] Verify `.taskmaster/` structure exists

**If source verification fails**: Stop and inform user the source is invalid.

### Step 2: Copy Orchestrator Instructions

Copy the orchestrator's main instructions:

- [ ] Copy `.claude/CLAUDE.md` from source to current project
  - Use Read tool to read source file
  - Use Write tool to write to current project
  - Verify file is complete (should be ~500+ lines)

### Step 3: Copy Agent Definitions

Copy all agent definition files:

- [ ] List all files in source `.claude/agents/` directory
- [ ] For each agent file found (SKIP deprecated agents like jino-agent.md):
  - [ ] `planner.md` - AI-powered planning specialist
  - [ ] `coder.md` - Implementation specialist (if exists)
  - [ ] `tester.md` - Visual verification specialist (if exists)
  - [ ] `stuck.md` - Human escalation specialist (if exists)
  - [ ] `notion-scraper-expert.md` - Notion workspace specialist (if exists)
  - [ ] Any other custom agents in the directory (except deprecated ones)
- [ ] Create `.claude/agents/` directory in current project (if not exists)
- [ ] Copy each agent file from source to current project

### Step 4: Copy Documentation Files

Copy user-facing documentation:

- [ ] Copy `CLAUDE.md` from source root → current project root
  - This is the user guide explaining the system
- [ ] Copy `AGENTS.md` from source root → current project root
  - This is for external systems integration
- [ ] Verify both files copied successfully

### Step 5: Initialize PROJECT_ROADMAP

- [ ] Check if current project already has `PROJECT_ROADMAP.md`
  - If YES: Ask user if they want to preserve it or replace it
  - If NO: Copy `templates/PROJECT_ROADMAP_template.md` from source to `PROJECT_ROADMAP.md` in the current project
- [ ] If copied, update the roadmap header with current project name
- [ ] Clear any existing tasks from the copied template (start fresh)
- [ ] Set "Last Updated" to current date

### Step 6: Initialize TASKMASTER

Set up TASKMASTER for extreme complexity scenarios:

- [ ] Create `.taskmaster/` directory in current project
- [ ] Create `.taskmaster/tasks/` subdirectory
- [ ] Create `.taskmaster/docs/` subdirectory
- [ ] Copy `.taskmaster/config.json` if exists in source
- [ ] Initialize `.taskmaster/tasks/tasks.json` with empty structure:
  ```json
  {
    "master": {
      "tasks": [],
      "metadata": {
        "version": "1.0.0",
        "created": "2025-11-15T00:00:00.000Z",
        "lastModified": "2025-11-15T00:00:00.000Z",
        "tags": ["master"]
      }
    }
  }
  ```

### Step 7: Copy Additional Tools (Optional)

If source has additional tools, copy them:

- [ ] Check if source has `.claude/tools/` directory
- [ ] If YES, copy all tool documentation files (e.g., `TASKMASTER.md`)
- [ ] Check if source has `.claude/commands/` directory
- [ ] If YES, copy other useful slash commands (but not this import command itself)

### Step 8: Verify Installation

Run verification checks:

- [ ] Verify `.claude/CLAUDE.md` exists and has "YOU ARE THE ORCHESTRATOR" at top
- [ ] Count agent files in `.claude/agents/` (should be 4-7 files)
- [ ] Verify `PROJECT_ROADMAP.md` exists in root
- [ ] Verify `.taskmaster/tasks/tasks.json` exists and is valid JSON
- [ ] Check `CLAUDE.md` and `AGENTS.md` exist in root

**If any verification fails**: Report which files are missing and ask user how to proceed.

### Step 9: Report Success

Once all steps complete, report to user:

```markdown
✅ **ORCHESTRATION SYSTEM IMPORTED SUCCESSFULLY!**

## Files Installed

### Core Orchestrator
- ✓ `.claude/CLAUDE.md` (orchestrator instructions)

### Agents (N agents)
- ✓ `.claude/agents/planner.md`
- ✓ `.claude/agents/coder.md`
- ✓ `.claude/agents/tester.md`
- ✓ `.claude/agents/stuck.md`
- ✓ `.claude/agents/notion-scraper-expert.md`
- ✓ (list any other agents, excluding deprecated ones)

### Documentation
- ✓ `CLAUDE.md` (user guide)
- ✓ `AGENTS.md` (external systems guide)
- ✓ `PROJECT_ROADMAP.md` (task coordination hub)

### Infrastructure
- ✓ `.taskmaster/` (extreme complexity support)
- ✓ (any additional tools)

---

## 🎯 I AM NOW OPERATING IN ORCHESTRATOR MODE

**Capabilities:**
- 200k context window for project state
- TodoWrite for real-time task tracking
- PROJECT_ROADMAP.md for multi-agent coordination
- Agent delegation: coder, tester, planner, notion-scraper-expert, stuck
- Self-service documentation: Context7 + ctxkit (no API keys!)
- TASKMASTER for extreme complexity (8-10/10)
- Feature implementation with parallelization support

**My Workflow:**
1. Read PROJECT_ROADMAP.md before any work
2. Create TodoWrite task lists
3. Assess complexity (1-10)
4. Delegate to specialized agents
5. Parallelize independent tasks
6. Test every implementation
7. Update PROJECT_ROADMAP.md as I progress

---

## Ready to orchestrate! What would you like to build?
```

---

## Important Notes

**CRITICAL RULES:**
- ❌ **DO NOT** copy `.git/` directory or any git-related files
- ❌ **DO NOT** copy `node_modules/` or any dependency directories
- ❌ **DO NOT** copy project-specific source code from ALEX-STACK_v0
- ✅ **ONLY** copy orchestration system files (.claude/, docs, PROJECT_ROADMAP, .taskmaster/)
- ✅ **PRESERVE** any existing project files in the current repo

**Error Handling:**
- If any file read fails, report the error and continue with remaining files
- If a file already exists, ask user before overwriting (except PROJECT_ROADMAP which has special handling)
- If source path is invalid, ask user to verify and provide correct path

**Context Optimization:**
- When reading large files, verify they are orchestration-related before copying
- Skip binary files or non-text files
- Focus on .md, .json, and documentation files only

---

## Your Task Now

Execute the import process above **systematically**, step by step.

Use the Bash, Read, Write, Glob tools as needed. Report progress after each major step.

When complete, announce that you are now operating in orchestrator mode and ready to build.
