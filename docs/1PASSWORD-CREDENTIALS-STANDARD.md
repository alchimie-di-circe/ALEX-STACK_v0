# 1Password Credentials Standard

**Version:** 1.0
**Last Updated:** 2025-11-15
**Purpose:** Standardize credential storage in 1Password vault for consistent automation with Claude Code and AI agents

---

## 🎯 Overview

This document defines the **standard structure** for storing API keys and credentials in 1Password vaults to ensure:
- **Consistency** across all services
- **Automation** with Claude Code agents (secret-xpert-light, etc.)
- **Zero configuration** when adding new credentials
- **Easy migration** between vaults and environments

---

## 📋 Standard Item Structure

### Item Configuration

All API keys and service credentials should follow this structure:

```yaml
Item Type: Login
Vault: AI DEV (or specified vault)
Title: [Service Name]
Fields:
  - username: [optional - service email/account]
  - password: [THE CREDENTIAL/API KEY/TOKEN]
  - url: [optional - service URL]
  - notes: [optional - description of what this is for]
```

### ✅ Key Principle

**Always use the `password` field** for the actual credential (API key, token, secret key, etc.)

**Why?**
- Every 1Password Login item has a `password` field by default
- No need to create custom fields
- Consistent across all services
- Works automatically with `op read` command

---

## 🔑 Naming Conventions

### Service Name Format

**Pattern:** `[Service Name] [Type]` (optional type suffix)

**Examples:**
- `Jina.ai` ✅
- `Notion MCP` ✅
- `Anthropic` ✅
- `GitHub` ✅
- `OpenAI` ✅

**Avoid:**
- Random capitalization: `JINA.AI API key` ❌ (inconsistent)
- Too verbose: `Notion MCP Suekou Server Integration Token` ❌
- Abbreviations only: `JNA` ❌ (unclear)

### Field Name Standard

| Credential Type | Field to Use | Example Value |
|----------------|--------------|---------------|
| API Key | `password` | `jina_abc123xyz...` |
| Token | `password` | `secret_def456...` |
| Secret Key | `password` | `sk-ant-abc123...` |
| Access Token | `password` | `ghp_abc123xyz...` |

**Never use custom fields** like `credential`, `TOKEN`, `api_key`, etc. unless absolutely necessary.

---

## 📖 Standard Examples

### Example 1: Jina AI

```bash
op item create \
  --category=login \
  --title="Jina.ai" \
  --vault="AI DEV" \
  username="user@example.com" \
  password="jina_abc123xyz..." \
  url="https://jina.ai"
```

**1Password Reference:**
```bash
op://AI DEV/Jina.ai/password
```

**In .envrc:**
```bash
export JINA_API_KEY="$(op read 'op://AI DEV/Jina.ai/password')"
```

### Example 2: Notion

```bash
op item create \
  --category=login \
  --title="Notion" \
  --vault="AI DEV" \
  username="user@example.com" \
  password="secret_notion123..." \
  url="https://www.notion.so"
```

**1Password Reference:**
```bash
op://AI DEV/Notion/password
```

**In .envrc:**
```bash
export NOTION_API_TOKEN="$(op read 'op://AI DEV/Notion/password')"
```

### Example 3: Anthropic (Claude API)

```bash
op item create \
  --category=login \
  --title="Anthropic" \
  --vault="AI DEV" \
  password="sk-ant-abc123..." \
  url="https://console.anthropic.com"
```

**1Password Reference:**
```bash
op://AI DEV/Anthropic/password
```

**In .envrc:**
```bash
export ANTHROPIC_API_KEY="$(op read 'op://AI DEV/Anthropic/password')"
```

---

## 🤖 For AI Agents

### Standard Instructions for Claude Code / Secret Agents

When an agent needs to create a new credential in 1Password:

1. **Use this template:**
   ```bash
   op item create \
     --category=login \
     --title="[Service Name]" \
     --vault="[Vault Name]" \
     password="[THE_CREDENTIAL]" \
     username="[optional_email]" \
     url="[optional_service_url]"
   ```

2. **Always use `password` field** for the credential

3. **Update .envrc with:**
   ```bash
   export [SERVICE]_API_KEY="$(op read 'op://[Vault]/[Service]/password')"
   ```

4. **Service name should be clean and simple:**
   - ✅ Good: `Jina.ai`, `Notion`, `GitHub`
   - ❌ Bad: `JINA.AI API key`, `notion-token`, `gh_api`

---

## 🔄 Migration Guide

### Migrating Existing Non-Standard Items

If you have existing items with custom fields (like `credential`, `TOKEN`, etc.):

#### Option 1: Edit Existing Item
```bash
# Move credential from custom field to password field
op item edit "[Item Name]" \
  --vault="AI DEV" \
  password="[value_from_custom_field]"

# Remove custom field if needed
# (do this via 1Password app GUI)
```

#### Option 2: Create New Standard Item
```bash
# Get value from old item
OLD_VALUE=$(op read "op://AI DEV/OLD ITEM NAME/custom_field")

# Create new standard item
op item create \
  --category=login \
  --title="Service Name" \
  --vault="AI DEV" \
  password="$OLD_VALUE"

# Delete old item (after verifying new one works)
op item delete "OLD ITEM NAME" --vault="AI DEV"
```

