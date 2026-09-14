---
pattern: "Learned Pretty-mermaid-skills: Node.js CLI Claude Skill wrapping beautiful-mermaid + @resvg/resvg-js to render Mermaid → SVG/PNG/ASCII with 15 themes; SVG-first pipeline (PNG/ASCII both derive from SVG), zero-dependency arg parsing and hand-rolled CSS var()/color-mix() resolution."
date: 2026-09-14
source: "learn: imxv/Pretty-mermaid-skills"
concepts: ["learn", "codebase", "mermaid", "diagram-rendering", "claude-skill", "cli-tool"]
---

# Learned Pretty-mermaid-skills

- Installed as a Claude Skill via `npx skills add`; pure Node.js ≥16 CLI, no build step, no browser dependency — renders Mermaid diagrams to SVG, PNG, and ASCII text across 15 themes.
- Pipeline is SVG-first: PNG rasterizes the SVG via `@resvg/resvg-js` (with hand-rolled CSS `var()`/`color-mix()` resolution and circular-variable detection), and ASCII derives its theme from the SVG theme via a fallback chain — not three independent renderers.
- No external CLI-arg-parsing dependency; args, hex-color parsing, and premultiplied-alpha color mixing (CSS Color Module Level 4) are all implemented from scratch.

Full docs: `ψ/learn/imxv/Pretty-mermaid-skills/Pretty-mermaid-skills.md`
