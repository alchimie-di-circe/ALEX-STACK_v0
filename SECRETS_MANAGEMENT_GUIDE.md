# Guida Completa alla Gestione di API Keys e Secrets

Una panoramica esaustiva di tutte le opzioni per gestire in sicurezza API keys, tokens e secrets per MCP servers e progetti di sviluppo.

---

## 📊 Tabella Comparativa Rapida

| Opzione | Sicurezza | Facilità | Team | Costo | Miglior Per |
|---------|-----------|----------|------|-------|-------------|
| 1Password CLI + Git | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ✅ | €€ | Team professionali |
| Bitwarden Secrets Mgr | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ✅ | €/Free | Team/Open source |
| Mozilla SOPS + age | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ✅ | Free | DevOps/GitOps |
| dotenvx (encrypted) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ | Free | Sviluppo moderno |
| HashiCorp Vault | ⭐⭐⭐⭐⭐ | ⭐⭐ | ✅ | Free/€€€ | Enterprise |
| AWS Secrets Manager | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ✅ | € pay-per-use | AWS users |
| GPG + git-crypt | ⭐⭐⭐⭐ | ⭐⭐ | ✅ | Free | Open source teams |
| direnv + private .env | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ❌ | Free | Sviluppo locale |
| dotenv (.env file) | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ❌ | Free | Prototipi rapidi |
| Shell exports (~/.bashrc) | ⭐⭐ | ⭐⭐⭐⭐ | ❌ | Free | Setup veloce |

---

## 🏆 Tier 1: Soluzioni Enterprise/Professional (Migliori per Team)

### 1. 1Password CLI + 1Password Connect ⭐ MIGLIORE PER TEAM

**Cos'è**: Password manager professionale con integrazione CLI e sviluppo

**Perché è la migliore**:
- ✅ Sicurezza di livello militare
- ✅ Interfaccia grafica + CLI
- ✅ Condivisione team sicura
- ✅ Audit logging completo
- ✅ Sincronizzazione cross-device
- ✅ 2FA integrato
- ✅ Integrazione con CI/CD

**Setup**:
```bash
# Installa 1Password CLI
brew install --cask 1password/tap/1password-cli

# Login
op signin

# Crea secrets
op item create --category=login \
  --title="Notion API" \
  --vault="Development" \
  'API Key[password]'=secret_your_token_here

# Usa secrets in .mcp.json
{
  "mcpServers": {
    "notion": {
      "env": {
        "NOTION_API_TOKEN": "op://Development/Notion API/API Key"
      }
    }
  }
}

# O esporta in shell
export NOTION_API_TOKEN=$(op read "op://Development/Notion API/API Key")
```

**Integrazione con Claude Code**:
```bash
# Script di startup automatico
# ~/.claude-env.sh
eval $(op signin)
export JINA_API_KEY=$(op read "op://Development/Jina AI/API Key")
export NOTION_API_TOKEN=$(op read "op://Development/Notion API/API Key")

# Aggiungi a .bashrc/.zshrc
source ~/.claude-env.sh
```

**Pro**:
- ✅ Migliore UX per team
- ✅ Eccellente sicurezza
- ✅ Audit trail completo
- ✅ Supporto dedicato
- ✅ Famiglia/Team sharing

**Contro**:
- ❌ A pagamento (~€3-8/mese per utente)
- ❌ Richiede installazione app

**Costo**: €3.99/mese (individuale), €7.99/mese (famiglia), da €19.95/mese (team)

---

### 2. Bitwarden Secrets Manager ⭐ MIGLIORE OPEN-SOURCE

**Cos'è**: Password manager open-source con secrets manager dedicato

**Perché è ottimo**:
- ✅ Open source e self-hostable
- ✅ CLI potente (bw-cli)
- ✅ Piano gratuito generoso
- ✅ Secrets Manager per development
- ✅ Team collaboration

