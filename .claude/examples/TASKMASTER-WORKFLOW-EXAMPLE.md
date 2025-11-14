# TASKMASTER + TodoWrite Integration - Complete Workflow Example

This document demonstrates a real-world workflow using TASKMASTER CLI integrated with the ALEX-STACK orchestrator system.

## Scenario: Building an E-Commerce Platform

**User Request**: "Build a complete e-commerce platform with product catalog, shopping cart, checkout, and payments"

**Complexity Assessment**: 9/10 - This is a multi-system integration requiring TASKMASTER

---

## Step 1: Orchestrator Creates PRD

The orchestrator recognizes this is extreme complexity (9/10) and creates a formal PRD.

```bash
# PRD already created at:
# .taskmaster/docs/example-ecommerce-prd.txt
```

**PRD Contents**:
- 6 major features (Product Catalog, Cart, Checkout, Payments, Orders, Auth)
- Technical requirements (performance, security, scalability)
- Success criteria
- Testing strategy

---

## Step 2: Parse PRD with TASKMASTER

```bash
task-master parse-prd docs/example-ecommerce-prd.txt
```

**Expected Output**:
```
✓ Parsed PRD successfully
✓ Created 6 high-level tasks
✓ Identified dependencies
✓ Saved to tasks.json

Tasks created:
  1. Product Catalog Implementation
  2. Shopping Cart System
  3. Checkout Flow
  4. Payment Processing Integration
  5. Order Management System
  6. User Authentication & Profiles
```

---

## Step 3: Analyze Task Complexity

```bash
task-master analyze-complexity --research
```

**Expected Output** (saved to `scripts/task-complexity-report.json`):
```json
{
  "tasks": [
    {
      "id": 1,
      "title": "Product Catalog Implementation",
      "complexity": 8,
      "recommendedSubtasks": 7,
      "reasoning": "Requires Elasticsearch integration, image handling, recommendation engine"
    },
    {
      "id": 2,
      "title": "Shopping Cart System",
      "complexity": 7,
      "recommendedSubtasks": 5,
      "reasoning": "State management, persistence, real-time updates"
    },
    {
      "id": 3,
      "title": "Checkout Flow",
      "complexity": 9,
      "recommendedSubtasks": 8,
      "reasoning": "Multi-step form, validation, address management, shipping calculations"
    },
    {
      "id": 4,
      "title": "Payment Processing Integration",
      "complexity": 10,
      "recommendedSubtasks": 9,
      "reasoning": "Stripe + PayPal, PCI compliance, error handling, webhooks, refunds"
    },
    {
      "id": 5,
      "title": "Order Management System",
      "complexity": 7,
      "recommendedSubtasks": 6,
      "reasoning": "Admin interface, fulfillment workflow, status tracking"
    },
    {
      "id": 6,
      "title": "User Authentication & Profiles",
      "complexity": 8,
      "recommendedSubtasks": 6,
      "reasoning": "OAuth, email verification, password reset, profile management"
    }
  ]
}
```

---

## Step 4: Expand High-Complexity Tasks (8-10/10)

TASKMASTER recommends expanding tasks with complexity ≥ 8:

```bash
# Expand Product Catalog (complexity 8)
task-master expand --id=1 --research

# Expand Checkout Flow (complexity 9)
task-master expand --id=3 --research

# Expand Payment Processing (complexity 10)
task-master expand --id=4 --research

# Expand User Authentication (complexity 8)
task-master expand --id=6 --research
```

**Note**: Tasks 2 (cart) and 5 (orders) with complexity 7 can be handled directly by TodoWrite

---

## Step 5: Review Expanded Tasks

```bash
task-master show 1
```

**Example Output** (Product Catalog expanded):
```
Task #1: Product Catalog Implementation
Status: pending
Complexity: 8/10
Priority: high
Dependencies: Database schema setup

Subtasks (7):
  1.1 - Design and implement product database schema
       Dependencies: None

  1.2 - Set up Elasticsearch cluster and indexing pipeline
       Dependencies: 1.1

  1.3 - Build product listing API with pagination
       Dependencies: 1.1

  1.4 - Implement advanced search with filters
       Dependencies: 1.2, 1.3

  1.5 - Create product detail page component
       Dependencies: 1.3

  1.6 - Build image gallery with AWS S3 integration
       Dependencies: 1.5

  1.7 - Implement recommendation engine (collaborative filtering)
       Dependencies: 1.3

Test Strategy:
- Unit tests for search query parsing
- Integration tests for Elasticsearch queries
- E2E tests for product browsing flow
- Performance tests (query response < 200ms)
```

