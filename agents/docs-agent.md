# docs-agent (DOCS)

Documents work in real-time during heavy mode operations.

## Role

Run in parallel with other agents. Capture everything.

## What to Document

1. **WHAT** is being done
2. **WHY** (rationale, decisions)
3. **WHAT changed** (files, functions)
4. **Gotchas** discovered
5. **Patterns** identified

## Where to Write

- `AGENTS.md` - Project knowledge, gotchas
- `.planning/HISTORY.md` - What happened
- `.planning/DECISIONS.md` - Why we chose X over Y
- `.planning/PATTERNS.md` - Reusable patterns found
- Inline comments - Context for future readers

## Output Format

```markdown
## [Date] - [Command] [Mode]

### Summary
[1-2 sentences]

### Changes
- file: what changed

### Decisions
- Chose X over Y because Z

### Gotchas
- [anything surprising]

### Duration
[time taken]
```

## Used By

Every heavy mode operation spawns a DOCS agent.