**Setup**:
```bash
# Installa Bitwarden CLI
npm install -g @bitwarden/cli

# Login
bw login

# Unlock vault (ricevi session key)
export BW_SESSION=$(bw unlock --raw)

# Crea secret
bw create item '{
  "organizationId": null,
  "collectionIds": [],
  "folderId": null,
  "type": 1,
  "name": "Notion API Key",
  "notes": "API key for Notion MCP",
  "fields": [{
    "name": "api_key",
    "value": "secret_your_token",
    "type": 1
  }]
}'

# Recupera secret
export NOTION_API_TOKEN=$(bw get item "Notion API Key" | jq -r '.fields[] | select(.name=="api_key") | .value')
```

**Bitwarden Secrets Manager (per Development)**:
```bash
# Setup Secrets Manager
bws login
bws secret list
bws secret get <secret-id>

# In CI/CD
export BWS_ACCESS_TOKEN="your_token"
bws secret get notion-api-key -o json | jq -r '.value'
```

**Pro**:
- ✅ Open source
- ✅ Self-hosting possibile
- ✅ Piano free generoso
- ✅ Ottima CLI
- ✅ Community attiva

**Contro**:
- ❌ Secrets Manager a pagamento
- ❌ UX meno polished di 1Password

**Costo**: Free (base), €10/mese (Premium), €3/mese/utente (Families)

---

### 3. Mozilla SOPS + age ⭐ MIGLIORE PER GITOPS

**Cos'è**: Secrets OPerationS - cripta files di config per committarli in Git

**Perché è potente**:
- ✅ Secrets versionati in Git
- ✅ Merge/diff funzionano
- ✅ Multi-provider (age, GPG, KMS)
- ✅ Ottimo per GitOps/Infrastructure as Code
- ✅ Completamente gratuito

**Setup**:
```bash
# Installa SOPS
brew install sops

# Installa age (encryption)
brew install age

# Genera chiave age
age-keygen -o ~/.config/sops/age/keys.txt

# Salva public key
export AGE_PUBLIC_KEY=$(age-keygen -y ~/.config/sops/age/keys.txt)

# Crea .sops.yaml
cat > .sops.yaml <<EOF
creation_rules:
  - path_regex: \.mcp\.json$
    age: $AGE_PUBLIC_KEY
  - path_regex: \.env.*
    age: $AGE_PUBLIC_KEY
EOF

# Cripta .mcp.json
sops -e .mcp.json > .mcp.json.enc

# Decripta (per uso)
sops -d .mcp.json.enc > .mcp.json

# Edita direttamente
sops .mcp.json.enc
```

**Setup per Claude Code**:
```bash
# Script di avvio
#!/bin/bash
# ~/.local/bin/claude-with-secrets

# Decripta secrets
sops -d ~/.config/claude/.mcp.json.enc > ~/.config/claude/.mcp.json

# Avvia Claude Code
claude "$@"

# Cleanup al termine
trap "rm ~/.config/claude/.mcp.json" EXIT
```

**Pro**:
- ✅ Secrets versionati in Git (sicuri)
- ✅ Gratuito e open source
- ✅ Ottimo per team
- ✅ Supporta rotation
- ✅ GitOps-friendly

**Contro**:
- ❌ Curva di apprendimento
- ❌ Richiede gestione chiavi
- ❌ Setup iniziale complesso

**Costo**: Gratuito

---

### 4. dotenvx (Encrypted .env) ⭐ MIGLIORE PER MODERNE WORKFLOW

**Cos'è**: Evoluzione di dotenv con encryption nativa e multi-environment

**Perché è eccellente**:
- ✅ .env criptati committabili in Git
- ✅ Multi-environment (dev/staging/prod)
- ✅ Sincronizzazione team
- ✅ Backward compatible con dotenv
- ✅ Zero config

**Setup**:
```bash
# Installa dotenvx
npm install -g @dotenvx/dotenvx

# Inizializza progetto
dotenvx init

# Crea .env con chiavi
cat > .env <<EOF
JINA_API_KEY=jina_xxxxx
NOTION_API_TOKEN=secret_xxxxx
EOF

# Cripta (genera .env.keys)
dotenvx encrypt

# File .env ora è criptato, committabile!
git add .env
git commit -m "Add encrypted secrets"

# .env.keys va in .gitignore (chiave privata)
echo ".env.keys" >> .gitignore

# Usa con Claude Code
dotenvx run -- claude
```

