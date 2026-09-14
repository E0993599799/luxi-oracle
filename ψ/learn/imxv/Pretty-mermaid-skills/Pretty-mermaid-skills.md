# Pretty-mermaid-skills Learning Index

## Source
- **Origin**: ./origin/
- **GitHub**: https://github.com/imxv/Pretty-mermaid-skills

## Explorations

### 2026-09-14 1421 (default, 3 agents)
- [[2026-09-14/1421_ARCHITECTURE|Architecture]]
- [[2026-09-14/1421_CODE-SNIPPETS|Code Snippets]]
- [[2026-09-14/1421_QUICK-REFERENCE|Quick Reference]]

**Key insights**:
- Lightweight Node.js CLI (no build step, no browser) wrapping `beautiful-mermaid` + `@resvg/resvg-js` to render Mermaid diagrams to SVG, PNG, and ASCII text with 15 built-in themes — installed via `npx skills add` as a Claude Skill.
- Rendering pipeline is SVG-first: PNG and ASCII both derive from the SVG output (PNG via `@resvg/resvg-js` rasterization with CSS `var()`/`color-mix()` resolution baked in; ASCII via a theme-derivation fallback chain), not three independent renderers.
- No external CLI-arg parser dependency — args are hand-parsed; color/CSS handling (hex parsing, premultiplied-alpha `color-mix`, circular-var detection) is implemented from scratch rather than pulled from a library.
