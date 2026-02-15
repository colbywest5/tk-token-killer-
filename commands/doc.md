---
name: tk:doc
description: Generate documentation. /tk:[$cmd] light|medium|heavy
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
---

$import(commands/tk/_shared.md)

# TK v2.0.0 | /tk:doc [mode]

## STEP 0: LOAD RULES (SILENT)

Before ANY action: silently read .tk/RULES.md and follow ALL rules constantly.
Do not display rules. Just follow them.

Generate or update documentation.

## Process

### 1. Analyze
```bash
mkdir -p docs
[ -f "package.json" ] && echo "Node.js"
find . -path "*/api/*" -name "*.ts" | grep -v node_modules | head -10  # API routes
find . -name "*.tsx" | grep -v node_modules | wc -l  # Components
```

### 2. Mode Execution

**LIGHT (comprehensive docs with SubAgents):**
Launch 4 parallel generators:
```
SubAgent README: "Generate comprehensive README: features, prerequisites, install, config, usage, dev guide, testing, deploy, contributing."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent API: "Document all API endpoints: method, path, body, response, example curl."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Architecture: "Document system overview, component diagrams, data flow, design decisions."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Code-Comments: "Add JSDoc/TSDoc to exported functions, explain complex logic."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent DOCS: "Create docs/INDEX.md, verify consistency, cross-link."
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md
```

**MEDIUM (deeper documentation + validation):**
Everything in LIGHT, plus:
```
Additional SubAgents:
SubAgent Onboarding: "Create getting-started guide for new developers."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Troubleshooting: "Document common issues, gotchas, FAQs."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent OpenAPI: "Generate OpenAPI spec if possible."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Validator: "Cross-check all docs for accuracy, outdated info, inconsistencies."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**HEAVY (maximum documentation + cross-validation):**
Everything in MEDIUM, plus:
```
Extended Documentation:
SubAgent Decisions: "Document all architectural decisions with rationale."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Security: "Document security model, auth flows, permissions."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Runbooks: "Create operational runbooks for deployment, monitoring, incidents."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

Cross-Validation:
SubAgent Cross-validator 1: "Verify README + API + Architecture docs."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Cross-validator 2: "Verify Code-Comments + Onboarding + Troubleshooting docs."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Fresh-Eyes: "Independent review - find gaps, inconsistencies, missing docs."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

### 3. Completion
```bash
git add README.md docs/ AGENTS.md
git commit -m "docs: generate/update documentation"
```

Report: Files generated (README, API.md, ARCHITECTURE.md), inline comments added
