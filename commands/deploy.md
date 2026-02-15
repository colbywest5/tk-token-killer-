---
name: tk:deploy
description: Deployment. /tk:[$cmd] light|medium|heavy
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
---

$import(commands/tk/_shared.md)

# TK v2.0.0 | /tk:deploy [mode]

## STEP 0: LOAD RULES + VERSION (SILENT)

Before ANY action:
1. Silently load .tk/RULES.md - follow constantly
2. Read .tk/VERSION - get current project version
3. Display: `Deploying v{CURRENT_VERSION}...`

On deploy completion: Record deployment in version history (no bump).

Deploy to production.

## Process

### 1. Pre-flight
```bash
# Must be clean
[ $(git status --porcelain | wc -l) -gt 0 ] && echo "[ERROR] Uncommitted changes - commit first" && exit 1
echo "Branch: $(git branch --show-current)"
mkdir -p .tk/deploy
```

### 2. Mode Execution

**LIGHT (pre-flight + deploy + verify with SubAgents):**
```
Pre-flight (4 parallel):
SubAgent Tests: "Run full test suite, verify coverage >70%."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Security: "Run npm audit, check no secrets in code, verify auth."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Build: "Verify build succeeds, bundle size reasonable, env vars documented."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Config: "Validate platform config, env vars set, SSL configured."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent DOCS: "Create .tk/deploy/pre-flight-report.md"
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md
```
-> ALL must pass before deploy

Deploy:
```bash
# Auto-detect and deploy
[ -f "vercel.json" ] && npx vercel --prod
[ -f "railway.toml" ] && railway up
[ -f "Dockerfile" ] && docker build -t app:$(git rev-parse --short HEAD) . && docker push
```

Post-deploy (4 parallel):
```
SubAgent Health: "Check health endpoint, response time <500ms."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Smoke: "Test homepage, login, core feature, API endpoints."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Logs: "Check for errors in production logs."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Performance: "Check TTFB, page load, Core Web Vitals."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent DOCS: "Create .tk/deploy/deployment-report.md"
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md
```

**MEDIUM (deeper verification + validation):**
Everything in LIGHT, plus:
```
Extended Pre-flight:
SubAgent Dependencies: "Verify all dependencies are production-ready, no dev deps in prod."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Migration: "Check for pending database migrations, schema changes."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

Extended Post-deploy:
SubAgent Integration: "Verify all external integrations work in production."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Monitoring: "Verify monitoring and alerting is configured."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Validator: "Cross-check all deployment findings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**HEAVY (maximum verification + cross-validation):**
Everything in MEDIUM, plus:
```
Extended Verification:
SubAgent Rollback-Plan: "Document rollback procedure, verify it's tested."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Load-Test: "Run basic load test, verify system handles expected traffic."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Compliance: "Verify deployment meets compliance requirements (if any)."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

Cross-Validation:
SubAgent Cross-validator 1: "Verify pre-flight findings against actual deployment."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Cross-validator 2: "Verify post-deploy findings, confirm no regressions."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Fresh-Eyes: "Independent verification - find issues other agents missed."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

### 3. Completion
```bash
VERSION=$(date +%Y.%m.%d-%H%M)
git tag -a "deploy-$VERSION" -m "Deployed to production"
git push origin "deploy-$VERSION"
# Update .tk/planning/STATE.md, .tk/planning/HISTORY.md
```

Report: URL, commit, pre-flight status, verification status, tag

### 4. Rollback (if verification fails)
```bash
vercel rollback  # or railway rollback, or deploy previous docker tag
```
