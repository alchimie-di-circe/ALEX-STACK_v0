# Claude Code Orchestration System - Agent Index

> **Note**: This file provides a quick reference index for the orchestration system. For the complete technical guide, see [CLAUDE.md](./CLAUDE.md).

## 🎯 System Overview

This orchestration system uses a master-agent architecture where Claude Code acts as the orchestrator, delegating tasks to specialized subagents that work in isolated context windows.

**For complete documentation**: See [CLAUDE.md](./CLAUDE.md) - the comprehensive technical guide.

## 📋 Quick Agent Reference

### Available Agents

1. **[Jino Agent](./CLAUDE.md#jino-agent)** - Web research specialist (Jina.ai MCP)
2. **[Notion Scraper Expert](./CLAUDE.md#notion-scraper-expert)** - Notion workspace specialist (Suekou MCP)
3. **[Coder](./CLAUDE.md#coder)** - Implementation specialist
4. **[Tester](./CLAUDE.md#tester)** - Visual verification with Playwright
5. **[Planner](./CLAUDE.md#planner)** - AI-powered project planning (TASKMASTER CLI)
6. **[Stuck](./CLAUDE.md#stuck)** - Human escalation point
7. **[Secret Xpert Light](./CLAUDE.md#secret-xpert-light)** - Secrets management (marketplace plugin)

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
    ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐
    │ JINO   │  │ NOTION │  │ CODER  │  │ TESTER │  │PLANNER │  │ STUCK  │  │SECRET  │
    │ AGENT  │  │SCRAPER │  │        │  │        │  │        │  │        │  │ XPERT  │
    │(Fresh) │  │(Fresh) │  │(Fresh) │  │(Fresh) │  │(Fresh) │  │(Fresh) │  │(Fresh) │
    │        │  │        │  │        │  │        │  │        │  │        │  │        │
    │Research│  │ Notion │  │Implement│ │Verify  │  │AI Task │  │Human   │  │Secrets │
    │& Web   │  │Extract │  │One Task│  │w/Play- │  │Break-  │  │Escal-  │  │Mgmt    │
    │Extract │  │& Mgmt  │  │        │  │wright  │  │down    │  │ation   │  │direnv+ │
    │        │  │        │  │        │  │        │  │        │  │        │  │1Pass   │
    └────────┘  └────────┘  └────────┘  └────────┘  └────────┘  └────────┘  └────────┘
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
