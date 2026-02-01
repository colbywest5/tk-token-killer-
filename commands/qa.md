---
name: tk:qa
description: QA testing. /tk qa light|medium|heavy <what to test>
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - WebSearch
  - AskUserQuestion
---

# /tk qa <mode> <message>

Test systematically. Find bugs before users do.

## Process

### 1. Pre-flight
```bash
mkdir -p .qa
npm test --help 2>/dev/null && echo "✓ npm test available"
```

### 2. Mode Execution

**LIGHT (~5 min smoke test):**
```bash
# 1. Dev server starts?
timeout 30 npm run dev & sleep 10 && curl -s localhost:3000 && kill $!
# 2. Tests pass?
npm test
# 3. Types clean?
npm run typecheck
# 4. Build works?
npm run build
# 5. Lint?
npm run lint
```
Report pass/fail counts. Recommend medium if issues found.

**MEDIUM (~15 min full coverage):**
- Everything in light, plus:
- `npm test -- --coverage` (check coverage %)
- Test all API endpoints found
- Edge cases: empty strings, long strings (1000 chars), special chars, null, unicode
- Create .planning/ISSUES.md entries for findings
- Report with severity ratings

**HEAVY (~30 min, 5 parallel specialists):**
```
Spawn simultaneously:
SubAgent 1 (Security): SQL injection, XSS, CSRF, auth bypass, secrets in code, npm audit
SubAgent 2 (Edge Cases): Empty/huge inputs, unicode, negative numbers, dates (3000/1900), rapid submissions
SubAgent 3 (Performance): Slow endpoints (>500ms), N+1 queries, memory leaks, bundle size, concurrent load
SubAgent 4 (Accessibility): Tab navigation, focus indicators, ARIA labels, alt text, color contrast, keyboard-only
SubAgent 5 (Chaos): DB connection fail, API timeout, malformed JSON, session expire mid-action
SubAgent DOCS: Compile .qa/full-report.md, update .planning/ISSUES.md, prepare AGENTS.md gotchas
```

### 3. Completion

```bash
# Merge findings into .qa/full-report.md
# - Executive summary
# - All issues by severity (CRITICAL/HIGH/MEDIUM/LOW)
# - Recommendations

# Log issues to .planning/ISSUES.md
# Update STATE.md, HISTORY.md
```

Report: Tests run, issues found by severity, deploy readiness

Offer: "Fix critical issues now?" → /tk debug for each
