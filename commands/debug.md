---
name: tk:debug
description: Systematic debugging. /tk:[$cmd] light|medium|heavy <problem>
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - WebSearch
  - AskUserQuestion
---

$import(commands/tk/_shared.md)

# TK v2.0.0 | /tk:debug [mode]

## STEP 0: LOAD RULES + VERSION (SILENT)

Before ANY action:
1. Silently load .tk/RULES.md - follow constantly
2. Read .tk/VERSION - get current project version
3. Display: `Debugging... (v{CURRENT_VERSION})`

On fix completion: Bump PATCH version, display `v{OLD} -> v{NEW}`

Debug systematically. Break repair loops.

## Critical Rules
1. **NEVER retry what's been tried** - check .tk/debug/attempts.md
2. **Revert before experimenting** - don't compound errors
3. **One change at a time** - isolate variables
4. **Capture every gotcha** - update AGENTS.md when fixed

## Process

### 1. Pre-flight
```bash
mkdir -p .tk/debug
[ -f ".tk/planning/ISSUES.md" ] && grep -A5 "## Open" .tk/planning/ISSUES.md
[ -f ".tk/debug/attempts.md" ] && tail -20 .tk/debug/attempts.md
```

### 2. Capture Error
```bash
$FAILING_COMMAND 2>&1 | tee .tk/debug/error.txt
grep -i "[error keyword]" AGENTS.md  # Check if known issue
```

### 3. Mode Execution

**LIGHT (systematic with SubAgents):**
1. Form 3 hypotheses with evidence
2. Launch 3 investigator SubAgents in parallel:
```
SubAgent Investigator 1: "Investigate hypothesis 1: [hypothesis]. DO NOT FIX. Report findings only."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Investigator 2: "Investigate hypothesis 2: [hypothesis]. DO NOT FIX. Report findings only."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Investigator 3: "Investigate hypothesis 3: [hypothesis]. DO NOT FIX. Report findings only."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent DOCS: "Document all investigation findings in real-time."
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md
```
3. For confirmed causes, make ONE fix, test
4. Log attempt: `| 1 | [what] | [result] | [time] |` -> .tk/debug/attempts.md
5. If still fails after 3 attempts -> escalate to medium

**MEDIUM (deeper investigation + fix strategies):**
Launch 5 investigator SubAgents + 3 fixer SubAgents + Validator:
```
Phase 1 - Investigate:
SubAgent Investigator 1-3: Same as LIGHT
SubAgent Investigator 4: "Fresh eyes investigation - ignore hypotheses, find root cause."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Investigator 5: "Trace error through entire call stack, identify all affected code."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent DOCS: Document session in real-time
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md

Phase 2 - Fix (for confirmed causes):
SubAgent Fixer A: "Conventional fix - minimal change to resolve issue."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Fixer B: "Restructure approach - fix root cause, not symptom."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Fixer C: "Simplify approach - reduce complexity to eliminate bug class."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Validator: "Verify all proposed fixes against codebase patterns and test coverage."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```
If all approaches fail -> escalate to heavy

**HEAVY (maximum investigation + cross-validation):**
```
Phase 1 - Investigate (8 parallel):
SubAgent Investigator 1-5: Same as MEDIUM
SubAgent Investigator 6: "Analyze git history for when bug was introduced."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Investigator 7: "Check for similar bugs in codebase or dependencies."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Investigator 8: "Review related tests - what's missing? What should catch this?"
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent DOCS: Document all attempts in real-time
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md

Phase 2 - Cross-validate findings:
SubAgent Cross-validator 1: "Verify Investigator 1-4 findings. Confirm or refute."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Cross-validator 2: "Verify Investigator 5-8 findings. Confirm or refute."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

Phase 3 - Fix (multiple approaches + verification):
SubAgent Fixer A-C: Same as MEDIUM
SubAgent Fixer D: "Defensive fix - add guards and validation to prevent recurrence."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Fix-Verifier 1: "Verify proposed fixes don't introduce regressions."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Fix-Verifier 2: "Write test cases that would have caught this bug."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

Phase 4 - Nuclear options (if all else fails):
- rm -rf node_modules && npm install
- git bisect to find breaking commit
- Fresh clone test
- Revert to known good
```

### 4. Completion (when fixed)

```bash
# Verify
$FAILING_COMMAND && npm test && npm run typecheck

# Capture gotcha
cat >> AGENTS.md << EOF
### Gotcha: [issue] ($(date +%Y-%m-%d))
**Symptom:** [what you see]
**Root cause:** [why]
**Fix:** [solution]
EOF

# Log to .tk/planning/ISSUES.md as resolved
# Update .tk/planning/STATE.md, .tk/planning/HISTORY.md
git add AGENTS.md .tk/planning/ && git commit -m "docs: add gotcha for [issue]"
```

Report: Issue, root cause, fix, duration, attempts, "gotcha documented"
