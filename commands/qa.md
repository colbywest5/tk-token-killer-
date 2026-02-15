---
name: tk:qa
description: QA testing with security analysis. /tk:[$cmd] light|medium|heavy <what to test>
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - WebSearch
  - AskUserQuestion
---

$import(commands/tk/_shared.md)

# TK v2.0.0 | /tk:qa [mode]

## STEP 0: LOAD RULES (SILENT)

Before ANY action: silently read .tk/RULES.md and follow ALL rules constantly.
Do not display rules. Just follow them.

Test systematically. Find bugs AND security vulnerabilities before users do.

## Security Patterns to Check

| Pattern | Risk | Safe Alternative |
|---------|------|------------------|
| `child_process.exec()` | Command injection | Use `execFile()` with array args |
| `new Function()` | Code injection | Avoid dynamic code evaluation |
| `eval()` | Arbitrary code execution | Use `JSON.parse()` for data |
| `dangerouslySetInnerHTML` | XSS | Sanitize with DOMPurify |
| `document.write()` | XSS | Use `createElement()` + `appendChild()` |
| `.innerHTML =` | XSS | Use `textContent` or sanitize |
| `pickle` (Python) | Deserialization attack | Use JSON instead |
| `os.system()` | Command injection | Use `subprocess` with list args |
| GitHub Actions `${{ }}` in `run:` | Command injection | Use `env:` variables instead |

## Process

### 1. Pre-flight
```bash
mkdir -p .tk/qa
npm test --help 2>/dev/null && echo "[OK] npm test available"
```

### 2. Mode Execution

**LIGHT (full test suite with parallel SubAgents):**
Launch 6 parallel specialist SubAgents:
```
SubAgent Security: "Audit this codebase for vulnerabilities.
   Check for: Command injection, Code injection, XSS, SQL/NoSQL injection,
   Deserialization attacks, Hardcoded secrets, GitHub Actions injection,
   CSRF validation, Auth bypass, Authorization gaps, npm audit vulnerabilities.
   For each finding: Severity (CRITICAL/HIGH/MEDIUM/LOW), File:line, Attack vector, Safe alternative.
   Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Edge-Cases: "Try to break the application with unusual inputs:
   Empty strings, 10KB strings, Null bytes, special characters,
   Unicode edge cases (RTL, zero-width, emoji), Negative numbers,
   floats where integers expected, Future dates, past dates,
   Rapid repeated submissions, Concurrent conflicting updates."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Performance: "Find bottlenecks:
   Slow endpoints (>500ms), N+1 database queries, Memory leaks,
   Large bundle size, Missing indexes."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Accessibility: "Check a11y compliance:
   Tab navigation, Focus indicators, ARIA labels, Alt text,
   Color contrast (4.5:1), Keyboard-only operation."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Resilience: "Test failure handling:
   Database connection fails, External API timeout/500,
   Session expires mid-action, Malformed JSON payload,
   Network loss mid-upload."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent DOCS: "Compile comprehensive report:
   .tk/qa/full-report.md (all findings by severity)
   .tk/planning/ISSUES.md (update with issues)
   AGENTS.md (add security gotchas discovered)"
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md
```

Also run:
```bash
# Functional tests
npm test && npm run typecheck && npm run build

# Security scan
npm audit
```

**MEDIUM (deeper analysis + validation):**
Everything in LIGHT, plus:
```
Additional SubAgents:
SubAgent API-Tester: "Test all API endpoints systematically:
   Valid inputs, boundary conditions, auth requirements, rate limiting."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Integration: "Test component integrations:
   Data flow between services, State management, Event handling."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Validator: "Cross-check all findings. Identify false positives, confirm real issues."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**HEAVY (maximum coverage + cross-validation):**
Everything in MEDIUM, plus:
```
Extended Testing:
SubAgent Regression: "Check for regressions against previous functionality."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Stress: "Stress test under load - concurrent users, data volume."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Dependency-Audit: "Deep audit of all dependencies for known vulnerabilities."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

Cross-validation:
SubAgent Cross-validator 1: "Verify Security + Edge-Cases + Performance findings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Cross-validator 2: "Verify Accessibility + Resilience + API findings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Fresh-Eyes: "Independent review - find issues other agents missed."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

### 3. Completion

Merge findings into .tk/qa/full-report.md:
- Executive summary
- **CRITICAL** issues (blocks release)
- **HIGH** issues (fix before release)
- **MEDIUM** issues (fix soon)
- **LOW** issues (nice to have)
- Security-specific findings section
- Recommendations

```bash
# Update .tk/planning/STATE.md, .tk/planning/HISTORY.md
git add .tk/qa/ .tk/planning/ AGENTS.md
git commit -m "docs: QA report - [X] issues found"
```

Report: Tests run, issues by severity, security findings, deploy readiness

**Offer:**
- "Fix critical issues now?" -> run `/tk:debug` for each
- "Create GitHub issues?"
- "Generate security report for stakeholders?"

## GitHub Actions Security

When reviewing `.github/workflows/*.yml`:

**UNSAFE (command injection risk):**
```yaml
run: echo "${{ github.event.issue.title }}"
```

**SAFE (use env variables):**
```yaml
env:
  TITLE: ${{ github.event.issue.title }}
run: echo "$TITLE"
```

**Risky inputs to flag:**
- `github.event.issue.title/body`
- `github.event.pull_request.title/body`
- `github.event.comment.body`
- `github.event.commits.*.message`
- `github.head_ref`
