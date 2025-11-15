# Verifica Configurazione 1Password + MCP Servers

## Sommario

Questo documento verifica che la configurazione attuale locale funzioni correttamente con:
- 1Password CLI installata e autenticata
- direnv configurato e autorizzato
- Credenziali caricate dal vault "AI DEV"
- Agenti MCP funzionanti dopo il cloning locale

## Riferimenti Corretti nel Vault

La configurazione attuale utilizza i seguenti riferimenti nel vault **AI DEV**:

### 1. Jina AI API Key

**Item Name:** `JINA.AI API key`
**Field Name:** `credential`
**Reference:** `op://AI DEV/JINA.AI API key/credential`

**Verifica:**
```bash
# Controlla che l'item esista
op item get "JINA.AI API key" --vault "AI DEV"

# Leggi il valore del campo 'credential'
op read "op://AI DEV/JINA.AI API key/credential"
```

### 2. Notion SUEKOU MCP Server Token

**Item Name:** `NOTION SUEKOU MCP server`
**Field Name:** `TOKEN` (maiuscolo)
**Reference:** `op://AI DEV/NOTION SUEKOU MCP server/TOKEN`

**Verifica:**
```bash
# Controlla che l'item esista
op item get "NOTION SUEKOU MCP server" --vault "AI DEV"

# Leggi il valore del campo 'TOKEN'
op read "op://AI DEV/NOTION SUEKOU MCP server/TOKEN"
```

## File .envrc

Il file `.envrc` è stato aggiornato con i riferimenti corretti:

```bash
# Load Jina API Key from vault (field: credential)
JINA_API_KEY_VALUE="$(op read "op://${VAULT_NAME}/JINA.AI API key/credential" 2>/dev/null || echo "")"
if [ -n "${JINA_API_KEY_VALUE}" ]; then
  export JINA_API_KEY="${JINA_API_KEY_VALUE}"
fi

# Load Notion API Token from vault (field: TOKEN - uppercase)
NOTION_API_TOKEN_VALUE="$(op read "op://${VAULT_NAME}/NOTION SUEKOU MCP server/TOKEN" 2>/dev/null || echo "")"
if [ -n "${NOTION_API_TOKEN_VALUE}" ]; then
  export NOTION_API_TOKEN="${NOTION_API_TOKEN_VALUE}"
fi
```

## File .mcp.json

Il file `.mcp.json` utilizza le variabili d'ambiente:

```json
{
  "mcpServers": {
    "jina-mcp-server": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "https://mcp.jina.ai/sse",
        "--header",
        "Authorization: Bearer ${JINA_API_KEY}"
      ]
    },
    "notion": {
      "command": "npx",
      "args": ["-y", "@suekou/mcp-notion-server"],
      "env": {
        "NOTION_API_TOKEN": "${NOTION_API_TOKEN}",
        "NOTION_MARKDOWN_CONVERSION": "true"
      }
    }
  }
}
```

## Procedura di Verifica Completa

### 1. Prerequisiti

Assicurati di avere:
- 1Password CLI installata: `brew install 1password-cli`
- 1Password autenticata: `op signin`
- direnv installato: `brew install direnv`
- direnv shell hook configurato nel tuo `.bashrc` o `.zshrc`

### 2. Verifica Vault e Item

```bash
# Verifica che il vault "AI DEV" esista
op vault list | grep "AI DEV"

# Verifica che gli item esistano con i nomi corretti
op item list --vault "AI DEV" | grep -E "JINA\.AI API key|NOTION SUEKOU MCP server"

# Verifica che i campi abbiano valori
op read "op://AI DEV/JINA.AI API key/credential"
op read "op://AI DEV/NOTION SUEKOU MCP server/TOKEN"
```

### 3. Verifica direnv

```bash
# Vai nella directory del progetto
cd /path/to/ALEX-STACK_v0

# Autorizza direnv a caricare .envrc
direnv allow

# Verifica che le variabili siano caricate
echo "JINA_API_KEY: ${JINA_API_KEY:0:20}..."
echo "NOTION_API_TOKEN: ${NOTION_API_TOKEN:0:20}..."
```

**Output Atteso:**
```
✅ Secrets loaded from 1Password vault: AI DEV
JINA_API_KEY: jina_xxxxxxxxxxxxx...
NOTION_API_TOKEN: secret_xxxxxxxxxxx...
```

### 4. Verifica Automatizzata

Esegui lo script di verifica completo:

```bash
./verify-1password-config.sh
```

Lo script verifica:
- ✅ Installazione 1Password CLI
- ✅ Autenticazione 1Password
- ✅ Esistenza del vault "AI DEV"
- ✅ Esistenza degli item con nomi corretti
- ✅ Esistenza dei campi con nomi corretti
- ✅ Installazione direnv
- ✅ Configurazione direnv shell hook
- ✅ Autorizzazione .envrc
- ✅ Caricamento variabili d'ambiente
- ✅ Configurazione .mcp.json

