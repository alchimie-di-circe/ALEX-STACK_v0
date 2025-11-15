# Repository Reorganization Analysis & Proposal

## Executive Summary

This document analyzes the current ALEX-STACK_v0 repository structure and proposes a reorganization to:
1. Update CLAUDE.md with missing agents (notion-scraper-expert)
2. Group E2B/Docker sandboxed agent files in dedicated folder
3. Organize documentation by topic for better discoverability
4. Prepare ORCHESTRATION BASIC plugin for marketplace

## Current State Analysis

### Agents Inventory

**Existing Agents** (.claude/agents/):
1. ✅ **coder** - Implementation specialist
2. ✅ **jino-agent** - Web research specialist (Jina.ai MCP)
3. ✅ **notion-scraper-expert** - Notion workspace specialist (Suekou Notion MCP) ⚠️ MISSING FROM CLAUDE.md
4. ✅ **planner** - AI-powered project planning (TASKMASTER CLI)
5. ✅ **secret-xpert-light** - Secrets management (direnv + 1Password) - In marketplace/
6. ✅ **stuck** - Human escalation point
7. ✅ **tester** - Visual verification (Playwright MCP)

### MCP Servers (.mcp.json)

1. **playwright** - Browser automation for tester agent
2. **jina-mcp-server** - Jina.ai remote MCP for jino-agent
3. **notion** - Suekou Notion MCP for notion-scraper-expert ⚠️ AGENT NOT IN CLAUDE.md
4. **awesome-copilot** - Disabled, for discovering community prompts

### Tools

1. **TASKMASTER CLI** - AI-powered task breakdown (used by planner agent)
2. **direnv** - Environment variable management
3. **1Password CLI** - Secrets vault integration

### Documentation Status

**CLAUDE.md Files (Root & .claude/):**
- Root CLAUDE.md: Technical guide for users ✅ UPDATED
- .claude/CLAUDE.md: Orchestrator instructions ✅ UPDATED
- ✅ **AGENTS.md converted to reference index** (was duplicate, now 67-line index pointing to CLAUDE.md)

**Status:**
- ✅ notion-scraper-expert agent now documented in CLAUDE.md
- ✅ planner agent documented in CLAUDE.md
- ✅ Architecture diagram updated with all 7 agents
- ✅ AGENTS.md no longer a duplicate (converted to index)
- ✅ PROJECT_ROADMAP.md consolidated (removed duplications)

### File Organization Issues

**Root Directory** (cluttered with 30+ files):

**E2B/Docker Files** (9 files - should be grouped):
- E2B_ARCHITECTURE.md
- E2B_CLOUD_GUIDE.md
- E2B_COMPARISON.md
- E2B_IMPLEMENTATION_SUMMARY.md
- E2B_SETUP_GUIDE.md
- Dockerfile.e2b
- Dockerfile.e2b.local
- docker-entrypoint.sh
- e2b-sandbox.config.json
- start-e2b-sandbox.sh
- src/e2b-cloud-sandbox.js

**MCP Files** (2 locations - should consolidate):
- MCP_AUTH_SETUP_STATUS.md (root)
- MCP_TOOLS_docs/Archon_Research_Report.md

**Security/Secrets Files** (scattered):
- SECRETS_MANAGEMENT_GUIDE.md (root)
- VAULT_SETUP.md (root)
- verify-1password-config.sh (root)
- .envrc, .envrc.local.example (root)
- templates/.envrc.*.template (templates/)
- docs/1PASSWORD-CREDENTIALS-STANDARD.md
- docs/1PASSWORD-INTEGRATION.md

**General Docs** (root):
- CLAUDE.md (keep in root)
- AGENTS.md (duplicate - remove)
- README.md (keep in root)
- COPILOT_QUICK_START.md (could move to docs/)
- VERIFICA-CONFIGURAZIONE.md (Italian verification doc - could move to docs/)

**Empty Placeholder Folders**:
- docs/AGENTS/.gitkeep
- docs/E2B/.gitkeep
- docs/PLUGINS/.gitkeep
- docs/SECURITY/.gitkeep
- 1pass/ (contains only empty file)

## Proposed Reorganization

### New Structure

