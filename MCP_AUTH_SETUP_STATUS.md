# MCP Server Authentication Setup Status

**Project**: ALEX-STACK
**Date**: 2025-11-15
**Status**: CONFIGURED & READY (awaiting 1Password CLI authentication)

---

## Executive Summary

The direnv + 1Password CLI integration is fully configured and ready to use. Two MCP servers are configured to receive credentials:

1. **Jina MCP Server** - Requires JINA_API_KEY
2. **Notion Suekou MCP Server** - Requires NOTION_API_TOKEN

Both credentials will be automatically loaded from your 1Password vault 'AI DEV' when you authenticate.

---

## Current Configuration Status

### Installed Components

| Component | Status | Details |
|-----------|--------|---------|
| direnv | ✅ Installed | Version 2.32.1, ready to load environment variables |
| 1Password CLI | ❌ Not installed | Needs to be installed on your local machine |
| .envrc | ✅ Configured | Contains 1Password vault references (safe to commit) |
| .envrc.local.example | ✅ Configured | Fallback template for manual credentials |
| .gitignore | ✅ Configured | Includes .envrc.local (secrets protected) |
| .mcp.json | ✅ Configured | References environment variables |

### Files Involved

```
/home/user/ALEX-STACK_v0/
├── .envrc                      ✅ Ready to load from 1Password
├── .envrc.local.example        ✅ Fallback template
├── .gitignore                  ✅ Protects .envrc.local
├── .mcp.json                   ✅ References JINA_API_KEY and NOTION_API_TOKEN
└── VAULT_SETUP.md              ✅ Setup instructions (in Italian)
```

---

## What's Been Configured

### .envrc Configuration

The `.envrc` file has been updated with intelligent fallback logic:

```bash
# Primary: Try to load from 1Password vault "AI DEV"
# Using actual item names and field names from the vault
JINA_API_KEY="$(op read "op://AI DEV/JINA.AI API key/credential")"
NOTION_API_TOKEN="$(op read "op://AI DEV/NOTION SUEKOU MCP server/TOKEN")"

# Fallback: If 1Password not available, use .envrc.local
if [ -z "$JINA_API_KEY" ] && [ -z "$NOTION_API_TOKEN" ]; then
  source_env .envrc.local
fi
```

**Current Vault Item References:**
- Jina AI: Item name `JINA.AI API key`, field `credential`
- Notion: Item name `NOTION SUEKOU MCP server`, field `TOKEN`

This means:
- If you have 1Password CLI installed and authenticated → credentials auto-load from vault
- If you don't have 1Password CLI → falls back to .envrc.local
- Supports both cloud and local workflows seamlessly

**Note:** These items use non-standard field names. For future credentials, follow the [1Password Credentials Standard](./docs/1PASSWORD-CREDENTIALS-STANDARD.md) which recommends using the `password` field for all credentials.

### MCP Server Configuration

The `.mcp.json` file references these environment variables:

```json
{
  "mcpServers": {
    "jina-mcp-server": {
      "args": ["--header", "Authorization: Bearer ${JINA_API_KEY}"]
    },
    "notion": {
      "env": {
        "NOTION_API_TOKEN": "${NOTION_API_TOKEN}"
      }
    }
  }
}
```

When you start Claude Code, direnv automatically loads these variables and passes them to MCP servers.

### .gitignore Security

```bash
# Already protected by .gitignore:
.envrc.local           # Never committed
.env
.env.local
.env.*.local
```

Your actual credentials are protected!

---

## Next Steps (IMMEDIATE ACTION REQUIRED)

### Step 1: Install 1Password CLI on Your Local Machine

Choose your operating system:

**macOS:**
```bash
brew install 1password-cli
```

**Linux (Debian/Ubuntu):**
```bash
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
  sudo tee /etc/apt/sources.list.d/1password.list > /dev/null

sudo apt update && sudo apt install -y 1password-cli
```

**Linux (Fedora/RHEL):**
```bash
sudo dnf install 1password-cli
```

**Windows:**
```powershell
winget install AgieBits.1Password.CLI
```

### Step 2: Authenticate with 1Password

```bash
op signin
```

Follow the interactive prompts to sign in with your 1Password account.

### Step 3: Verify Vault Access

```bash
# List your vaults
op vault list

# Should show "AI DEV" (and possibly "Personal")
```

### Step 4: Verify Vault Items Exist

The configuration expects these specific items in your "AI DEV" vault:

**Required Items:**
1. Item name: `JINA.AI API key`
   - Field name: `credential`
   - Reference: `op://AI DEV/JINA.AI API key/credential`

