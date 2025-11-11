# 1Password CLI Integration Guide

Complete guide for integrating 1Password CLI with Claude Code and ALEX-STACK for secure, automated secrets management.

## 📋 Table of Contents

- [Overview](#overview)
- [Why 1Password CLI?](#why-1password-cli)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Initial Setup](#initial-setup)
- [Vault Structure](#vault-structure)
- [Integration with direnv](#integration-with-direnv)
- [Cloud + Local Workflows](#cloud--local-workflows)
- [Team Collaboration](#team-collaboration)
- [Security Best Practices](#security-best-practices)
- [Troubleshooting](#troubleshooting)
- [Advanced Usage](#advanced-usage)

## Overview

1Password CLI (`op`) allows you to securely access credentials from your 1Password vault via command line. When combined with direnv, it provides automatic, seamless secret management for Claude Code MCP servers and other development tools.

**Key Benefits:**
- Zero plaintext secrets on disk
- Automatic synchronization across cloud and local environments
- One-click key rotation via vault updates
- Team collaboration without sharing credential files
- Full audit trail of credential access

## Why 1Password CLI?

### Traditional Approach Problems:

```bash
# ❌ Secrets in plaintext files
# .envrc
export JINA_API_KEY="jina_abc123xyz..."  # Visible on disk!
export NOTION_API_TOKEN="secret_def456..."

# Risks:
# - Accidentally commit to Git
# - Visible in backups
# - Hard to rotate across environments
# - No audit trail
```

### 1Password CLI Solution:

```bash
# ✅ Secrets in encrypted vault
# .envrc
export JINA_API_KEY="$(op read 'op://Private/Jina.ai/api_key')"
export NOTION_API_TOKEN="$(op read 'op://Private/Notion MCP Suekou/token')"

# Benefits:
# - Credentials stay in encrypted vault
# - .envrc can be safely committed (no secrets!)
# - Rotate key in vault = updates everywhere
# - Full audit trail in 1Password
```

## Prerequisites

### Required:
- **1Password account** - Personal or team plan with CLI access
- **macOS, Linux, or WSL** - Supported platforms
- **direnv** - For automatic environment loading

### Recommended:
- **1Password app** (desktop or mobile) - For easier vault management
- **Touch ID / Face ID** - For biometric authentication
- **Git** - For version control

## Installation

### macOS

```bash
# Install 1Password CLI
brew install 1password-cli

# Verify installation
op --version
```

### Linux (Debian/Ubuntu)

```bash
# Add 1Password repository
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] \
  https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
  sudo tee /etc/apt/sources.list.d/1password.list

# Install
sudo apt update
sudo apt install 1password-cli

# Verify
op --version
```

### Other Platforms

Visit [1Password CLI documentation](https://developer.1password.com/docs/cli/get-started/) for:
- Linux (other distributions)
- WSL (Windows Subsystem for Linux)
- Manual installation

## Initial Setup

### Step 1: Authenticate 1Password CLI

```bash
# Sign in to your 1Password account
op signin

# You'll be prompted for:
# - Sign-in address (e.g., my.1password.com)
# - Email address
# - Master Password or Secret Key

# Verify authentication
op vault list
```

**Tip:** Use biometric unlock for convenience:
```bash
# macOS: Enable Touch ID
op account add --biometric

# This allows you to unlock with Touch ID instead of typing password
```

### Step 2: Choose or Create a Vault

```bash
# List existing vaults
op vault list

# Use existing vault (e.g., "Private")
# Or create new vault for development secrets:
op vault create "Development"
```

### Step 3: Install direnv (if not already)

```bash
# macOS
brew install direnv

# Linux
sudo apt-get install direnv

# Setup shell hook
# For bash:
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
source ~/.bashrc

# For zsh:
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
source ~/.zshrc
```

## Vault Structure

### Recommended Organization

Create separate items for each service in your vault:

```
Private Vault (or Development Vault)
├── Jina.ai
│   └── Fields:
│       ├── api_key: jina_abc123xyz...
│       └── notes: Web research MCP server
│
├── Notion MCP Suekou
│   └── Fields:
│       ├── token: secret_def456...
│       └── notes: Notion workspace integration
│
├── Anthropic
│   └── Fields:
│       ├── api_key: sk-ant-...
│       └── notes: Claude API key
│
├── GitHub
│   └── Fields:
│       ├── token: ghp_...
│       └── notes: GitHub CLI/API access
│
└── OpenAI
    └── Fields:
        ├── api_key: sk-...
        └── notes: OpenAI API
```

### Creating Items via CLI

```bash
# Template
op item create \
  --category=login \
  --title="Service Name" \
  --vault=Private \
  field_name="value"

# Example: Jina.ai
op item create \
  --category=login \
  --title="Jina.ai" \
  --vault=Private \
  api_key="your_jina_api_key_here"

# Example: Notion MCP
op item create \
  --category=login \
  --title="Notion MCP Suekou" \
  --vault=Private \
  token="your_notion_token_here"
```

### Creating Items via App (Easier)

1. Open 1Password app
2. Select vault (e.g., "Private")
3. Click "+" → New Item
4. Choose "Login" category
5. Set title (e.g., "Jina.ai")
6. Add custom fields:
   - Field name: `api_key`
   - Value: your actual API key
7. Add notes (optional)
8. Save

## Integration with direnv

### Creating .envrc with 1Password

```bash
# Navigate to your project
cd /path/to/your/project

# Create .envrc with 1Password integration
cat > .envrc <<'EOF'
# .envrc with 1Password CLI integration
VAULT_NAME="Private"  # Your vault name

if command -v op >/dev/null 2>&1 && op vault list >/dev/null 2>&1; then
  # Load secrets from 1Password vault
  export JINA_API_KEY="$(op read "op://${VAULT_NAME}/Jina.ai/api_key")"
  export NOTION_API_TOKEN="$(op read "op://${VAULT_NAME}/Notion MCP Suekou/token")"

  echo "✅ Secrets loaded from 1Password vault: ${VAULT_NAME}"
else
  # Fallback to .envrc.local
  if [ -f .envrc.local ]; then
    source_env .envrc.local
    echo "⚠️  Using .envrc.local (1Password unavailable)"
  else
    echo "❌ 1Password CLI not available and .envrc.local missing"
  fi
fi

export CLAUDE_PROJECT_ROOT="$(pwd)"
export NODE_ENV="${NODE_ENV:-development}"
EOF

# Allow direnv to load this file
direnv allow

# Verify secrets are loaded
echo $JINA_API_KEY
```

### 1Password Reference Format

```bash
op://[vault]/[item]/[field]
      ↓       ↓      ↓
    Private  Jina.ai  api_key

# Examples:
op://Private/Jina.ai/api_key
op://Development/GitHub/token
op://Work/Anthropic/api_key
```

### Reading from 1Password

```bash
# Read a specific field
op read "op://Private/Jina.ai/api_key"

# Use in .envrc
export JINA_API_KEY="$(op read 'op://Private/Jina.ai/api_key')"

# Note the single quotes around the reference!
# This prevents shell expansion issues
```

## Cloud + Local Workflows

### Scenario 1: Claude Code Web (Cloud)

```bash
# In Claude Code web session:

# 1. Authenticate 1Password CLI (one-time per session)
op signin

# 2. Navigate to project directory
cd /workspace/your-project

# 3. direnv automatically loads secrets from your vault!
# No manual copying or pasting needed

# 4. Verify
echo $JINA_API_KEY  # Shows value from vault

# 5. Use Claude Code agents that need MCP credentials
# They now have access to all required secrets!
```

### Scenario 2: Local Terminal/IDE

```bash
# In local Mac terminal:

# 1. One-time authentication (stays authenticated)
op signin

# 2. Navigate to project
cd ~/Projects/your-project

# 3. direnv automatically loads secrets from vault
# Same .envrc file, same vault, same credentials!

# 4. Works identically to cloud workflow
echo $JINA_API_KEY  # Same value as in cloud!
```

### Scenario 3: Switching Between Cloud and Local

```bash
# No configuration changes needed!
# Same .envrc file works in both environments

# Cloud:
cd /workspace/project && direnv allow
# Credentials from vault ✅

# Local:
cd ~/Projects/project && direnv allow
# Same credentials from same vault ✅

# Perfect sync!
```

## Team Collaboration

### Sharing Secrets with Team Members

#### Option A: Shared Vault (Recommended)

```bash
# Team lead creates vault and items
op vault create "Team-Development"

op item create \
  --category=login \
  --title="Jina.ai" \
  --vault=Team-Development \
  api_key="shared_team_key"

# Share vault with team members via 1Password app:
# 1. Open 1Password app
# 2. Go to vault settings
# 3. Add team members
# 4. Set permissions (view/edit)
```

Team members setup:
```bash
# 1. Authenticate 1Password CLI
op signin

# 2. Clone project repository
git clone <repo>
cd <repo>

# 3. Update .envrc to use team vault
# Edit VAULT_NAME="Team-Development"

# 4. Allow direnv
direnv allow

# Done! They have access via shared vault
```

#### Option B: Individual Vaults (More Secure)

Each team member uses their own vault with their own credentials:

```bash
# Each developer creates items in their Private vault
# Using their individual API keys

# .envrc stays the same (references Private vault)
# But each developer has their own keys
```

### Committing .envrc to Git

```bash
# With 1Password integration, .envrc contains NO secrets!
# It's safe to commit:

git add .envrc
git commit -m "Add 1Password-integrated environment setup"
git push

# Team members clone repo and:
# 1. op signin
# 2. direnv allow
# 3. Done!
```

### Creating .envrc.local Fallback for Non-1Password Users

```bash
# Create example template
cat > .envrc.local.example <<'EOF'
# .envrc.local.example - Manual fallback
# Copy to .envrc.local and fill in your credentials

export JINA_API_KEY="your_jina_key_here"
export NOTION_API_TOKEN="your_notion_token_here"
EOF

# Commit example (safe)
git add .envrc.local.example

# Ensure .envrc.local is gitignored
echo ".envrc.local" >> .gitignore
git add .gitignore

git commit -m "Add fallback credential template"
```

## Security Best Practices

### ✅ DO:

1. **Use strong master password** for 1Password account
2. **Enable 2FA** on 1Password account
3. **Use biometric unlock** (Touch ID/Face ID) for CLI
4. **Rotate keys regularly** via vault (propagates automatically)
5. **Review audit logs** in 1Password periodically
6. **Use separate vaults** for different security levels (personal/work/team)
7. **Set appropriate permissions** when sharing vaults
8. **Add .envrc.local to .gitignore** (fallback credentials)
9. **Test fallback path** to ensure it works without 1Password
10. **Document vault structure** for team onboarding

### ❌ DON'T:

1. **Never commit .envrc.local** with real secrets
2. **Don't share master password** or Secret Key via insecure channels
3. **Don't store master password** in files or scripts
4. **Don't disable 2FA** on 1Password account
5. **Don't use same API keys** across dev/staging/prod
6. **Don't skip biometric setup** (use it for convenience)
7. **Don't share vaults** with external parties without review
8. **Don't hardcode secrets** as fallback in .envrc
9. **Don't ignore 1Password security alerts**
10. **Don't commit .git-crypt keys** or similar encryption keys

### Audit Trail

1Password automatically logs all credential access:

```bash
# View activity log in 1Password app:
# Settings → Activity Log

# Shows:
# - Who accessed what credential
# - When it was accessed
# - From which device/location
# - What action was performed
```

## Troubleshooting

### Issue: "401 Unauthorized" or Authentication Fails

```bash
# Solution 1: Re-authenticate
op signout
op signin

# Solution 2: Check account status
op account list

# Solution 3: Verify vault access
op vault list
```

### Issue: "Item not found in vault"

```bash
# Solution: List items to verify name
op item list --vault Private

# Create if missing
op item create \
  --category=login \
  --title="Jina.ai" \
  --vault=Private \
  api_key="your_key"
```

### Issue: Variables showing empty in .envrc

```bash
# Test 1Password read directly
op read "op://Private/Jina.ai/api_key"

# If this works, check .envrc syntax:
# ❌ Wrong: export KEY=$(op read op://Private/Item/field)
# ✅ Correct: export KEY="$(op read 'op://Private/Item/field')"

# Note the quotes!
```

### Issue: "op: command not found"

```bash
# Reinstall 1Password CLI
brew reinstall 1password-cli  # macOS

# Or follow installation steps for your platform
```

### Issue: Biometric unlock not working

```bash
# macOS: Re-enable Touch ID
op account add --biometric

# Verify Touch ID is enabled in System Preferences
```

### Issue: Session expires frequently

```bash
# Extend session duration (default: 30 minutes)
op signin --duration 8h  # 8 hours

# Or configure default duration in config
```

## Advanced Usage

### Multi-Environment Setup

```bash
# .envrc with environment detection
ENVIRONMENT="${ENVIRONMENT:-development}"
VAULT_NAME="${OP_VAULT_NAME:-Private}"

if [ "$ENVIRONMENT" = "production" ]; then
  VAULT_NAME="Production"
fi

export JINA_API_KEY="$(op read "op://${VAULT_NAME}/Jina.ai/api_key")"
```

Usage:
```bash
# Development (default)
cd project && direnv allow

# Production
ENVIRONMENT=production cd project && direnv allow
```

### Conditional Credential Loading

```bash
# .envrc with service selection
SERVICES="${SERVICES:-jina,notion}"

if [[ $SERVICES == *"jina"* ]]; then
  export JINA_API_KEY="$(op read 'op://Private/Jina.ai/api_key')"
fi

if [[ $SERVICES == *"notion"* ]]; then
  export NOTION_API_TOKEN="$(op read 'op://Private/Notion MCP Suekou/token')"
fi
```

### Caching for Performance

```bash
# .envrc with caching (avoid repeated op reads)
if [ -z "$_SECRETS_LOADED" ]; then
  export JINA_API_KEY="$(op read 'op://Private/Jina.ai/api_key')"
  export NOTION_API_TOKEN="$(op read 'op://Private/Notion MCP Suekou/token')"
  export _SECRETS_LOADED="true"
fi
```

### Using with CI/CD

For CI/CD environments, use 1Password Connect Server or Service Accounts:

```bash
# GitHub Actions example with 1Password Connect
- uses: 1password/load-secrets-action@v1
  with:
    connect-host: ${{ secrets.OP_CONNECT_HOST }}
    connect-token: ${{ secrets.OP_CONNECT_TOKEN }}
    secrets: |
      JINA_API_KEY=op://Private/Jina.ai/api_key
      NOTION_API_TOKEN=op://Private/Notion MCP Suekou/token
```

See [1Password Connect documentation](https://developer.1password.com/docs/connect/) for details.

## Next Steps

- **Try Secret Manager Pro plugin**: Pre-configured integration in `marketplace/secret-manager-pro/`
- **Read SETUP-LOCAL.md**: Hybrid workflow setup guide
- **Explore templates**: Ready-to-use `.envrc` templates in `templates/`
- **Use Secret Xpert Light agent**: AI assistant for secret management

## Resources

- [1Password CLI Documentation](https://developer.1password.com/docs/cli/)
- [1Password Connect](https://developer.1password.com/docs/connect/) (for CI/CD)
- [direnv Documentation](https://direnv.net/)
- [Secret Manager Pro Plugin](../marketplace/secret-manager-pro/)
- [ALEX-STACK Repository](https://github.com/alchimie-di-circe/ALEX-STACK_v0)

---

**Questions or issues?** Open an issue on [GitHub](https://github.com/alchimie-di-circe/ALEX-STACK_v0/issues)