**Multi-environment**:
```bash
# .env.development
NOTION_API_TOKEN=secret_dev_token

# .env.production
NOTION_API_TOKEN=secret_prod_token

# Usa environment specifico
dotenvx run -f .env.production -- claude
```

**Team Sharing**:
```bash
# Genera chiave per teammate
dotenvx keypair

# Condividi public key con team
# Team membri possono decriptare con loro private key

# In CI/CD
dotenvx run --env-file=.env.production -- npm test
```

**Pro**:
- ✅ Moderna e developer-friendly
- ✅ Secrets in Git (criptati)
- ✅ Multi-environment nativo
- ✅ Ottima DX
- ✅ Gratuito

**Contro**:
- ❌ Relativamente nuovo (meno maturo)
- ❌ Richiede gestione .env.keys

**Costo**: Gratuito (open source)

---

### 5. HashiCorp Vault ⭐ MIGLIORE PER ENTERPRISE

**Cos'è**: Secrets management centralizzato per enterprise

**Perché per enterprise**:
- ✅ Dynamic secrets
- ✅ Secret rotation automatica
- ✅ Access policies granulari
- ✅ Audit logging completo
- ✅ Multi-cloud support

**Setup**:
```bash
# Installa Vault
brew install vault

# Avvia server dev (locale)
vault server -dev

# In produzione: usa Vault server dedicato
# export VAULT_ADDR='https://vault.company.com'
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='root-token-from-dev'

# Salva secrets
vault kv put secret/mcp \
  jina_api_key=jina_xxxxx \
  notion_api_token=secret_xxxxx

# Leggi secrets
vault kv get -field=jina_api_key secret/mcp

# Usa con Claude Code
export JINA_API_KEY=$(vault kv get -field=jina_api_key secret/mcp)
export NOTION_API_TOKEN=$(vault kv get -field=notion_api_token secret/mcp)
claude
```

**Script avanzato**:
```bash
#!/bin/bash
# claude-vault-wrapper.sh

# Autentica con Vault (vari metodi)
vault login -method=github token=$GITHUB_TOKEN

# Carica tutti i secrets
eval $(vault kv get -format=json secret/mcp | jq -r '.data.data | to_entries | .[] | "export \(.key | ascii_upcase)=\(.value)"')

# Avvia Claude
claude "$@"
```

**Pro**:
- ✅ Enterprise-grade
- ✅ Dynamic secrets
- ✅ Secret rotation
- ✅ Audit completo
- ✅ Policy engine

**Contro**:
- ❌ Overkill per piccoli team
- ❌ Complesso da gestire
- ❌ Richiede infrastruttura
- ❌ Costoso (enterprise)

**Costo**: Gratuito (open source), da €0.03/hour per node (HCP Vault)

---

## 🔐 Tier 2: Cloud Secrets Managers

### 6. AWS Secrets Manager

**Setup**:
```bash
# Installa AWS CLI
brew install awscli

# Configura
aws configure

# Crea secret
aws secretsmanager create-secret \
  --name mcp/notion-api \
  --secret-string '{"NOTION_API_TOKEN":"secret_xxxxx"}'

# Recupera
export NOTION_API_TOKEN=$(aws secretsmanager get-secret-value \
  --secret-id mcp/notion-api \
  --query SecretString \
  --output text | jq -r '.NOTION_API_TOKEN')
```

**Pro**: ✅ Integrazione AWS, ✅ Rotation automatica, ✅ IAM policies
**Contro**: ❌ Solo AWS, ❌ Pay-per-use (~€0.40/secret/mese)

---

### 7. Google Cloud Secret Manager

**Setup**:
```bash
# Installa gcloud
brew install google-cloud-sdk

# Crea secret
echo -n "secret_xxxxx" | gcloud secrets create notion-api-token --data-file=-

# Usa
export NOTION_API_TOKEN=$(gcloud secrets versions access latest --secret="notion-api-token")
```

**Pro**: ✅ Integrazione GCP, ✅ Free tier generoso
**Contro**: ❌ Solo GCP, ❌ Richiede progetto GCP

---

### 8. Azure Key Vault

