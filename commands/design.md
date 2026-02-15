---
name: tk:design
description: Create distinctive frontend interfaces. /tk:[$cmd] light|medium|heavy <what to build>
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
  - WebSearch
  - WebFetch
---

$import(commands/tk/_shared.md)

# TK v2.0.0 | /tk:design [mode]

## STEP 0: LOAD RULES (SILENT)

Before ANY action: silently read .tk/RULES.md and follow ALL rules constantly.
Do not display rules. Just follow them.

Create production-grade frontend interfaces with exceptional design quality. Avoid generic "AI slop" aesthetics.

## Critical Principles

**NEVER use:**
- Generic fonts (Inter, Roboto, Arial, system fonts, Space Grotesk)
- Cliched colors (purple gradients on white)
- Predictable layouts and cookie-cutter patterns
- Same aesthetic twice

**ALWAYS:**
- Commit to a BOLD aesthetic direction
- Make unexpected, memorable choices
- Match implementation complexity to vision
- Execute with precision and intentionality

## Process

### 1. Pre-flight (from _shared.md)

### 2. Design Thinking (before ANY code)

**ALL MODES:** Answer these explicitly:

- **Purpose:** What problem? Who uses it?
- **Tone:** Pick an EXTREME - brutally minimal, maximalist chaos, retro-futuristic, organic/natural, luxury/refined, playful/toy-like, editorial/magazine, brutalist/raw, art deco/geometric, soft/pastel, industrial/utilitarian
- **Constraints:** Framework, performance, accessibility requirements
- **Differentiation:** What's the ONE thing someone will remember?

### 3. Mode Execution

**LIGHT (full design process with SubAgents):**
Interview user (3-5 questions):
- What's the vibe/mood? (show tone options)
- Any brand colors/fonts to respect?
- Reference sites they admire?
- Target audience?
- Dark or light theme preference?

Launch 3 research SubAgents + 4 specialists:
```
Phase 1 - Research:
SubAgent Research 1: "Research aesthetic direction - find 3 reference sites/designs matching the vibe."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Research 2: "Research typography - find perfect font pairing for this context."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Research 3: "Research color theory - build palette that matches tone."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent DOCS: "Document design decisions in .tk/planning/DESIGN.md"
  CRITICAL: Document everything to .tk/agents/DOCS-{id}.md

Phase 2 - Build (parallel specialists):
SubAgent Structure: "HTML/component architecture, semantic markup, accessibility."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Styling: "CSS/styling system, variables, responsive breakpoints."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Motion: "Animations, transitions, micro-interactions, scroll effects."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Polish: "Visual details, textures, shadows, custom cursors, grain overlays."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**MEDIUM (deeper research + validation):**
Everything in LIGHT, plus:
```
Additional Research:
SubAgent Research 4: "Analyze competitor designs - what works, what doesn't."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Research 5: "Research accessibility best practices for chosen aesthetic."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

Additional Build:
SubAgent Responsive: "Test and optimize for all breakpoints."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Validator: "Review all components for consistency and polish."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

**HEAVY (maximum parallelization + cross-validation):**
Everything in MEDIUM, plus:
```
Extended Research:
SubAgent Research 6: "Deep-dive into chosen aesthetic's history and best examples."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Research 7: "Research performance impact of design choices."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md

Cross-validation:
SubAgent Cross-validator 1: "Review all design decisions against user requirements."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Cross-validator 2: "Fresh eyes review - identify inconsistencies and missed opportunities."
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
SubAgent Devil's Advocate: "Challenge design choices - what could be bolder? What's too safe?"
  CRITICAL: Document everything to .tk/agents/{your-agent-id}.md
```

### 4. Implementation Checklist

Before completion, verify:
- [ ] Typography: No generic fonts, distinctive pairing
- [ ] Colors: CSS variables, cohesive palette, not timid/evenly-distributed
- [ ] Motion: Page load animation with staggered reveals, hover states
- [ ] Layout: Not predictable - has asymmetry, overlap, or unexpected composition
- [ ] Atmosphere: Background isn't flat solid color (gradients, textures, patterns)
- [ ] Memorable: Has ONE unforgettable detail
- [ ] Functional: Production-ready, accessible, responsive

### 5. Completion

```bash
# Update .tk/planning/STATE.md, .tk/planning/HISTORY.md
# If patterns discovered, add to .tk/planning/PATTERNS.md
git add -A && git commit -m "feat: [component/page name] - [aesthetic direction]"
```

Report: What was built, aesthetic direction chosen, key design decisions, how to use/integrate

## Aesthetic Reference (vary between these, never repeat)

| Direction | Typography | Colors | Motion | Details |
|-----------|------------|--------|--------|---------|
| Brutalist | Mono, raw | Black/white, neon accent | Glitchy, abrupt | Exposed grid, raw borders |
| Luxury | Thin serif, refined | Deep jewel tones, gold | Smooth, elegant | Subtle textures, shadows |
| Playful | Rounded, bouncy | Bright primaries, pastels | Springy, wobble | Blob shapes, illustrations |
| Editorial | Classic serif | High contrast B&W | Minimal, purposeful | Large type, white space |
| Retro-future | Geometric sans | Neon on dark | Glow, scan lines | CRT effects, chrome |
| Organic | Handwritten, natural | Earth tones, greens | Flowing, natural | Grain, paper textures |
| Art Deco | Geometric display | Gold, black, cream | Geometric reveals | Borders, patterns |

**Remember:** Claude is capable of extraordinary creative work. Commit fully to a distinctive vision.
