# Quick Start: Import Claude Code Orchestration System

This guide shows you how to import the **Claude Code Orchestration System** into any project, local or cloud.

---

## 🎯 What You Get

Once imported, Claude Code operates as an **orchestrator** with:

- **200k context** for project state management
- **TodoWrite** for real-time task tracking
- **PROJECT_ROADMAP.md** for multi-agent coordination
- **Agent delegation**: coder, tester, planner, jino-agent, stuck
- **TASKMASTER** for extreme complexity breakdown (8-10/10)
- **Parallelization** of independent tasks for efficiency
- **Feature implementation guidelines** with complexity assessment

---

## 🚀 Three Ways to Import

### Option 1: Slash Command (Recommended ⭐)

The **easiest and most reliable** method - Claude does everything for you!

```bash
# 1. Open Claude Code in your target project
cd /path/to/your-project
claude

# 2. Use the slash command
/import-orchestration from /path/to/ALEX-STACK_v0
```

**What happens:**
- Claude reads the source orchestration system
- Copies all necessary files (`.claude/`, `PROJECT_ROADMAP.md`, `.taskmaster/`)
- Verifies installation
- Announces it's ready as orchestrator

**Benefits:**
- ✅ Structured checklist (nothing missed)
- ✅ Claude explains every step
- ✅ Automatic verification
- ✅ Seamless transition to orchestrator mode

---

### Option 2: Natural Language (Simple)

If the slash command doesn't exist yet, just ask Claude directly:

```bash
cd /path/to/your-project
claude

# Then simply say:
"Import the orchestration plugin from /path/to/ALEX-STACK_v0"
```

**What happens:**
- Claude understands your intent
- Reads the source files
- Copies them to your project
- Verifies and announces readiness

**Benefits:**
- ✅ Natural, conversational
- ✅ Works even without slash commands
- ✅ Claude adapts to your project structure

---

### Option 3: Manual Copy (For Offline/CI)

If you need to copy files without Claude active:

```bash
# From the ALEX-STACK_v0 directory
cd /path/to/ALEX-STACK_v0

# Copy to your project
export TARGET="/path/to/your-project"

# Copy orchestrator instructions
cp -r .claude/ $TARGET/.claude/

# Copy documentation
cp CLAUDE.md $TARGET/CLAUDE.md
cp AGENTS.md $TARGET/AGENTS.md

# Initialize PROJECT_ROADMAP from template
cp .claude/templates/PROJECT_ROADMAP.template.md $TARGET/PROJECT_ROADMAP.md

# Initialize TASKMASTER
mkdir -p $TARGET/.taskmaster/{tasks,docs}
cp -r .taskmaster/config.json $TARGET/.taskmaster/ 2>/dev/null || true
echo '{"master":{"tasks":[],"metadata":{"version":"1.0.0"}}}' > $TARGET/.taskmaster/tasks/tasks.json

# Verify
ls -la $TARGET/.claude/CLAUDE.md
ls -la $TARGET/PROJECT_ROADMAP.md
```

**Benefits:**
- ✅ Works offline
- ✅ Scriptable (CI/CD)
- ✅ No Claude Code needed

**Drawbacks:**
- ❌ Manual verification needed
- ❌ May need to customize PROJECT_ROADMAP for your project

---

## 📁 What Gets Imported

### Core Files (Required)

```
your-project/
├── .claude/
│   ├── CLAUDE.md              # Orchestrator instructions (YOU ARE THE ORCHESTRATOR)
│   ├── agents/
│   │   ├── planner.md         # AI-powered planning (TASKMASTER)
│   │   ├── coder.md           # Implementation specialist
│   │   ├── tester.md          # Visual verification (Playwright)
│   │   ├── stuck.md           # Human escalation
│   │   └── jino-agent.md      # Web research (Jina AI)
│   ├── commands/
│   │   └── import-orchestration.md  # This import command
│   └── templates/
│       └── PROJECT_ROADMAP.template.md  # Template for new projects
├── PROJECT_ROADMAP.md         # Task coordination hub (SINGLE SOURCE OF TRUTH)
├── CLAUDE.md                  # User guide (how the system works)
├── AGENTS.md                  # External systems integration guide
└── .taskmaster/
    ├── tasks/
    │   └── tasks.json         # Strategic planning tasks (empty initially)
    └── docs/                  # PRD storage for TASKMASTER
```

### Files NOT Imported (Intentionally)

- ❌ `.git/` - Your project keeps its own git history
- ❌ `node_modules/`, `venv/` - Dependencies are project-specific
- ❌ Source code files - Only orchestration system is copied
- ❌ Project-specific configs - Preserve your existing setup

---

## ✅ Verification Checklist

After import, verify these files exist:

```bash
# Check core orchestrator
ls .claude/CLAUDE.md           # Should start with "YOU ARE THE ORCHESTRATOR"

# Check agents (should have 4-7 files)
ls .claude/agents/*.md

# Check coordination hub
ls PROJECT_ROADMAP.md          # Single source of truth

# Check TASKMASTER
ls .taskmaster/tasks/tasks.json

# Check documentation
ls CLAUDE.md AGENTS.md
```

All present? ✅ You're ready!

---

## 🎯 First Use: Verify Orchestrator Mode

After import, confirm Claude is operating as orchestrator:

