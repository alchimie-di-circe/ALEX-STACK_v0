# Official Anthropic MCP Servers Research Report

**Research Date**: 2025-11-16
**Requested Servers**: Context7, Sequential Thinking, Memory

---

## Executive Summary

This report covers three MCP servers that were researched:
1. **Memory MCP Server** - ❌ **NOT IMPLEMENTED** (Requires local file storage, incompatible with Claude Code Web)
2. **Sequential Thinking MCP Server** - ✅ **IMPLEMENTED** (Official Anthropic server for structured problem-solving)
3. **Context7 MCP Server** - ✅ **IMPLEMENTED** (Third-party server by Upstash for code documentation)

**Note**: This document preserves research on Memory MCP for reference, but it is NOT used in this project.

---

## 1. Memory MCP Server (Official Anthropic) - ❌ NOT IMPLEMENTED

### ⚠️ Implementation Status: SKIPPED

**Reason**: Requires local file storage (`memory.jsonl`), which is incompatible with Claude Code Web environment.

**Alternative**: Use `PROJECT_ROADMAP.md` for cross-session state persistence.

### Overview (Research Only)
A knowledge graph-based persistent memory system that allows Claude to remember information about users across chat sessions.

### Key Capabilities
- **Entity Management**: Create and manage entities (people, organizations, events)
- **Relationship Mapping**: Define directed connections between entities
- **Observations**: Store atomic facts about entities
- **Persistent Storage**: Knowledge graph persists across sessions
- **Search Capabilities**: Query the graph by entity names, types, or observations

### Core Concepts

**Entities** - Primary nodes with:
- Unique name (identifier)
- Entity type (e.g., "person", "organization", "event")
- List of observations

**Relations** - Directed connections:
- From entity → To entity
- Relation type (active voice)
- Example: "John_Smith" → "works_at" → "Anthropic"

**Observations** - Discrete facts:
- Atomic (one fact per observation)
- Attached to specific entities
- Can be added/removed independently

### Available Tools

1. **create_entities** - Create multiple new entities
2. **create_relations** - Define relationships between entities
3. **add_observations** - Add facts to existing entities
4. **delete_entities** - Remove entities (cascading deletion)
5. **delete_observations** - Remove specific facts
6. **delete_relations** - Remove relationships
7. **read_graph** - Retrieve entire knowledge graph
8. **search_nodes** - Query based on search terms
9. **open_nodes** - Retrieve specific entities by name

### Configuration (.mcp.json)

**NPX Installation:**
```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

**Docker Installation:**
```json
{
  "mcpServers": {
    "memory": {
      "command": "docker",
      "args": ["run", "-i", "-v", "claude-memory:/app/dist", "--rm", "mcp/memory"]
    }
  }
}
```

**With Custom Storage Path:**
```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "env": {
        "MEMORY_FILE_PATH": "/path/to/custom/memory.jsonl"
      }
    }
  }
}
```

### Environment Variables
- `MEMORY_FILE_PATH`: Path to memory storage JSONL file (default: `memory.jsonl`)

### NPM Package
- **Package**: `@modelcontextprotocol/server-memory`
- **Version**: 0.6.3
- **License**: MIT
- **Author**: Anthropic, PBC

### Use Cases
- **Chat Personalization**: Remember user preferences, history, and context
- **Project Context**: Maintain relationships between code, files, and concepts
- **User Profiling**: Track user identity, behaviors, preferences, goals
- **Relationship Mapping**: Model connections up to 3 degrees of separation

### Best Practices
- Create entities for recurring organizations, people, and events
- Store atomic facts as observations (one fact per observation)
- Use active voice for relation types
- Regularly update observations as new information emerges
- Use search_nodes for discovery, open_nodes for targeted retrieval

### Which Agents Should Use This?
- **Orchestrator**: For tracking project state, user preferences across sessions
- **Planner**: For remembering architectural decisions and patterns
- **All Agents**: For maintaining context about user, project, and domain knowledge

---

## 2. Sequential Thinking MCP Server (Official Anthropic)

### Overview
Provides a tool for dynamic and reflective problem-solving through structured, step-by-step thinking processes.

### Key Capabilities
- **Step-by-step Reasoning**: Break down complex problems into manageable thoughts
- **Revision Support**: Revise and refine previous thoughts as understanding deepens
- **Branching Logic**: Explore alternative reasoning paths
- **Dynamic Planning**: Adjust total thought count as problem scope becomes clear
- **Hypothesis Generation**: Generate and verify solution hypotheses

### Available Tool

**sequential_thinking** - Single tool with rich parameters:

**Inputs:**
- `thought` (string): Current thinking step content
- `nextThoughtNeeded` (boolean): Whether another thought is required
- `thoughtNumber` (integer): Current step number
- `totalThoughts` (integer): Estimated total thoughts needed
- `isRevision` (boolean, optional): Whether this revises previous thinking
- `revisesThought` (integer, optional): Which thought number is being reconsidered
- `branchFromThought` (integer, optional): Branching point for alternative paths
- `branchId` (string, optional): Branch identifier
- `needsMoreThoughts` (boolean, optional): Request for additional thought capacity

### Configuration (.mcp.json)

**NPX Installation:**
```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

**Docker Installation:**
```json
{
  "mcpServers": {
    "sequentialthinking": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "mcp/sequentialthinking"]
    }
  }
}
```

**Disable Logging:**
```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
      "env": {
        "DISABLE_THOUGHT_LOGGING": "true"
      }
    }
  }
}
```

### Environment Variables
- `DISABLE_THOUGHT_LOGGING`: Set to `"true"` to disable thought logging

### NPM Package
- **Package**: `@modelcontextprotocol/server-sequential-thinking`
- **Version**: 0.6.2
- **License**: MIT
- **Author**: Anthropic, PBC