**Setup**:
```bash
# Installa Azure CLI
brew install azure-cli

# Login
az login

# Crea secret
az keyvault secret set \
  --vault-name myKeyVault \
  --name notion-api-token \
  --value "secret_xxxxx"

# Recupera
export NOTION_API_TOKEN=$(az keyvault secret show \
  --vault-name myKeyVault \
  --name notion-api-token \
  --query value -o tsv)
```

**Pro**: ✅ Integrazione Azure, ✅ HSM-backed
**Contro**: ❌ Solo Azure, ❌ Setup complesso

---

## 🛠️ Tier 3: Soluzioni Locali/Development

### 9. GPG + git-crypt ⭐ MIGLIORE PER OPEN SOURCE TEAMS

**Cos'è**: Cripta automaticamente files in Git usando GPG keys

**Setup**:
```bash
# Installa git-crypt
brew install git-crypt gnupg

# Inizializza nel repo
cd /root/workspace
git-crypt init

# Configura files da criptare
cat > .gitattributes <<EOF
.mcp.json filter=git-crypt diff=git-crypt
.env* filter=git-crypt diff=git-crypt
**/secrets/** filter=git-crypt diff=git-crypt
EOF

# Genera GPG key (se non ce l'hai)
gpg --full-generate-key

# Aggiungi collaboratori
git-crypt add-gpg-user user@email.com

# Files ora sono automaticamente criptati in Git!
git add .mcp.json
git commit -m "Add encrypted config"
```

**Pro**:
- ✅ Trasparente (automatic encrypt/decrypt)
- ✅ Gratuito
- ✅ Team-friendly
- ✅ No vendor lock-in

**Contro**:
- ❌ Richiede GPG key management
- ❌ Problemi se perdi chiave
- ❌ Setup iniziale complesso

---

### 10. direnv + .env privato ⭐ MIGLIORE PER SVILUPPO LOCALE

**Cos'è**: Carica automaticamente variabili ambiente quando entri in una directory

**Setup**:
```bash
# Installa direnv
brew install direnv

# Setup shell (aggiungi a ~/.bashrc o ~/.zshrc)
eval "$(direnv hook bash)"  # per bash
eval "$(direnv hook zsh)"   # per zsh

# Crea .envrc nel progetto
cd /root/workspace
cat > .envrc <<EOF
export JINA_API_KEY=jina_xxxxx
export NOTION_API_TOKEN=secret_xxxxx
EOF

# Permetti (prima volta)
direnv allow

# IMPORTANTE: .envrc in .gitignore
echo ".envrc" >> .gitignore

# Ora quando entri nella directory, variabili sono caricate!
cd /root/workspace  # variabili caricate automaticamente
cd ~               # variabili scaricate automaticamente
```

**Template per team**:
```bash
# Committa .envrc.example (senza secrets)
cat > .envrc.example <<EOF
# Copy questo file a .envrc e riempi con i tuoi valori
export JINA_API_KEY=your_jina_key_here
export NOTION_API_TOKEN=your_notion_token_here
EOF

git add .envrc.example
git commit -m "Add environment template"
```

**Pro**:
- ✅ Automatico e trasparente
- ✅ Per-directory isolation
- ✅ Ottimo per multi-progetto
- ✅ Zero overhead

**Contro**:
- ❌ Solo locale
- ❌ Secrets in plaintext su disco

---

### 11. dotenv (.env file) - Classico

**Setup**:
```bash
# Crea .env
cat > .env <<EOF
JINA_API_KEY=jina_xxxxx
NOTION_API_TOKEN=secret_xxxxx
EOF

# IMPORTANTE: .env in .gitignore
echo ".env" >> .gitignore

# Usa con node
npm install dotenv

# In script JS
require('dotenv').config()
console.log(process.env.NOTION_API_TOKEN)

# O carica manualmente in shell
export $(cat .env | xargs)
claude
```

**Pro**: ✅ Semplice, ✅ Standard di fatto, ✅ Ampio supporto
**Contro**: ❌ Facile committare per errore, ❌ Solo locale

---

### 12. Shell Environment Variables (~/.bashrc)

