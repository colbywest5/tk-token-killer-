---
name: tk:sync
description: View and manage multi-agent coordination
allowed-tools:
  - Read
  - Write
  - Bash
---

# /tk:sync

View and manage coordination across multiple Claude Code instances and agents.

## Usage

```
/tk:sync              # Show status of all active agents
/tk:sync cleanup      # Remove stale locks and dead agents
/tk:sync logs         # Show recent activity across all agents
/tk:sync merge        # Merge all agent findings to AGENTS.md
```

## Show Status

Display all active agents and what they're working on:

```bash
echo "=== TK Multi-Agent Status ==="
echo ""

# Show coordination file
if [ -f ".tk/COORDINATION.md" ]; then
    echo "## Active Agents"
    cat .tk/COORDINATION.md | tail -20
else
    echo "No agents registered yet."
fi

echo ""
echo "## Agent Logs"
for agent in .tk/agents/*.md; do
    [ -f "$agent" ] || continue
    name=$(basename "$agent" .md)
    heartbeat=$(cat ".tk/agents/$name.heartbeat" 2>/dev/null || echo "0")
    now=$(date +%s)
    age=$((now - heartbeat))
    
    if [ $age -lt 120 ]; then
        status="ALIVE"
    else
        status="STALE ($age sec)"
    fi
    
    echo "### $name [$status]"
    tail -5 "$agent"
    echo ""
done

echo "## Active Locks"
ls -la .tk/locks/ 2>/dev/null || echo "No locks."
```

## Cleanup

Remove stale locks and dead agent registrations:

```bash
echo "Cleaning up stale agents and locks..."

# Remove locks older than 5 minutes
find .tk/locks -type d -mmin +5 -exec rm -rf {} \; 2>/dev/null

# Archive old agent logs (older than 1 hour)
mkdir -p .tk/agents/archive
find .tk/agents -maxdepth 1 -name "*.md" -mmin +60 -exec mv {} .tk/agents/archive/ \; 2>/dev/null

# Remove stale heartbeats
find .tk/agents -name "*.heartbeat" -mmin +5 -delete 2>/dev/null

echo "Done."
```

## Show Logs

Show recent activity across all agents:

```bash
echo "=== Recent Activity (last 50 entries) ==="
echo ""

# Combine all agent logs with timestamps
for agent in .tk/agents/*.md; do
    [ -f "$agent" ] || continue
    name=$(basename "$agent" .md)
    grep "^\[" "$agent" | sed "s/^/[$name] /"
done | sort | tail -50
```

## Merge Findings

Merge all agent findings into AGENTS.md:

```bash
echo "Merging agent findings to AGENTS.md..."

# Acquire lock
wait_for_lock "AGENTS.md"

# Add header
echo -e "\n\n## Agent Findings ($(date +%Y-%m-%d %H:%M))\n" >> AGENTS.md

# Extract findings from each agent
for agent in .tk/agents/*.md; do
    [ -f "$agent" ] || continue
    name=$(basename "$agent" .md)
    
    # Look for sections marked as findings
    findings=$(grep -A5 "### Finding\|### Gotcha\|### Pattern" "$agent" 2>/dev/null)
    
    if [ -n "$findings" ]; then
        echo "### From $name" >> AGENTS.md
        echo "$findings" >> AGENTS.md
        echo "" >> AGENTS.md
    fi
done

# Release lock
release_lock "AGENTS.md"

echo "Done. Check AGENTS.md for merged findings."
```

## File Structure

```
.tk/
├── COORDINATION.md      # Who's working on what
├── VERSION              # TK version
├── RULES.md             # Project rules
├── locks/               # Lock directories
│   ├── AGENTS.md.lock/
│   │   ├── owner        # Agent ID holding lock
│   │   └── time         # When acquired
│   └── STATE.md.lock/
└── agents/              # Per-agent state
    ├── mac1-123-456.md  # Agent log
    ├── mac1-123-456.heartbeat
    ├── mac2-789-012.md
    └── archive/         # Old agent logs
```

## Best Practices for Vibe Coding

1. **Run `/tk:sync` periodically** to see what all agents are doing
2. **Run `/tk:sync cleanup`** if you see stale locks
3. **Run `/tk:sync merge`** after a big session to consolidate learnings
4. **Each agent documents immediately** to its own file (no waiting)
5. **Shared files use locks** so no overwrites
6. **Append, don't overwrite** for logs and history
