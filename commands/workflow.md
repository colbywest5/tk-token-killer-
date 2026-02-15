---
name: tk:workflow
description: Generate visual workflow documentation. /tk:workflow light|medium|heavy [context]
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - WebSearch
---

# /tk:workflow [mode] [context]

Generate comprehensive, self-contained HTML documentation with visual workflow diagrams, OSI model analysis, analytical charts, and dual-view output (Full + Executive). Perfect for team understanding, onboarding, and executive briefings.

---

## Audience Modes

| Flag | What to Show | What to Hide |
|------|--------------|--------------|
| (default) | Everything (internal documentation) | Only secrets |
| `--audience:customer` | User-facing features, frontend, UX flows | Backend, database, API internals, server architecture |
| `--audience:executive` | High-level overview, metrics, recommendations | Implementation details, code specifics |

**Usage:**
```
/tk:workflow heavy --audience:customer How does checkout work?
/tk:workflow medium --audience:executive Document the payment system
```

**When `--audience:customer` is active:**
- Hide all backend implementation details
- Hide database schemas, API internals, server architecture
- Focus on: user-facing features, frontend flows, what customers see/experience
- Still show: frontend architecture, user journeys, feature descriptions
- Redact: anything technical that customers shouldn't see

**When `--audience:executive` is active:**
- Show high-level system overview and business metrics
- Show recommendations with business impact
- Hide implementation details and code specifics
- Focus on: what it does, why it matters, what to improve

---

## CRITICAL RULES (READ FIRST)

### 1. SVG BLACK BOX PREVENTION

**BLACK BOXES IN SVG OUTPUT ARE UNACCEPTABLE.**

Before writing ANY SVG element, follow this checklist:

```
PRE-OUTPUT SVG CHECKLIST (MANDATORY):
[ ] Every <path> has fill="none" if it's a line/stroke
[ ] Every <path> that IS a shape has an explicit fill color
[ ] Every <rect> has an explicit fill attribute
[ ] Every <circle> has an explicit fill attribute
[ ] Every <polygon> has an explicit fill attribute
[ ] Every <ellipse> has an explicit fill attribute
[ ] No path d="" attributes are left incomplete
[ ] All paths that should be closed end with Z
[ ] No elements rely on default black fill
```

**THE FIX IS SIMPLE:** Add `fill="none"` to EVERY line/connector/arrow path. Add explicit `fill="#color"` to EVERY shape.

**Examples of CORRECT SVG:**
```svg
<!-- LINE: Must have fill="none" -->
<path d="M10 10 L100 50" stroke="#64748b" stroke-width="2" fill="none"/>

<!-- ARROW: Must have fill="none" on path -->
<path d="M10 10 L90 10" stroke="#64748b" stroke-width="2" fill="none"/>
<polygon points="90,5 100,10 90,15" fill="#64748b"/>

<!-- SHAPE: Must have explicit fill color -->
<rect x="10" y="10" width="100" height="50" fill="#3b82f6" rx="4"/>
<circle cx="50" cy="50" r="20" fill="#22c55e"/>
```

**Examples of WRONG SVG (causes black boxes):**
```svg
<!-- WRONG: Missing fill="none" - will render black -->
<path d="M10 10 L100 50" stroke="#64748b" stroke-width="2"/>

<!-- WRONG: Missing fill attribute - will render black -->
<rect x="10" y="10" width="100" height="50"/>

<!-- WRONG: Incomplete path - unpredictable rendering -->
<path d="M10 10 L100 50 L100 100" stroke="#64748b"/>
```

**VALIDATION STEP:** After generating any SVG, mentally trace each element and verify it has the correct fill attribute. If in doubt, add `fill="none"`.

---

### 2. SECRETS REDACTION (SECURITY)

**NEVER expose secrets, credentials, or sensitive data in documentation.**

This documentation is for internal use and should be detailed, BUT must redact:

