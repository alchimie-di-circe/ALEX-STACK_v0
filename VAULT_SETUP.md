# Vault Setup Guide - AI DEV

Guida rapida per creare gli item necessari nel tuo vault 1Password **"AI DEV"** per ALEX-STACK.

## 📋 Item da Creare

### Item Richiesti (MCP Servers)

Questi sono gli item **necessari** per far funzionare i server MCP di Claude Code:

#### 1. Jina.ai (REQUIRED)
```
Nome item: Jina.ai
Categoria: Login
Vault: AI DEV

Campi:
├─ api_key: [la tua Jina API key]
└─ notes: "MCP Server per web research e content extraction"

Dove ottenere la key:
→ https://jina.ai/
→ Dashboard → API Keys → Create Key
```

#### 2. Notion MCP Suekou (REQUIRED)
```
Nome item: Notion MCP Suekou
Categoria: Login
Vault: AI DEV

Campi:
├─ token: [il tuo Notion Integration Token]
└─ notes: "MCP Server per Notion workspace integration"

Dove ottenere il token:
→ https://www.notion.so/my-integrations
→ Create New Integration → Copy Internal Integration Token
```

### Item Opzionali (Servizi Aggiuntivi)

Questi item sono **opzionali** ma utili per funzionalità avanzate:

#### 3. Anthropic (Optional)
```
Nome item: Anthropic
Categoria: Login
Vault: AI DEV

Campi:
├─ api_key: [la tua Anthropic API key]
└─ notes: "Claude API per uso diretto (non tramite Claude Code)"

Dove ottenere la key:
→ https://console.anthropic.com/
→ API Keys → Create Key
```

#### 4. GitHub (Optional)
```
Nome item: GitHub
Categoria: Login
Vault: AI DEV

Campi:
├─ token: [il tuo GitHub Personal Access Token]
└─ notes: "GitHub CLI e API access"

Dove ottenere il token:
→ https://github.com/settings/tokens
→ Generate new token (classic)
→ Scopes: repo, workflow
```

#### 5. OpenAI (Optional)
```
Nome item: OpenAI
Categoria: Login
Vault: AI DEV

Campi:
├─ api_key: [la tua OpenAI API key]
└─ notes: "OpenAI API per uso alongside Claude"

Dove ottenere la key:
→ https://platform.openai.com/api-keys
→ Create new secret key
```

## 🚀 Creazione Item

### Metodo 1: Via 1Password App (Più Facile)

1. Apri l'app 1Password
2. Seleziona il vault **"AI DEV"**
3. Clicca **"+"** → New Item → **Login**
4. Compila i campi:
   - **Title**: Nome esatto dell'item (es. "Jina.ai")
   - **Add custom field** → Field name: nome campo (es. "api_key")
   - **Value**: Incolla la tua API key
   - **Notes**: Aggiungi descrizione (opzionale)
5. Salva

### Metodo 2: Via 1Password CLI (Più Veloce)

```bash
# Autentica 1Password CLI (se non già fatto)
op signin

# Crea item Jina.ai
op item create \
  --category=login \
  --title="Jina.ai" \
  --vault="AI DEV" \
  api_key="jina_INSERISCI_QUI_LA_TUA_KEY"

# Crea item Notion MCP Suekou
op item create \
  --category=login \
  --title="Notion MCP Suekou" \
  --vault="AI DEV" \
  token="secret_INSERISCI_QUI_IL_TUO_TOKEN"

# Opzionali:

# Anthropic
op item create \
  --category=login \
  --title="Anthropic" \
  --vault="AI DEV" \
  api_key="sk-ant-INSERISCI_QUI_LA_TUA_KEY"

# GitHub
op item create \
  --category=login \
  --title="GitHub" \
  --vault="AI DEV" \
  token="ghp_INSERISCI_QUI_IL_TUO_TOKEN"

# OpenAI
op item create \
  --category=login \
  --title="OpenAI" \
  --vault="AI DEV" \
  api_key="sk-INSERISCI_QUI_LA_TUA_KEY"
```

## ✅ Verifica Setup

Dopo aver creato gli item, verifica che siano accessibili:

