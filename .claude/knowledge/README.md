# 📚 Orchestrator Agent Knowledge Base

Welcome to the knowledge base for the Claude Code Orchestrator Agent. This directory contains comprehensive documentation for all tools and features available to optimize your project orchestration and planning.

---

## 📖 Core Documentation

### 🎯 TASKMASTER CLI Suite

**Start here** if you're using TASKMASTER for project planning:

#### 1. **TASKMASTER_SETUP.md** - Installation & Quick Start ⚡
   - ✅ Installation verification status
   - 🚀 Quick start methods
   - 🔧 Configuration options
   - ✅ Verification checklist

   **When to read**: First time using TASKMASTER

#### 2. **TASKMASTER_CLI_GUIDE.md** - Complete Reference 📖
   - 📍 All commands with examples
   - 🎯 Core features explained
   - 💾 Backup & restore operations
   - 🔗 Dependency management
   - 📊 Analysis & reporting
   - ⚠️ Troubleshooting guide

   **When to read**: When you need detailed command reference

#### 3. **TASKMASTER_ADDON.md** - Usage Guidelines 📚
   - 🎯 When to use TASKMASTER (mandatory scenarios)
   - 🚀 New orchestrator workflow
   - 🔧 Integration with CLAUDE.md
   - 💡 Pro tips & best practices
   - 📋 Feature matrix

   **When to read**: To understand WHEN and WHY to use TASKMASTER

---

## 🔗 Quick Links

### Main Configuration Files

| File | Purpose |
|------|---------|
| `.claude/CLAUDE.md` | Main orchestrator instructions (UPDATED with TASKMASTER) |
| `.claude/TASKMASTER_ADDON.md` | TASKMASTER integration guide |
| `.claude/agents/coder.md` | Coder subagent definition |
| `.claude/agents/tester.md` | Tester subagent definition |
| `.claude/agents/stuck.md` | Stuck subagent definition |

### Knowledge Base Files

| File | Purpose | Priority |
|------|---------|----------|
| `TASKMASTER_SETUP.md` | Installation & setup | 🟢 START HERE |
| `TASKMASTER_CLI_GUIDE.md` | Complete command reference | 🟡 PRIMARY REFERENCE |
| `TASKMASTER_ADDON.md` | Usage guidelines & integration | 🟡 USAGE GUIDE |
| `README.md` | This file - navigation guide | 🔵 REFERENCE |

---

## 🎯 Usage Scenarios

### Scenario 1: I'm an Orchestrator Starting a New Project

**Steps**:
1. Read: `TASKMASTER_ADDON.md` → "QUANDO USARE TASKMASTER"
2. Use: TASKMASTER commands from `TASKMASTER_CLI_GUIDE.md`
3. Reference: `.claude/CLAUDE.md` → "Step 0: INTELLIGENT PLANNING WITH TASKMASTER"

**Commands you'll need**:
```bash
npx @raja-rakoto/taskmaster-cli --version
npx @raja-rakoto/taskmaster-cli [command] [options]
```

### Scenario 2: I Need Specific Command Syntax

**Read**: `TASKMASTER_CLI_GUIDE.md` → "Comandi Core" section

**Examples included**:
- Task generation
- Dependency management
- Analysis & reporting
- Backup & restore

### Scenario 3: I'm Confused About When to Use TASKMASTER

**Read**: `TASKMASTER_ADDON.md` → "QUANDO USARE TASKMASTER CLI"

**Key rules**:
- ✅ MANDATORY: Initial project planning
- ✅ MANDATORY: Complex projects (10+ tasks)
- ✅ RECOMMENDED: PRD analysis
- ✅ RECOMMENDED: Status reporting

### Scenario 4: Installation or Technical Issues

**Read**: `TASKMASTER_SETUP.md` → "Troubleshooting" section

**Or**: `TASKMASTER_CLI_GUIDE.md` → "Troubleshooting" section

---

## 🚀 The Orchestrator's Workflow

```
USER: "Build a complex project"
    ↓
ORCHESTRATOR:
1. Read: TASKMASTER_ADDON.md (understand WHEN to use)
2. Run: TASKMASTER commands (see TASKMASTER_CLI_GUIDE.md)
3. Analyze: TASKMASTER output
4. Use CLAUDE.md: Step 0 - Follow the workflow
    ↓
TASKMASTER:
- Automatically decomposes requirements
- Identifies dependencies
- Provides complexity analysis
- Generates recommendations
    ↓
ORCHESTRATOR:
- Creates TodoWrite list (informed by TASKMASTER)
- Delegates tasks to coder subagent
- Tests with tester subagent
- Escalates to stuck if needed
    ↓
✅ PROJECT COMPLETE
```

---

## 📊 Feature Matrix

### When to Use Each Tool

| Tool | Best For | Read | Command |
|------|----------|------|---------|
| **TASKMASTER** | Initial planning, complex projects, PRD analysis | TASKMASTER_ADDON.md | `npx @raja-rakoto/taskmaster-cli` |
| **TodoWrite** | Tracking progress, managing tasks | CLAUDE.md Step 1 | Use Task tool |
| **Coder** | Implementation | CLAUDE.md Step 2 | Use Task tool |
| **Tester** | Verification | CLAUDE.md Step 3 | Use Task tool |
| **Stuck** | Problem solving | CLAUDE.md Step 4 | Use Task tool |