---

## Step 6: Transfer to TodoWrite for Execution

The orchestrator reads TASKMASTER output and creates a comprehensive TodoWrite list:

```javascript
TodoWrite([
  // From Task 1 (Product Catalog) - 7 subtasks
  { content: "Design product database schema with PostgreSQL", status: "pending" },
  { content: "Set up Elasticsearch cluster and indexing pipeline", status: "pending" },
  { content: "Build product listing API with pagination", status: "pending" },
  { content: "Implement advanced search with Elasticsearch filters", status: "pending" },
  { content: "Create product detail page React component", status: "pending" },
  { content: "Build image gallery with AWS S3 integration", status: "pending" },
  { content: "Implement recommendation engine", status: "pending" },

  // From Task 2 (Shopping Cart) - Manual breakdown (complexity 7)
  { content: "Implement cart state management with Redux", status: "pending" },
  { content: "Add cart persistence with Redis", status: "pending" },
  { content: "Build cart UI components", status: "pending" },
  { content: "Implement promotional code system", status: "pending" },

  // From Task 3 (Checkout Flow) - 8 subtasks from TASKMASTER
  { content: "Build multi-step checkout form with validation", status: "pending" },
  { content: "Implement shipping address management", status: "pending" },
  { content: "Add shipping method selection with cost API", status: "pending" },
  { content: "Create order review and confirmation pages", status: "pending" },
  // ... 4 more checkout subtasks

  // From Task 4 (Payment Processing) - 9 subtasks from TASKMASTER
  { content: "Integrate Stripe SDK and payment element", status: "pending" },
  { content: "Implement Stripe webhook handlers", status: "pending" },
  { content: "Add PayPal integration as fallback", status: "pending" },
  { content: "Build payment retry logic for failures", status: "pending" },
  // ... 5 more payment subtasks

  // From Task 5 (Order Management) - Manual breakdown
  { content: "Build admin order dashboard", status: "pending" },
  { content: "Implement order status tracking", status: "pending" },
  { content: "Add fulfillment workflow", status: "pending" },

  // From Task 6 (User Auth) - 6 subtasks from TASKMASTER
  { content: "Implement email/password authentication", status: "pending" },
  { content: "Add OAuth integration (Google, Facebook)", status: "pending" },
  { content: "Build password reset flow with email", status: "pending" },
  { content: "Implement email verification system", status: "pending" },
  // ... 2 more auth subtasks
])

// Total: ~45 todos from intelligent breakdown
```

---

## Step 7: Execute with Normal Orchestrator Workflow

Now the orchestrator proceeds with standard delegation:

### Example: First Todo (Database Schema)

```
Orchestrator:
  ├─→ Invoke coder("Design product database schema with PostgreSQL")
  │   └─→ Coder creates schema.sql with products, categories, inventory tables
  │
  ├─→ Invoke tester("Verify schema creates without errors, check foreign keys")
  │   └─→ Tester runs migration, validates constraints
  │
  └─→ Mark todo #1 complete ✓
```

### Example: Payment Integration (High Complexity)

```
Orchestrator:
  ├─→ Invoke jino-agent("Fetch Stripe API documentation and webhook best practices")
  │   └─→ Returns: Clean markdown guide with code examples
  │
  ├─→ Invoke coder("Integrate Stripe SDK following [docs]")
  │   ├─→ Coder implements payment intent creation
  │   ├─→ Coder adds webhook handlers
  │   └─→ Reports completion
  │
  ├─→ Invoke tester("Test payment flow with Stripe test cards")
  │   ├─→ Tester uses Playwright to fill checkout form
  │   ├─→ Tester submits test card (4242 4242 4242 4242)
  │   ├─→ Takes screenshot of success page
  │   └─→ Verifies webhook received
  │
  └─→ Mark payment todo complete ✓
```

---

## Step 8: Progress Tracking

Throughout execution, the orchestrator maintains TodoWrite:

