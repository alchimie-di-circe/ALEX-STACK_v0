# TASKMASTER CLI - Setup & Installation Guide

## ✅ Installation Status

**Status**: ✅ INSTALLED GLOBALLY
**Version**: 1.0.0
**Package**: @raja-rakoto/taskmaster-cli
**Location**: `/usr/local/lib/node_modules/@raja-rakoto/taskmaster-cli`

### Verification Command

```bash
# Check global installation
npm list -g @raja-rakoto/taskmaster-cli

# Show version
npx @raja-rakoto/taskmaster-cli --version
```

---

## 🚀 Quick Start for Orchestrator

### Method 1: Direct via npx (Recommended)

```bash
# Run any TASKMASTER command via npx
npx @raja-rakoto/taskmaster-cli [command] [options]

# Examples
npx @raja-rakoto/taskmaster-cli --version
npx @raja-rakoto/taskmaster-cli --help
```

### Method 2: Create a Shell Alias (Optional)

Add to your `.bashrc` or `.zshrc`:

```bash
alias tm='npx @raja-rakoto/taskmaster-cli'
```

Then reload:
```bash
source ~/.bashrc  # or source ~/.zshrc
```

Usage:
```bash
tm --version
tm --help
```

### Method 3: Create a Bash Wrapper Script (Optional)

Create `/usr/local/bin/taskmaster`:

```bash
#!/bin/bash
npx @raja-rakoto/taskmaster-cli "$@"
```

Make executable:
```bash
chmod +x /usr/local/bin/taskmaster
```

Usage:
```bash
taskmaster --version
taskmaster --help
```

---

## 📁 Project Structure

When using TASKMASTER in a project, it creates:

```
project-root/
├── .taskmaster/                 # TASKMASTER data directory
│   ├── tasks/
│   │   └── tasks.json          # Task database
│   ├── config.json             # Local config
│   └── backups/                # Saved states
├── .claude/
│   ├── knowledge/
│   │   ├── TASKMASTER_CLI_GUIDE.md    # Full reference
│   │   ├── TASKMASTER_SETUP.md        # This file
│   │   └── ...
│   ├── TASKMASTER_ADDON.md     # Usage guidelines
│   ├── CLAUDE_TASKMASTER.md               # Main orchestrator (updated)
│   └── agents/
└── [your project files]
```

---

## ⚙️ Environment Configuration

### Option 1: Global Config

Create `~/.taskmaster/config.json`:

```json
{
  "primaryModel": "claude-opus-4-1",
  "researchModel": "claude-sonnet-4-1",
  "fallbackModel": "gpt-4-turbo",
  "responseLanguage": "it",
  "dataDirectory": "./.taskmaster",
  "logLevel": "info"
}
```

### Option 2: Project-Local .env

Create `.env.taskmaster` in project root:

```bash
# API Keys (minimo uno)
ANTHROPIC_API_KEY=sk-ant-xxxxx
OPENAI_API_KEY=sk-xxxxx

# Models
TASKMASTER_MAIN_MODEL=claude-opus-4-1
TASKMASTER_RESEARCH_MODEL=claude-sonnet-4-1
TASKMASTER_FALLBACK_MODEL=gpt-4-turbo

# Settings
TASKMASTER_RESPONSE_LANGUAGE=it
TASKMASTER_LOG_LEVEL=info
TASKMASTER_DATA_DIR=./.taskmaster
```

Load before using:
```bash
export $(cat .env.taskmaster | xargs)
```

---

## 🎯 First-Time Usage

### Scenario 1: Simple Test

```bash
# Test installation
npx @raja-rakoto/taskmaster-cli --version

# Expected output:
# TaskMaster AI Core initialized
# version 1.0.0
```

### Scenario 2: Initialize Project

```bash
cd /path/to/project

# Create config (if needed)
mkdir -p .taskmaster
npx @raja-rakoto/taskmaster-cli --help
```

### Scenario 3: Generate Tasks from Requirements

```bash
# Create a test requirements file
cat > PROJECT_REQUIREMENTS.md << 'EOF'
# Build a Todo Application

## Requirements
- React 18+ with TypeScript
- Task CRUD operations
- localStorage persistence
- Dark mode toggle
- Responsive design
- Unit tests

## Tech Stack
- React + TypeScript
- Zustand for state
- Vitest for tests
- Tailwind CSS
EOF

# Generate tasks (if package supports it)
npx @raja-rakoto/taskmaster-cli --help
```

---

## 🔗 Integration with Orchestrator

### Usage in Your Workflow

**For IMMEDIATE use in this repository**:

