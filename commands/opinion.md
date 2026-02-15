---
name: tk:opinion
description: Get an honest audit and opinion of your project
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Task
---

$import(commands/tk/_shared.md)

# TK v2.0.0 | /tk:opinion [mode]

## STEP 0: LOAD RULES (SILENT)

Before ANY action: silently read .tk/RULES.md and follow ALL rules constantly.
Do not display rules. Just follow them.

Audit the project and give honest, actionable opinions.

## Phase 1: Discovery Scan

Scan the project to understand what exists:

```
SCAN:
+-- README.md / docs/ -> Project vision, goals, MVP definition
+-- package.json / requirements.txt / go.mod -> Dependencies, scripts
+-- src/ / lib/ / app/ -> Code structure, patterns
+-- tests/ / __tests__ / spec/ -> Test coverage
+-- .github/ / CI config -> Automation
+-- AGENTS.md / .tk/planning/ -> Existing project context
+-- TODO.md / ROADMAP.md / MVP.md -> Planned work
+-- Git history -> Activity, contributors, velocity
```

## Phase 2: Ask Questions

Before giving opinions, ask 3-5 questions to understand context:

```
QUESTION TYPES:
- What's the goal? (MVP, production, learning project, side project?)
- Who's the user? (You, team, public, enterprise?)
- What's the timeline? (Shipping soon, long-term, no deadline?)
- What's the constraint? (Time, money, skills, scope?)
- What matters most? (Speed, quality, features, learning?)
```

WAIT for answers before proceeding.

## Phase 3: Mode Execution

**LIGHT (4 parallel auditors):**
```
SubAgent Architecture-Auditor: "Audit structure, patterns, complexity. Is it conventional for this stack? Would a new dev understand it in 10 min?"
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Code-Auditor: "Audit consistency, dead code, duplicate logic, error handling, type safety."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Deps-Auditor: "Audit dependencies - necessary or bloated? Security vulns? Outdated? Conflicting?"
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent DX-Auditor: "Audit DevX, onboarding, documentation. Can someone new get started?"
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent DOCS: "Document findings in .tk/planning/AUDIT.md"
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md
```

**MEDIUM (deeper audit + validation):**
Everything in LIGHT, plus:
```
Additional SubAgents:
SubAgent Testing-Auditor: "Audit test coverage, test quality, CI integration."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent DevOps-Auditor: "Audit CI/CD, deployment, secrets handling."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent MVP-Auditor: "If MVP.md exists - what % complete? What's blocking? Scope creep?"
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Validator: "Cross-check all findings, identify contradictions."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**HEAVY (maximum audit + cross-validation):**
Everything in MEDIUM, plus:
```
Extended Audit:
SubAgent Performance-Auditor: "Audit for performance issues, bottlenecks, scalability concerns."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Security-Auditor: "Audit security posture, auth, vulnerabilities."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Comparison-Auditor: "Compare to similar projects - what best practices are missing?"
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

Cross-Validation:
SubAgent Cross-validator 1: "Verify Architecture + Code + Deps findings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Cross-validator 2: "Verify DX + Testing + DevOps findings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Devil's-Advocate: "Challenge all findings - what did we miss? What are we wrong about?"
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

## Phase 4: The Opinion

Deliver honest, direct feedback:

```
FORMAT:

## What's Working
[2-3 things that are genuinely good - be specific]

## What's Not Working
[2-3 things that need attention - be direct, not mean]

## What You Should Stop Doing
[Things wasting time or adding complexity without value]

## What You Should Start Doing
[High-impact changes that would help most]

## If I Had to Ship This Tomorrow
[What's the minimum to make it work?]

## If I Had a Month
[What would make the biggest difference?]

## MVP Reality Check (if applicable)
- Current state: [X]% complete
- Blocking issues: [list]
- Scope creep detected: [yes/no, examples]
- Realistic timeline: [estimate]

## Hot Takes
[1-2 spicy but honest opinions - things the dev might not want to hear but needs to]
```

## Output

After opinion, offer:

```
NEXT STEPS:
1. /tk:clean - Fix the easy stuff (dead code, formatting)
2. /tk:doc - Improve documentation
3. /tk:qa - Run full test + security scan
4. /tk:build [specific suggestion] - Tackle highest priority

Want me to run any of these?
```

## Rules

1. BE HONEST - Don't sugarcoat. Be kind but direct.
2. BE SPECIFIC - "Code is messy" -> "The auth module mixes concerns"
3. BE ACTIONABLE - Every criticism comes with a solution
4. RESPECT CONTEXT - Side project != enterprise expectations
5. NO GATEKEEPING - Don't shame for not knowing things
6. PRIORITIES MATTER - Focus on what helps most, not what's "proper"
