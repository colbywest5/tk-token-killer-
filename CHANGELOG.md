# Changelog

All notable changes to TK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.1.0] - 2025-02-01

### Added
- `/tk:rules` - Set global rules for all agents (no emojis, no placeholders, etc.)
- `/tk:update` - Self-update from GitHub
- `/tk:opinion` - Honest project audit with actionable feedback
- Agent definitions in `agents/` folder
- Hook definitions in `hooks/` folder
- GitHub Actions release workflow
- CONTRIBUTING.md
- MAINTAINERS.md

### Changed
- `_shared.md` now loads and enforces rules from `.tk/RULES.md`
- Updated workflow.svg with all 18 commands
- Improved installation documentation

---

## [1.0.0] - 2025-02-01

### Added
- Initial release of TK (Toolkit)
- 16 commands: map, build, design, debug, qa, review, clean, doc, deploy, init, resume, learn, status, tokens, help
- 3 modes: light, medium, heavy
- Heavy mode with parallel SubAgents + DOCS agent
- `/tk:build` 7-phase workflow
- `/tk:qa` security vulnerability scanning
- `/tk:design` distinctive UI creation
- Token usage tracking
- One-line installer script
- NPM package support
- MCP integration
- Claude Code plugin structure

### Integrated Patterns From
- [Get Shit Done](https://github.com/glittercowboy/get-shit-done)
- [Ralph](https://github.com/snarktank/ralph)
- [feature-dev](https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev)
- [security-guidance](https://github.com/anthropics/claude-code/tree/main/plugins/security-guidance)
- [frontend-design](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design)