2. Item name: `NOTION SUEKOU MCP server`
   - Field name: `TOKEN`
   - Reference: `op://AI DEV/NOTION SUEKOU MCP server/TOKEN`

**Verify they exist:**
```bash
# Check if Jina item exists
op item get "JINA.AI API key" --vault "AI DEV"

# Check if Notion item exists
op item get "NOTION SUEKOU MCP server" --vault "AI DEV"
```

**If items don't exist, create them:**
```bash
# Create Jina.AI API key item with 'credential' field
op item create \
  --category=login \
  --title="JINA.AI API key" \
  --vault="AI DEV" \
  credential[text]="YOUR_ACTUAL_JINA_API_KEY_HERE"

# Create Notion SUEKOU MCP server item with 'TOKEN' field
op item create \
  --category=login \
  --title="NOTION SUEKOU MCP server" \
  --vault="AI DEV" \
  TOKEN[text]="YOUR_ACTUAL_NOTION_TOKEN_HERE"
```

**Note:** These items use custom field names (`credential` and `TOKEN`) instead of the standard `password` field. For future credentials, follow the [1Password Credentials Standard](./docs/1PASSWORD-CREDENTIALS-STANDARD.md).

### Step 5: Setup direnv Shell Hook

Add direnv to your shell:

**For bash:**
```bash
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
source ~/.bashrc
```

**For zsh:**
```bash
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
source ~/.zshrc
```

**For fish:**
```bash
echo 'direnv hook fish | source' >> ~/.config/fish/config.fish
```

### Step 6: Enable direnv and Verify

```bash
cd /path/to/ALEX-STACK_v0

# Allow direnv to load .envrc
direnv allow

# Verify credentials are loaded
echo "JINA_API_KEY: ${JINA_API_KEY:0:20}..."
echo "NOTION_API_TOKEN: ${NOTION_API_TOKEN:0:20}..."
```

Expected output:
```
✅ Secrets loaded from 1Password vault: AI DEV
JINA_API_KEY: jina_xxxxxxxxxxxxx...
NOTION_API_TOKEN: secret_xxxxxxxxxxx...
```

**Automated Verification:**

Run the comprehensive verification script to check all components:

```bash
./verify-1password-config.sh
```

This script checks:
- 1Password CLI installation and authentication
- Vault and item existence with correct field names
- direnv installation and configuration
- Environment variable loading
- .mcp.json configuration

It will provide detailed feedback on any missing or misconfigured components.

---

## Fallback: Without 1Password CLI

If you prefer not to use 1Password CLI, you can manually set credentials:

```bash
# Copy the example template
cp .envrc.local.example .envrc.local

# Edit with your actual credentials
nano .envrc.local
# Replace placeholder values with real API keys

# Allow direnv
direnv allow

# Verify
echo $JINA_API_KEY
```

The .envrc will automatically detect this and use .envrc.local as fallback.

---

## Credential Sources

### Jina AI API Key

1. Go to: https://jina.ai/
2. Sign in to your account
3. Navigate to API Keys
4. Create or copy your API key
5. Store in 1Password: `op://AI DEV/Jina.ai/api_key`

### Notion Integration Token

1. Go to: https://www.notion.so/my-integrations
2. Create a new integration or select existing
3. Copy "Internal Integration Token"
4. Store in 1Password: `op://AI DEV/Notion MCP Suekou/token`

---

## Verification Checklist

Before using MCP servers, verify each step:

- [ ] 1Password CLI installed: `which op`
- [ ] 1Password authenticated: `op vault list`
- [ ] Vault "AI DEV" exists: `op vault list | grep "AI DEV"`
- [ ] Jina item exists: `op item get "JINA.AI API key" --vault "AI DEV"`
- [ ] Notion item exists: `op item get "NOTION SUEKOU MCP server" --vault "AI DEV"`
- [ ] direnv shell hook installed: `grep direnv ~/.bashrc` or `~/.zshrc`
- [ ] direnv allowed in project: `direnv status` (not blocked)
- [ ] JINA_API_KEY loaded: `echo $JINA_API_KEY` (shows key)
- [ ] NOTION_API_TOKEN loaded: `echo $NOTION_API_TOKEN` (shows token)
- [ ] MCP servers configured: `.mcp.json` references both env vars

---

## How It Works (Architecture)

