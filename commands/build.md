---
name: tk:build
description: Build something. /tk build light|medium|heavy <what to build>
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
  - WebSearch
  - WebFetch
---

# /tk build <mode> <message>

Build what $MESSAGE describes.

## Process

### 1. Pre-flight (from _shared.md)
### 2. Load Context
```bash
cat AGENTS.md
[ -f ".planning/CODEBASE.md" ] && cat .planning/CODEBASE.md
[ -f ".planning/PATTERNS.md" ] && cat .planning/PATTERNS.md
```

### 3. Understand

**LIGHT:** Accept $MESSAGE as-is, no questions, skip to planning
**MEDIUM:** 2-3 clarifying questions (scope, tech preferences, key features)
**HEAVY:** Deep questioning (goals, users, constraints, edge cases, security, performance)

### 4. Research (heavy only)

```
Spawn simultaneously:
SubAgent 1: Best practices for [project type]
SubAgent 2: [Framework] patterns and architecture
SubAgent 3: Common pitfalls for [project type]
SubAgent 4: Libraries/tools for [requirements]
SubAgent DOCS: Summarize research to .planning/RESEARCH.md
```

### 5. Plan

**LIGHT:** Quick task list in .planning/TASKS.md
**MEDIUM/HEAVY:** Detailed plan with acceptance criteria, update STATE.md with tasks

### 6. Execute

For each task:
1. Update STATE.md activeTask
2. Create git checkpoint
3. Execute:
   - **LIGHT:** Direct implementation
   - **MEDIUM:** With tests, clear commits
   - **HEAVY:** SubAgent per task + DOCS
4. Test: `npm test`, `npm run typecheck`
5. Commit: `git commit -m "feat: $TASK_NAME"`
6. Mark complete in STATE.md
7. Capture any patterns/gotchas learned

**HEAVY parallel execution:**
- Group tasks by dependencies
- Spawn SubAgents per group + DOCS SubAgent
- Wait, then next group

### 7. Escalation Triggers
- LIGHT→MEDIUM: 2+ failures, unexpected complexity
- MEDIUM→HEAVY: 3+ failures, security/perf concerns, multiple systems

### 8. Completion
```bash
# Update STATE.md (clear active), HISTORY.md (log success)
# Update CODEBASE.md with new files
git add .planning/ AGENTS.md && git commit -m "docs: update after build"
```

Report: Tasks completed, commits made, patterns discovered, how to test
