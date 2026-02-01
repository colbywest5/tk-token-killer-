---
name: tk:tokens
description: Show TK command file sizes and estimated token counts
allowed-tools:
  - Bash
---

# /tk:tokens

Show actual file sizes and estimated token counts for TK commands.

## Process

Detect OS and calculate real file sizes (~4 characters = 1 token):

```bash
echo "TK Command Sizes"
echo "================"
echo ""
printf "%-15s %8s %10s\n" "Command" "Bytes" "~Tokens"
printf "%-15s %8s %10s\n" "-------" "-----" "-------"

# Find TK commands directory
if [ -d "$HOME/.claude/commands/tk" ]; then
    TK_DIR="$HOME/.claude/commands/tk"
elif [ -d "$USERPROFILE/.claude/commands/tk" ]; then
    TK_DIR="$USERPROFILE/.claude/commands/tk"
elif [ -d ".claude/commands/tk" ]; then
    TK_DIR=".claude/commands/tk"
else
    echo "TK commands not found"
    exit 1
fi

# Calculate sizes
total_bytes=0
for file in "$TK_DIR"/*.md; do
    [ -f "$file" ] || continue
    name=$(basename "$file" .md)
    bytes=$(wc -c < "$file" | tr -d ' ')
    tokens=$((bytes / 4))
    total_bytes=$((total_bytes + bytes))
    printf "%-15s %8s %10s\n" "$name" "$bytes" "~$tokens"
done | sort -t$'\t' -k2 -rn

echo ""
echo "---------------------------------------"
total_tokens=$((total_bytes / 4))
printf "%-15s %8s %10s\n" "TOTAL" "$total_bytes" "~$total_tokens"
echo ""
echo "Note: ~4 chars = 1 token (rough estimate)"
```

## What This Shows

- **Bytes**: Actual file size on disk
- **~Tokens**: Rough estimate (actual tokenization varies)

## Context Usage

When you run a TK command:
1. `_shared.md` loads (~900 tokens)
2. Command file loads (varies)
3. Your codebase context
