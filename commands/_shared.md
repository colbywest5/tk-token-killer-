---
name: tk:_shared
description: Core behaviors for ALL /tk:command calls. Read this first.
---

# Shared Behaviors

Every command uses these patterns. Apply them automatically.

## Version

```
TK_VERSION=1.1.0
```

## Multi-Agent Coordination

**CRITICAL: TK supports multiple Claude Code instances with parallel agents.**

### Agent Identity

On EVERY command start, generate a unique agent ID:

```bash
AGENT_ID="$(hostname)-$(date +%s)-$$-$RANDOM"
echo "$AGENT_ID" > .tk/.agent-$AGENT_ID
```

### Coordination File

All agents register in `.tk/COORDINATION.md`:

```markdown
# Active Agents

| Agent ID | Command | Started | Status |
|----------|---------|---------|--------|
| mac1-1706812345-1234-5678 | /tk:build | 14:32:05 | WORKING |
| mac1-1706812350-2345-6789 | /tk:qa | 14:32:10 | WORKING |
```

### File Locking (Prevent Overwrites)

Before writing ANY shared file, acquire a lock:

```bash
LOCK_FILE=".tk/locks/$(echo $FILE | tr '/' '-').lock"
mkdir -p .tk/locks

# Try to acquire lock (atomic mkdir)
acquire_lock() {
    local lockdir=".tk/locks/$1.lock"
    if mkdir "$lockdir" 2>/dev/null; then
        echo "$AGENT_ID" > "$lockdir/owner"
        echo "$(date +%s)" > "$lockdir/time"
        return 0
    fi
    return 1
}

# Wait for lock with timeout
wait_for_lock() {
    local file="$1"
    local timeout=30
    local waited=0
    while ! acquire_lock "$file"; do
        sleep 1
        waited=$((waited + 1))
        if [ $waited -ge $timeout ]; then
            echo "LOCK TIMEOUT: $file held by $(cat .tk/locks/$file.lock/owner 2>/dev/null)"
            return 1
        fi
    done
    return 0
}

# Release lock
release_lock() {
    rm -rf ".tk/locks/$1.lock"
}
```

### Append-Only Logging

**NEVER overwrite shared logs. ALWAYS append with agent ID + timestamp.**

```bash
log_action() {
    local file="$1"
    local message="$2"
    wait_for_lock "$(basename $file)"
    echo "[$AGENT_ID $(date +%H:%M:%S)] $message" >> "$file"
    release_lock "$(basename $file)"
}

# Usage
log_action ".planning/HISTORY.md" "Started /tk:build - Add auth"
log_action ".planning/HISTORY.md" "Completed Phase 1: Discovery"
```

### Conflict Detection

Before reading shared files, check if modified since last read:

```bash
check_file_changed() {
    local file="$1"
    local last_hash="$2"
    local current_hash=$(md5sum "$file" 2>/dev/null | cut -d' ' -f1)
    if [ "$current_hash" != "$last_hash" ]; then
        echo "WARNING: $file changed by another agent. Re-reading..."
        return 1
    fi
    return 0
}
```

### State File Structure

Each agent maintains its own state:

```
.tk/
├── COORDINATION.md      # Who's working on what (append-only)
├── VERSION              # Current TK version
├── RULES.md             # Project rules
├── locks/               # Lock files (dirs)
│   ├── AGENTS.md.lock/
│   └── STATE.md.lock/
└── agents/              # Per-agent state
    ├── agent-abc123.md  # Agent ABC's notes
    └── agent-def456.md  # Agent DEF's notes
```

### Safe Write Pattern

ALL file writes MUST follow this pattern:

```bash
safe_write() {
    local file="$1"
    local content="$2"
    local lockname=$(echo "$file" | tr '/' '-')
    
    # 1. Acquire lock
    wait_for_lock "$lockname" || return 1
    
    # 2. Read current content
    local current=$(cat "$file" 2>/dev/null)
    
    # 3. Write to temp file first
    local tmpfile="$file.tmp.$AGENT_ID"
    echo "$content" > "$tmpfile"
    
    # 4. Atomic move
    mv "$tmpfile" "$file"
    
    # 5. Release lock
    release_lock "$lockname"
    
    # 6. Log the change
    log_action ".tk/COORDINATION.md" "Updated $file"
}
```

### Agent Heartbeat