| Type | Example | Redact To |
|------|---------|-----------|
| API Keys | `sk-1234567890abcdef` | `[API_KEY_REDACTED]` |
| Passwords | `myP@ssw0rd123` | `[PASSWORD_REDACTED]` |
| Tokens | `ghp_xxxxxxxxxxxx` | `[TOKEN_REDACTED]` |
| Connection Strings | `mongodb://user:pass@host` | `mongodb://[CREDENTIALS]@host` |
| Private Keys | `-----BEGIN RSA PRIVATE KEY-----` | `[PRIVATE_KEY_REDACTED]` |
| AWS Keys | `AKIA...` | `[AWS_KEY_REDACTED]` |
| Database Passwords | `DB_PASS=secret` | `DB_PASS=[REDACTED]` |
| JWT Secrets | `JWT_SECRET=xxx` | `JWT_SECRET=[REDACTED]` |
| Usernames (service accounts) | `admin_sa_prod` | Keep if non-sensitive, redact if reveals infrastructure |

**What TO include (be detailed):**
- Environment variable NAMES (not values)
- Configuration file STRUCTURE (not secrets)
- API endpoint PATHS (not auth tokens)
- Database SCHEMA (not credentials)
- Service NAMES and PURPOSES
- Architecture and data flow
- All technical details that don't compromise security

**Redaction format:**
```
Environment Variables:
- DATABASE_URL=[CONNECTION_STRING_REDACTED]
- API_KEY=[REDACTED]
- JWT_SECRET=[REDACTED]
- DEBUG=true  (non-sensitive, keep as-is)
- PORT=3000   (non-sensitive, keep as-is)
```

**When in doubt, redact it.**

---

## Use Cases

- Team doesn't understand how a system/feature works
- Onboarding new developers
- Executive briefings on technical systems
- Architecture reviews
- Pre-refactor analysis
- Knowledge transfer
- Network/system layer analysis

## Output Structure

**Two interconnected HTML pages:**
1. `workflow-full.html` - Complete analytical documentation
2. `workflow-executive.html` - Condensed executive summary

Both pages include:
- Navigation link to the other view at the top
- "Export to PDF" button
- Self-contained styling (no external dependencies)

---

## MANDATORY: Professional Style Guidelines

**NO EMOJIS. EVER.**

This is professional documentation. Never use emojis anywhere in the output:
- No emojis in headings
- No emojis in body text
- No emojis in labels or captions
- No emojis in status indicators
- No emojis in buttons or navigation

**Use professional SVG icons instead.**

For status indicators, use inline SVG icons:

```svg
<!-- Checkmark (success) -->
<svg width="16" height="16" viewBox="0 0 16 16" fill="none">
  <circle cx="8" cy="8" r="7" stroke="#22c55e" stroke-width="2" fill="none"/>
  <path d="M5 8 L7 10 L11 6" stroke="#22c55e" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
</svg>

<!-- Warning (caution) -->
<svg width="16" height="16" viewBox="0 0 16 16" fill="none">
  <path d="M8 1 L15 14 L1 14 Z" stroke="#f59e0b" stroke-width="1.5" fill="none" stroke-linejoin="round"/>
  <path d="M8 6 L8 9" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" fill="none"/>
  <circle cx="8" cy="11.5" r="1" fill="#f59e0b"/>
</svg>

<!-- Error (critical) -->
<svg width="16" height="16" viewBox="0 0 16 16" fill="none">
  <circle cx="8" cy="8" r="7" stroke="#ef4444" stroke-width="2" fill="none"/>
  <path d="M5.5 5.5 L10.5 10.5 M10.5 5.5 L5.5 10.5" stroke="#ef4444" stroke-width="2" stroke-linecap="round" fill="none"/>
</svg>

<!-- Info -->
<svg width="16" height="16" viewBox="0 0 16 16" fill="none">
  <circle cx="8" cy="8" r="7" stroke="#3b82f6" stroke-width="2" fill="none"/>
  <path d="M8 7 L8 11" stroke="#3b82f6" stroke-width="2" stroke-linecap="round" fill="none"/>
  <circle cx="8" cy="4.5" r="1" fill="#3b82f6"/>
</svg>
```

