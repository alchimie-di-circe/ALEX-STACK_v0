# Claude Code Orchestration System - Agent Index

> **Note**: This file provides a quick reference index for the orchestration system. For the complete technical guide, see [CLAUDE.md](./CLAUDE.md).

## 🎯 System Overview

This orchestration system uses a master-agent architecture where Claude Code acts as the orchestrator, delegating tasks to specialized subagents that work in isolated context windows.

**For complete documentation**: See [CLAUDE.md](./CLAUDE.md) - the comprehensive technical guide.

## 📋 Quick Agent Reference

### Available Agents

1. **[Notion Scraper Expert](./CLAUDE.md#notion-scraper-expert)** - Notion workspace specialist (Suekou MCP)
2. **[Coder](./CLAUDE.md#coder)** - Implementation specialist (Context7 + ctxkit self-service)
3. **[Tester](./CLAUDE.md#tester)** - Visual verification with Playwright
4. **[Planner](./CLAUDE.md#planner)** - AI-powered project planning (TASKMASTER CLI)
5. **[Stuck](./CLAUDE.md#stuck)** - Human escalation point
6. **[Secret Xpert Light](./CLAUDE.md#secret-xpert-light)** - Secrets management (marketplace plugin)

### Deprecated Agents

- **Jino Agent** - Removed in favor of coder's self-service documentation (Context7 + ctxkit). Preliminary research phase is no longer needed as coder has direct access to documentation during implementation.

### Key Files

- **[CLAUDE.md](./CLAUDE.md)** - Complete technical documentation
- **[PROJECT_ROADMAP.md](./PROJECT_ROADMAP.md)** - Single source of truth for project state
- **[.claude/CLAUDE.md](./.claude/CLAUDE.md)** - Orchestrator-specific instructions
- **[.claude/agents/](./.claude/agents/)** - Individual agent definition files

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│  CLAUDE (200k Context) - Master Orchestrator                           │
│  - Maintains project state and todo lists                               │
│  - Delegates individual tasks to subagents                               │
│  - Tracks overall progress via PROJECT_ROADMAP.md                        │
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

## 🔗 Integration with Other Systems

This agent system can be integrated with:
- **Other AI CLIs** (Aider, Cursor, etc.)
- **Custom automation workflows**
- **Team-based development**
- **Educational purposes**

For detailed integration patterns, see the [complete technical guide](./CLAUDE.md).

---

**For the full documentation, workflows, examples, and best practices, please refer to [CLAUDE.md](./CLAUDE.md)**.
