# TK Workflow Skill

A developer toolkit providing structured workflows for Claude Code.

## When to Use

This skill is automatically invoked when:
- User runs any `/tk:*` command
- Building features that need structured approach
- Debugging complex issues
- Reviewing code changes
- Deploying to production

## Core Principles

1. **Structure over chaos** - Use defined phases, not ad-hoc coding
2. **Ask before assuming** - Clarify requirements before implementation
3. **Document immediately** - Each agent logs to its own file
4. **Coordinate carefully** - Multiple agents use file locking
5. **Rules are enforced** - Check .tk/RULES.md before generating code

## Workflow Phases

### /tk:build (7 phases)
1. Discovery - Understand requirements
2. Exploration - Trace existing patterns
3. Questions - Resolve ambiguities (MANDATORY)
4. Architecture - Multiple approaches, you choose
5. Implementation - Build with conventions
6. Review - Check quality (≥80% confidence)
7. Summary - Document what changed

### /tk:debug
1. Reproduce - Confirm the issue
2. Hypothesize - Form theories
3. Test - One hypothesis at a time
4. Fix - Minimal change
5. Verify - Confirm fix works
6. Document - Capture the gotcha

### /tk:qa
1. Functional tests - Does it work?
2. Edge cases - What breaks it?
3. Security scan - Vulnerabilities?
4. Performance - Any bottlenecks?
5. Accessibility - Usable by everyone?

## Multi-Agent Coordination

When running heavy mode with multiple Claude Code instances:
- Each agent gets unique ID
- Logs to own file (.tk/agents/)
- Acquires locks before writing shared files
- Appends with timestamps, never overwrites
- Use /tk:sync to see all agents

## Files Created

```
AGENTS.md              # Project knowledge
.tk/
├── RULES.md           # Enforced rules
├── VERSION            # TK version
├── COORDINATION.md    # Active agents
└── agents/            # Per-agent logs
.planning/
├── STATE.md           # Current work
├── HISTORY.md         # What happened
├── DECISIONS.md       # Why we chose X
└── PATTERNS.md        # Reusable patterns
```
