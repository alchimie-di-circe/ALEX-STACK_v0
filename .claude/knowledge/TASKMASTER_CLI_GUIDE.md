# TASKMASTER CLI - Guida Completa per Orchestrator Agent

## 📚 Indice
1. [Panoramica](#panoramica)
2. [Installazione](#installazione)
3. [Configurazione](#configurazione)
4. [Comandi Core](#comandi-core)
5. [Workflow di Planning](#workflow-di-planning)
6. [Esempi Pratici](#esempi-pratici)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

---

## Panoramica

**TASKMASTER CLI** (`@raja-rakoto/taskmaster-cli`) è uno strumento CLI interattivo progettato per semplificare la gestione di progetti complessi attraverso orchestrazione AI, planning automatico ed esecuzione dal terminale.

### Cosa lo rende perfetto per l'Orchestrator Agent

- **Task Decomposition Automatica**: Converte PRD/requirements in alberi di task strutturati
- **Dependency Management**: Traccia automaticamente le dipendenze tra task
- **AI-Powered Planning**: Genera task lists intelligenti da documentazione
- **Context Preservation**: Mantiene lo stato dei task nell'esecuzione
- **Multi-Model Support**: Supporta Anthropic (Claude), OpenAI, Google Gemini, Mistral, ecc.
- **Tree View & Reporting**: Visualizzazione gerarchica e report di complessità

### Versione Consigliata

```
@raja-rakoto/taskmaster-cli: ^0.7.0+
Richiede: Node.js v22.8.0+
Richiede: TaskMaster AI Core v0.23.0+
```

---

## Installazione

### Passo 1: Prerequisiti

```bash
# Verificare Node.js versione
node --version  # Deve essere >= v22.8.0

# Verificare npm
npm --version   # Deve essere >= v10.0.0
```

### Passo 2: Installazione Globale (Raccomandato)

```bash
# Installazione globale per uso cross-project
npm install -g @raja-rakoto/taskmaster-cli

# Verificare installazione
taskmaster --version
taskmaster --help
```

### Passo 3: Installazione Locale (Alternativa)

```bash
# Se preferisci installare solo in questo progetto
npm install @raja-rakoto/taskmaster-cli

# Usare con npx
npx taskmaster --help
```

### Passo 4: Verifica Installazione

```bash
# Test di funzionamento base
taskmaster init --help

# Se vedi help output, l'installazione è riuscita ✅
```

---

## Configurazione

### File di Configurazione: `.env.taskmaster`

Crea questo file nella root del workspace:

```bash
# TASKMASTER CLI Configuration

# API Keys (minimo uno richiesto)
ANTHROPIC_API_KEY=sk-ant-xxxxx
OPENAI_API_KEY=sk-xxxxx
GOOGLE_GENERATIVE_AI_API_KEY=xxxxx

# Modelli principale e fallback
TASKMASTER_MAIN_MODEL=claude-opus-4-1        # Modello primario
TASKMASTER_RESEARCH_MODEL=claude-sonnet-4-1  # Per ricerche/analisi
TASKMASTER_FALLBACK_MODEL=gpt-4-turbo        # Fallback alternativo

# Lingua risposta
TASKMASTER_RESPONSE_LANGUAGE=it              # Italiano

# Percorso task database
TASKMASTER_DATA_DIR=./.taskmaster            # Dove salvare i task

# Verbosità log
TASKMASTER_LOG_LEVEL=info                    # info, debug, error
```

### Configurazione Globale (Primera Volta)

```bash
# Lanciare init interattivo
taskmaster init

# Ti chiederà di:
# 1. Scegliere modello principale
# 2. Scegliere modello ricerca (opzionale)
# 3. Scegliere fallback (opzionale)
# 4. Impostare lingua risposta
# 5. Configurare directory dati
```

Questo crea `~/.taskmaster/config.json` con le tue preferenze globali.

---

## Comandi Core

### 📍 Categoria: Inizializzazione & Setup

#### `taskmaster init`
Inizializza nuovo progetto TaskMaster nella directory corrente.

```bash
taskmaster init
# Crea: .taskmaster/ directory con config locale
# Crea: tasks.json file per tracking
```

**Quando usare**: All'inizio di ogni nuovo progetto

---

### 📋 Categoria: Task Generation (il cuore del planning)

#### `taskmaster generate:tasks [options]`
**Genera automaticamente task list da PRD o requirements.**

```bash
# Generare da file PRD
taskmaster generate:tasks --from-prd ./PROJECT_REQUIREMENTS.md

# Generare da descrizione inline
taskmaster generate:tasks --description "Build React todo app with TypeScript and testing"

# Generare con decomposizione automatica in subtask
taskmaster generate:tasks --from-prd ./requirements.md --decompose-levels 3

# Generare e salvare in file
taskmaster generate:tasks --description "..." --output ./tasks-generated.json
```

**Output**: Crea structured task tree con:
- Task ID unico
- Descrizione dettagliata
- Subtask (se decomposizione attivata)
- Stima complessità (Low/Medium/High)
- Dipendenze pre-identificate

**Pro Tip**: Questo è il comando che l'Orchestrator dovrebbe usare per il PLANNING INIZIALE!

---

#### `taskmaster generate:subtasks <task-id>`
**Decompone un task singolo in subtask.**

```bash
taskmaster generate:subtasks task_001

# Decomposizione aggressiva (fino a 4 livelli)
taskmaster generate:subtasks task_001 --depth 4

# Decomposizione leggera (solo 1 livello)
taskmaster generate:subtasks task_001 --depth 1
```

**Quando usare**: Un task è troppo complesso e hai bisogno di spezzarlo ulteriormente

---

### 📊 Categoria: Task Management (CRUD)

#### `taskmaster list [options]`
**Mostra tutti i task in formato albero.**

```bash
# Elenco completo con visualizzazione ad albero
taskmaster list

# Elenco solo task completati
taskmaster list --filter completed

# Elenco solo task pending
taskmaster list --filter pending

# Elenco solo task in progress
taskmaster list --filter in-progress

# Elenco con dettagli estesi
taskmaster list --verbose

# Elenco gerarchico formattato
taskmaster list --tree
```

**Output Format**:
```
├─ TASK_001 [PENDING] - Analyze requirements
│  ├─ TASK_001_A [COMPLETED] - Read documentation
│  ├─ TASK_001_B [IN_PROGRESS] - Identify dependencies
│  └─ TASK_001_C [PENDING] - Create architecture diagram
├─ TASK_002 [PENDING] - Setup development environment
│  └─ TASK_002_A [PENDING] - Install dependencies
└─ TASK_003 [PENDING] - Core implementation
```

---

#### `taskmaster show <task-id> [options]`
**Mostra dettagli completi di un task singolo.**

```bash
# Dettagli base
taskmaster show TASK_001

# Con full context e dependenze
taskmaster show TASK_001 --verbose

# Con relazioni (parent/child/dependencies)
taskmaster show TASK_001 --with-relations

# JSON output per processamento
taskmaster show TASK_001 --json
```

**Informazioni mostrate**:
- Task ID e stato
- Descrizione completa
- Subtask
- Dependencies
- Complessità
- Tempo stimato
- Assegnazione (se presente)

---

#### `taskmaster add <description> [options]`
**Aggiunge manualmente un nuovo task.**

```bash
# Task semplice
taskmaster add "Create authentication module"

# Task con stato iniziale
taskmaster add "Create authentication module" --status pending

# Task come subtask di un task esistente
taskmaster add "Implement JWT strategy" --parent TASK_002

# Task con dipendenze
taskmaster add "Build API endpoints" --depends-on TASK_005,TASK_006

# Task con complessità specificata
taskmaster add "Write unit tests" --complexity high
```

---

#### `taskmaster update <task-id> [options]`
**Aggiorna un task esistente.**

```bash
# Aggiorna descrizione
taskmaster update TASK_001 --description "New description"

# Cambio stato
taskmaster update TASK_001 --status completed

# Cambia complessità
taskmaster update TASK_001 --complexity high

# Converti a subtask
taskmaster update TASK_001 --make-subtask --parent TASK_002

# Aggiungi tag
taskmaster update TASK_001 --add-tags "backend,api,urgent"
```

---

#### `taskmaster remove <task-id>`
**Rimuove un task (e suoi subtask).**

```bash
# Rimuove task e tutti i subtask
taskmaster remove TASK_001

# Chiede conferma prima di rimuovere
taskmaster remove TASK_001 --confirm

# Rimuove solo il task, non i subtask
taskmaster remove TASK_001 --orphan-subtasks
```

---

#### `taskmaster next`
**Mostra il prossimo task da completare (rispettando dipendenze).**

```bash
# Mostra task con priorità più alta disponibile
taskmaster next

# Con ragione della priorità
taskmaster next --explain

# Mostra prossimi 3 task
taskmaster next --count 3
```

**Output**:
```
➤ TASK_002_B [PENDING] - Install and configure dependencies
  Reason: Prerequisite for TASK_003
  Complexity: Medium
  Estimated time: 1.5 hours
```

---

### 🔗 Categoria: Dependency Management

#### `taskmaster dependency:add <task-id> <depends-on>`
**Aggiunge dipendenza tra task.**

```bash
# Task B dipende da Task A
taskmaster dependency:add TASK_B TASK_A

# Multipli
taskmaster dependency:add TASK_C TASK_A,TASK_B

# Con tipo di dipendenza (optional)
taskmaster dependency:add TASK_B TASK_A --type blocking
```

---

#### `taskmaster dependency:validate`
**Valida e corregge automaticamente le dipendenze.**

```bash
# Rileva e corregge inconsistenze
taskmaster dependency:validate

# Con report dettagliato
taskmaster dependency:validate --report

# Dry run (non salva cambiamenti)
taskmaster dependency:validate --dry-run
```

**Problemi che rileva**:
- Dipendenze circolari
- Task orfani
- Inconsistenze stato/dipendenza
- Deadlock potenziali

---

### 📈 Categoria: Analysis & Reporting

#### `taskmaster analyze [options]`
**Analizza il progetto completo.**

```bash
# Analisi base
taskmaster analyze

# Con report dettagliato
taskmaster analyze --detailed

# Genera file report
taskmaster analyze --report ./analysis-report.md

# Complessità overall
taskmaster analyze --complexity-only

# Stima tempo totale
taskmaster analyze --estimate-time
```

**Output include**:
- Task count by status
- Complessità media
- Dipendenze critiche
- Bottleneck identificati
- Stima tempo totale
- Critical path analysis

---

#### `taskmaster report [type]`
**Genera report in vari formati.**

```bash
# Report markdown
taskmaster report markdown > project-report.md

# Report JSON
taskmaster report json > project-data.json

# Report CSV (per Excel)
taskmaster report csv > tasks.csv

# Report dettagliato con grafici ASCII
taskmaster report detailed
```

---

### 💾 Categoria: Backup & State Management

#### `taskmaster save`
**Salva snapshot dello stato corrente dei task.**

```bash
# Salva automaticamente con timestamp
taskmaster save

# Salva con nome custom
taskmaster save --name "milestone-1-checkpoint"

# Salva in percorso custom
taskmaster save --path ./backups/checkpoint.json
```

---

#### `taskmaster restore [name]`
**Ripristina task state da salvataggio precedente.**

```bash
# Lista tutti i salvataggi disponibili
taskmaster restore --list

# Ripristina salvataggio specifico
taskmaster restore milestone-1-checkpoint

# Ripristina dal file
taskmaster restore --from ./backups/checkpoint.json
```

---

#### `taskmaster clean`
**Pulisce dati obsoleti e fa manutenzione.**

```bash
# Pulizia base
taskmaster clean

# Rimozione aggressive di task archiviati
taskmaster clean --remove-archived

# Reset completo della directory
taskmaster clean --hard-reset  # ⚠️ Attenzione: irrevocabile!
```

---

## Workflow di Planning

### Scenario 1: Planning Iniziale da PRD

```bash
# 1. Inizializzare progetto
taskmaster init

# 2. Generare task list da PRD
taskmaster generate:tasks --from-prd ./PROJECT_REQUIREMENTS.md --decompose-levels 3

# 3. Visualizzare struttura creata
taskmaster list --tree

# 4. Validare dipendenze
taskmaster dependency:validate

# 5. Generare report iniziale
taskmaster report detailed

# 6. Salvare checkpoint
taskmaster save --name "project-start"
```

### Scenario 2: Aggiungere Task Durante Progetto

```bash
# 1. Identificare necessità nuovo task
taskmaster add "Implementare feature X" --complexity medium

# 2. Posizionare nella gerarchia
taskmaster update TASK_NEW --parent TASK_PARENT

# 3. Aggiungere dipendenze
taskmaster dependency:add TASK_NEW TASK_REQUIRED

# 4. Validare
taskmaster dependency:validate

# 5. Mostrare stato aggiornato
taskmaster list --tree
```

### Scenario 3: Tracking Progresso

```bash
# 1. Cosa fare adesso?
taskmaster next

# 2. Al completamento di un task
taskmaster update TASK_001 --status completed

# 3. Analizzare progresso
taskmaster analyze

# 4. Vedere tasks bloccati
taskmaster list --filter in-progress

# 5. Report su stato attuale
taskmaster report markdown
```

---

## Esempi Pratici

### Esempio 1: React Todo App

```bash
# File: requirements.md
# Build a React Todo App
# Requirements:
# - React 18+ with TypeScript
# - State management with Zustand
# - Task CRUD operations
# - Persist to localStorage
# - Unit tests with Vitest
# - E2E tests with Playwright
# - Responsive design
# - Dark mode toggle

# Comando
taskmaster generate:tasks --from-prd ./requirements.md --decompose-levels 3

# Output creato automaticamente
# ├─ TASK_001 - Setup Project Structure
# │  ├─ TASK_001_A - Initialize React + TypeScript
# │  ├─ TASK_001_B - Configure build tools
# │  └─ TASK_001_C - Setup ESLint & Prettier
# ├─ TASK_002 - Core Todo Functionality
# │  ├─ TASK_002_A - Create Todo components
# │  ├─ TASK_002_B - Implement Zustand store
# │  ├─ TASK_002_C - CRUD operations
# │  └─ TASK_002_D - localStorage persistence
# ├─ TASK_003 - Testing Setup
# │  ├─ TASK_003_A - Unit tests with Vitest
# │  ├─ TASK_003_B - E2E tests with Playwright
# │  └─ TASK_003_C - Coverage reports
# ├─ TASK_004 - UI/UX Features
# │  ├─ TASK_004_A - Responsive design
# │  └─ TASK_004_B - Dark mode implementation
# └─ TASK_005 - Documentation & Deployment
#    ├─ TASK_005_A - README
#    └─ TASK_005_B - Deploy to Vercel
```

### Esempio 2: API Backend Project

```bash
# Workflow completo
taskmaster init
taskmaster generate:tasks --description "Build REST API for e-commerce platform with authentication, products, orders, payments"
taskmaster analyze --detailed
taskmaster report markdown > project-plan.md
taskmaster save --name "api-project-baseline"

# Iterazione durante sviluppo
taskmaster next  # Cosa fare adesso?
# Completare task
taskmaster update TASK_003 --status completed
# Aggiungere task scoperto durante sviluppo
taskmaster add "Implement rate limiting" --parent TASK_002 --depends-on TASK_001
# Re-validare
taskmaster dependency:validate
```

---

## Best Practices

### ✅ DO's

1. **Usa `generate:tasks` per initial planning**
   ```bash
   taskmaster generate:tasks --from-prd ./requirements.md --decompose-levels 3
   ```

2. **Valida dipendenze regolarmente**
   ```bash
   taskmaster dependency:validate
   ```

3. **Salva checkpoint dopo milestone**
   ```bash
   taskmaster save --name "milestone-1"
   ```

4. **Usa `next` per flow sequenziale**
   ```bash
   taskmaster next --explain
   ```

5. **Genera report per stakeholder**
   ```bash
   taskmaster report markdown > status-report.md
   ```

### ❌ DON'Ts

1. **Non creare task troppo grandi**
   - Usa `--decompose-levels` generosamente
   - Ogni task deve essere completabile in 1-2 sessioni

2. **Non ignorare dipendenze**
   - Esegui `dependency:validate` regolarmente
   - Le dipendenze evitano blocchi e confusione

3. **Non modificare manualmente JSON**
   - Usa sempre i comandi CLI
   - Il formato interno può cambiare

4. **Non resettare tutto senza backup**
   - Esegui `save` prima di operazioni rischiose
   - Usa `--dry-run` dove disponibile

---

## Troubleshooting

### Problema: "Command not found: taskmaster"

```bash
# Soluzione 1: Installare globalmente
npm install -g @raja-rakoto/taskmaster-cli

# Soluzione 2: Usare npx
npx @raja-rakoto/taskmaster-cli --version

# Soluzione 3: Verificare installazione
npm list -g @raja-rakoto/taskmaster-cli
```

### Problema: "API key not found"

```bash
# Verificare .env file
cat .env.taskmaster

# Verificare variabili di ambiente
echo $ANTHROPIC_API_KEY

# Ricreare config
taskmaster init
```

### Problema: "Circular dependency detected"

```bash
# Analizzare le dipendenze
taskmaster show <task-id> --with-relations

# Rimuovere dipendenza circolare
taskmaster dependency:add <task-id> <parent> --remove-reverse

# Validare e correggere
taskmaster dependency:validate
```

### Problema: "Task corrupted or incomplete"

```bash
# Restore da backup
taskmaster list --list  # Mostra backups disponibili
taskmaster restore milestone-name

# Se nessun backup, pulire e ricominciare
taskmaster clean --hard-reset  # ⚠️
taskmaster init
```

---

## Integrazione con Orchestrator Agent

### Quando Usare TASKMASTER

**OBBLIGATORIO**:
- ✅ Initial project planning (prima di qualsiasi delegation a coder)
- ✅ Quando task è complesso e necessita decomposizione
- ✅ Quando hai PRD/requirements che necessitano parsing
- ✅ Quando devi tracciare dipendenze complesse

**OPZIONALE**:
- ✅ Task tracking durante esecuzione
- ✅ Report generation per utente
- ✅ Analysis di progetto complexity

### Flusso Orchestrator Recommended

```bash
# 1. Utente: "Build a X"
# 2. Orchestrator: taskmaster generate:tasks --from-prd ...
# 3. Orchestrator: taskmaster analyze --detailed
# 4. Orchestrator: Crea todo list interna dal resultado
# 5. Orchestrator: Delega a coder per first task
# 6. Dopo ogni milestone: taskmaster save --name "..."
# 7. Al completamento: taskmaster report markdown
```

---

## Conclusione

TASKMASTER CLI è lo strumento perfetto per il **planning complesso e gestione dipendenze** nel nostro orchestration system. Usalo come **primo step per ogni progetto nuovo**, soprattutto per analisi iniziale e decomposizione automatica di requirements complessi.

**Quick Ref**:
- Planning: `taskmaster generate:tasks --from-prd`
- Monitoring: `taskmaster list --tree` + `taskmaster next`
- Analysis: `taskmaster analyze --detailed`
- Reporting: `taskmaster report markdown`
- Checkpoints: `taskmaster save --name`

🚀 **Ready to orchestrate complex projects!**
