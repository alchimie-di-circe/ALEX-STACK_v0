# Local Setup Guide - Hybrid Cloud + Local Workflow

Complete guide for setting up ALEX-STACK for **hybrid workflows** that work seamlessly in both Claude Code Web (cloud) and local terminal/IDE environments.

## 📋 Table of Contents

- [Overview](#overview)
- [Workflow Options](#workflow-options)
- [Option A: Symlink (Always Synced)](#option-a-symlink-always-synced)
- [Option B: Manual Copy (Independent)](#option-b-manual-copy-independent)
- [Option C: Hybrid (Development + Usage)](#option-c-hybrid-development--usage)
- [Plugin Usage](#plugin-usage)
- [Secret Management](#secret-management)
- [Git Workflow](#git-workflow)
- [Troubleshooting](#troubleshooting)

## Overview

ALEX-STACK is designed to work in three environments:

1. **Claude Code Web** (cloud) - Import repo into online sessions
2. **Local Terminal** (Mac/Linux) - Use agents via CLI
3. **Local IDE** (VSCode, etc.) - Integrate with code editor

The **hybrid approach** lets you:
- ✅ Develop agents locally with full IDE support
- ✅ Test in Claude Code Web immediately
- ✅ Sync changes between cloud and local automatically
- ✅ Use same credentials (via 1Password) everywhere
- ✅ Choose per-project which agents to use

## Workflow Options

### Quick Comparison

| Approach | Sync | Complexity | Best For |
|----------|------|------------|----------|
| **A: Symlink** | Automatic | Simple | Active development |
| **B: Manual Copy** | Manual | Simplest | Stable usage |
| **C: Hybrid** | Selective | Medium | Mixed dev/usage |

Choose based on your needs:
- **Active development**: Option A (Symlink)
- **Just using plugins**: Option B (Manual Copy)
- **Mix of both**: Option C (Hybrid)

---

## Option A: Symlink (Always Synced)

**Best for:** Active development on ALEX-STACK agents and continuous integration.

### How It Works

```
┌──────────────────────────────────────────────┐
│  GitHub Repository (Source of Truth)         │
│  github.com/alchimie-di-circe/ALEX-STACK_v0  │
└──────────────┬───────────────────────────────┘
               │
               │ git clone
               ▼
┌──────────────────────────────────────────────┐
│  Local Clone                                 │
│  ~/Projects/ALEX-STACK_v0/                   │
│    ├── .claude/agents/                       │
│    ├── marketplace/                          │
│    └── ...                                   │
└──────────────┬───────────────────────────────┘
               │
               │ symlink
               ▼
┌──────────────────────────────────────────────┐
│  Claude Code Config                          │
│  ~/.claude/                                  │
│    └── agents/                               │
│        └── alex-stack@ → ~/Projects/ALEX...  │
└──────────────────────────────────────────────┘
               │
               │ Claude Code reads agents
               ▼
         ✅ Agents available!
```

### Setup Steps

```bash
# 1. Clone repository locally
cd ~/Projects
git clone https://github.com/alchimie-di-circe/ALEX-STACK_v0.git
cd ALEX-STACK_v0

# 2. Verify structure
ls -la .claude/agents/
# Should show: jino-agent.md, secret-xpert-light.md, etc.

# 3. Create symlink to Claude Code config
ln -s ~/Projects/ALEX-STACK_v0/.claude/agents ~/.claude/agents/alex-stack

# 4. Verify symlink
ls -la ~/.claude/agents/
# Should show: alex-stack@ -> /Users/you/Projects/ALEX-STACK_v0/.claude/agents

# 5. Test Claude Code can see agents
# Open Claude Code terminal and check:
ls ~/.claude/agents/alex-stack/
# Should list all agents!
```

### Development Workflow

```bash
# Day-to-day usage:

# 1. Edit agents locally with your favorite editor
cd ~/Projects/ALEX-STACK_v0
code .claude/agents/jino-agent.md  # or vim, nano, etc.

# 2. Changes are immediately available to Claude Code!
# (via symlink - no copy needed)

# 3. Test in Claude Code
# Just invoke the agent - it uses latest version from symlink

# 4. Commit changes when ready
git add .claude/agents/jino-agent.md
git commit -m "Update jino-agent with new feature"
git push

# 5. Other machines pull changes
git pull
# Symlink automatically points to updated version!
```

### Pros and Cons

**✅ Pros:**
- Always in sync (edit once, available everywhere)
- No manual copy steps
- Perfect for active development
- Easy to track changes with Git
- Updates propagate automatically

**⚠️ Cons:**
- Tightly coupled to repo location
- Moving repo breaks symlink
- All agents always available (no selective loading)

---

## Option B: Manual Copy (Independent)

**Best for:** Stable usage without constant development, or selective agent usage.

### How It Works

```
┌──────────────────────────────────────────────┐
│  GitHub Repository                           │
│  github.com/alchimie-di-circe/ALEX-STACK_v0  │
└──────────────┬───────────────────────────────┘
               │
               │ download specific agents
               ▼
┌──────────────────────────────────────────────┐
│  Claude Code Config                          │
│  ~/.claude/agents/                           │
│    ├── jino-agent.md       (copied)          │
│    ├── secret-xpert-light.md (copied)        │
│    └── my-custom-agent.md  (local only)      │
└──────────────────────────────────────────────┘
               │
               │ Claude Code reads agents
               ▼
         ✅ Agents available!
```

### Setup Steps

```bash
# 1. Create Claude Code agents directory (if not exists)
mkdir -p ~/.claude/agents

# 2. Download agents you need from GitHub
# Option 2A: Clone temporarily
cd /tmp
git clone https://github.com/alchimie-di-circe/ALEX-STACK_v0.git
cp ALEX-STACK_v0/.claude/agents/jino-agent.md ~/.claude/agents/
cp ALEX-STACK_v0/.claude/agents/secret-xpert-light.md ~/.claude/agents/
rm -rf ALEX-STACK_v0

# Option 2B: Download directly (requires gh CLI or curl)
curl -o ~/.claude/agents/jino-agent.md \
  https://raw.githubusercontent.com/alchimie-di-circe/ALEX-STACK_v0/main/.claude/agents/jino-agent.md

# 3. Verify agents
ls ~/.claude/agents/
# Should show copied agents

# 4. (Optional) Download plugins from marketplace
# Download specific plugin package and extract to your project
```

### Usage Workflow

```bash
# Day-to-day usage:

# 1. Use Claude Code with installed agents
# Agents work independently of repo

# 2. Update agents when needed
cd /tmp
git clone https://github.com/alchimie-di-circe/ALEX-STACK_v0.git
cp ALEX-STACK_v0/.claude/agents/updated-agent.md ~/.claude/agents/
rm -rf ALEX-STACK_v0

# 3. Or create your own local agents
nano ~/.claude/agents/my-custom-agent.md
# This agent is local-only, not in repo

# 4. Mix repo agents with local custom agents
ls ~/.claude/agents/
# jino-agent.md           (from repo)
# secret-xpert-light.md   (from repo)
# my-custom-agent.md      (local only)
```

### Pros and Cons

**✅ Pros:**
- Fully independent of repo
- Can mix repo agents with local custom agents
- Selective: only copy agents you need
- No Git knowledge required
- Simpler mental model

**⚠️ Cons:**
- Manual updates required
- No automatic sync with repo changes
- Need to remember which agents are outdated

---

## Option C: Hybrid (Development + Usage)

**Best for:** Active development on some agents while using stable versions of others.

### How It Works

```
┌──────────────────────────────────────────────┐
│  Local Development Repo                      │
│  ~/Projects/ALEX-STACK_v0/                   │
│    ├── .claude/agents/      (development)    │
│    └── marketplace/         (plugins)        │
└──────────────────────────────────────────────┘
                │
                │ selective install
                ▼
┌──────────────────────────────────────────────┐
│  Claude Code Config                          │
│  ~/.claude/agents/                           │
│    ├── jino-agent.md        (copied stable)  │
│    ├── secret-xpert-light@  (symlink dev)    │
│    └── my-custom-agent.md   (local only)     │
└──────────────────────────────────────────────┘
```

### Setup Steps

```bash
# 1. Clone repo for development
cd ~/Projects
git clone https://github.com/alchimie-di-circe/ALEX-STACK_v0.git

# 2. Create agents directory
mkdir -p ~/.claude/agents

# 3. Symlink agents you're actively developing
ln -s ~/Projects/ALEX-STACK_v0/.claude/agents/secret-xpert-light.md \
  ~/.claude/agents/secret-xpert-light.md

# 4. Copy stable agents you just want to use
cp ~/Projects/ALEX-STACK_v0/.claude/agents/jino-agent.md \
  ~/.claude/agents/jino-agent.md

# 5. Create local custom agents
cat > ~/.claude/agents/my-custom-agent.md <<EOF
---
name: my-custom-agent
description: My personal custom agent
---
# My Custom Agent
...
EOF

# 6. Result:
ls -la ~/.claude/agents/
# jino-agent.md                    (copied - stable)
# secret-xpert-light.md@           (symlink - dev)
# my-custom-agent.md               (local - custom)
```

### Development Workflow

```bash
# Developing secret-xpert-light (symlinked):
cd ~/Projects/ALEX-STACK_v0
code .claude/agents/secret-xpert-light.md
# Edit → Save → Changes immediately available!

# Using jino-agent (copied - stable):
# Just use it, no edits needed
# Update manually when new version released:
git pull
cp .claude/agents/jino-agent.md ~/.claude/agents/

# Local custom agent:
code ~/.claude/agents/my-custom-agent.md
# Edit directly, independent of repo
```

### Pros and Cons

**✅ Pros:**
- Best of both worlds
- Develop some agents, use others
- Mix repo agents with local custom agents
- Selective sync (only what you're developing)

**⚠️ Cons:**
- More complex mental model
- Need to track which agents are symlinked vs copied
- Potential confusion about where to edit

---

## Plugin Usage

All three workflow options support marketplace plugins:

### Installing Plugins

```bash
# Option 1: Direct copy (standalone plugin)
cp -r ~/Projects/ALEX-STACK_v0/marketplace/secret-manager-pro ~/my-project/

cd ~/my-project/secret-manager-pro
./scripts/setup.sh

# Option 2: Use in-place (symlink)
ln -s ~/Projects/ALEX-STACK_v0/marketplace/secret-manager-pro ~/my-project/secrets

cd ~/my-project/secrets
./scripts/setup.sh

# Option 3: Download plugin only (no full repo)
# Download plugin directory from GitHub
# Extract to project
# Run setup.sh
```

### Plugin Structure

```
my-project/
├── secret-manager-pro/        # Plugin directory
│   ├── .claude/agents/        # Plugin agents
│   ├── templates/             # .envrc templates
│   ├── scripts/               # Setup scripts
│   └── README.md
├── .envrc                     # Generated by plugin setup
├── .envrc.local.example       # Template for team
└── .gitignore                 # Updated by plugin
```

---

## Secret Management

All workflow options work with Secret Manager Pro + 1Password CLI:

### Setup Once

```bash
# 1. Install 1Password CLI
brew install 1password-cli

# 2. Authenticate
op signin

# 3. Create vault items (once)
op item create \
  --category=login \
  --title="Jina.ai" \
  --vault=Private \
  api_key="your_key"

# Done! Works everywhere now.
```

### Works in All Environments

```bash
# Cloud (Claude Code Web):
cd /workspace/project
direnv allow
echo $JINA_API_KEY  # ✅ From vault

# Local Terminal:
cd ~/Projects/project
direnv allow
echo $JINA_API_KEY  # ✅ Same vault, same key!

# Local IDE:
# IDE automatically loads from direnv
# Same credentials! ✅
```

See [1PASSWORD-INTEGRATION.md](./1PASSWORD-INTEGRATION.md) for complete guide.

---

## Git Workflow

### With Symlink (Option A)

```bash
# Workflow:
cd ~/Projects/ALEX-STACK_v0

# Make changes
code .claude/agents/jino-agent.md

# Test in Claude Code (via symlink - automatic)

# Commit when ready
git add .claude/agents/jino-agent.md
git commit -m "feat: Add new search capability to jino-agent"
git push

# Other machines:
git pull  # Symlink points to updated version automatically!
```

### With Manual Copy (Option B)

```bash
# Workflow:
# 1. Edit local copy directly
code ~/.claude/agents/my-agent.md

# 2. (Optional) Contribute back to repo
cd ~/Projects/ALEX-STACK_v0
cp ~/.claude/agents/my-agent.md .claude/agents/
git add .claude/agents/my-agent.md
git commit -m "feat: Add my-agent"
git push
```

### With Hybrid (Option C)

```bash
# For symlinked agents (in development):
cd ~/Projects/ALEX-STACK_v0
code .claude/agents/dev-agent.md
git add .claude/agents/dev-agent.md
git commit -m "Update dev-agent"
git push

# For copied agents (stable):
# Just use them, update manually when needed
git pull
cp .claude/agents/stable-agent.md ~/.claude/agents/

# For local agents:
# No git involved, edit directly
code ~/.claude/agents/local-agent.md
```

---

## Troubleshooting

### Symlink Issues

**Problem:** "No such file or directory" when using symlink

```bash
# Check symlink target
ls -la ~/.claude/agents/alex-stack

# If broken, recreate
rm ~/.claude/agents/alex-stack
ln -s ~/Projects/ALEX-STACK_v0/.claude/agents ~/.claude/agents/alex-stack
```

**Problem:** Moved repo, symlink broken

```bash
# Update symlink to new location
rm ~/.claude/agents/alex-stack
ln -s /new/path/to/ALEX-STACK_v0/.claude/agents ~/.claude/agents/alex-stack
```

### Agent Not Found

**Problem:** Claude Code can't find agent

```bash
# Check agent location
ls ~/.claude/agents/

# Option A: If using symlink
ls -la ~/.claude/agents/alex-stack/

# Option B: If using copy
ls ~/.claude/agents/agent-name.md

# Verify agent frontmatter
head ~/.claude/agents/agent-name.md
# Should show:
# ---
# name: agent-name
# ---
```

### Sync Issues

**Problem:** Local changes not appearing in cloud

```bash
# Option A (Symlink): Commit and push
cd ~/Projects/ALEX-STACK_v0
git add .
git commit -m "Update"
git push

# In cloud: git pull
```

**Problem:** Can't decide which workflow to use

**Answer:**
- **Just starting?** → Option B (Manual Copy)
- **Active development?** → Option A (Symlink)
- **Mix of both?** → Option C (Hybrid)

---

## Next Steps

- **Setup 1Password CLI**: [1PASSWORD-INTEGRATION.md](./1PASSWORD-INTEGRATION.md)
- **Try Secret Manager Pro**: `marketplace/secret-manager-pro/`
- **Create custom agents**: See `.claude/agents/` examples
- **Join discussions**: [GitHub Discussions](https://github.com/alchimie-di-circe/ALEX-STACK_v0/discussions)

---

**Questions?** Open an issue on [GitHub](https://github.com/alchimie-di-circe/ALEX-STACK_v0/issues)