```bash
# Go to workspace root
cd /root/workspace

# Use TASKMASTER via npx
npx @raja-rakoto/taskmaster-cli --version

# Example in orchestrator workflow
npx @raja-rakoto/taskmaster-cli --help
```

### Integration in CLAUDE_TASKMASTER.md

The main `CLAUDE_TASKMASTER.md` has been updated to include TASKMASTER in **Step 0** of the workflow. When you (the orchestrator) receive a new project:

```bash
# Step 0: Run TASKMASTER planning first
cd /project/directory

npx @raja-rakoto/taskmaster-cli --version

# Then continue with manual planning
# Use TASKMASTER insights to inform TodoWrite
```

---

## 📚 Documentation Structure

All TASKMASTER documentation is in `.claude/knowledge/`:

1. **TASKMASTER_CLI_GUIDE.md** (📖 PRIMARY REFERENCE)
   - Complete command reference
   - All features explained
   - Examples for every scenario
   - Troubleshooting guide
   - Best practices

2. **TASKMASTER_ADDON.md** (📚 USAGE GUIDELINES)
   - When to use TASKMASTER
   - Integration with your workflow
   - Practical examples
   - Critical rules

3. **TASKMASTER_SETUP.md** (THIS FILE)
   - Installation verification
   - Quick start options
   - Configuration options
   - First-time usage

---

## ✅ Verification Checklist

Run these commands to verify everything is set up:

```bash
# 1. Check npm installation
npm list -g @raja-rakoto/taskmaster-cli
# ✅ Should show: @raja-rakoto/taskmaster-cli@1.0.0

# 2. Check version via npx
npx @raja-rakoto/taskmaster-cli --version
# ✅ Should show: version 1.0.0

# 3. Check documentation exists
ls -la /root/workspace/.claude/knowledge/TASKMASTER*.md
# ✅ Should show all 3 files

# 4. Check CLAUDE_TASKMASTER.md updated
grep -c "TASKMASTER" /root/workspace/.claude/CLAUDE_TASKMASTER.md
# ✅ Should show count > 10

# 5. Verify knowledge directory
ls -la /root/workspace/.claude/knowledge/
# ✅ Should include TASKMASTER files
```

---

## 🚀 Ready to Use

Your orchestrator agent is now equipped with:

✅ **TASKMASTER CLI** - Installed globally (v1.0.0)
✅ **Full Documentation** - In `.claude/knowledge/`
✅ **Integration Guide** - In `.claude/TASKMASTER_ADDON.md`
✅ **Updated Workflow** - In `.claude/CLAUDE_TASKMASTER.md` (Step 0)

### Next Steps

1. **When a user gives you a project**, use TASKMASTER for planning:
   ```bash
   npx @raja-rakoto/taskmaster-cli --version
   # (See TASKMASTER_CLI_GUIDE.md for full commands)
   ```

2. **Use TASKMASTER output** to inform your TodoWrite planning

3. **Reference the guides** for detailed command options

4. **Check TASKMASTER_ADDON.md** for when/how to use specific commands

---

## 💡 Pro Tips

1. **Create a bash function** for easier access:
   ```bash
   tm() {
     npx @raja-rakoto/taskmaster-cli "$@"
   }
   ```

2. **Always run `dependency:validate`** after complex task additions

3. **Save checkpoints** at major milestones with `save --name "milestone-x"`

4. **Generate reports** for user communication at project completion

5. **Reference TASKMASTER_CLI_GUIDE.md** for any unclear commands

---

## ❓ Troubleshooting

### "Command not found"

```bash
# Verify installation
npm list -g @raja-rakoto/taskmaster-cli

# If empty, reinstall
npm install -g @raja-rakoto/taskmaster-cli

# Use via npx
npx @raja-rakoto/taskmaster-cli --version
```

### "API key not configured"

```bash
# Create .env.taskmaster
cat > .env.taskmaster << 'EOF'
ANTHROPIC_API_KEY=sk-ant-xxxxx
EOF

# Load it
export $(cat .env.taskmaster | xargs)
```

### "tasks.json not found"

This is normal - it means you haven't initialized a project yet. Follow the examples in TASKMASTER_CLI_GUIDE.md to generate tasks.

---

## 📞 Support

- **Full Reference**: `.claude/knowledge/TASKMASTER_CLI_GUIDE.md`
- **Usage Guidelines**: `.claude/TASKMASTER_ADDON.md`
- **Integration**: `.claude/CLAUDE_TASKMASTER.md` (see section: TASKMASTER CLI Integration)

🎉 **You're all set!** Your orchestrator agent is now TASKMASTER-enabled for superior AI-powered planning!
