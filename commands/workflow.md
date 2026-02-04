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

Generate a comprehensive, self-contained HTML document with visual workflow diagrams, explanations, and analysis. Perfect for when a team needs to understand how something works.

## Use Cases

- Team doesn't understand how a system/feature works
- Onboarding new developers
- Executive briefings on technical systems
- Architecture reviews
- Pre-refactor analysis
- Knowledge transfer

## Process

### 1. Analyze Target

```bash
# Determine what we're documenting
# - If [context] mentions specific files/features, focus there
# - If no context, analyze the entire project

# Gather information
find . -name "*.ts" -o -name "*.tsx" -o -name "*.js" | grep -v node_modules | head -50
[ -f "package.json" ] && cat package.json | head -50
[ -f "AGENTS.md" ] && cat AGENTS.md
[ -f ".tk/MAP.md" ] && cat .tk/MAP.md

# Look for existing docs
ls docs/ 2>/dev/null
[ -f "README.md" ] && cat README.md | head -100
```

### 2. Mode Execution

**LIGHT (Quick Overview):**
Generate single HTML file with:
- System overview section
- One main SVG flow diagram
- Key components list
- Basic how-it-works explanation
- Output: `workflow-overview.html`

**MEDIUM (Detailed Analysis):**
Generate comprehensive HTML with:
- Executive summary (2-3 paragraphs)
- Multiple SVG diagrams (data flow, component interactions, user journey)
- Detailed component breakdowns
- Real-world usage example (step-by-step walkthrough)
- Technology stack overview
- Output: `workflow-report.html`

**HEAVY (Full Documentation + Analysis):**
```
SubAgent 1 (Mapper): Deep-dive code analysis, identify all flows, entry points, dependencies
SubAgent 2 (Diagrammer): Create comprehensive SVG diagrams (architecture, sequence, data flow, state)
SubAgent 3 (Explainer): Write detailed explanations for each component/flow
SubAgent 4 (Analyst): Identify improvement opportunities, tech debt, potential issues
SubAgent DOCS: Compile everything into polished HTML document
```

Output: `workflow-complete.html` with:
- Executive summary
- Table of contents with anchor links
- Interactive SVG diagrams (hover states via CSS)
- Detailed system breakdown
- Real-world example walkthrough with visual annotations
- Component deep-dives
- Data flow analysis
- Improvement recommendations
- Tech debt assessment
- Glossary of terms
- Appendix with code snippets

