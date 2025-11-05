# CLAUDE_TASKMASTER.md - TASKMASTER CLI Addon
## Integrazione TASKMASTER per Planning Ottimizzato

---

## 🎯 QUANDO USARE TASKMASTER CLI

### OBBLIGATORIO - Usare SEMPRE TASKMASTER in questi scenari:

#### 1️⃣ **Initial Project Planning** (SEMPRE - PRIMO STEP)
**Trigger**: Appena ricevi requirements per un nuovo progetto
```
USER: "Build a React todo app with TypeScript, testing, and dark mode"

YOU (Orchestrator):
1. PRIMA di qualsiasi planning manuale:
   → taskmaster init
   → taskmaster generate:tasks --from-prd <requirements> --decompose-levels 3
   → taskmaster analyze --detailed
   → taskmaster report markdown > project-plan.md

2. POI esegui il planning manuale con TodoWrite
3. Usa il risultato TASKMASTER come base per i tuoi todo items
```

**Vantaggi**:
- ✅ Decomposizione automatica intelligente
- ✅ Identificazione automatica dipendenze
- ✅ Rilevamento criticità e bottleneck
- ✅ Stima tempo complessivo progetto
- ✅ Eliminazione bias di planning manuale

---

#### 2️⃣ **Complex Projects con Molte Dipendenze**
**Trigger**: Quando il progetto ha 10+ task principali
```bash
# Anziché planning manuale, usa:
taskmaster generate:tasks --description "Your complex requirements" --decompose-levels 4

# Poi valida automaticamente:
taskmaster dependency:validate
```

**Quando**: Qualsiasi progetto enterprise, backend complesso, system design

---

#### 3️⃣ **PRD o Requirements Document Analysis**
**Trigger**: Quando l'utente fornisce PRD/requirements in formato file
```bash
# NON leggere e analizzare manualmente
# INVECE:
taskmaster generate:tasks --from-prd ./PROJECT_REQUIREMENTS.md --decompose-levels 3
taskmaster analyze --report

# Questo estrae informazioni molto meglio di una lettura manuale
```

---

#### 4️⃣ **Multi-Step Planning con Subtask Profonde**
**Trigger**: Quando devi pianificare con 3+ livelli di gerarchia
```bash
# Manuale → tedioso e error-prone
# Automatico:
taskmaster generate:subtasks TASK_001 --depth 4
taskmaster dependency:validate
```

---

### CONSIGLIATO - Usare TASKMASTER anche in:

#### 📊 **Project Status Reporting**
```bash
# Prima di report all'utente:
taskmaster analyze --detailed
taskmaster report markdown > current-status.md

# Dai all'utente dato accurato e professionale
```

---

#### 💾 **Milestone Checkpoints**
```bash
# Al completamento di major milestone:
taskmaster save --name "milestone-2-complete"

# Questo permette rollback se necessario
```

---

#### 🔄 **Mid-Project Task Addition**
**Scenario**: Durante coding scopri task aggiuntivi
```bash
# Anziché aggiungerli casualmente:
taskmaster add "New requirement discovered" --parent TASK_PARENT --complexity medium
taskmaster dependency:validate  # Assicura coerenza

# Questo mantiene progetto tracciato e coerente
```

---

## 🚀 IL TUO NUOVO WORKFLOW ORCHESTRATOR

### ✨ Vecchio Workflow (senza TASKMASTER):
```
USER requirement
  ↓
YOU: Leggi requirement manualmente
  ↓
YOU: Crea todo list manualmente
  ↓
Possibili problemi:
- Dimenti task
- Planning inefficiente
- Dipendenze non gestite
- Bias personale
```

### ⚡ NUOVO Workflow (con TASKMASTER):
```
USER requirement
  ↓
YOU: taskmaster generate:tasks --from-prd <req> --decompose-levels 3
  ↓
YOU: taskmaster analyze --detailed
  ↓
YOU: taskmaster report markdown > analysis.md
  ↓
YOU: Usa TASKMASTER output come base per TodoWrite
  ↓
Vantaggi:
- ✅ Planning AI-powered, non soggettivo
- ✅ Decomposizione ottimale automatica
- ✅ Dipendenze gestite
- ✅ Stima realistica
- ✅ Bottleneck identificati
```

---

## 🎓 COMANDI ESSENZIALI PER ORCHESTRATOR

### Comando #1: PLANNING INIZIALE
```bash
taskmaster init && \
taskmaster generate:tasks --from-prd <file> --decompose-levels 3 && \
taskmaster analyze --detailed && \
taskmaster report markdown > project-analysis.md
```
**Quando**: Start di ogni progetto novo
**Output**: Structured task tree + analysis

---

### Comando #2: VALIDAZIONE DIPENDENZE
```bash
taskmaster dependency:validate
```
**Quando**: Prima di fare major delegation a coder
**Output**: Corregge inconsistenze automaticamente

---

### Comando #3: PROSSIMO TASK DISPONIBILE
```bash
taskmaster next --explain
```
**Quando**: Vuoi delegare task successivo a coder
**Output**: Task con priorità massima disponibile

---

### Comando #4: SALVA CHECKPOINT
```bash
taskmaster save --name "milestone-description"
```
**Quando**: Al completamento di milestone
**Output**: Snapshot dello stato salvato

---

### Comando #5: REPORT PROGRESSO
```bash
taskmaster report detailed > status-report.md
```
**Quando**: Devi informare utente
**Output**: Report professionale e dettagliato

---

