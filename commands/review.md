---
name: tk:review
description: Code review. /tk:[$cmd] light|medium|heavy
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
---

$import(commands/tk/_shared.md)

# TK v2.0.0 | /tk:review [mode]

## STEP 0: LOAD RULES (SILENT)

Before ANY action: silently read .tk/RULES.md and follow ALL rules constantly.
Do not display rules. Just follow them.

Review code changes like a senior engineer.

## Process

### 1. Get Scope
```bash
mkdir -p .tk/review
git diff > .tk/review/changes.diff
git diff --name-only > .tk/review/changed-files.txt
FILES_COUNT=$(wc -l < .tk/review/changed-files.txt)
```
If nothing staged, ask: uncommitted changes? branch vs main? specific files?

### 2. Load Context
```bash
[ -f ".tk/planning/PATTERNS.md" ] && cat .tk/planning/PATTERNS.md
[ -f "AGENTS.md" ] && grep -A50 "## Conventions" AGENTS.md
```

### 3. Mode Execution

**LIGHT (4 parallel reviewers):**
```
SubAgent Correctness: "Review for logic errors, null handling, edge cases, race conditions. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Security: "Review for injection, XSS, CSRF, auth bypass, secrets, input validation. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Performance: "Review for N+1, re-renders, memoization, bundle size, memory leaks. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Maintainability: "Review for naming, types, duplication, complexity, pattern violations. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent DOCS: "Merge findings into .tk/review/report.md, note positive observations."
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md
```

**MEDIUM (6 reviewers + validator):**
Everything in LIGHT, plus:
```
Additional SubAgents:
SubAgent API-Review: "Review API contracts, error responses, validation. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Test-Coverage: "Identify missing tests for changed code. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Validator: "Cross-check all findings, identify false positives, rank by severity."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**HEAVY (8 reviewers + cross-validators):**
Everything in MEDIUM, plus:
```
Extended Review:
SubAgent Architecture: "Review architectural impact, coupling, cohesion. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Accessibility: "Review for a11y issues in UI changes. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

Cross-Validation:
SubAgent Cross-validator 1: "Verify Correctness + Security + Performance findings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Cross-validator 2: "Verify Maintainability + API + Test findings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Fresh-Eyes: "Independent review - find issues other reviewers missed."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

### 4. Completion
```bash
# Create final verdict: APPROVED or CHANGES REQUESTED
# Update .tk/planning/PATTERNS.md if new patterns found
# Update .tk/planning/STATE.md, .tk/planning/HISTORY.md
```

Report: Files reviewed, verdict, issues by severity, positive observations

Offer: "Auto-fix safe issues?" or "Show fixes?"