```
/ALEX-STACK_v0
├── CLAUDE.md                    (main technical guide - UPDATED)
├── README.md                    (main readme)
├── package.json
├── .mcp.json
├── .gitignore
├── .dockerignore
├── .env.example
├── .envrc                       (user-specific, gitignored)
│
├── .claude/                     (Claude Code configuration)
│   ├── CLAUDE.md                (orchestrator instructions - UPDATED)
│   ├── agents/                  (all 7 agent definitions)
│   │   ├── coder.md
│   │   ├── jino-agent.md
│   │   ├── notion-scraper-expert.md
│   │   ├── planner.md
│   │   ├── secret-xpert-light.md
│   │   ├── stuck.md
│   │   └── tester.md
│   ├── examples/
│   │   └── TASKMASTER-WORKFLOW-EXAMPLE.md
│   └── tools/
│       └── TASKMASTER.md
│
├── .taskmaster/                 (TASKMASTER CLI state)
│   ├── config.json
│   ├── state.json
│   ├── docs/
│   ├── tasks/
│   └── templates/
│
├── .devcontainer/               (devcontainer config)
│   └── devcontainer.json
│
├── docs/                        (📁 REORGANIZED)
│   ├── 1PASSWORD-CREDENTIALS-STANDARD.md
│   ├── 1PASSWORD-INTEGRATION.md
│   ├── SETUP-LOCAL.md
│   ├── COPILOT_QUICK_START.md   (moved from root)
│   ├── VERIFICA-CONFIGURAZIONE.md (moved from root)
│   │
│   ├── E2B/                     (📁 E2B documentation)
│   │   ├── E2B_ARCHITECTURE.md  (moved from root)
│   │   ├── E2B_CLOUD_GUIDE.md   (moved from root)
│   │   ├── E2B_COMPARISON.md    (moved from root)
│   │   ├── E2B_IMPLEMENTATION_SUMMARY.md (moved from root)
│   │   └── E2B_SETUP_GUIDE.md   (moved from root)
│   │
│   ├── MCP/                     (📁 MCP documentation)
│   │   ├── MCP_AUTH_SETUP_STATUS.md (moved from root)
│   │   └── Archon_Research_Report.md (moved from MCP_TOOLS_docs/)
│   │
│   └── SECURITY/                (📁 Security documentation)
│       ├── SECRETS_MANAGEMENT_GUIDE.md (moved from root)
│       └── VAULT_SETUP.md       (moved from root)
│
├── e2b/                         (📁 NEW - E2B implementation files)
│   ├── Dockerfile.e2b           (moved from root)
│   ├── Dockerfile.e2b.local     (moved from root)
│   ├── docker-entrypoint.sh     (moved from root)
│   ├── e2b-sandbox.config.json  (moved from root)
│   ├── start-e2b-sandbox.sh     (moved from root)
│   └── src/
│       └── e2b-cloud-sandbox.js (moved from src/)
│
├── scripts/                     (scripts and utilities)
│   ├── install-plugin.sh
│   ├── sync-agents.sh
│   └── verify-1password-config.sh (moved from root)
│
├── templates/                   (configuration templates)
│   ├── .envrc.1password.template
│   ├── .envrc.local.example
│   └── .envrc.manual.template
│
└── marketplace/                 (marketplace plugins)
    └── secret-manager-pro/
        └── orchestration-basic/ (📁 NEW - to be created)
```

### Files to Remove

