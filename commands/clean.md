---
name: tk:clean
description: Cleanup codebase. /tk:[$cmd] light|medium|heavy
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
---

$import(commands/tk/_shared.md)

# TK v2.0.0 | /tk:clean [mode]

## STEP 0: LOAD RULES (SILENT)

Before ANY action: silently read .tk/RULES.md and follow ALL rules constantly.
Do not display rules. Just follow them.

Clean the codebase.

## Process

### 1. Pre-flight
```bash
mkdir -p .tk/cleanup
git stash push -m "pre-cleanup-$(date +%s)"  # Checkpoint
```

### 2. Mode Execution

**LIGHT (4 parallel cleaners):**
```
SubAgent Dead-Code: "Find unused exports, unreachable code, commented-out code, unused variables."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Dependencies: "Find unused deps, outdated packages, security vulnerabilities."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Refactoring: "Find duplicates, long functions, deep nesting, pattern violations."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Organization: "Find import issues, naming problems, missing index files, circular deps."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent DOCS: "Document all findings in .tk/cleanup/report.md"
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md
```

Also run:
```bash
# Console.logs
grep -rn "console.log" --include="*.ts" --include="*.tsx" | grep -v node_modules | grep -v "\.test\." > .tk/cleanup/console-logs.txt

# Count TODOs
grep -rn "TODO\|FIXME" --include="*.ts" | grep -v node_modules > .tk/cleanup/todos.txt

# Lint fix
npm run lint -- --fix
```

Offer to fix each category, atomic commits per fix type.

**MEDIUM (deeper analysis + validation):**
Everything in LIGHT, plus:
```
Additional SubAgents:
SubAgent Type-Safety: "Find any type issues, loose types, missing types."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Test-Cleanup: "Find duplicate tests, outdated tests, test smells."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Config-Cleanup: "Find unused config, duplicate env vars, outdated settings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Validator: "Cross-check findings, identify safe vs risky cleanups."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**HEAVY (maximum cleanup + cross-validation):**
Everything in MEDIUM, plus:
```
Extended Cleanup:
SubAgent Performance: "Find performance anti-patterns, unnecessary re-renders."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Security: "Find security smells, potential vulnerabilities."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Documentation: "Find outdated comments, missing docs, incorrect docs."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

Cross-Validation:
SubAgent Cross-validator 1: "Verify Dead-Code + Dependencies + Refactoring findings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Cross-validator 2: "Verify Organization + Type-Safety + Test findings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Fresh-Eyes: "Independent review - find issues other cleaners missed."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

### 3. Verification
```bash
npm run typecheck && npm test && npm run build || (echo "[ERROR] Cleanup broke something - rolling back" && git stash pop)
```

### 4. Completion
```bash
# Update .tk/planning/CODEBASE.md with removed files
# Update .tk/planning/STATE.md, .tk/planning/HISTORY.md
git commit -m "chore: cleanup codebase"
```

Report: Items removed (console.logs, exports, deps), items updated (packages, vulns), items refactored
