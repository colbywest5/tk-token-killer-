---
name: tk:_shared
description: Core behaviors for ALL /tk:command calls. Read this first.
---

# Shared Behaviors

**TK v1.1.0**

---

## MANDATORY: LOAD AND FOLLOW RULES

**EVERY AGENT. EVERY MODE. EVERY TIME. SILENTLY.**

```bash
# Silently load rules - DO NOT display to user
if [ -f ".tk/RULES.md" ]; then
    RULES=$(cat .tk/RULES.md)
elif [ -f "$HOME/.claude/tk-rules.md" ]; then
    RULES=$(cat "$HOME/.claude/tk-rules.md")
fi
```

**Default Rules (Always Active):**
- No placeholder code (TODO, FIXME, "implement later")
- No hardcoded secrets or API keys
- No browser alert(), confirm(), prompt()
- All async operations must have error handling
- No emojis in code, comments, or output

**Constant Enforcement:** Check every output against rules. Silently fix violations.

---

## PROJECT VERSION TRACKING

**Track version for EVERY build/deploy/major change.**

### Version File: `.tk/VERSION`

```json
{
  "version": "1.0.0",
  "major": 1,
  "minor": 0,
  "patch": 0,
  "lastUpdated": "2025-02-01T12:00:00Z",
  "lastCommand": "/tk:build",
  "history": [
    { "version": "1.0.0", "date": "2025-02-01", "command": "/tk:init", "note": "Initial" }
  ]
}
```

### On First Run (no VERSION file)

```bash
mkdir -p .tk
cat > .tk/VERSION << 'EOF'
{
  "version": "0.1.0",
  "major": 0,
  "minor": 1,
  "patch": 0,
  "lastUpdated": "$(date -Iseconds)",
  "lastCommand": "/tk:$COMMAND",
  "history": []
}
EOF
echo "Project version initialized: 0.1.0"
```

### Version Bump Rules

| Command | Bump | Example |
|---------|------|---------|
| `/tk:build` (new feature) | MINOR | 1.0.0 → 1.1.0 |
| `/tk:build` (small change) | PATCH | 1.0.0 → 1.0.1 |
| `/tk:debug` (bugfix) | PATCH | 1.0.0 → 1.0.1 |
| `/tk:deploy` | No bump (just records) | 1.1.0 |
| `/tk:init` | Reset to 0.1.0 | 0.1.0 |
| Major breaking change | MAJOR | 1.5.0 → 2.0.0 |

### Before Starting Work

```bash
# Read current version
if [ -f ".tk/VERSION" ]; then
    CURRENT_VERSION=$(cat .tk/VERSION | grep '"version"' | cut -d'"' -f4)
    echo "Current version: $CURRENT_VERSION"
else
    # Initialize
    CURRENT_VERSION="0.1.0"
fi
```

### After Completing Work

```bash
# Determine bump type based on changes
# - New feature = MINOR
# - Bugfix/small change = PATCH
# - Breaking change = MAJOR

# Update VERSION file
# Add to history
# Log: "Version: X.Y.Z → X.Y.Z+1"
```

### Display in Output

Every build/deploy should show:
```
Version: 1.2.3 → 1.2.4
```

---

## Pre-Flight (EVERY command)

```bash
# 1. Load rules (silently)
# 2. Read project version
mkdir -p .tk/agents .tk/locks .planning

# 3. Generate agent ID
AGENT_ID="$(hostname)-$(date +%s)-$$-$RANDOM"

# 4. Register agent
echo "| $AGENT_ID | /tk:$COMMAND $MODE | $(date +%H:%M:%S) | WORKING |" >> .tk/COORDINATION.md

# 5. Create agent log
cat > ".tk/agents/$AGENT_ID.md" << EOF
# Agent: $AGENT_ID
Command: /tk:$COMMAND $MODE
Started: $(date -Iseconds)
Project Version: $CURRENT_VERSION
## Log
EOF

# 6. Check context
[ ! -f "AGENTS.md" ] && echo "No AGENTS.md - run /tk:map first"
```

---

## File Locking

```bash
acquire_lock() {
    mkdir -p .tk/locks
    mkdir ".tk/locks/$1.lock" 2>/dev/null && echo "$AGENT_ID" > ".tk/locks/$1.lock/owner"
}

release_lock() {
    rm -rf ".tk/locks/$1.lock"
}

wait_for_lock() {
    for i in $(seq 1 30); do
        acquire_lock "$1" && return 0
        sleep 1
    done
    return 1
}

safe_write() {
    wait_for_lock "$(basename $1)" || return 1
    echo "[$AGENT_ID $(date +%H:%M:%S)] $2" >> "$1"
    release_lock "$(basename $1)"
}
```

---

## On Completion

```bash
# Log completion
echo "[$(date +%H:%M:%S)] COMPLETED" >> ".tk/agents/$AGENT_ID.md"

# Update version (if applicable)
# build/debug = bump patch or minor
# Record in .tk/VERSION history

# Update coordination
echo "| $AGENT_ID | DONE | $(date +%H:%M:%S) |" >> .tk/COORDINATION.md
```

---

## Mode Behaviors

| Mode | Rules | Questions | SubAgents | Version |
|------|-------|-----------|-----------|---------|
| light | Silent | 0-1 | No | Bump patch |
| medium | Silent | 2-3 | Optional | Bump patch/minor |
| heavy | Silent | Full | Yes + DOCS | Bump minor |

---

## Escalation

- **light → medium:** After 2 failed attempts
- **medium → heavy:** After 3 failed hypotheses