## 🔧 INTEGRAZIONE PRATICA CON WORKFLOW

### Step 1: Initial Planning Session
```markdown
USER: "Build an e-commerce API with Node, TypeScript, PostgreSQL, JWT auth, payment integration, and admin panel"

ORCHESTRATOR ACTIONS:
1. taskmaster init
2. taskmaster generate:tasks --description "..." --decompose-levels 3
3. taskmaster analyze --detailed
4. taskmaster report markdown > ecommerce-plan.md
5. taskmaster save --name "ecommerce-initial"

OUTPUT RECEIVED:
- Structured task tree
- Dependency graph
- Complexity analysis
- Time estimates
- Critical path identified

THEN:
6. Use TASKMASTER output to guide TodoWrite creation
7. Create detailed todo list based on AI-generated plan
8. Delegate first task to coder
```

---

### Step 2: During Project Execution
```markdown
During development, coder discovers:
- Need for additional validation layer
- Missing error handling module
- New security requirement

ACTIONS:
1. taskmaster add "Add validation layer" --parent TASK_003
2. taskmaster add "Error handling module" --depends-on TASK_005
3. taskmaster add "Security audit" --complexity high
4. taskmaster dependency:validate
5. taskmaster list --tree  # Verify new structure
```

---

### Step 3: Milestone Completion
```markdown
After completing major milestone:

ACTIONS:
1. taskmaster save --name "milestone-1-api-complete"
2. taskmaster analyze --detailed
3. taskmaster report markdown > milestone-1-report.md
4. Share report with user
```

---

### Step 4: Project Completion
```markdown
When all tasks done:

ACTIONS:
1. taskmaster list  # Verify all COMPLETED
2. taskmaster report detailed > final-project-report.md
3. taskmaster save --name "project-final"
4. Present final report to user
```

---

## 🚨 CRITICAL RULES FOR TASKMASTER USAGE

### ❌ NEVER:
1. ❌ Skip `taskmaster dependency:validate` dopo ogni major change
2. ❌ Creare task manualmente senza verificare con TASKMASTER analysis
3. ❌ Manualmente editare `.taskmaster/tasks.json`
4. ❌ Ignorare "circular dependency" warnings
5. ❌ Saltare initial `generate:tasks` per projects complessi

### ✅ ALWAYS:
1. ✅ Usa `generate:tasks` come first step per ANY progetto
2. ✅ Valida dipendenze prima di delegation
3. ✅ Salva checkpoint ai milestone
4. ✅ Genera report per user communication
5. ✅ Usa `taskmaster next` per determinare ordine sequenziale

---

## 📋 FEATURE MATRIX: QUANDO QUALE COMANDO

| Scenario | Comando | Quando |
|----------|---------|--------|
| Nuovo progetto | `init` + `generate:tasks` | User submission |
| Analysis progetto | `analyze --detailed` | Before TodoWrite |
| Validazione | `dependency:validate` | Prima delegation |
| Prossimo step | `taskmaster next` | Ready for coder |
| Aggiorna stato | `update <id> --status` | After coder complete |
| Report | `report markdown` | User communication |
| Checkpoint | `save --name` | Milestone complete |
| Recovery | `restore --name` | If issues arise |

---

## 💡 PRO TIPS

### Tip 1: Task Generation da Descrizione Inline
```bash
# Rapido per piccoli projects
taskmaster generate:tasks --description "Build login form with validation, password reset, 2FA"
```

### Tip 2: Decomposizione Aggressiva
```bash
# Quando task è veramente complesso
taskmaster generate:subtasks TASK_001 --depth 5
```

### Tip 3: Export per Stakeholder
```bash
# JSON per processamento
taskmaster report json > project-data.json

# Markdown per documentation
taskmaster report markdown > project-plan.md

# CSV per Excel
taskmaster report csv > tasks.csv
```

### Tip 4: Quick Status Check
```bash
# Numero task by status
taskmaster list --filter pending
taskmaster list --filter in-progress
taskmaster list --filter completed
```

### Tip 5: Find Next Available Task
```bash
# Ignora task bloccati, mostra cosa fare adesso
taskmaster next --explain
```

---

## 📦 CONFIGURATION PER ORCHESTRATOR

Aggiungi a `.env` nella root:
```
ANTHROPIC_API_KEY=sk-ant-xxxxx          # Per planning intelligente
TASKMASTER_MAIN_MODEL=claude-opus-4-1   # Modello pianificazione
TASKMASTER_RESPONSE_LANGUAGE=it          # Risposte in italiano
TASKMASTER_LOG_LEVEL=info                # Log livello
```

---

## 🎯 SUMMARY: COSA RICORDARE

1. **TASKMASTER = Your Planning Brain**
   - Non è opzionale, è parte del sistema
   - Usa SEMPRE per initial planning
   - Usa SEMPRE per analysis complex

2. **Command Priority**
   - `generate:tasks` = PRIORITY #1
   - `dependency:validate` = PRIORITY #2
   - `analyze --detailed` = PRIORITY #3

3. **Integration Points**
   - After TASKMASTER → Create TodoWrite
   - After TodoWrite → Delegate to coder
   - After milestone → `save` + `report`

4. **The Promise**
   - ✅ Better planning (AI-powered)
   - ✅ No forgotten tasks
   - ✅ Dependency awareness
   - ✅ Realistic estimates
   - ✅ Professional reporting

---

**TASKMASTER CLI transforms you from "hoping your planning is good" to "knowing your planning is optimal"** 🚀
