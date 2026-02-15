---
name: tk:build
description: Build something with structured workflow. /tk:[$cmd] light|medium|heavy <what to build>
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
  - WebSearch
  - WebFetch
---

$import(commands/tk/_shared.md)

# TK v2.0.0 | /tk:build [mode]

## STEP 0: LOAD RULES + VERSION (SILENT)

Before ANY action:
1. Silently load .tk/RULES.md - follow constantly
2. Read .tk/VERSION - get current project version
3. Display: `Building... (v{CURRENT_VERSION})`

Build what $MESSAGE describes using a structured 7-phase workflow.

## On Completion

After successful build:
1. Bump version (new feature = MINOR, small fix = PATCH)
2. Update .tk/VERSION with new version + history entry
3. Display: `Complete. v{OLD} -> v{NEW}`

## Core Principles
- **Ask clarifying questions**: Identify ambiguities BEFORE implementation
- **Understand before acting**: Read existing code patterns first
- **Read files identified by agents**: Build deep context before proceeding
- **Simple and elegant**: Prioritize readable, maintainable code

## Process

### Phase 1: Discovery
**Goal:** Understand what needs to be built

- Create todo list with all phases
- If unclear, ask: What problem? What should it do? Constraints?
- Summarize understanding and confirm with user

**LIGHT:** 2-3 clarifying questions
**MEDIUM:** Full requirements gathering
**HEAVY:** Full requirements gathering + follow-up questions

### Phase 2: Codebase Exploration
**Goal:** Understand relevant existing code and patterns

**LIGHT:** Launch 3 code-explorer SubAgents in parallel:
```
SubAgent Explorer 1: "Find features similar to [feature], trace implementation comprehensively. Return 5-10 key files to read."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Explorer 2: "Map architecture and abstractions for [area]. Return key files."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Explorer 3: "Analyze current implementation of [related feature]. Return key files."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```
After agents return: **READ ALL IDENTIFIED FILES** to build deep understanding.

**MEDIUM:** Launch 5 code-explorer SubAgents in parallel:
```
SubAgent Explorer 1-3: Same as LIGHT
SubAgent Explorer 4: "Find edge cases and error handling patterns. Return key files."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Explorer 5: "Analyze test patterns and coverage for [area]. Return key files."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**HEAVY:** Launch 8 code-explorer SubAgents in parallel:
```
SubAgent Explorer 1-5: Same as MEDIUM
SubAgent Explorer 6: "Deep-dive into dependencies and external integrations. Return key files."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Explorer 7: "Analyze performance patterns and bottlenecks. Return key files."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Explorer 8: "Review security patterns and potential vulnerabilities. Return key files."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

### Phase 3: Clarifying Questions
**Goal:** Fill gaps and resolve ALL ambiguities before design

**CRITICAL: DO NOT SKIP THIS PHASE**

Review codebase findings + original request. Identify underspecified aspects:
- Edge cases
- Error handling
- Integration points
- Scope boundaries
- Backward compatibility
- Performance needs

**Present ALL questions in organized list. WAIT for answers before Phase 4.**

If user says "whatever you think is best" -> provide recommendation, get explicit confirmation.

### Phase 4: Architecture Design
**Goal:** Design implementation approach

**LIGHT:** Launch 3 code-architect SubAgents with different focuses:
```
SubAgent Architect 1 (Minimal): "Smallest change, maximum reuse. Design for [feature]."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Architect 2 (Clean): "Maintainability, elegant abstractions. Design for [feature]."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Architect 3 (Pragmatic): "Balance speed + quality. Design for [feature]."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**MEDIUM:** Launch 5 code-architect SubAgents + 1 Validator:
```
SubAgent Architect 1-3: Same as LIGHT
SubAgent Architect 4 (Performance): "Optimize for speed and efficiency. Design for [feature]."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Architect 5 (Extensibility): "Design for future growth and flexibility."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Validator: "Review all architect proposals, identify conflicts, gaps, and risks."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**HEAVY:** Launch 6 code-architect SubAgents + 2 Cross-validators + Devil's Advocate:
```
SubAgent Architect 1-5: Same as MEDIUM
SubAgent Architect 6 (Security): "Security-first design, threat modeling."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Cross-validator 1: "Verify Architect 1-3 proposals against codebase patterns."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Cross-validator 2: "Verify Architect 4-6 proposals against codebase patterns."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Devil's Advocate: "Challenge ALL proposals. Find flaws, edge cases, what could go wrong."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

Present comparison with trade-offs. **Form opinion on best fit.** Ask user which approach they prefer.

### Phase 5: Implementation
**Goal:** Build the feature

**DO NOT START WITHOUT USER APPROVAL** (all modes)

1. Update .tk/planning/STATE.md activeTask
2. Create git checkpoint before starting
3. Read all relevant files from Phase 2
4. Implement following chosen architecture
5. Follow codebase conventions strictly
6. Test: `npm test`, `npm run typecheck`
7. Commit: `git commit -m "feat: $TASK_NAME"`

**All modes - parallel execution:**
- Group tasks by dependencies
- SubAgent per task group + DOCS SubAgent
- DOCS documents in real-time: what, why, how, what changed
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md

### Phase 6: Quality Review
**Goal:** Ensure code is correct, simple, DRY, elegant

**LIGHT:** Launch 3 code-reviewer SubAgents:
```
SubAgent Reviewer 1 (Quality): "Review for simplicity, DRY, elegance. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Reviewer 2 (Bugs): "Review for bugs, logic errors, edge cases. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Reviewer 3 (Conventions): "Review for project conventions, patterns. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**MEDIUM:** Launch 5 code-reviewer SubAgents + 1 Validator:
```
SubAgent Reviewer 1-3: Same as LIGHT
SubAgent Reviewer 4 (Security): "Review for security vulnerabilities. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Reviewer 5 (Performance): "Review for performance issues. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Validator: "Cross-check all reviewer findings, identify false positives."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**HEAVY:** Launch 6 code-reviewer SubAgents + 2 Cross-validators:
```
SubAgent Reviewer 1-5: Same as MEDIUM
SubAgent Reviewer 6 (Maintainability): "Review for long-term maintainability. Only report confidence >=80."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Cross-validator 1: "Verify reviewer findings against actual code."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Cross-validator 2: "Fresh eyes review - find issues reviewers missed."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

Consolidate findings. **Present to user:** fix now, fix later, or proceed as-is.

### Phase 7: Summary
**Goal:** Document what was accomplished

```bash
# Update .tk/planning/STATE.md, .tk/planning/HISTORY.md
# Capture patterns/gotchas learned -> AGENTS.md
git add .tk/planning/ AGENTS.md && git commit -m "docs: update after build"
```

Report:
- What was built
- Key decisions made
- Files modified
- Suggested next steps

## Escalation Triggers
- **LIGHT->MEDIUM:** 2+ failures, unexpected complexity, user confusion
- **MEDIUM->HEAVY:** 3+ failures, security/perf concerns, multiple interacting systems