### 3. HTML Template Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Workflow: [PROJECT_NAME]</title>
    <style>
        /* Modern, clean styling */
        :root {
            --primary: #2563eb;
            --secondary: #64748b;
            --bg: #ffffff;
            --bg-alt: #f8fafc;
            --text: #1e293b;
            --border: #e2e8f0;
            --success: #22c55e;
            --warning: #f59e0b;
            --error: #ef4444;
        }
        
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: var(--text);
            background: var(--bg);
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        /* Header */
        .header {
            border-bottom: 3px solid var(--primary);
            padding-bottom: 2rem;
            margin-bottom: 3rem;
        }
        
        .header h1 { font-size: 2.5rem; margin-bottom: 0.5rem; }
        .header .meta { color: var(--secondary); font-size: 0.9rem; }
        
        /* Executive Summary */
        .executive-summary {
            background: linear-gradient(135deg, #eff6ff 0%, #f0fdf4 100%);
            border-left: 4px solid var(--primary);
            padding: 1.5rem 2rem;
            margin-bottom: 3rem;
            border-radius: 0 8px 8px 0;
        }
        
        /* Table of Contents */
        .toc {
            background: var(--bg-alt);
            padding: 1.5rem 2rem;
            border-radius: 8px;
            margin-bottom: 3rem;
        }
        
        .toc h2 { font-size: 1.2rem; margin-bottom: 1rem; }
        .toc ul { list-style: none; }
        .toc li { margin: 0.5rem 0; }
        .toc a { color: var(--primary); text-decoration: none; }
        .toc a:hover { text-decoration: underline; }
        
        /* Sections */
        section {
            margin-bottom: 4rem;
            scroll-margin-top: 2rem;
        }
        
        section h2 {
            font-size: 1.8rem;
            border-bottom: 2px solid var(--border);
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
        }
        
        section h3 { font-size: 1.3rem; margin: 1.5rem 0 1rem; }
        
        /* SVG Diagrams */
        .diagram-container {
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 2rem;
            margin: 1.5rem 0;
            overflow-x: auto;
        }
        
        .diagram-container svg {
            display: block;
            margin: 0 auto;
            max-width: 100%;
            height: auto;
        }
        
        .diagram-caption {
            text-align: center;
            color: var(--secondary);
            font-size: 0.9rem;
            margin-top: 1rem;
        }
        
        /* SVG Interactive Styles */
        svg .node { transition: all 0.2s ease; }
        svg .node:hover { filter: brightness(1.1); cursor: pointer; }
        svg .node:hover + .tooltip { opacity: 1; }
        
        /* Cards */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin: 1.5rem 0;
        }
        
        .card {
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 1.5rem;
        }
        
        .card h4 {
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
            color: var(--primary);
        }
        
        /* Code blocks */
        pre {
            background: #1e293b;
            color: #e2e8f0;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            overflow-x: auto;
            font-family: 'Fira Code', 'Consolas', monospace;
            font-size: 0.9rem;
            margin: 1rem 0;
        }
        
        code {
            background: var(--bg-alt);
            padding: 0.2rem 0.4rem;
            border-radius: 4px;
            font-family: 'Fira Code', 'Consolas', monospace;
            font-size: 0.9em;
        }
        
        pre code { background: none; padding: 0; }
        
        /* Callouts */
        .callout {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin: 1.5rem 0;
        }
        
        .callout-info {
            background: #eff6ff;
            border-left: 4px solid var(--primary);
        }
        
        .callout-warning {
            background: #fffbeb;
            border-left: 4px solid var(--warning);
        }
        
        .callout-success {
            background: #f0fdf4;
            border-left: 4px solid var(--success);
        }
        
        .callout-error {
            background: #fef2f2;
            border-left: 4px solid var(--error);
        }
        
        /* Tables */
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 1.5rem 0;
        }
        
        th, td {
            text-align: left;
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--border);
        }
        
        th { background: var(--bg-alt); font-weight: 600; }
        tr:hover { background: var(--bg-alt); }
        
        /* Improvement Items */
        .improvement-item {
            display: flex;
            gap: 1rem;
            padding: 1rem;
            border: 1px solid var(--border);
            border-radius: 8px;
            margin: 0.75rem 0;
        }
        
        .improvement-priority {
            font-size: 0.8rem;
            font-weight: 600;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            white-space: nowrap;
            height: fit-content;
        }
        
        .priority-high { background: #fecaca; color: #991b1b; }
        .priority-medium { background: #fef08a; color: #854d0e; }
        .priority-low { background: #bbf7d0; color: #166534; }
        
        /* Footer */
        .footer {
            margin-top: 4rem;
            padding-top: 2rem;
            border-top: 1px solid var(--border);
            color: var(--secondary);
            font-size: 0.9rem;
            text-align: center;
        }
        
        /* Print styles */
        @media print {
            body { max-width: none; padding: 0; }
            .toc { break-after: page; }
            section { break-inside: avoid; }
            pre { white-space: pre-wrap; }
        }
    </style>
</head>
<body>
    <!-- HEADER -->
    <header class="header">
        <h1>Workflow: [PROJECT_NAME]</h1>
        <div class="meta">
            Generated: [DATE] | Version: [VERSION] | Mode: [MODE]
        </div>
    </header>
    
    <!-- EXECUTIVE SUMMARY -->
    <div class="executive-summary">
        <h2>Executive Summary</h2>
        <!-- 2-3 paragraph overview for leadership/non-technical stakeholders -->
    </div>
    
    <!-- TABLE OF CONTENTS -->
    <nav class="toc">
        <h2>Contents</h2>
        <ul>
            <li><a href="#overview">System Overview</a></li>
            <li><a href="#architecture">Architecture</a></li>
            <li><a href="#data-flow">Data Flow</a></li>
            <li><a href="#walkthrough">Real-World Example</a></li>
            <li><a href="#components">Component Breakdown</a></li>
            <li><a href="#improvements">Improvement Recommendations</a></li>
            <li><a href="#glossary">Glossary</a></li>
        </ul>
    </nav>
    
    <!-- SECTIONS -->
    <section id="overview">
        <h2>System Overview</h2>
        <!-- High-level description -->
        <div class="diagram-container">
            <!-- Main architecture SVG -->
            <div class="diagram-caption">Figure 1: System Architecture</div>
        </div>
    </section>
    
    <section id="architecture">
        <h2>Architecture</h2>
        <!-- Component breakdown with diagrams -->
    </section>
    
    <section id="data-flow">
        <h2>Data Flow</h2>
        <!-- How data moves through the system -->
        <div class="diagram-container">
            <!-- Data flow SVG -->
            <div class="diagram-caption">Figure 2: Data Flow Diagram</div>
        </div>
    </section>
    
    <section id="walkthrough">
        <h2>Real-World Example</h2>
        <!-- Step-by-step walkthrough with visuals -->
    </section>
    
    <section id="components">
        <h2>Component Breakdown</h2>
        <div class="card-grid">
            <!-- Component cards -->
        </div>
    </section>
    
    <section id="improvements">
        <h2>Improvement Recommendations</h2>
        <!-- Prioritized improvement suggestions -->
    </section>
    
    <section id="glossary">
        <h2>Glossary</h2>
        <!-- Term definitions -->
    </section>
    
    <footer class="footer">
        Generated by /tk:workflow | [PROJECT_NAME] v[VERSION]
    </footer>
</body>
</html>
```

### 4. SVG Diagram Guidelines

**Architecture Diagram:**
```svg
<svg viewBox="0 0 800 400" xmlns="http://www.w3.org/2000/svg">
    <!-- Use rounded rectangles for components -->
    <rect class="node" x="50" y="50" width="140" height="60" rx="8" fill="#3b82f6"/>
    <text x="120" y="85" text-anchor="middle" fill="white" font-weight="500">Component</text>
    
    <!-- Arrows for connections -->
    <defs>
        <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
            <polygon points="0 0, 10 3.5, 0 7" fill="#64748b"/>
        </marker>
    </defs>
    <path d="M190 80 L250 80" stroke="#64748b" stroke-width="2" marker-end="url(#arrowhead)"/>
    
    <!-- Groups for layers -->
    <g class="layer frontend">...</g>
    <g class="layer backend">...</g>
    <g class="layer database">...</g>
</svg>
```

**Color Palette for Diagrams:**
- Frontend/UI: `#3b82f6` (blue)
- Backend/API: `#8b5cf6` (purple)
- Database: `#22c55e` (green)
- External Services: `#f59e0b` (amber)
- User Actions: `#06b6d4` (cyan)
- Arrows/Lines: `#64748b` (slate)

**Sequence Diagram Format:**
- Use vertical lanes for actors/systems
- Numbered steps
- Clear request/response arrows

### 5. Content Guidelines

**Executive Summary Must Include:**
- What the system does (1 sentence)
- Who uses it and why (1-2 sentences)
- Key technical approach (1 sentence)
- Current state assessment (1 sentence)

**Real-World Example Must:**
- Use concrete, realistic scenario
- Show actual data/values (use fake but realistic)
- Step through the entire flow
- Highlight what happens at each stage
- Include both happy path and error handling

**Improvements Section Format:**
```html
<div class="improvement-item">
    <span class="improvement-priority priority-high">HIGH</span>
    <div>
        <strong>Title of Improvement</strong>
        <p>What: Description of the change</p>
        <p>Why: Business/technical benefit</p>
        <p>How: Brief implementation approach</p>
    </div>
</div>
```

### 6. Completion

```bash
# Output file based on mode
OUTFILE="workflow-overview.html"   # light
OUTFILE="workflow-report.html"     # medium
OUTFILE="workflow-complete.html"   # heavy

# Place in docs/ if it exists, otherwise project root
[ -d "docs" ] && OUTFILE="docs/$OUTFILE"

echo "Generated: $OUTFILE"

# Version bump (patch for docs)
# Update .tk/VERSION

# Git commit
git add "$OUTFILE"
git commit -m "docs: generate workflow documentation"
```

Report: 
- Generated file path
- Sections included
- Diagrams created
- Key findings summary