1. **AGENTS.md** (duplicate of CLAUDE.md - delete)
2. **MCP_TOOLS_docs/** (move content to docs/MCP/, delete folder)
3. **1pass/** (empty folder with dummy file - delete)
4. **src/** (only contains e2b file, move to e2b/src/ - delete old folder)
5. **docs/AGENTS/.gitkeep** (remove empty placeholder)
6. **docs/E2B/.gitkeep** (remove empty placeholder after populating)
7. **docs/PLUGINS/.gitkeep** (remove empty placeholder)
8. **docs/SECURITY/.gitkeep** (remove empty placeholder after populating)

## Changes Required to CLAUDE.md

### 1. Add notion-scraper-expert to Architecture Diagram

**Current Diagram** (4 agents):
```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ JINO AGENT   │  │ CODER        │  │ TESTER       │  │ STUCK        │
```

**Proposed Diagram** (6 core agents):
```
┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐
│ JINO       │ │ NOTION     │ │ CODER      │ │ TESTER     │ │ PLANNER    │ │ STUCK      │
│ AGENT      │ │ SCRAPER    │ │            │ │            │ │            │ │            │
│ (Research) │ │ (Notion)   │ │ (Code)     │ │ (Verify)   │ │ (Planning) │ │ (Human)    │
└────────────┘ └────────────┘ └────────────┘ └────────────┘ └────────────┘ └────────────┘
```

### 2. Add notion-scraper-expert Section to Both CLAUDE.md Files

**Location in Root CLAUDE.md**: After "Jino Agent" section (line ~35-39)

**Content to Add**:
```markdown
2. **Notion Scraper Expert** - Notion workspace specialist
   - Uses Suekou Notion MCP for Notion operations
   - Extracts knowledge from Notion pages/databases
   - Converts Notion content to optimized Markdown
   - Manages Notion content (create, edit, delete with approval)
   - Returns structured documentation to orchestrator
```

**Location in .claude/CLAUDE.md**: After "jino-agent" section (line ~61-77)

**Content to Add**:
```markdown
### notion-scraper-expert
**Purpose**: Notion workspace analysis, extraction, and management

- **When to invoke**: PROACTIVELY when Notion content extraction, documentation fetching, or workspace management is needed
- **What to pass**: Notion URLs, page IDs, database IDs, or workspace queries
- **Context**: Gets its own clean context window
- **Returns**: Clean markdown content, structured documentation, or operation confirmation
- **Preferred over**: Manual Notion API calls for knowledge extraction and workspace organization
- **Auto-invoke when**:
  - Extracting documentation from Notion pages
  - Querying Notion databases for information
  - Converting Notion content to token-efficient Markdown
  - Creating/editing/deleting Notion content (with user approval)
  - Organizing Notion workspace programmatically
  - Preparing knowledge context from user's Notion
- **On error**: Will invoke stuck agent automatically
```

### 3. Update MCP Integration Section

**Add Suekou Notion MCP Server** after Playwright section (~line 225-243):

```markdown
### Suekou Notion MCP Server

**Configuration**: Set `NOTION_API_TOKEN` environment variable

**Capabilities:**
- **Page Retrieval**: Get Notion pages with properties and content
- **Database Queries**: Query databases with filters and sorts
- **Markdown Conversion**: Auto-convert to token-efficient Markdown
- **Content Creation**: Create pages, databases, and database items
- **Content Management**: Update properties, delete blocks, add comments
- **Workspace Search**: Search across entire Notion workspace

**Usage Pattern:**
```
Claude identifies need for Notion documentation
  → Invokes notion-scraper-expert with Notion URL or query
  → Notion scraper uses Suekou Notion MCP to extract/convert
  → Returns clean, optimized Markdown to Claude
  → Claude provides documentation to coder for implementation
```
```

### 4. Update Orchestration Flow Diagram

**Add notion-scraper-expert step** in the flow (around line 60-89):

```markdown
3. For each todo:
   ├─ If research needed → Invoke JINO AGENT
   │                        ├─ Uses Jina AI MCP
   │                        ├─ Extracts docs/searches
   │                        └─ Returns research
   ├─ If Notion docs needed → Invoke NOTION-SCRAPER-EXPERT
   │                           ├─ Uses Suekou Notion MCP
   │                           ├─ Extracts Notion content
   │                           └─ Returns optimized Markdown
   ↓
```

### 5. Update .claude/CLAUDE.md Available Subagents Section

Add notion-scraper-expert between jino-agent and stuck sections.

### 6. Update Examples Section

Add example workflow showing notion-scraper-expert usage:

```markdown
### Scenario 4: Extracting Specs from Notion

```
User: "Implement the feature described in this Notion doc: https://www.notion.so/..."

Claude:
- Creates todos: [Extract Notion specs, Implement feature, Test implementation]
- Invokes notion-scraper-expert("Extract content from Notion URL")
  → Notion scraper uses Suekou MCP to retrieve page
  → Converts to clean Markdown with feature specs
  → Returns structured requirements
- Invokes coder("Implement feature following [specs from Notion]")
  → Coder implements based on extracted documentation
- Invokes tester("Verify feature works as specified")
  → Tester validates with screenshots
- Marks complete ✓
```
```

## ORCHESTRATION BASIC Plugin Structure

### Marketplace Plugin Location

```
marketplace/orchestration-basic/
├── README.md
├── package.json
├── .claude/
│   ├── CLAUDE.md                (orchestrator guide)
│   └── agents/
│       ├── coder.md
│       ├── jino-agent.md
│       ├── notion-scraper-expert.md
│       ├── planner.md
│       ├── stuck.md
│       └── tester.md
├── docs/
│   ├── INSTALLATION.md
│   ├── QUICK_START.md
│   └── EXAMPLES.md
└── scripts/
    └── install-plugin.sh
```

### Plugin Description

**Name**: ORCHESTRATION BASIC

**Description**: Complete Claude Code orchestration system with 6 specialized agents for managing complex software projects. Master-agent architecture with context isolation, visual verification, and human-in-the-loop escalation.

**Agents Included**:
1. **coder** - Implementation specialist
2. **jino-agent** - Web research & content extraction (Jina.ai MCP)
3. **notion-scraper-expert** - Notion workspace specialist (Suekou MCP)
4. **planner** - AI-powered project planning (TASKMASTER CLI)
5. **tester** - Visual verification (Playwright MCP)
6. **stuck** - Human escalation point

**MCP Servers Required**:
- Playwright MCP (for tester)
- Jina.ai Remote MCP (for jino-agent)
- Suekou Notion MCP (for notion-scraper-expert)

**Tools Required**:
- TASKMASTER CLI (for planner)

**Note**: secret-xpert-light is NOT included (has its own dedicated plugin: secret-manager-pro)

## File Reference Updates Required

After reorganization, update references in:

1. **README.md** - Update paths to moved documentation files
2. **CLAUDE.md** - Update Learning Resources section with new paths
3. **.claude/CLAUDE.md** - Update references to tools and examples
4. **docs/SETUP-LOCAL.md** - Update paths to E2B and security docs
5. **docker-entrypoint.sh** → **e2b/docker-entrypoint.sh** - Check for hardcoded paths
6. **start-e2b-sandbox.sh** → **e2b/start-e2b-sandbox.sh** - Check for file references
7. **scripts/*.sh** - Update any references to moved files
8. **.devcontainer/devcontainer.json** - Update E2B dockerfile paths if referenced
9. **Any workflow/CI files** - Update E2B and script paths

## Implementation Priority

### Phase 1: Update CLAUDE.md (High Priority)
1. Add notion-scraper-expert to both CLAUDE.md files
2. Update architecture diagrams
3. Add MCP server documentation
4. Add example workflows

### Phase 2: File Reorganization (Medium Priority)
1. Create new folders (docs/E2B, docs/MCP, docs/SECURITY, e2b/)
2. Move files to new locations
3. Update all file references
4. Remove duplicate/empty files
5. Test that all paths still work

### Phase 3: Create ORCHESTRATION BASIC Plugin (Medium Priority)
1. Create marketplace/orchestration-basic/ structure
2. Copy relevant agent files
3. Create plugin README.md
4. Create installation scripts
5. Test plugin installation

### Phase 4: Cleanup (Low Priority)
1. Remove AGENTS.md duplicate
2. Remove empty folders (1pass/, MCP_TOOLS_docs/)
3. Verify .gitignore is updated
4. Update any remaining documentation

## Benefits of Reorganization

### For Claude Code & Agents
✅ **Clearer structure** - E2B files grouped together, not scattered
✅ **Topic-based docs** - Easy to find MCP, E2B, security documentation
✅ **No confusion** - Docker/E2B in dedicated folder, not mixed with root files
✅ **Fast discovery** - docs/ organized by category

### For Users
✅ **Clean root** - Only essential files in root directory
✅ **Logical organization** - Related files grouped together
✅ **Better documentation** - notion-scraper-expert properly documented
✅ **Marketplace ready** - ORCHESTRATION BASIC plugin available

### For Maintenance
✅ **No duplicates** - AGENTS.md removed
✅ **No empty folders** - Placeholders removed after population
✅ **Consistent paths** - All references updated
✅ **Easy updates** - Clear structure for future additions

## Risks & Mitigations

### Risk 1: Breaking File References
**Mitigation**: Comprehensive grep for all file paths before moving, update systematically

### Risk 2: Git History Loss
**Mitigation**: Use `git mv` instead of `mv` to preserve file history

### Risk 3: Broken Scripts
**Mitigation**: Test all scripts after reorganization, update paths in scripts/

### Risk 4: User Confusion
**Mitigation**: Create MIGRATION.md guide showing old → new paths

## Next Steps

1. ✅ Review and approve this analysis
2. 🔄 Implement Phase 1: Update CLAUDE.md files
3. 🔄 Implement Phase 2: Reorganize files
4. 🔄 Implement Phase 3: Create ORCHESTRATION BASIC plugin
5. 🔄 Implement Phase 4: Final cleanup
6. ✅ Commit and push changes to branch

---

**Generated**: 2025-11-15
**For**: ALEX-STACK_v0 Repository Reorganization
**Session**: claude/orchestration-plugin-restructure-01Ss7DYTXKPWupuX1gswV8Qa