Every 60 seconds, update heartbeat (so other agents know you're alive):

```bash
update_heartbeat() {
    echo "$(date +%s)" > ".tk/agents/$AGENT_ID.heartbeat"
}

# Check if agent is alive (no heartbeat in 2 min = dead)
is_agent_alive() {
    local agent="$1"
    local heartbeat=$(cat ".tk/agents/$agent.heartbeat" 2>/dev/null || echo "0")
    local now=$(date +%s)
    local age=$((now - heartbeat))
    [ $age -lt 120 ]
}
```

### Immediate Documentation Rule

**FIRST action of EVERY command:**

```
1. Generate AGENT_ID
2. Register in COORDINATION.md
3. Create agent-specific log: .tk/agents/$AGENT_ID.md
4. Log: "Starting [command] [mode] at [time]"
5. Log: "Task: [description]"
```

**DURING execution (every significant step):**

```
6. Log to agent file: "[time] [step]: [what happened]"
7. If modifying shared file: acquire lock, update, release, log
```

**ON completion:**

```
8. Log: "Completed at [time] - [outcome]"
9. Update COORDINATION.md status: DONE
10. Merge important findings to AGENTS.md (with lock)
11. Cleanup: remove lock files, update heartbeat
```

---

## Pre-Flight (run before any task)

```bash
# Create directories
mkdir -p .tk/locks .tk/agents .planning

# Generate agent ID
AGENT_ID="$(hostname | tr ' ' '-')-$(date +%s)-$$-$RANDOM"
export AGENT_ID

# Register agent
echo "| $AGENT_ID | /tk:$COMMAND | $(date +%H:%M:%S) | STARTING |" >> .tk/COORDINATION.md

# Create agent log
cat > ".tk/agents/$AGENT_ID.md" << EOF
# Agent: $AGENT_ID
Command: /tk:$COMMAND $MODE
Started: $(date -Iseconds)
Task: $MESSAGE

## Log
EOF

# Load rules
RULES=""
if [ -f ".tk/RULES.md" ]; then
    RULES=$(cat .tk/RULES.md)
fi

# Check context (don't fail, just warn)
[ ! -f "AGENTS.md" ] && echo "No AGENTS.md. Run /tk:map first."

# Start heartbeat
update_heartbeat
```

## Rules Enforcement

**ALL agents MUST check and follow `.tk/RULES.md` before generating any code or output.**

Default rules (always apply):
```
- No placeholder code (TODO, FIXME, "implement later")
- No hardcoded secrets or API keys
- No browser alert(), confirm(), prompt() popups
- All async operations must have error handling
- No emojis in code or commit messages
```

## State Tracking

**On start (use safe_write):**
```bash
# Log to agent file (no lock needed - agent owns it)
echo "[$(date +%H:%M:%S)] Starting: $MESSAGE" >> ".tk/agents/$AGENT_ID.md"

# Update shared state (with lock)
safe_write ".planning/STATE.md" "..."
```

**On completion:**
```bash
# Update agent status
echo "[$(date +%H:%M:%S)] COMPLETED: $OUTCOME" >> ".tk/agents/$AGENT_ID.md"

# Update coordination
sed -i "s/$AGENT_ID.*WORKING/$AGENT_ID | ... | DONE/" .tk/COORDINATION.md

# Merge findings to AGENTS.md (if any)
if [ -n "$NEW_FINDINGS" ]; then
    wait_for_lock "AGENTS.md"
    echo -e "\n## [$AGENT_ID $(date +%Y-%m-%d)]\n$NEW_FINDINGS" >> AGENTS.md
    release_lock "AGENTS.md"
fi
```

## Git Commits (Conflict-Safe)

```bash
safe_commit() {
    local message="$1"
    
    # Pull latest first
    git pull --rebase 2>/dev/null || true
    
    # Stage and commit
    git add -A
    git commit -m "$message [$AGENT_ID]" --allow-empty
    
    # Push with retry
    for i in 1 2 3; do
        git push && return 0
        git pull --rebase
    done
    echo "WARNING: Push failed after 3 attempts"
}
```

## Escalation

- **light → medium:** After 2 failed attempts or unexpected complexity
- **medium → heavy:** After 3 failed hypotheses or multiple interacting systems

## DOCS SubAgent (heavy mode only)

Spawn with EVERY parallel group. DOCS agent writes to its own file first, then merges:

```
SubAgent DOCS [$AGENT_ID-docs]: "
  1. Create your own log: .tk/agents/$AGENT_ID-docs.md
  2. Document in real-time to YOUR file (no locks needed)
  3. On completion, merge to shared files WITH LOCKS
  4. Never overwrite - always append with timestamps
"
```

## Mode Summary

| Mode | Interaction | SubAgents | Time |
|------|-------------|-----------|------|
| light | Minimal | No | Fast |
| medium | 2-3 questions | Optional | Balanced |
| heavy | Full interview | Yes + DOCS | Thorough |