### Use Cases
- **Complex Problem Solving**: Multi-step analysis requiring course correction
- **Planning and Design**: Tasks that need revision as understanding deepens
- **Analytical Tasks**: Problems where full scope isn't initially clear
- **Context Maintenance**: Maintaining state across multiple reasoning steps
- **Information Filtering**: Distinguishing relevant from irrelevant data
- **Iterative Refinement**: Solutions that improve through revision

### Best Practices
- Start with estimated totalThoughts, adjust with needsMoreThoughts
- Use isRevision when reconsidering previous conclusions
- Branch for exploring alternative solution paths
- Keep thoughts atomic and focused on single insights
- Maintain thoughtNumber sequence for traceability

### Which Agents Should Use This?
- **Planner**: For breaking down complex projects with AI-powered reasoning
- **Coder**: For architecting complex implementations step-by-step
- **Orchestrator**: For complex decision-making requiring multiple reasoning steps
- **Any Agent**: When facing problems that need structured, revisable thinking

---

## 3. Context7 MCP Server (Third-Party - Upstash)

### Overview
**IMPORTANT**: This is NOT an official Anthropic server. It's a popular third-party MCP server created by Upstash.

### Key Information
- **Developer**: Upstash (not Anthropic)
- **Repository**: https://github.com/upstash/context7
- **Stars**: 37,208+ (extremely popular)
- **Forks**: 1,841+
- **Language**: JavaScript
- **License**: MIT
- **Description**: "Up-to-date code documentation for LLMs and AI code editors"
- **Website**: https://context7.com

### Primary Purpose
Provides AI code editors and LLMs with access to current, up-to-date documentation for code libraries and frameworks.

### Status
This server is actively maintained by Upstash and is NOT part of the official Anthropic MCP servers repository.

### Alternative Official Options
If you need official Anthropic servers for documentation/code assistance, consider:
- **Fetch MCP Server**: Web content fetching and conversion
- **Filesystem MCP Server**: File operations with access controls
- **Git MCP Server**: Repository reading and manipulation

### Recommendation
If you specifically need Context7's functionality (up-to-date code documentation), you should:
1. Research the Upstash Context7 repository directly
2. Review their documentation and configuration
3. Understand it's a third-party integration (not officially supported by Anthropic)
4. Follow Upstash's installation and configuration instructions

For this orchestration system, **we recommend using official Anthropic MCP servers** where possible for better support and integration.

---

## Configuration Summary for .mcp.json

### ❌ Memory MCP - NOT IMPLEMENTED

Memory MCP Server was researched but NOT added to `.mcp.json` due to incompatibility with Claude Code Web (requires local file storage).

### ✅ Actual Implementation

Only Sequential Thinking was added from this research. Current `.mcp.json` has:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"],
      "env": {}
    },
    "ctxkit": {
      "command": "npx",
      "args": ["-y", "ctxkit"],
      "env": {},
      "description": "Free MCP server for discovering llm.txt files. No API key required."
    },
    "notion": {
      "command": "npx",
      "args": ["-y", "@suekou/mcp-notion-server"],
      "env": {
        "NOTION_API_TOKEN": "${NOTION_API_TOKEN}",
        "NOTION_MARKDOWN_CONVERSION": "true"
      }
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/mcp-server-context7"]
    }
  }
}
```

**Note**: Jina MCP Server was removed for security reasons (API key requirement in Claude Code Web environment).

---

## Agent Integration Recommendations

### ❌ Memory MCP Server - NOT IMPLEMENTED

Memory MCP Server was researched but NOT integrated into the agent system. Use `PROJECT_ROADMAP.md` instead for cross-session persistence.

### ✅ Sequential Thinking MCP Server - IMPLEMENTED

**Best For:**
- **Planner**: Complex project breakdown requiring iterative refinement
- **Coder**: Multi-step implementation planning
- **Orchestrator**: Complex decision-making scenarios

**When to Use:**
- Problem complexity is unclear initially (scope discovery needed)
- Solution requires revision as understanding deepens
- Multiple alternative approaches need exploration
- Step-by-step reasoning needs to be visible/traceable
- Task has high complexity (8-10/10) and needs structured thinking

**Agent Instructions Update:**
Add to planner/coder CLAUDE.md files:
```markdown
## Sequential Thinking Integration

For complex problems (8-10/10 complexity):
1. Use sequential_thinking tool to break down the problem
2. Start with estimated totalThoughts, adjust as needed
3. Use isRevision=true when reconsidering previous thoughts
4. Branch when exploring alternative solution paths
5. Maintain clear thoughtNumber sequence for traceability

This provides structured, visible reasoning for:
- Complex architectural decisions
- Multi-step implementation planning
- Problems where full scope emerges during analysis
```

---

## Implementation Status

- ❌ **Memory MCP**: Not implemented (incompatible with Claude Code Web)
- ✅ **Sequential Thinking MCP**: Implemented in `.mcp.json`
- ✅ **Context7 MCP**: Implemented for coder agent self-service documentation
- ✅ **ctxkit MCP**: Implemented as fallback documentation source

For details on the implemented architecture, see `docs/MCP/SIMPLIFIED_ARCHITECTURE_NO_API_KEYS.md`.

---

## Resources

- **MCP Official Servers**: https://github.com/modelcontextprotocol/servers
- **Memory Server README**: https://github.com/modelcontextprotocol/servers/tree/main/src/memory
- **Sequential Thinking README**: https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking
- **MCP Documentation**: https://modelcontextprotocol.io
- **Context7 (Third-Party)**: https://github.com/upstash/context7 (NOT official Anthropic)

---

**Report Completed**: 2025-11-16
**Compiled by**: Jino Agent (Web Research Specialist)
