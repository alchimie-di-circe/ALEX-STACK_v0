# Simplified Architecture: No API Keys Required 🔒

> **Date**: 2025-11-16
> **Status**: ✅ Implemented and Deployed
> **Security**: No API keys - safe for Claude Code Web

---

## 🎯 Problem: API Keys in Claude Code Web

### Security Issue Discovered

API keys (like `JINA_API_KEY`) cannot be securely managed in Claude Code Web environment:
- Credentials exposed in browser environment
- No secure secret management available
- Risk of API key leakage

### Previous Architecture (INSECURE)

```
Orchestrator → Jino Agent (Jina.ai MCP) → Requires JINA_API_KEY ❌
                                           ↓
                                    SECURITY RISK
```

---

## ✅ Solution: Self-Service Documentation Without API Keys

### New Simplified Architecture (SECURE)

```
Coder Agent has TWO self-service MCP servers:

1. Context7 (Upstash)
   ├─ Popular frameworks/libraries
   ├─ No API key required ✅
   └─ Try THIS FIRST

2. ctxkit (ctxkit.dev)
   ├─ llm.txt discovery from official docs
   ├─ No API key required ✅
   └─ Fallback if Context7 doesn't have docs

3. Stuck Agent
   └─ If both fail → human guidance
```

### Flow Diagram

```
User Request
    ↓
Orchestrator (TodoWrite)
    ↓
Coder Agent
    ├─→ Try Context7 (popular frameworks)
    │       ↓
    │   Found? → Implement ✅
    │       ↓
    │   Not Found?
    │       ↓
    ├─→ Try ctxkit (llm.txt discovery)
    │       ↓
    │   Found? → Implement ✅
    │       ↓
    │   Not Found?
    │       ↓
    └─→ Invoke Stuck Agent → Human Guidance
```

---

## 🔄 What Changed

### Removed (Insecure)

| Component | Reason | Replacement |
|-----------|--------|-------------|
| Jino Agent | Required JINA_API_KEY | Context7 + ctxkit |
| jina-mcp-server | Unsafe credentials | ctxkit MCP |
| Preliminary research flow | Complex, needed API keys | Self-service docs |

### Added (Secure)

| Component | Purpose | API Key? |
|-----------|---------|----------|
| ctxkit MCP server | llm.txt discovery | ❌ None |
| Context7 (already had) | Popular frameworks | ❌ None |
| Simplified cascading | Context7 → ctxkit → stuck | ❌ None |

---

## 📊 Architecture Comparison

### Before (With Jino Agent - INSECURE)

```
┌─────────────┐
│ORCHESTRATOR │
└──────┬──────┘
       │
       ├─→ Need research? → JINO AGENT (Jina.ai MCP) ❌ Requires JINA_API_KEY
       │                        ↓
       │                   Returns docs
       │                        ↓
       └─→ CODER ← gets docs from Jino
               ├─→ Context7 (self-service)
               └─→ Stuck if needed
```

**Problems:**
- ❌ API key required
- ❌ Two-step process (orchestrator → Jino → coder)
- ❌ Security risk in Claude Code Web
- ❌ Extra agent complexity

### After (No API Keys - SECURE)

```
┌─────────────┐
│ORCHESTRATOR │
└──────┬──────┘
       │
       └─→ CODER (self-service docs)
               ├─→ Context7 FIRST (popular frameworks) ✅
               ├─→ ctxkit if needed (llm.txt) ✅
               └─→ Stuck if both fail ✅
```

**Benefits:**
- ✅ No API keys required
- ✅ One-step process (orchestrator → coder)
- ✅ Secure for Claude Code Web
- ✅ Simpler architecture

---

## 🔌 MCP Servers Configuration

