---
name: tk:tokens
description: Show TK command file sizes and estimated token counts
allowed-tools:
  - Bash
---

# /tk:tokens

Show actual file sizes and estimated token counts for TK commands.

## Process

Calculate real file sizes and estimate tokens (~4 characters = 1 token):

### macOS / Linux

```bash
echo "TK Command Sizes"
echo "================"
echo ""
printf "%-15s %8s %10s\n" "Command" "Bytes" "~Tokens"
printf "%-15s %8s %10s\n" "-------" "-----" "-------"

for file in ~/.claude/commands/tk/*.md; do
    name=$(basename "$file" .md)
    bytes=$(wc -c < "$file" | tr -d ' ')
    tokens=$((bytes / 4))
    printf "%-15s %8s %10s\n" "$name" "$bytes" "~$tokens"
done | sort -t$'\t' -k2 -rn

echo ""
echo "---------------------------------------"
total_bytes=$(cat ~/.claude/commands/tk/*.md | wc -c | tr -d ' ')
total_tokens=$((total_bytes / 4))
printf "%-15s %8s %10s\n" "TOTAL" "$total_bytes" "~$total_tokens"
echo ""
echo "Note: Token estimate uses ~4 chars = 1 token (rough average)"
```

### Windows PowerShell

```powershell
Write-Host "TK Command Sizes" -ForegroundColor Cyan
Write-Host "================" -ForegroundColor Cyan
Write-Host ""

$files = Get-ChildItem "$env:USERPROFILE\.claude\commands\tk\*.md"
$results = foreach ($file in $files) {
    [PSCustomObject]@{
        Command = $file.BaseName
        Bytes = $file.Length
        '~Tokens' = [math]::Round($file.Length / 4)
    }
}

$results | Sort-Object Bytes -Descending | Format-Table -AutoSize

$totalBytes = ($files | Measure-Object -Property Length -Sum).Sum
$totalTokens = [math]::Round($totalBytes / 4)

Write-Host "---------------------------------------"
Write-Host "TOTAL: $totalBytes bytes (~$totalTokens tokens)"
Write-Host ""
Write-Host "Note: Token estimate uses ~4 chars = 1 token (rough average)" -ForegroundColor DarkGray
```

## What This Shows

- **Bytes**: Actual file size on disk
- **~Tokens**: Rough estimate (actual tokenization varies by model)

## Context

When you run a TK command:
1. `_shared.md` is loaded (~2,000 tokens)
2. The specific command file is loaded
3. Total context = shared + command + your codebase

## Tips

- Smaller files = faster loading, more room for your code
- Heavy mode spawns SubAgents with fresh context each
- Use `light` mode for quick tasks to minimize overhead