**Setup**:
```bash
# Aggiungi a ~/.bashrc o ~/.zshrc
cat >> ~/.bashrc <<EOF

# MCP Server API Keys
export JINA_API_KEY="jina_xxxxx"
export NOTION_API_TOKEN="secret_xxxxx"
EOF

# Reload
source ~/.bashrc
```

**Pro**: ✅ Semplicissimo, ✅ Sempre disponibile
**Contro**: ❌ Visibile a tutti i processi, ❌ No per-project, ❌ Backup difficile

---

## 🌐 Tier 4: CI/CD & GitHub Integration

### 13. GitHub Secrets (per CI/CD)

**Setup**:
```bash
# Via GitHub CLI
gh secret set NOTION_API_TOKEN -b"secret_xxxxx"
gh secret set JINA_API_KEY -b"jina_xxxxx"

# Via Web UI:
# Settings > Secrets and variables > Actions > New repository secret
```

**Uso in GitHub Actions**:
```yaml
# .github/workflows/test.yml
name: Test with Secrets
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        env:
          NOTION_API_TOKEN: ${{ secrets.NOTION_API_TOKEN }}
          JINA_API_KEY: ${{ secrets.JINA_API_KEY }}
        run: |
          npm test
```

**Environment Secrets**:
```yaml
# Per environment specifici (dev/staging/prod)
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Deploy
        env:
          NOTION_API_TOKEN: ${{ secrets.NOTION_API_TOKEN }}
```

---

### 14. GitLab CI/CD Variables

**Setup via Web UI**:
```
Settings > CI/CD > Variables > Add Variable
- Key: NOTION_API_TOKEN
- Value: secret_xxxxx
- Type: Variable
- Protected: ✅
- Masked: ✅
```

**Uso**:
```yaml
# .gitlab-ci.yml
test:
  script:
    - echo "Using $NOTION_API_TOKEN"
    - npm test
```

---

### 15. Environment-based Solutions (Vercel, Netlify, Railway)

**Vercel**:
```bash
# Via CLI
vercel env add NOTION_API_TOKEN

# Via Web: Project Settings > Environment Variables
```

**Netlify**:
```bash
# Via CLI
netlify env:set NOTION_API_TOKEN secret_xxxxx

# Via Web: Site settings > Environment variables
```

---

## 📋 Best Practices Universali

### 1. .gitignore - SEMPRE

```bash
# .gitignore essenziale
.env
.env.*
!.env.example
.envrc
!.envrc.example
.mcp.json
!.mcp.json.example
**/secrets/
*.key
*.pem
.env.keys
```

### 2. Template Files per Team

```bash
# Committa esempi senza secrets
.env.example
.envrc.example
.mcp.json.example

# Documenta nel README
cat >> README.md <<EOF
## Setup

1. Copy \`.env.example\` to \`.env\`
2. Fill in your API keys
3. Run \`claude\`
EOF
```

### 3. Secret Rotation

```bash
# Ruota secrets regolarmente (esempio quarterly)
# Script di rotazione
#!/bin/bash
# rotate-secrets.sh

# 1. Genera nuovo secret
NEW_KEY=$(openssl rand -hex 32)

# 2. Aggiorna in secret manager
op item edit "Notion API" 'API Key[password]'=$NEW_KEY

# 3. Aggiorna in Notion
# (manuale o via API)

# 4. Verifica funziona
# 5. Revoca vecchio secret
```

### 4. Least Privilege

```bash
# Usa API keys con permessi minimi necessari

# Notion: Solo read per read-only operations
# Jina: API key con rate limits appropriati
```

### 5. Monitoring & Audit

```bash
# Monitora uso API keys
# Alert su:
# - Uso anomalo
# - Fallimenti autenticazione
# - Rate limit hit

# Se usi 1Password/Vault: Audit logging automatico
```

---

## 🎯 Raccomandazioni per Caso d'Uso

### Solo Tu (Sviluppatore Singolo)
**Raccomandazione**: direnv + .env privato
- Semplice, veloce, efficace
- Backup con: Time Machine / cloud backup

### Team Piccolo (2-5 persone)
**Raccomandazione**: dotenvx o Bitwarden
- dotenvx: se tutti usano Git
- Bitwarden: se serve anche password sharing