```
Progress: 12/45 completed (27%)

Recently completed:
  ✓ Design product database schema
  ✓ Set up Elasticsearch cluster
  ✓ Build product listing API
  ✓ Implement search filters

Currently in progress:
  → Create product detail page component

Upcoming:
  - Build image gallery with S3
  - Implement recommendation engine
  - Shopping cart state management
  ...
```

---

## Step 9: Completion Report

After all 45 todos complete:

```
Orchestrator Report:

✅ E-Commerce Platform Complete!

Implementation Summary:
- 6 major feature areas implemented
- 45 individual tasks completed
- All integrations tested (Stripe, PayPal, Elasticsearch, S3)
- Payment flow verified with test transactions
- Visual testing completed (Playwright screenshots)
- All navigation links functional (zero 404s)

Test Results:
- Unit tests: 342 passed
- Integration tests: 56 passed
- E2E tests: 18 passed (Playwright)
- Performance: Average page load 1.2s ✓

Key Achievements:
- Stripe payment processing with webhook handling
- Elasticsearch product search (< 200ms response time)
- Real-time cart updates with Redis persistence
- OAuth integration (Google, Facebook)
- Multi-step checkout with validation
- Admin order management dashboard

Ready for QA review and staging deployment!
```

---

## Why TASKMASTER Was Essential Here

### Without TASKMASTER:
- Orchestrator would need to manually break down 6 features into 45 subtasks
- Risk of missing critical dependencies (e.g., Stripe webhooks)
- No complexity scoring to prioritize effort
- Might miss best practices (PCI compliance, payment retry logic)

### With TASKMASTER:
- ✅ AI analyzed each feature and recommended optimal subtask counts
- ✅ Research flag fetched latest Stripe/PayPal best practices
- ✅ Dependency graph ensured correct implementation order
- ✅ Complexity scores (8-10/10) justified the tooling overhead
- ✅ 45 well-structured, researched tasks ready for execution

---

## Key Takeaways

1. **Complexity Threshold**: Use TASKMASTER for 8-10/10 projects
2. **PRD-First**: Formalize requirements before parsing
3. **Selective Expansion**: Only expand high-complexity tasks (save time)
4. **Research Integration**: Use `--research` flag for current best practices
5. **TodoWrite Handoff**: Transfer TASKMASTER output to TodoWrite for tracking
6. **Normal Delegation**: Coder/tester workflow unchanged after planning phase

---

## File Artifacts

After this workflow completes:

```
.taskmaster/
├── config.json                          # TASKMASTER configuration
├── state.json                           # Current state
├── docs/
│   └── example-ecommerce-prd.txt       # Original PRD
└── research/                            # Saved research from --research flag
    ├── stripe-integration-research.md
    ├── elasticsearch-setup-research.md
    └── oauth-best-practices-research.md

tasks.json                               # TASKMASTER task database (45 tasks)
tasks/
├── task_001.txt                         # Individual task details
├── task_002.txt
└── ... (45 files)

scripts/
└── task-complexity-report.json          # Complexity analysis output

# Standard project files created by coder agent
src/
├── components/
│   ├── ProductCatalog/
│   ├── ShoppingCart/
│   ├── Checkout/
│   └── Auth/
├── api/
│   ├── products.js
│   ├── cart.js
│   ├── payments.js
│   └── orders.js
└── ...
```

---

## Comparison: TASKMASTER vs Manual TodoWrite

| Aspect | Manual TodoWrite | TASKMASTER CLI |
|--------|------------------|----------------|
| **Time to plan** | 15-30 min manual breakdown | 2-3 min (automated) |
| **Task quality** | Varies by orchestrator | AI-researched, consistent |
| **Dependencies** | Manual tracking | Auto-validated graph |
| **Best practices** | May miss current patterns | Research-backed with `--research` |
| **Complexity analysis** | Subjective guess | AI-scored 1-10 |
| **Subtask count** | Trial and error | Optimal recommendation |
| **Suitable for** | Simple-medium (1-7/10) | Complex-extreme (8-10/10) |

---

## Next Steps

After completing this workflow:

1. **Review TASKMASTER output** in `tasks.json` for future reference
2. **Save research findings** from `.taskmaster/research/` for documentation
3. **Archive the PRD** for product team handoff
4. **Use complexity scores** to estimate future similar projects
5. **Refine the process** based on what worked well

---

**This example demonstrates the full power of TASKMASTER + ALEX-STACK orchestration for handling genuinely complex software projects with intelligent planning and systematic execution.**
