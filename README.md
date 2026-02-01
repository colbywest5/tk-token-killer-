# TK - Token Killer

**79% token reduction** while maintaining full capabilities.

A token-optimized command system for Claude Code / AI coding assistants. Originally based on worksmith patterns, compressed from ~133KB to ~33KB without losing any functionality.

## Quick Start

```bash
/tk map heavy    # Map your project first (creates context)
/tk build medium Add user authentication
/tk debug light  The API returns 500 errors
```

## Commands

| Command | Purpose |
|---------|---------|
| `map` | Map project, create context **(RUN FIRST)** |
| `build` | Build/create something |
| `design` | Create distinctive frontend interfaces |
| `debug` | Fix a problem |
| `qa` | Test something |
| `review` | Code review |
| `clean` | Cleanup codebase |
| `doc` | Generate documentation |
| `deploy` | Deploy to production |
| `init` | Initialize new project |
| `resume` | Resume interrupted work |
| `learn` | Capture a learning |
| `status` | Show project status |
| `help` | Show help |

## Modes

| Mode | Description | SubAgents |
|------|-------------|-----------|
| `light` | Fast, minimal interaction | No |
| `medium` | Balanced, key decisions | Optional |
| `heavy` | Comprehensive, parallel work | Yes + DOCS |

## Heavy Mode SubAgents

Every heavy mode operation includes a dedicated **DOCS SubAgent** that documents in real-time:

| Command | SubAgents |
|---------|-----------|
| map | 6 mappers + DOCS |
| build | Research + task workers + DOCS |
| design | 3 research + 4 specialists + DOCS |
| debug | 4 investigators + 3 fixers + DOCS |
| qa | 5 specialists + DOCS |
| review | 4 reviewers + DOCS |
| clean | 4 cleaners + DOCS |
| deploy | 4 pre-flight + 4 post-deploy + DOCS |

## Key Files Created

```
AGENTS.md              # Master project knowledge
.planning/
├── STATE.md           # Current work state
├── HISTORY.md         # Work log
├── ISSUES.md          # Known issues
├── PATTERNS.md        # Discovered patterns
├── DECISIONS.md       # Decision log
├── CODEBASE.md        # File map
└── ARCHITECTURE.md    # System design
```

## Installation

Copy `tk.md` and the `commands/` folder to your project or Claude Code commands directory.

## File Structure

```
tk.md                  # Main router (1.6 KB)
commands/
├── _shared.md         # Shared behaviors (2.4 KB)
├── map.md             # Map project (2.6 KB)
├── build.md           # Build features (2.1 KB)
├── design.md          # Frontend design (4.9 KB)
├── debug.md           # Debug problems (2.4 KB)
├── qa.md              # QA testing (2.0 KB)
├── review.md          # Code review (2.1 KB)
├── clean.md           # Cleanup (1.9 KB)
├── doc.md             # Documentation (1.6 KB)
├── deploy.md          # Deployment (2.3 KB)
├── init.md            # New project (1.9 KB)
├── resume.md          # Resume work (0.9 KB)
├── learn.md           # Capture learnings (1.2 KB)
├── status.md          # Project status (0.9 KB)
└── help.md            # Help reference (1.9 KB)
```

**Total: ~33KB** (down from ~133KB original)

## Integrations

Built with patterns from:
- Anthropic's [frontend-design](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design) skill
- Anthropic's [feature-dev](https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev) plugin
- Anthropic's [security-guidance](https://github.com/anthropics/claude-code/tree/main/plugins/security-guidance) plugin

## License

MIT
