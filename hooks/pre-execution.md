# pre-execution hook

Runs before any TK command executes.

## Trigger

Every `/tk:*` command (except /tk:help)

## Checks

1. **Load rules** from `.tk/RULES.md` or `~/.claude/tk-rules.md`
2. **Check context** - warn if AGENTS.md missing or stale
3. **Check state** - warn if active work in progress
4. **Create directories** - ensure `.planning/` and `.tk/` exist

## Implementation

```bash
# Create required directories
mkdir -p .planning .tk

# Load project rules (override global)
if [ -f ".tk/RULES.md" ]; then
    RULES=$(cat .tk/RULES.md)
elif [ -f "$HOME/.claude/tk-rules.md" ]; then
    RULES=$(cat "$HOME/.claude/tk-rules.md")
fi

# Context check
if [ ! -f "AGENTS.md" ]; then
    echo "Warning: No AGENTS.md. Run /tk:map first."
fi

# Freshness check
if [ -f "AGENTS.md" ]; then
    DAYS_OLD=$(( ($(date +%s) - $(stat -c %Y AGENTS.md 2>/dev/null || stat -f %m AGENTS.md)) / 86400 ))
    if [ $DAYS_OLD -gt 7 ]; then
        echo "Warning: Context is $DAYS_OLD days old. Consider /tk:map."
    fi
fi

# Active work check
if [ -f ".planning/STATE.md" ] && grep -q "activeTask:.*[^none]" .planning/STATE.md; then
    echo "Active work found. Resume or start fresh?"
fi
```

## Rules Applied

Default rules (always enforced):
- No placeholder code (TODO, FIXME)
- No hardcoded secrets
- No browser popups (alert/confirm/prompt)
- Error handling for async operations
- No emojis in code output