### .mcp.json (Updated)

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
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
      "env": {}
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/mcp-server-context7"],
      "env": {}
    }
  }
}
```

**Note**: `NOTION_API_TOKEN` is optional - only needed if using Notion integration.

---

## 📚 Documentation Strategy

### Context7 Coverage

**Best for:**
- React, Next.js, Vue, Svelte
- TypeScript, JavaScript
- Tailwind CSS, CSS frameworks
- Popular npm packages
- Standard web development

**When it works:**
- Framework/library is in Context7's index
- You need API references, examples, patterns

### ctxkit Coverage

**Best for:**
- Official documentation sites with llm.txt
- Niche or specialized libraries
- Legacy frameworks
- Project-specific technologies

**When it works:**
- Documentation site has llm.txt file
- Standard documentation structure

### Stuck Agent Escalation

**Use when:**
- Both Context7 AND ctxkit lack documentation
- Need human guidance on approach
- Ambiguous requirements

---

## 🚀 Migration Guide

### For Orchestrator

**OLD (with Jino):**
```
1. Create todos
2. Check if research needed
3. If yes → invoke Jino Agent
4. Invoke coder with research
```

**NEW (no Jino):**
```
1. Create todos
2. Invoke coder directly
3. Coder handles all documentation self-service
```

### For Coder Agent

**OLD (with Jino):**
```
1. Receive todo + preliminary research from orchestrator
2. Use Context7 for additional docs
3. Invoke stuck if Context7 insufficient
```

**NEW (self-service):**
```
1. Receive todo from orchestrator
2. Try Context7 FIRST for docs
3. If Context7 doesn't have it, try ctxkit
4. If both fail, invoke stuck agent
```

### For Workflows

| Workflow | Before (Jino) | After (No Jino) |
|----------|---------------|-----------------|
| Simple feature | Orchestrator → Coder | Same (no change) |
| Needs docs | Orchestrator → Jino → Coder | Orchestrator → Coder (self-service) |
| Complex research | Orchestrator → Jino → Coder | Orchestrator → Coder (Context7 + ctxkit) |
| Missing docs | Jino → Stuck | Coder → Stuck |

---

## ✅ Benefits of New Architecture

### Security
- ✅ **No API keys required** - safe for Claude Code Web
- ✅ **No credential exposure** - all MCP servers are free/public
- ✅ **No secret management** - nothing to secure

### Simplicity
- ✅ **Fewer agents** - removed Jino Agent entirely
- ✅ **Clearer flow** - orchestrator → coder (direct)
- ✅ **Self-contained** - coder handles own research

### Performance
- ✅ **One less step** - no preliminary research phase
- ✅ **Faster iteration** - coder doesn't wait for orchestrator
- ✅ **Parallel work** - documentation lookup happens during coding

### Reliability
- ✅ **Free tools** - no API rate limits to worry about
- ✅ **Two sources** - Context7 + ctxkit (redundancy)
- ✅ **Fallback path** - stuck agent for edge cases

---

## 📝 Files Modified

| File | Change | Status |
|------|--------|--------|
| `.mcp.json` | Removed jina-mcp-server, added ctxkit | ✅ |
| `.claude/CLAUDE.md` | Removed Jino references, updated flow | ✅ |
| `.claude/agents/coder.md` | Added ctxkit, updated docs strategy | ✅ |
| `.claude/agents/jino-agent.md` | Deprecated → .DEPRECATED | ✅ |
| `docs/MCP/MCP_INTEGRATION_SUMMARY.md` | Will be updated | ⏳ |
| `CLAUDE.md` (root) | Will be updated | ⏳ |
| `README.md` | Will be updated | ⏳ |

---

## 🧪 Testing Checklist

- [ ] Coder can access Context7 for React docs
- [ ] Coder can access ctxkit for llm.txt discovery
- [ ] Coder invokes stuck when both fail
- [ ] Orchestrator no longer references Jino Agent
- [ ] No JINA_API_KEY environment variable needed
- [ ] All workflows function without API keys

---

## 🎯 Next Steps

1. Update remaining documentation (README.md, CLAUDE.md root)
2. Test architecture with real coding task
3. Verify Context7 + ctxkit coverage is sufficient
4. Document any edge cases that require stuck agent

---

## 📚 Additional Resources

- **Context7 MCP**: [Upstash MCP Documentation](https://github.com/upstash/mcp-server-context7)
- **ctxkit**: [ctxkit.dev](https://ctxkit.dev)
- **Sequential Thinking**: Official Anthropic MCP server
- **Deprecation Notice**: `.claude/agents/.JINO-AGENT-DEPRECATED.md`

---

**Last Updated**: 2025-11-16
**Committed**: 5ba5f5c - "Remove Jino Agent and simplify architecture to Context7 + ctxkit"
**Status**: Architecture simplified and secured ✅