```bash
# Verifica che il vault esista
op vault list | grep "AI DEV"

# Lista tutti gli item nel vault AI DEV
op item list --vault "AI DEV"

# Testa la lettura di un item specifico
op item get "Jina.ai" --vault "AI DEV"

# Testa la lettura di un campo specifico
op read "op://AI DEV/Jina.ai/api_key"
# Dovrebbe stampare la tua API key!

# Testa Notion
op read "op://AI DEV/Notion MCP Suekou/token"
```

Se tutti i comandi sopra funzionano, sei pronto! ✅

## 🔧 Configurazione ALEX-STACK

Una volta creati gli item nel vault **"AI DEV"**, il file `.envrc` del repo è già configurato per usarli:

```bash
# Nel repo ALEX-STACK_v0
cd /path/to/ALEX-STACK_v0

# Permetti a direnv di caricare le variabili
direnv allow

# Verifica che le credenziali siano caricate
echo $JINA_API_KEY
echo $NOTION_API_TOKEN

# Se vedi le tue API keys, funziona! 🎉
```

## 🔐 Struttura Vault Raccomandata

Per mantenere il vault **"AI DEV"** organizzato:

```
Vault: AI DEV
├─── MCP Servers (Claude Code)
│    ├── Jina.ai
│    └── Notion MCP Suekou
│
├─── AI Services
│    ├── Anthropic
│    ├── OpenAI
│    └── [altri AI services]
│
├─── Development Tools
│    ├── GitHub
│    └── [altri dev tools]
│
└─── [altre categorie]
```

**Tip**: Puoi aggiungere tag agli item per raggrupparli:
- Tag "claude-code" per MCP servers
- Tag "required" per item obbligatori
- Tag "optional" per servizi aggiuntivi

## 📝 Nomi Item - IMPORTANTE!

I nomi degli item devono corrispondere **ESATTAMENTE** a quelli nel file `.envrc`:

| Item in 1Password | Riferimento in .envrc |
|-------------------|----------------------|
| `Jina.ai` | `op://AI DEV/Jina.ai/api_key` |
| `Notion MCP Suekou` | `op://AI DEV/Notion MCP Suekou/token` |
| `Anthropic` | `op://AI DEV/Anthropic/api_key` |
| `GitHub` | `op://AI DEV/GitHub/token` |
| `OpenAI` | `op://AI DEV/OpenAI/api_key` |

⚠️ **Attenzione**: Spazi e maiuscole/minuscole contano!

## 🔄 Aggiornare le Credenziali

Quando ruoti una API key:

### Via 1Password App:
1. Apri l'item
2. Modifica il campo (es. `api_key`)
3. Salva

### Via CLI:
```bash
op item edit "Jina.ai" api_key="nuova_key_qui" --vault "AI DEV"
```

Poi ricarica direnv:
```bash
direnv allow
echo $JINA_API_KEY  # Dovrebbe mostrare la nuova key!
```

## 🆘 Troubleshooting

### Problema: "Item not found"
```bash
# Verifica il nome esatto dell'item
op item list --vault "AI DEV"

# Il nome deve corrispondere ESATTAMENTE
# ❌ "jina.ai" → Non funziona
# ✅ "Jina.ai" → Funziona
```

### Problema: "Field not found"
```bash
# Verifica i campi dell'item
op item get "Jina.ai" --vault "AI DEV"

# Il campo deve essere esattamente:
# ✅ "api_key" (per Jina, Anthropic, OpenAI)
# ✅ "token" (per Notion, GitHub)
```

### Problema: "Vault not found"
```bash
# Lista tutti i vault
op vault list

# Il vault deve essere esattamente "AI DEV"
# Se il nome è diverso, aggiorna VAULT_NAME in .envrc
```

## 📚 Risorse

- [1Password CLI Documentation](https://developer.1password.com/docs/cli/)
- [Jina AI Documentation](https://jina.ai/docs/)
- [Notion API Documentation](https://developers.notion.com/)
- [ALEX-STACK 1Password Integration Guide](./docs/1PASSWORD-INTEGRATION.md)

---

**Hai creato gli item?** Torna al README principale e segui la guida di setup!
