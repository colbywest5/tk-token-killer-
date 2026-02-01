---
name: tk:help
description: Show command reference
allowed-tools:
  - Bash
---

# /tk help

```
╔═══════════════════════════════════════════════════════════════╗
║  /tk <task> <mode> <message>                                ║
╚═══════════════════════════════════════════════════════════════╝

CONTEXT (run first!)
  map       Map project, create AGENTS.md and .planning/

BUILD
  build     Build/create something
  design    Create distinctive frontend interfaces
  init      Initialize new project

QUALITY
  qa        Run tests (smoke → full → specialists)
  review    Code review (quick → thorough → parallel)
  clean     Cleanup (console.logs → dead code → refactor)

TROUBLESHOOTING
  debug     Fix problems (2 attempts → hypotheses → parallel)

UTILITIES
  doc       Generate documentation
  deploy    Deploy (just deploy → verify → full pipeline)
  status    Project health (no mode)
  resume    Resume interrupted work
  learn     Capture gotcha/pattern/decision
  help      This help

MODES
  light     Fast, minimal interaction
  medium    Balanced, key decisions
  heavy     Comprehensive, parallel SubAgents + DOCS

HEAVY MODE SUBAGENTS
  map:    6 mappers + DOCS
  build:  3 explorers + 3 architects + 3 reviewers + DOCS
  design: 3 research + 4 specialists + DOCS
  debug:  4 investigators + 3 fixers + DOCS
  qa:     6 specialists (incl. Security) + DOCS
  review: 4 reviewers + DOCS
  clean:  4 cleaners + DOCS
  deploy: 4 pre-flight + 4 post-deploy + DOCS

KEY FILES
  AGENTS.md              Master project knowledge
  .planning/STATE.md     Current work state
  .planning/HISTORY.md   Work log
  .planning/ISSUES.md    Known issues
  .planning/PATTERNS.md  Discovered patterns
```
