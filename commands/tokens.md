---
name: tk:tokens
description: Show token usage estimates for TK commands
allowed-tools:
  - Bash
---

# /tk:tokens

Show estimated token savings compared to source implementations.

## Token Estimates

```
╔═══════════════════════════════════════════════════════════════════════╗
║                        TK TOKEN USAGE                                 ║
╠═══════════════════════════════════════════════════════════════════════╣
║  Command      │ TK Tokens  │ Original   │ Savings                     ║
╠═══════════════════════════════════════════════════════════════════════╣
║  /tk:map      │ ~650       │ ~3,500     │ 81%                         ║
║  /tk:build    │ ~1,100     │ ~5,200     │ 79%                         ║
║  /tk:design   │ ~1,200     │ ~4,800     │ 75%                         ║
║  /tk:debug    │ ~600       │ ~2,800     │ 79%                         ║
║  /tk:qa       │ ~1,600     │ ~6,500     │ 75%                         ║
║  /tk:review   │ ~550       │ ~2,100     │ 74%                         ║
║  /tk:clean    │ ~500       │ ~2,200     │ 77%                         ║
║  /tk:doc      │ ~400       │ ~1,800     │ 78%                         ║
║  /tk:deploy   │ ~580       │ ~2,400     │ 76%                         ║
║  /tk:init     │ ~480       │ ~2,300     │ 79%                         ║
╠═══════════════════════════════════════════════════════════════════════╣
║  _shared.md   │ ~620       │ ~3,200     │ 81%                         ║
╠═══════════════════════════════════════════════════════════════════════╣
║  TOTAL        │ ~8,280     │ ~36,800    │ ~78%                        ║
╚═══════════════════════════════════════════════════════════════════════╝

Notes:
- Tokens estimated using cl100k_base tokenizer
- "Original" = combined token count from source implementations
- Actual savings vary based on mode (light/medium/heavy)
- Heavy mode spawns SubAgents which have their own context

Token Calculation:
- TK loads _shared.md (~620 tokens) + command file
- Light mode: base tokens only
- Medium mode: +10-20% for additional prompts
- Heavy mode: SubAgents get fresh context windows

Cost Savings (at $3/1M input tokens):
- Per command: ~$0.00008 saved
- Per feature (map+build+qa+deploy): ~$0.0003 saved
- Per day (heavy usage, 50 commands): ~$0.004 saved
- Per month: ~$0.12 saved

The real value isn't cost—it's context window space.
More room = better quality output before degradation.
```