```
┌─────────────────────────────────────┐
│  Your 1Password Vault (AI DEV)     │
│  - Jina.ai (api_key)               │
│  - Notion MCP Suekou (token)       │
└──────────────┬──────────────────────┘
               │
               ↓ (1Password CLI reads)
┌──────────────────────────────────────┐
│  .envrc (direnv config)              │
│  - Loads from 1Password vault        │
│  - Sets environment variables        │
│  - Falls back to .envrc.local        │
└──────────────┬──────────────────────┘
               │
               ↓ (direnv auto-loads)
┌──────────────────────────────────────┐
│  Environment Variables               │
│  - JINA_API_KEY                     │
│  - NOTION_API_TOKEN                 │
└──────────────┬──────────────────────┘
               │
               ↓ (referenced in .mcp.json)
┌──────────────────────────────────────┐
│  MCP Servers (via Claude Code)       │
│  - Jina MCP Server (gets key)       │
│  - Notion MCP Server (gets token)   │
└──────────────────────────────────────┘
```

---

## Security Features

1. **Zero plaintext secrets**: Credentials stay in encrypted 1Password vault
2. **Automatic rotation**: Update key in vault, propagates instantly
3. **Cloud + Local sync**: Same vault works everywhere
4. **Audit trail**: 1Password tracks all access
5. **Biometric unlock**: Touch ID/Face ID support
6. **Fallback security**: .envrc.local protected by .gitignore

---

## Rotating API Keys

### With 1Password (Recommended)

```bash
# Update in vault
op item edit "Jina.ai" api_key="new_key_here" --vault "AI DEV"

# Reload direnv
direnv allow

# Instantly available!
echo $JINA_API_KEY  # Shows new key
```

### With Manual Fallback

```bash
# Edit .envrc.local
nano .envrc.local

# Update credentials and save

# Reload
direnv allow
```

---

## Team Collaboration

### Recommended: Share Vault Access

1. In 1Password app, share "AI DEV" vault with team members
2. They run: `op signin` and `direnv allow`
3. Credentials automatically sync!

### Alternative: Share .envrc.local.example

1. Commit `.envrc.local.example` to Git
2. Team members copy: `cp .envrc.local.example .envrc.local`
3. They fill in their own credentials
4. Each person has their own `.envrc.local`

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `op: command not found` | Install 1Password CLI (see Step 1 above) |
| `1Password CLI not authenticated` | Run `op signin` |
| `Item not found in vault` | Create item with correct name in 1Password |
| `direnv: error .envrc is blocked` | Run `direnv allow` |
| `Variables not loading` | Check direnv shell hook is installed |
| `.envrc.local committed accidentally` | Run `git rm --cached .envrc.local` |

See `VAULT_SETUP.md` for detailed troubleshooting.

---

## Files Modified/Created

| File | Status | Purpose |
|------|--------|---------|
| `.envrc` | ✅ Updated | Configured with 1Password integration + fallback using correct vault item names |
| `.envrc.local.example` | ✅ Verified | Template for manual fallback |
| `.gitignore` | ✅ Verified | Protects .envrc.local |
| `.mcp.json` | ✅ Verified | References environment variables |
| `VAULT_SETUP.md` | ✅ Verified | Italian setup guide (existing) |
| `MCP_AUTH_SETUP_STATUS.md` | ✅ Updated | This file (your status report with correct vault references) |
| `verify-1password-config.sh` | ✅ Created | Automated verification script for complete setup validation |

---

## Quick Command Reference

```bash
# Verify 1Password CLI
op --version

# Sign in to 1Password
op signin

# List vaults
op vault list

# List vault items
op item list --vault "AI DEV"

# Create vault item
op item create --category=login --title="Jina.ai" --vault="AI DEV" api_key="value"

# Read secret
op read "op://AI DEV/Jina.ai/api_key"

# Allow direnv
direnv allow

# Check direnv status
direnv status

# View environment variables
echo $JINA_API_KEY
echo $NOTION_API_TOKEN
```

---

## Next Steps After Setup

Once authentication is configured and verified:

1. Start Claude Code with MCP servers enabled
2. Test Jina MCP server for web research
3. Test Notion MCP server for workspace integration
4. Add additional services to vault as needed
5. Share vault access with team members

---

## Resources

- **1Password CLI**: https://developer.1password.com/docs/cli/
- **direnv**: https://direnv.net/
- **Jina AI**: https://jina.ai/docs/
- **Notion API**: https://developers.notion.com/
- **VAULT_SETUP.md**: Italian setup guide (in this directory)

---

## Support

If you encounter issues:

1. Check troubleshooting section above
2. Review `VAULT_SETUP.md` for detailed instructions
3. Run verification checklist
4. Consult tool documentation links above

---

**Status**: READY TO AUTHENTICATE
**Last Updated**: 2025-11-15
**Configuration Type**: direnv + 1Password CLI (Recommended)
**Fallback**: Manual .envrc.local (if 1Password unavailable)
