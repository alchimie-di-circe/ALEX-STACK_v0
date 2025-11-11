# Secret Manager Pro 🔐

Production-grade secrets management for Claude Code using **direnv + 1Password CLI**.

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](package.json)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Compatible-purple.svg)](https://docs.claude.com/claude-code)

## 🌟 Features

- ✨ **1Password CLI Integration** - Pull secrets directly from encrypted vault
- 🔄 **Cloud + Local Sync** - Same setup works in Claude Web and local terminal
- 🛡️ **Zero Plaintext Secrets** - Credentials never stored on disk
- 🎯 **Graceful Fallback** - Works with or without 1Password
- ⚡ **Automatic Loading** - direnv loads secrets when you enter directory
- 🚀 **Fast Setup** - Production-ready in 5-10 minutes
- 👥 **Team-Friendly** - Share vault access, not files
- 🔐 **Biometric Auth** - Touch ID/Face ID for credential access

## 🎯 Why Use This Plugin?

### Traditional Approach Problems:
- ❌ API keys in plaintext files (`.env`, `.envrc`)
- ❌ Risk of accidentally committing secrets to Git
- ❌ Manual key rotation across multiple environments
- ❌ Different setups for cloud vs local
- ❌ No audit trail for credential access

### Secret Manager Pro Solution:
- ✅ Secrets in encrypted 1Password vault
- ✅ Automatic Git protection (.gitignore best practices)
- ✅ One-click key rotation (update vault, sync everywhere)
- ✅ Identical setup for cloud and local workflows
- ✅ Complete audit trail in 1Password

## 📦 What's Included

```
secret-manager-pro/
├── .claude/
│   └── agents/
│       └── secret-xpert-light.md   # AI assistant for secret management
├── templates/
│   ├── .envrc.1password.template   # 1Password CLI integration
│   ├── .envrc.manual.template      # Manual fallback
│   └── .envrc.local.example        # Team template
├── scripts/
│   ├── setup.sh                    # Interactive setup wizard
│   ├── check-requirements.sh       # Verify dependencies
│   └── test-integration.sh         # Test 1Password connection
├── README.md                        # This file
└── package.json                     # Plugin metadata
```

## 🚀 Quick Start

### Prerequisites

**Required:**
- [direnv](https://direnv.net/) - Automatic environment loader
- Bash/Zsh shell

**Recommended:**
- [1Password CLI](https://developer.1password.com/docs/cli/) - Secure vault integration
- 1Password account with API access

### Option A: Setup with 1Password (Recommended)

```bash
# 1. Install dependencies
brew install direnv 1password-cli

# 2. Setup shell hook (one-time)
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc  # or ~/.zshrc for zsh
source ~/.bashrc

# 3. Authenticate 1Password
op signin

# 4. Navigate to your project
cd /path/to/your/project

# 5. Copy 1Password template
cp /path/to/secret-manager-pro/templates/.envrc.1password.template .envrc

# 6. Customize .envrc (optional)
# Edit vault name and item references if needed

# 7. Allow direnv
direnv allow

# 8. Verify
echo $JINA_API_KEY  # Should show your key from vault!
```

### Option B: Setup without 1Password (Fallback)

```bash
# 1. Install direnv
brew install direnv

# 2. Setup shell hook
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
source ~/.bashrc

# 3. Navigate to your project
cd /path/to/your/project

# 4. Copy manual template
cp /path/to/secret-manager-pro/templates/.envrc.manual.template .envrc

# 5. Edit .envrc with your API keys
nano .envrc  # Replace placeholders with real credentials

# 6. Ensure .gitignore includes .envrc
echo ".envrc" >> .gitignore

# 7. Allow direnv
direnv allow

# 8. Verify
echo $JINA_API_KEY
```

## 🔧 Configuration

### 1Password Vault Structure

Create items in your 1Password vault for each service:

```bash
# Jina AI
op item create --category=login \
  --title="Jina.ai" \
  --vault=Private \
  api_key="your_jina_key_here"

# Notion MCP
op item create --category=login \
  --title="Notion MCP Suekou" \
  --vault=Private \
  token="your_notion_token_here"
```

Or use the 1Password app (easier with GUI):
1. Open 1Password
2. Go to "Private" vault (or your preferred vault)
3. Click "+" → New Item → Login
4. Title: "Jina.ai"
5. Add custom field: `api_key` = your key
6. Save

### Customizing .envrc

Edit `.envrc` to match your vault structure:

```bash
# Change vault name
VAULT_NAME="Work"  # Instead of "Private"

# Add more services
export ANTHROPIC_API_KEY="$(op read "op://${VAULT_NAME}/Anthropic/api_key")"
export GITHUB_TOKEN="$(op read "op://${VAULT_NAME}/GitHub/token")"
```

## 🎯 Usage with Claude Code

### Claude Code Web (Cloud)

```bash
# 1. Clone your project in Claude Web session
# 2. Authenticate 1Password CLI:
op signin

# 3. Navigate to project:
cd /workspace/your-project

# 4. direnv automatically loads secrets from vault!
echo $JINA_API_KEY  # Works!

# 5. Use Claude Code agents that need MCP credentials
# They now have access to JINA_API_KEY, NOTION_API_TOKEN, etc.
```

### Claude Code Local (Terminal/IDE)

```bash
# Same workflow as cloud!
# 1Password CLI authenticated once
# direnv loads secrets automatically
# Claude Code agents have credentials

# Your MCP servers (Jina, Notion) work instantly!
```

## 🔄 Key Rotation

### With 1Password (Recommended)

```bash
# 1. Update key in vault
op item edit "Jina.ai" api_key="new_key_here" --vault Private

# 2. Reload direnv (direnv auto-reloads on file change, but force if needed)
direnv allow

# 3. Done! All environments updated automatically
echo $JINA_API_KEY  # New key!
```

### Without 1Password

```bash
# 1. Edit .envrc
nano .envrc  # Update API key value

# 2. Save file (direnv auto-reloads)

# 3. Verify
echo $JINA_API_KEY  # New key
```

## 👥 Team Setup

### Sharing with Team (1Password)

```bash
# 1. Team lead creates vault items in 1Password

# 2. Share vault with team members (via 1Password app)

# 3. Team members:
git clone <repo>
cd <repo>
op signin  # Their 1Password account
direnv allow

# Done! They have access via shared vault
```

### Sharing with Team (Manual)

```bash
# 1. Commit .envrc.local.example to repo (safe, no secrets)
git add .envrc.local.example
git commit -m "Add credential template"

# 2. Team members:
git clone <repo>
cd <repo>
cp .envrc.local.example .envrc.local
# Edit .envrc.local with their credentials
direnv allow
```

## 🛠️ Troubleshooting

### Issue: "direnv: error .envrc is blocked"

```bash
direnv allow
```

### Issue: 1Password CLI not authenticated

```bash
# Check status
op vault list

# If fails, sign in
op signin

# Verify
op item list --vault Private

# Reload direnv
direnv allow
```

### Issue: Variables showing empty

```bash
# Test 1Password read directly
op read "op://Private/Jina.ai/api_key"

# If this works, check .envrc syntax:
cat .envrc

# Ensure quotes are correct:
# ✅ export KEY="$(op read 'op://Private/Item/field')"
# ❌ export KEY=$(op read op://Private/Item/field)

# Reload
direnv allow
```

### Issue: Item not found in vault

```bash
# List all items
op item list --vault Private

# Create missing item
op item create --category=login \
  --title="Jina.ai" \
  --vault=Private \
  api_key="your_key"

# Reload
direnv allow
```

## 🔐 Security Best Practices

### ✅ DO:
- Use 1Password CLI for production environments
- Add `.envrc.local` to `.gitignore`
- Rotate keys regularly via 1Password
- Use biometric authentication (Touch ID/Face ID)
- Review 1Password audit logs periodically
- Share vault access, never credential files

### ❌ DON'T:
- Commit `.envrc.local` with real secrets
- Share credentials via Slack/Email/etc.
- Use same API keys across dev/prod
- Skip `.gitignore` configuration
- Store 1Password master password in files

## 📚 Learn More

- [1Password CLI Documentation](https://developer.1password.com/docs/cli/)
- [direnv Documentation](https://direnv.net/)
- [Claude Code MCP Servers](https://docs.claude.com/mcp)
- [ALEX-STACK Repository](https://github.com/alchimie-di-circe/ALEX-STACK_v0)

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/alchimie-di-circe/ALEX-STACK_v0/issues)
- **Discussions**: [GitHub Discussions](https://github.com/alchimie-di-circe/ALEX-STACK_v0/discussions)
- **Documentation**: [docs/1PASSWORD-INTEGRATION.md](../../docs/1PASSWORD-INTEGRATION.md)

## 📝 License

MIT © Alex Stack Contributors

## 🙏 Credits

Built with:
- [1Password CLI](https://developer.1password.com/docs/cli/) by 1Password
- [direnv](https://direnv.net/) by zimbatm and contributors
- [Claude Code](https://docs.claude.com/claude-code) by Anthropic

---

**Made with ❤️ for the Claude Code community**