```bash
# Ask Claude:
"Are you operating in orchestrator mode?"

# Expected response should mention:
- "I am operating as the orchestrator"
- "200k context window"
- "TodoWrite for task tracking"
- "PROJECT_ROADMAP.md coordination"
- "Agent delegation capabilities"
```

---

## 🚀 Your First Project

Now that the system is imported, try building something:

```bash
# Example 1: Simple feature
"Add a login form to my app"

# Claude will:
# 1. Assess complexity (e.g., 4/10 - moderate)
# 2. Create TodoWrite breakdown
# 3. Update PROJECT_ROADMAP.md
# 4. Delegate to coder agents
# 5. Test with tester agent
# 6. Report completion

---

# Example 2: Complex project
"Build a multi-tenant SaaS platform with authentication and billing"

# Claude will:
# 1. Assess complexity (9/10 - extreme)
# 2. Invoke planner agent for TASKMASTER breakdown
# 3. Planner uses AI to create 20+ tasks with dependencies
# 4. Orchestrator delegates tasks in parallel
# 5. Tests and integrates systematically
# 6. Updates PROJECT_ROADMAP throughout
```

---

## 📚 Learning More

Once imported, read these files:

1. **CLAUDE.md** - Complete system overview and examples
2. **PROJECT_ROADMAP.md** - See how tasks are coordinated
3. **.claude/CLAUDE.md** - Detailed orchestrator instructions
4. **.claude/agents/*.md** - Learn what each agent does
5. **AGENTS.md** - If integrating with other AI systems

---

## 🔧 Customization

### Adapt to Your Project

**PROJECT_ROADMAP.md:**
```markdown
# Change project name
**Project Name**: Your App Name

# Add project-specific sections
## Custom Metrics
- Lines of code: X
- Test coverage: Y%
```

**Add Custom Agents:**
```bash
# Create your own specialized agent
.claude/agents/your-custom-agent.md
```

**Adjust Complexity Thresholds:**
Edit `.claude/CLAUDE.md` to change when to use planner agent.

---

## 🆘 Troubleshooting

### Import Failed

**Problem**: Files not copied
**Solution**:
1. Verify source path is correct
2. Check you have read permissions on source
3. Try manual copy (Option 3)

### Claude Doesn't Recognize Orchestrator Mode

**Problem**: Claude isn't following orchestration workflow
**Solution**:
1. Verify `.claude/CLAUDE.md` exists and starts with "YOU ARE THE ORCHESTRATOR"
2. Restart Claude Code to reload config
3. Ask explicitly: "Read .claude/CLAUDE.md and confirm you're the orchestrator"

### PROJECT_ROADMAP.md Not Updating

**Problem**: Roadmap stays empty
**Solution**:
1. Check file permissions (must be writable)
2. Remind Claude: "Update PROJECT_ROADMAP.md with current tasks"
3. Verify TodoWrite is being used

### TASKMASTER Not Working

**Problem**: Planner agent fails or TASKMASTER commands error
**Solution**:
1. Check `.taskmaster/tasks/tasks.json` is valid JSON
2. Verify `task-master` CLI is installed (if using)
3. Try manual task breakdown instead

---

## 🌟 Success Indicators

You'll know the system is working when Claude:

- ✅ Checks `PROJECT_ROADMAP.md` before starting work
- ✅ Creates detailed TodoWrite task lists immediately
- ✅ Assesses complexity (1-10 scale) for features
- ✅ Delegates to agents (coder, tester, planner)
- ✅ Parallelizes independent tasks
- ✅ Tests every implementation
- ✅ Updates PROJECT_ROADMAP.md throughout
- ✅ Reports completion with full results

---

## 📖 Example Session

```
User: [Imported orchestration system into new-project]

Claude:
  ✅ Orchestration System Imported Successfully!

  I am now operating in ORCHESTRATOR mode.

  Capabilities: 200k context, TodoWrite tracking,
  PROJECT_ROADMAP coordination, agent delegation,
  TASKMASTER for extreme complexity, parallelization.

  Ready to orchestrate! What would you like to build?

User: Build a React dashboard with charts

Claude:
  Reading PROJECT_ROADMAP.md... (empty, fresh start)

  Assessing complexity: 5/10 (moderate, multi-component)

  Creating TodoWrite breakdown:
  [ ] Set up React project structure
  [ ] Create Dashboard layout component
  [ ] Create Chart component
  [ ] Integrate chart library
  [ ] Style dashboard
  [ ] Test all components

  Updating PROJECT_ROADMAP.md...

  Invoking coder agent for task 1...
  [Work proceeds systematically]

  ✅ All tasks complete! Dashboard built and tested.
```

---

## 🚀 Ready to Go!

Pick your import method and get started:

```bash
# Recommended: Use slash command
/import-orchestration from /path/to/ALEX-STACK_v0

# Or just ask Claude
"Import orchestration plugin from /path/to/ALEX-STACK_v0"
```

**Once imported, Claude becomes your orchestrator and you can build anything!**

---

## 🔗 Resources

- **Full Documentation**: `CLAUDE.md` (after import)
- **Agent Reference**: `AGENTS.md` (after import)
- **Source Repository**: https://github.com/alchimie-di-circe/ALEX-STACK_v0
- **Issues/Support**: https://github.com/alchimie-di-circe/ALEX-STACK_v0/issues

---

**Happy Orchestrating!** 🎉