---

## 💡 Pro Tips for Orchestrators

### Tip 1: Know Your Commands
```bash
# Version check
npx @raja-rakoto/taskmaster-cli --version

# Help
npx @raja-rakoto/taskmaster-cli --help
```

### Tip 2: Save Checkpoints
Use TASKMASTER's save feature at milestones:
```bash
taskmaster save --name "milestone-1-complete"
```

### Tip 3: Always Validate
Before delegating to coder, validate dependencies:
```bash
taskmaster dependency:validate
```

### Tip 4: Generate Reports
Keep users informed with reports:
```bash
taskmaster report markdown > status-report.md
```

### Tip 5: Use the Guides
When unsure:
- TASKMASTER_ADDON.md for "when"
- TASKMASTER_CLI_GUIDE.md for "how"
- TASKMASTER_SETUP.md for "troubleshooting"

---

## 🔍 Navigation Quick Reference

```
.claude/knowledge/
├── README.md (THIS FILE)
│   └─→ Start here for navigation
│
├── TASKMASTER_SETUP.md
│   └─→ Installation & quick start
│
├── TASKMASTER_CLI_GUIDE.md
│   └─→ Complete command reference
│       - All features
│       - Examples
│       - Troubleshooting
│
└── TASKMASTER_ADDON.md
    └─→ Usage guidelines
        - When to use
        - Integration
        - Best practices
```

---

## ✅ Verification Checklist

Ensure everything is set up correctly:

```bash
# 1. TASKMASTER installed?
npm list -g @raja-rakoto/taskmaster-cli

# 2. Documentation exists?
ls -la /root/workspace/.claude/knowledge/TASKMASTER*.md

# 3. CLAUDE.md updated?
grep "TASKMASTER" /root/workspace/.claude/CLAUDE.md

# 4. Can run TASKMASTER?
npx @raja-rakoto/taskmaster-cli --version
```

All checks should pass ✅

---

## 🎓 Learning Path

### For Complete Beginners
1. Read: `.claude/CLAUDE.md` (sections: "Your Role", "YOUR MANDATORY WORKFLOW")
2. Read: `.claude/TASKMASTER_ADDON.md` (sections: "QUANDO USARE TASKMASTER")
3. Skim: `TASKMASTER_SETUP.md` (verification checklist)

### For Experienced Orchestrators
1. Reference: `TASKMASTER_CLI_GUIDE.md` (bookmark this!)
2. Reference: `TASKMASTER_ADDON.md` (when/why rules)
3. Troubleshoot: Use search or specific sections as needed

### For Implementation
1. Follow: `.claude/CLAUDE.md` → Step 0 (TASKMASTER planning)
2. Use: `TASKMASTER_CLI_GUIDE.md` → Specific command section
3. Create: TodoWrite from TASKMASTER output
4. Delegate: To subagents (coder/tester/stuck)

---

## 🆘 Help & Troubleshooting

### "Where do I find X command?"
→ See `TASKMASTER_CLI_GUIDE.md` → "Comandi Core" section

### "When should I use Y?"
→ See `TASKMASTER_ADDON.md` → "QUANDO USARE TASKMASTER"

### "Installation isn't working"
→ See `TASKMASTER_SETUP.md` → "Troubleshooting"

### "Integration confused me"
→ See `TASKMASTER_ADDON.md` → "IL TUO NUOVO WORKFLOW ORCHESTRATOR"

### "I need a quick example"
→ See `TASKMASTER_CLI_GUIDE.md` → "Esempi Pratici"

---

## 📞 Document Quick Reference

| Question | Answer Location |
|----------|-----------------|
| How do I install TASKMASTER? | TASKMASTER_SETUP.md → Installation |
| When should I use TASKMASTER? | TASKMASTER_ADDON.md → QUANDO USARE |
| What's the syntax for X command? | TASKMASTER_CLI_GUIDE.md → Comandi Core |
| How do I fix X error? | TASKMASTER_CLI_GUIDE.md → Troubleshooting |
| What's the orchestrator workflow? | CLAUDE.md → YOUR MANDATORY WORKFLOW |
| How does TASKMASTER fit in? | CLAUDE.md → Step 0 & TASKMASTER Integration |

---

## 🎉 Summary

You now have:

✅ **Complete TASKMASTER Documentation**
- Setup & installation guide
- Full command reference
- Usage guidelines & best practices

✅ **Integration with Orchestrator**
- CLAUDE.md updated with TASKMASTER
- Step 0: Intelligent Planning workflow
- Guidelines on when/how to use

✅ **Installation Verified**
- @raja-rakoto/taskmaster-cli v1.0.0 installed globally
- All commands accessible via npx
- Documentation complete and organized

🚀 **You're ready to orchestrate complex projects with AI-powered planning!**

---

**Last Updated**: 2025-11-05
**Status**: ✅ Complete & Ready to Use
**Next Step**: Start using TASKMASTER on your next project!