### Example: Migrating Current Jina Item

**Current (non-standard):**
- Item: `JINA.AI API key`
- Field: `credential`
- Reference: `op://AI DEV/JINA.AI API key/credential`

**Standard (recommended):**
```bash
# Get current value
JINA_KEY=$(op read "op://AI DEV/JINA.AI API key/credential")

# Create new standard item
op item create \
  --category=login \
  --title="Jina.ai" \
  --vault="AI DEV" \
  password="$JINA_KEY" \
  username="bookslookfor@gmail.com" \
  url="https://jina.ai"

# Update .envrc
# Change: op://AI DEV/JINA.AI API key/credential
# To:     op://AI DEV/Jina.ai/password

# Delete old item after verification
op item delete "JINA.AI API key" --vault="AI DEV"
```

---

## 📝 .envrc Template

Using the standard, your `.envrc` becomes predictable:

```bash
VAULT_NAME="AI DEV"

if command -v op >/dev/null 2>&1 && op vault list >/dev/null 2>&1; then
  # All credentials use the same pattern: op://VAULT/ServiceName/password

  export JINA_API_KEY="$(op read "op://${VAULT_NAME}/Jina.ai/password" 2>/dev/null || echo "")"
  export NOTION_API_TOKEN="$(op read "op://${VAULT_NAME}/Notion/password" 2>/dev/null || echo "")"
  export ANTHROPIC_API_KEY="$(op read "op://${VAULT_NAME}/Anthropic/password" 2>/dev/null || echo "")"
  export GITHUB_TOKEN="$(op read "op://${VAULT_NAME}/GitHub/password" 2>/dev/null || echo "")"
  export OPENAI_API_KEY="$(op read "op://${VAULT_NAME}/OpenAI/password" 2>/dev/null || echo "")"

  # Simple, clean, consistent!
fi
```

---

## 🎨 Multi-Environment Support

### Pattern for Dev/Staging/Prod

**Option 1: Separate Vaults**
```bash
# Development vault
op://AI DEV/Jina.ai/password

# Production vault
op://AI PROD/Jina.ai/password
```

**Option 2: Item Name Suffixes**
```bash
# Same vault, different items
op://AI DEV/Jina.ai Dev/password
op://AI DEV/Jina.ai Prod/password
```

**Recommended:** Option 1 (separate vaults) for better security isolation

---

## 🔐 Security Best Practices

### DO ✅

1. **Use `password` field** for all credentials
2. **Keep service names clean** and recognizable
3. **Add `username` field** with service email when applicable
4. **Add `url` field** for easy access to service dashboards
5. **Use vault sharing** for team credentials
6. **Rotate credentials** via 1Password (auto-propagates to all environments)
7. **Document in notes** what the credential is used for

### DON'T ❌

1. **Don't create custom fields** unless absolutely required by the service
2. **Don't use inconsistent capitalization** (Jina.ai ✅, JINA.AI ❌)
3. **Don't store credentials in files** when you can use 1Password
4. **Don't share vaults** with external parties without review
5. **Don't use same key** across dev/staging/prod
6. **Don't skip 2FA** on your 1Password account

---

## 🚀 Quick Reference

### Creating New Credential

```bash
# 1. Create item in 1Password
op item create \
  --category=login \
  --title="ServiceName" \
  --vault="AI DEV" \
  password="api_key_value_here"

# 2. Add to .envrc
export SERVICE_API_KEY="$(op read 'op://AI DEV/ServiceName/password')"

# 3. Add to .mcp.json (if MCP server)
{
  "mcpServers": {
    "service-mcp": {
      "env": {
        "SERVICE_API_KEY": "${SERVICE_API_KEY}"
      }
    }
  }
}

# 4. Test
direnv allow
echo $SERVICE_API_KEY
```

### Agent Automation Template

For secret-xpert-light or other agents:

```markdown
When user requests: "Add [Service] credentials"

1. Ask for API key value
2. Create standard item:
   - Title: [Service]
   - Vault: AI DEV (or user-specified)
   - Field: password (always!)
3. Update .envrc with: op://AI DEV/[Service]/password
4. Update .mcp.json if it's an MCP server
5. Verify with: direnv allow && echo $VAR_NAME
```

---

## 📚 Related Documentation

- [1PASSWORD-INTEGRATION.md](./1PASSWORD-INTEGRATION.md) - Full integration guide
- [SETUP-LOCAL.md](./SETUP-LOCAL.md) - Local development setup
- [VAULT_SETUP.md](SECURITY/VAULT_SETUP.md) - Vault creation and initial setup
- [.claude/agents/secret-xpert-light.md](../.claude/agents/secret-xpert-light.md) - Secret management agent

---

## 🔄 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-11-15 | Initial standard definition |

---

## ❓ Questions?

Open an issue on [GitHub](https://github.com/alchimie-di-circe/ALEX-STACK_v0/issues) with label `documentation`
