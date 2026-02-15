---
name: tk:map
description: Map project and build context. RUN THIS FIRST.
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
  - WebSearch
---

$import(commands/tk/_shared.md)

# TK v2.0.0 | /tk:map [mode]

## STEP 0: LOAD RULES + VERSION (SILENT)

Before ANY action:
1. Silently load .tk/RULES.md - follow constantly
2. Read or initialize .tk/VERSION
3. If no version exists, initialize to v0.1.0

Map project, create context. Without this, other commands work blind.

## Process

### 1. Check Existing
```bash
[ -f "AGENTS.md" ] && echo "[OK] AGENTS.md exists"
[ -d ".tk/planning" ] && echo "[OK] .tk/planning/ exists"
```
If exists: ask update/fresh/show-existing

### 2. Initial Scan
```bash
# Detect stack
[ -f "package.json" ] && echo "Node.js" && grep -q "next" package.json && echo "Next.js"
[ -f "requirements.txt" ] && echo "Python"
[ -f "go.mod" ] && echo "Go"

# Size
echo "Files: $(find . -name '*.ts' -o -name '*.js' -o -name '*.py' | grep -v node_modules | wc -l)"
find . -type d -maxdepth 3 | grep -v node_modules | grep -v .git | head -30
```

### 3. Mode Execution

**LIGHT (full mapping with parallel SubAgents):**
Interview user (5-10 questions): What does it do? Who uses it? Current state? Fragile areas? Conventions? Gotchas? Testing? Deployment? External services?

Spawn 6 parallel mappers:
```
SubAgent Structure: "Map all files/directories, purpose, dependencies."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Architecture: "System design, components, data flows, diagrams."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Patterns: "Extract all coding patterns with examples."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent API-Schema: "Document endpoints, database models, types."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Config: "All env vars, config files, feature flags."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Tech-Debt: "TODOs, FIXMEs, code smells, security concerns."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent DOCS: "Synthesize into comprehensive AGENTS.md + all .tk/planning/ files."
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md
```

**MEDIUM (deeper analysis + validation):**
Everything in LIGHT, plus:
```
Additional SubAgents:
SubAgent Testing: "Analyze test coverage, test patterns, missing tests."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Integration: "Map all external integrations, APIs, services."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Security: "Identify security patterns, vulnerabilities, auth flows."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Validator: "Cross-check all findings for accuracy and completeness."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**HEAVY (maximum coverage + cross-validation):**
Everything in MEDIUM, plus:
```
Extended Analysis:
SubAgent Historical: "Analyze git history for evolution and key changes."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Performance: "Identify performance-critical paths and bottlenecks."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Dependencies: "Deep audit of all dependencies, versions, risks."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

Cross-Validation:
SubAgent Cross-validator 1: "Verify Structure + Architecture + Patterns findings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Cross-validator 2: "Verify API + Config + Tech-Debt findings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Fresh-Eyes: "Independent review - find what other agents missed."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

### 4. Core Files Created

```bash
mkdir -p .tk/planning .tk/agents .tk/locks .tk/debug .tk/qa

# STATE.md - work tracking
cat > .tk/planning/STATE.md << 'EOF'
# State
activeCommand: none
activeTask: none
lastContextUpdate: [now]
EOF

# HISTORY.md - work log
cat > .tk/planning/HISTORY.md << 'EOF'
# Work History
## [date]
### [time] - /tk:map $MODE
EOF

# ISSUES.md, DECISIONS.md - initialize empty
```

### 5. Commit
```bash
git add AGENTS.md .tk/planning/
git commit -m "docs: add project context (/tk:map $MODE)"
```

### 6. Report
```
[OK] Context created
Files: AGENTS.md, .tk/planning/CODEBASE.md, .tk/planning/ARCHITECTURE.md [+ mode-specific]
Context size: [X] words
Ready: /tk:build, /tk:debug, etc.
```