**Text-only alternatives (when icons aren't suitable):**
- Use `[OK]`, `[WARN]`, `[ERROR]`, `[INFO]` badges
- Use colored dots: small filled circles (`<circle r="4" fill="#22c55e"/>`)
- Use priority labels: `HIGH`, `MEDIUM`, `LOW` in styled spans

---

## Process

### 1. Analyze Target

**MANDATORY: Load ALL TK Context Files**

Before generating ANY documentation, recursively read all TK-generated context. This is critical - these files contain the project's institutional knowledge.

```bash
# Determine what we're documenting
# - If [context] mentions specific files/features, focus there
# - If no context, analyze the entire project using ALL available context

# ===========================================
# STEP 1: Load ROOT context files
# ===========================================
[ -f "AGENTS.md" ] && cat AGENTS.md           # Primary project knowledge base
[ -f "README.md" ] && cat README.md           # Project overview

# ===========================================
# STEP 2: Load .tk/ directory (TK runtime state)
# ===========================================
[ -d ".tk" ] && echo "=== .tk/ Context Found ==="

# Rules that govern all agents
[ -f ".tk/RULES.md" ] && cat .tk/RULES.md

# Version history and changelog
[ -f ".tk/VERSION" ] && cat .tk/VERSION

# Multi-agent coordination logs
[ -f ".tk/COORDINATION.md" ] && cat .tk/COORDINATION.md

# Map file if exists
[ -f ".tk/MAP.md" ] && cat .tk/MAP.md

# Per-agent logs (read all, they contain execution history)
if [ -d ".tk/agents" ]; then
    echo "=== Agent Logs ==="
    for f in .tk/agents/*.md; do
        [ -f "$f" ] && echo "--- $f ---" && cat "$f"
    done
fi

# ===========================================
# STEP 3: Load .tk/planning/ directory (Project planning state)
# ===========================================
[ -d ".tk/planning" ] && echo "=== .tk/planning/ Context Found ==="

# Current work state
[ -f ".tk/planning/STATE.md" ] && cat .tk/planning/STATE.md

# Work history log
[ -f ".tk/planning/HISTORY.md" ] && cat .tk/planning/HISTORY.md

# Known issues and bugs
[ -f ".tk/planning/ISSUES.md" ] && cat .tk/planning/ISSUES.md

# Architecture decisions with rationale
[ -f ".tk/planning/DECISIONS.md" ] && cat .tk/planning/DECISIONS.md

# Complete codebase file map
[ -f ".tk/planning/CODEBASE.md" ] && cat .tk/planning/CODEBASE.md

# System architecture documentation
[ -f ".tk/planning/ARCHITECTURE.md" ] && cat .tk/planning/ARCHITECTURE.md

# Discovered patterns and conventions
[ -f ".tk/planning/PATTERNS.md" ] && cat .tk/planning/PATTERNS.md

# ===========================================
# STEP 4: Load source code context
# ===========================================
[ -f "package.json" ] && cat package.json | head -50
find . -name "*.ts" -o -name "*.tsx" -o -name "*.js" | grep -v node_modules | head -50

# ===========================================
# STEP 5: Check for existing docs
# ===========================================
ls docs/ 2>/dev/null
[ -d "docs" ] && find docs/ -name "*.md" -exec cat {} \;
```

**Context Priority Order:**
1. `.tk/planning/ARCHITECTURE.md` - Use this for system diagrams
2. `.tk/planning/CODEBASE.md` - Use this for file/component references
3. `.tk/planning/PATTERNS.md` - Use this for conventions and examples
4. `.tk/planning/DECISIONS.md` - Use this for "why" explanations
5. `AGENTS.md` - Use this for project overview
6. `.tk/RULES.md` - Use this for constraints/guidelines
7. `.tk/planning/ISSUES.md` - Use this for improvement recommendations
8. `.tk/planning/HISTORY.md` - Use this for timeline/evolution

---

### 2. Mode Execution

**LIGHT (Full Analysis with SubAgents):**
Launch 6 parallel SubAgents:
```
SubAgent Mapper: "Deep-dive code analysis, identify all flows, entry points, dependencies."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Diagrammer: "Create comprehensive SVG diagrams (architecture, sequence, data flow, OSI model)."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Analyst: "Generate analytical charts (line graphs, pie charts, sparklines)."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent OSI-Specialist: "Map all components to OSI layers with detailed analysis."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Metrics: "Gather quantitative data for charts."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent DOCS: "Compile everything into polished dual-page HTML output."
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md
```

Generate two HTML files:
- `workflow-full.html` - Complete documentation
- `workflow-executive.html` - Executive summary
Both with navigation links and PDF export

**MEDIUM (Deeper Analysis + Validation):**
Everything in LIGHT, plus:
```
Additional SubAgents:
SubAgent Deep-Dive: "Trace complex flows end-to-end, document edge cases."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Security-Mapper: "Map security boundaries and data sensitivity."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Performance-Mapper: "Identify performance-critical paths."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Validator: "Cross-check all findings for accuracy and completeness."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**HEAVY (Maximum Analysis + Cross-Validation):**
Everything in MEDIUM, plus:
```
Extended Analysis:
SubAgent Historical: "Analyze how system evolved, document key changes."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Integration-Mapper: "Map all external integrations and dependencies."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Gap-Finder: "Identify documentation gaps and missing context."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

Cross-Validation:
SubAgent Cross-validator 1: "Verify Mapper + Diagrammer + Analyst findings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Cross-validator 2: "Verify OSI + Metrics + Security findings."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

SubAgent Fresh-Eyes: "Independent review - find issues other agents missed."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

---

### 3. MANDATORY: OSI Model Analysis

**For ALL modes, generate a dedicated OSI Model section.**

Map every component to its operating OSI layer(s). Many components span multiple layers.

**OSI Layer Reference:**
| Layer | Name | Examples |
|-------|------|----------|
| 7 | Application | HTTP, REST APIs, GraphQL, WebSocket handlers, UI components |
| 6 | Presentation | JSON serialization, encryption/TLS termination, data transformation |
| 5 | Session | Authentication, session management, connection pooling |
| 4 | Transport | TCP/UDP handling, load balancers, port management |
| 3 | Network | IP routing, DNS resolution, CDN edge nodes |
| 2 | Data Link | MAC addressing, switches, network interface config |
| 1 | Physical | Hardware, cables, wireless signals |

**For each component, document:**
1. Which layer(s) it operates on
2. What it does at each layer
3. How it interacts with adjacent layers
4. Performance characteristics at each layer

---

### 4. MANDATORY: Analytical Charts

**Generate these chart types using pure SVG (no external libraries):**

- **Pie Chart** - Component distribution by type
- **Bar Chart** - Components per OSI layer
- **Line Graph** - Dependency complexity trend
- **Sparklines** - Inline metrics

**Metrics to visualize:**
- Component count by type (pie)
- Component count by OSI layer (bar)
- Dependency complexity (line)
- Code distribution (pie)
- API endpoint count by category (bar)
- Test coverage trend (line + sparkline)

---

### 5. SVG Generation Rules

**CRITICAL: Follow these rules for ALL SVG graphics. Black boxes are UNACCEPTABLE.**

**EVERY SVG ELEMENT MUST HAVE AN EXPLICIT FILL:**

| Element Type | If it's a LINE/STROKE | If it's a SHAPE |
|--------------|----------------------|-----------------|
| `<path>` | `fill="none"` | `fill="#hexcolor"` |
| `<rect>` | N/A (always a shape) | `fill="#hexcolor"` |
| `<circle>` | `fill="none"` (if outline only) | `fill="#hexcolor"` |
| `<polygon>` | N/A (always a shape) | `fill="#hexcolor"` |
| `<ellipse>` | `fill="none"` (if outline only) | `fill="#hexcolor"` |
| `<line>` | No fill needed | N/A |
| `<polyline>` | `fill="none"` ALWAYS | N/A |

**Color Palette:**
- Primary: `#3b82f6` (blue)
- Success: `#22c55e` (green)
- Warning: `#f59e0b` (amber)
- Error: `#ef4444` (red)
- Purple: `#8b5cf6`
- Secondary: `#64748b` (slate)
- Background: `#f8fafc`
- Border: `#e2e8f0`
- Text: `#1e293b`
- Muted text: `#64748b`

---

### 6. Completion

```bash
# Output files based on mode
# All modes generate dual-page output

OUTFILE_FULL="workflow-full.html"
OUTFILE_EXEC="workflow-executive.html"

# Place in docs/ if it exists, otherwise project root
if [ -d "docs" ]; then
    mv "$OUTFILE_FULL" "docs/$OUTFILE_FULL"
    mv "$OUTFILE_EXEC" "docs/$OUTFILE_EXEC"
fi

echo "Generated workflow documentation"

# Git commit
git add docs/workflow*.html 2>/dev/null || git add workflow*.html
git commit -m "docs: generate workflow documentation"
```

**Report:**
- Generated files (list all)
- Sections included
- Charts generated
- OSI layers mapped
- Key metrics captured
- Recommendations count