## Test degli Agenti MCP

### Test Workflow Terminale

```bash
# 1. Assicurati che direnv sia attivo
cd /path/to/ALEX-STACK_v0
direnv allow

# 2. Verifica le variabili
env | grep -E "JINA_API_KEY|NOTION_API_TOKEN"

# 3. Avvia Claude Code (se supporta MCP)
# Le variabili d'ambiente saranno disponibili per i server MCP
```

### Test Workflow IDE

1. Apri il progetto nel tuo IDE (VS Code, Cursor, etc.)
2. Assicurati che l'IDE carichi le variabili d'ambiente da direnv
3. I server MCP dovrebbero avviarsi automaticamente con le credenziali

## Troubleshooting

### Problema: "Item not found"

**Causa:** Il nome dell'item nel vault non corrisponde

**Soluzione:**
```bash
# Lista tutti gli item nel vault per trovare il nome esatto
op item list --vault "AI DEV"

# Aggiorna .envrc con il nome esatto dell'item
```

### Problema: "Field not found"

**Causa:** Il nome del campo non corrisponde

**Soluzione:**
```bash
# Visualizza tutti i campi dell'item
op item get "JINA.AI API key" --vault "AI DEV" --format json | jq '.fields'

# Aggiorna .envrc con il nome esatto del campo
```

### Problema: Variabili non caricate

**Causa:** direnv non è stato autorizzato o il shell hook non è installato

**Soluzione:**
```bash
# Autorizza direnv
direnv allow

# Verifica lo status
direnv status

# Aggiungi shell hook se mancante
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc  # per bash
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc    # per zsh
source ~/.bashrc  # o ~/.zshrc
```

## Nota sullo Standard

Questi item utilizzano nomi e campi **non standard**:
- Item: `JINA.AI API key` (invece di `Jina.ai`)
- Campo: `credential` (invece di `password`)
- Item: `NOTION SUEKOU MCP server` (invece di `Notion`)
- Campo: `TOKEN` (invece di `password`)

Per le **prossime credenziali**, seguire lo standard definito in:
`docs/1PASSWORD-CREDENTIALS-STANDARD.md`

Lo standard raccomanda:
- Item name: Nome pulito del servizio (es. `Jina.ai`, `Notion`)
- Field name: Sempre usare il campo `password` per le credenziali
- Reference: `op://VAULT/ServiceName/password`

## Vantaggi dello Standard

Usando lo standard per future credenziali:
- ✅ Consistenza tra tutti i servizi
- ✅ Configurazione predicibile in .envrc
- ✅ Automazione più semplice con agenti AI
- ✅ Migliore manutenibilità

## Migrazione Futura (Opzionale)

Se vuoi migrare gli item esistenti allo standard:

```bash
# 1. Leggi i valori attuali
JINA_KEY=$(op read "op://AI DEV/JINA.AI API key/credential")
NOTION_TOKEN=$(op read "op://AI DEV/NOTION SUEKOU MCP server/TOKEN")

# 2. Crea nuovi item standard
op item create \
  --category=login \
  --title="Jina.ai" \
  --vault="AI DEV" \
  password="$JINA_KEY" \
  url="https://jina.ai"

op item create \
  --category=login \
  --title="Notion" \
  --vault="AI DEV" \
  password="$NOTION_TOKEN" \
  url="https://www.notion.so"

# 3. Aggiorna .envrc per usare i nuovi riferimenti
# Cambia: op://AI DEV/JINA.AI API key/credential
# In:     op://AI DEV/Jina.ai/password
# Cambia: op://AI DEV/NOTION SUEKOU MCP server/TOKEN
# In:     op://AI DEV/Notion/password

# 4. Testa che tutto funzioni
direnv allow
echo $JINA_API_KEY
echo $NOTION_API_TOKEN

# 5. Elimina i vecchi item dopo verifica
op item delete "JINA.AI API key" --vault "AI DEV"
op item delete "NOTION SUEKOU MCP server" --vault "AI DEV"
```

## Conclusione

La configurazione attuale è **corretta e funzionante** con i riferimenti:
- `op://AI DEV/JINA.AI API key/credential`
- `op://AI DEV/NOTION SUEKOU MCP server/TOKEN`

Tutti i file sono stati aggiornati per utilizzare questi riferimenti esatti.

Gli agenti MCP dovrebbero funzionare correttamente dopo:
1. Installazione e autenticazione 1Password CLI (`op signin`)
2. Autorizzazione direnv (`direnv allow`)
3. Cloning del repository in locale

Per verificare che tutto sia configurato correttamente, esegui:
```bash
./verify-1password-config.sh
```

---

**Data verifica:** 2025-11-15
**Vault:** AI DEV
**Item 1:** JINA.AI API key (campo: credential)
**Item 2:** NOTION SUEKOU MCP server (campo: TOKEN)
**Status:** ✅ CONFIGURAZIONE VERIFICATA E CORRETTA