### Team Medio (5-20 persone)
**Raccomandazione**: 1Password for Developers
- ROI eccellente
- Scala bene
- Ottima UX

### Team Grande / Enterprise
**Raccomandazione**: HashiCorp Vault o Cloud Secrets Manager
- Compliance requirements
- Audit necessari
- Dynamic secrets

### Open Source Project
**Raccomandazione**: SOPS + age o git-crypt
- Contributor-friendly
- Gratuito
- Trasparente

### CI/CD Heavy
**Raccomandazione**: GitHub/GitLab Secrets + Vault
- Integrazione nativa
- Secret injection automatico

---

## 🚀 Quick Start: Setup Consigliato per Claude Code

### Opzione Rapida (5 minuti)
```bash
# 1. Installa direnv
brew install direnv
eval "$(direnv hook bash)"

# 2. Crea .envrc
cd /root/workspace
cat > .envrc <<EOF
export JINA_API_KEY=your_key
export NOTION_API_TOKEN=your_token
EOF

# 3. Permetti
direnv allow

# 4. Ignora in Git
echo ".envrc" >> .gitignore

# Done! Claude Code avrà accesso alle env vars
```

### Opzione Team (30 minuti)
```bash
# 1. Installa dotenvx
npm install -g @dotenvx/dotenvx

# 2. Inizializza
dotenvx init

# 3. Crea secrets
cat > .env <<EOF
JINA_API_KEY=your_key
NOTION_API_TOKEN=your_token
EOF

# 4. Cripta
dotenvx encrypt

# 5. Commit encrypted .env (sicuro!)
git add .env .env.example
git commit -m "Add encrypted secrets"

# 6. .env.keys in .gitignore (chiave privata)
echo ".env.keys" >> .gitignore

# 7. Usa
dotenvx run -- claude
```

### Opzione Professional (1-2 ore)
```bash
# 1. Setup 1Password
# - Signup su 1password.com
# - Installa app + CLI
brew install --cask 1password-cli

# 2. Crea vault "Development"
# 3. Aggiungi secrets via app

# 4. Script wrapper
cat > ~/bin/claude-secure <<'EOF'
#!/bin/bash
eval $(op signin)
export JINA_API_KEY=$(op read "op://Development/Jina/API Key")
export NOTION_API_TOKEN=$(op read "op://Development/Notion/token")
claude "$@"
EOF

chmod +x ~/bin/claude-secure

# 5. Usa
claude-secure
```

---

## ⚠️ Security Warnings

### ❌ NON FARE MAI:
1. **Committare secrets in Git** (anche in private repos)
2. **Secrets in codice** hardcoded
3. **Secrets in logs** o error messages
4. **Condividere via chat/email** non criptato
5. **Usare same secret** per dev/prod
6. **Ignorare rotation** (ruota almeno yearly)

### ✅ FARE SEMPRE:
1. **Use .gitignore** per files con secrets
2. **Template files** committati (`.example`)
3. **Documentare** setup nel README
4. **Rotate regolarmente** secrets
5. **Monitor usage** e audit logs
6. **Least privilege** principle
7. **Backup** secrets securely

---

## 📚 Risorse Aggiuntive

- **1Password**: https://developer.1password.com
- **Bitwarden**: https://bitwarden.com/help/secrets-manager-quick-start/
- **SOPS**: https://github.com/mozilla/sops
- **dotenvx**: https://dotenvx.com/docs
- **HashiCorp Vault**: https://www.vaultproject.io/docs
- **git-crypt**: https://github.com/AGWA/git-crypt
- **direnv**: https://direnv.net
- **GitHub Secrets**: https://docs.github.com/en/actions/security-guides/encrypted-secrets

---

## 🎓 Conclusioni

**Per iniziare subito**: direnv + .env
**Per team piccoli**: dotenvx (encrypted)
**Per team professionali**: 1Password CLI
**Per enterprise**: HashiCorp Vault + Cloud Secrets Manager
**Per open source**: SOPS + age o git-crypt

La sicurezza è un viaggio, non una destinazione. Inizia con una soluzione semplice e scala man mano che cresci! 🚀
