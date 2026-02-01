# Changelog

All notable changes to TK will be documented in this file.

---

## [1.0.0] - 2025-02-01

### Added
- Initial release of TK (Token Killer)
- 14 commands: map, build, design, debug, qa, review, clean, doc, deploy, init, resume, learn, status, help
- 3 modes: light, medium, heavy
- Heavy mode with parallel SubAgents + DOCS agent
- `/tk:build` 7-phase workflow (Discovery → Exploration → Questions → Architecture → Implementation → Review → Summary)
- `/tk:qa` security vulnerability scanning (injection, XSS, secrets, npm audit)
- `/tk:design` distinctive UI creation (anti-AI-slop)
- Token usage tracking
- One-line installer script
- NPM package support
- MCP (Model Context Protocol) integration

### Integrated Patterns From
- [Get Shit Done](https://github.com/glittercowboy/get-shit-done) - Context engineering, multi-agent orchestration
- [Ralph](https://github.com/snarktank/ralph) - Autonomous loops, fresh context patterns
- [feature-dev](https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev) - 7-phase workflow, specialized agents
- [security-guidance](https://github.com/anthropics/claude-code/tree/main/plugins/security-guidance) - Vulnerability scanning
- [frontend-design](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design) - Distinctive UI principles

### Token Reduction
- ~79% fewer tokens compared to source implementations
- Condensed prompts, removed redundancy, lazy-loading patterns
