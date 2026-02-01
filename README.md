<div align="center">

# TK

**Token-optimized commands for Claude Code**

*~79% fewer tokens. Same capabilities.*

<br>

![TK Terminal](assets/terminal.svg)

<br>

</div>

---

## Why This Exists

AI coding tools burn through tokens fast. Most prompts are bloated with redundant instructions, verbose documentation, and unnecessary context. When your context window fills up, Claude starts forgetting things and producing worse code. This is **context rot**.

The best AI coding workflows—[Get Shit Done](https://github.com/glittercowboy/get-shit-done), [Ralph](https://github.com/snarktank/ralph), Anthropic's official plugins—are genuinely excellent. But they're written for readability, not efficiency.

**TK fixes that.** It takes the best patterns from 5 different systems, strips the redundancy, and delivers the same power with dramatically fewer tokens.

---

## Commands

<div align="center">

![TK Workflow](assets/workflow.svg)

</div>

<br>

### Core Workflow

| Command | What it does |
|---------|--------------|
| `/tk:map` | **Run this first.** Scans your codebase, creates `AGENTS.md` with project context, sets up `.planning/` directory. All other commands depend on this. |
| `/tk:build` | Builds features using a 7-phase workflow: Discovery → Codebase Exploration → Clarifying Questions → Architecture Design → Implementation → Quality Review → Summary |
| `/tk:qa` | Tests your code. Includes security vulnerability scanning for injection attacks, XSS, hardcoded secrets, and more. |
| `/tk:deploy` | Deploys to production with pre-flight checks and post-deploy verification. Auto-rollback on failure. |

### Quality & Maintenance

| Command | What it does |
|---------|--------------|
| `/tk:debug` | Systematic debugging. Forms hypotheses, tests them one at a time, reverts failed attempts. Escalates automatically when stuck. |
| `/tk:review` | Code review with 4 parallel reviewers checking correctness, security, performance, and conventions. Only reports high-confidence issues. |
| `/tk:clean` | Removes dead code, unused dependencies, console.logs. Refactors for clarity. |
| `/tk:design` | Creates distinctive frontend interfaces. Enforces unique typography, bold color choices, and intentional motion—no generic AI aesthetics. |

### Utilities

| Command | What it does |
|---------|--------------|
| `/tk:doc` | Generates documentation: README, API docs, architecture diagrams, inline comments. |
| `/tk:init` | Scaffolds a new project with your preferred stack, tooling, and CI/CD configuration. |
| `/tk:resume` | Picks up where you left off if work was interrupted. |
| `/tk:learn` | Captures gotchas, patterns, and decisions so future commands know about them. |
| `/tk:status` | Quick health check: git state, tests, types, build, dependencies. |
| `/tk:help` | Shows all commands and usage. |

---

## Modes

Every command supports three modes:

| Mode | When to use | What happens |
|------|-------------|--------------|
| `light` | Quick fixes, simple tasks | Fast execution, minimal questions, no SubAgents |
| `medium` | Standard features | Balanced approach, 2-3 clarifying questions, structured workflow |
| `heavy` | Complex features, thorough analysis | Full workflow with parallel SubAgents + dedicated DOCS agent |

**Example:**
```bash
/tk:build light    # Just build it, no questions
/tk:build medium   # Ask key questions, then build
/tk:build heavy    # Full 7-phase workflow with parallel agents
```

The system auto-suggests escalation. If `light` fails twice, it recommends `medium`. Trust it.

---

## Heavy Mode SubAgents

When you use `heavy` mode, TK spawns specialized SubAgents that work in parallel. Every operation includes a **DOCS agent** that documents in real-time.

| Command | SubAgents spawned |
|---------|-------------------|
| `map` | 6 mappers (structure, architecture, patterns, API, config, tech debt) + DOCS |
| `build` | 3 code-explorers → 3 code-architects → 3 code-reviewers + DOCS |
| `design` | 3 researchers + 4 specialists (structure, styling, motion, polish) + DOCS |
| `debug` | 4 investigators + 3 solution attempts + DOCS |
| `qa` | 6 specialists (security, edge cases, performance, accessibility, chaos, smoke) + DOCS |
| `review` | 4 reviewers (correctness, security, performance, maintainability) + DOCS |
| `clean` | 4 cleaners (dead code, dependencies, refactoring, organization) + DOCS |
| `deploy` | 4 pre-flight + 4 post-deploy verifiers + DOCS |

---

## `/tk:build` — The 7-Phase Workflow

When building features, TK follows a structured process:

### Phase 1: Discovery
Understands what you want to build. Creates a task list.

### Phase 2: Codebase Exploration
Spawns code-explorer agents to trace existing patterns, find similar features, and identify key files to read.

### Phase 3: Clarifying Questions
**This phase is mandatory.** The system identifies ambiguities—edge cases, error handling, integration points—and asks specific questions. It waits for your answers before proceeding.

### Phase 4: Architecture Design
Spawns code-architect agents with different approaches:
- **Minimal:** Smallest change, maximum reuse
- **Clean:** Maintainability, elegant abstractions
- **Pragmatic:** Balance of speed and quality

Presents trade-offs and recommends one. You choose.

### Phase 5: Implementation
After approval, implements the feature following the chosen architecture and codebase conventions.

### Phase 6: Quality Review
Spawns code-reviewer agents to check for bugs, quality issues, and convention violations. Only reports issues with ≥80% confidence.

### Phase 7: Summary
Documents what was built, decisions made, and files modified.

---

## `/tk:qa` — Security Scanning

QA mode includes vulnerability detection for:

| Vulnerability | What TK checks |
|---------------|----------------|
| Command injection | `exec()`, `child_process`, `os.system()` |
| Code injection | `eval()`, `new Function()` |
| XSS | `innerHTML`, `dangerouslySetInnerHTML`, `document.write()` |
| Deserialization | `pickle` (Python) |
| GitHub Actions injection | `${{ }}` in `run:` blocks |
| Secrets exposure | Hardcoded passwords, API keys |
| Dependencies | `npm audit` vulnerabilities |

For each finding, TK provides the safe alternative.

---

## Files Created

After running `/tk:map`, your project gets:

```
AGENTS.md              # Project knowledge base—stack, patterns, gotchas
.planning/
├── STATE.md           # Current work state (for /tk:resume)
├── HISTORY.md         # Work log
├── ISSUES.md          # Known issues (from QA)
├── PATTERNS.md        # Discovered patterns
├── DECISIONS.md       # Architectural decisions with rationale
├── CODEBASE.md        # File and module map
└── ARCHITECTURE.md    # System design with diagrams
```

All commands read from and write to these files. This is how context persists.

---

## Installation

```bash
git clone https://github.com/colbywest5/tk-Claude-Skill.git
cd tk-Claude-Skill

# Global install (all projects)
cp tk.md ~/.claude/commands/
cp -r commands/ ~/.claude/commands/tk/

# Or local install (current project)
mkdir -p .claude/commands
cp tk.md .claude/commands/
cp -r commands/ .claude/commands/tk/
```

Restart Claude Code, then run `/tk:help` to verify.

---

## Usage

```bash
# First time on a project
/tk:map heavy

# Build a feature
/tk:build medium Add user authentication with OAuth

# Debug an issue
/tk:debug light The API returns 500 on large payloads

# Before deploying
/tk:qa heavy
/tk:review medium

# Deploy
/tk:deploy medium

# Capture what you learned
/tk:learn Gotcha: Prisma needs explicit disconnect in serverless
```

---

## Tips

1. **Always `/tk:map` first** — other commands depend on the context it creates

2. **Start with `light`** — escalate only when needed

3. **Use `/tk:learn`** — capture gotchas immediately so they're not repeated

4. **Check `/tk:status`** — quick sanity check before starting work

5. **Trust the escalation** — if the system suggests `medium`, it's usually right

---

## Credits

TK combines patterns from:

| Source | What we integrated |
|--------|-------------------|
| [Get Shit Done](https://github.com/glittercowboy/get-shit-done) | Context engineering, multi-agent orchestration, atomic commits |
| [Ralph](https://github.com/snarktank/ralph) | Autonomous loops, fresh context per iteration, AGENTS.md patterns |
| [feature-dev](https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev) | 7-phase workflow, code-explorer/architect/reviewer agents |
| [security-guidance](https://github.com/anthropics/claude-code/tree/main/plugins/security-guidance) | Vulnerability scanning patterns |
| [frontend-design](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design) | Distinctive UI principles |

---

## Contributing

Found a way to reduce tokens further? PRs welcome.

---

## License

MIT
