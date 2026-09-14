# Pretty Mermaid — Quick Reference

## What It Does

Pretty Mermaid turns Mermaid diagram source code into polished, themed output in three formats:
- **SVG** — scalable, themeable, transparent-background support (best for docs, READMEs, websites)
- **PNG** — raster output rendered locally without a browser (best for chat, sharing, tools that don't handle SVG)
- **ASCII/Unicode** — terminal-friendly text art with ANSI color support (best for TUI output, logs, plain text)

**Zero browser dependency** — renders entirely in Node.js. Supports 15 built-in themes, CJK text, multiline labels, interactive XY chart tooltips, and batch parallel rendering.

## Installation

```bash
npx skills add imxv/pretty-mermaid-skills@pretty-mermaid -g -y
```

Requires Node.js 16+. Verify with:
```bash
npx skills list -g | grep pretty-mermaid
node scripts/themes.mjs
```

## Key Features

| Feature | Benefit |
|---------|---------|
| **Multi-format** | SVG, PNG, ASCII with one source file |
| **15 themes** | `tokyo-night`, `github-dark`, `dracula`, `nord`, `zinc-light`, `catppuccin-mocha`, `solarized-dark`, etc. |
| **6 diagram types** | Flowchart, Sequence, State, Class, ER, XY charts |
| **No browser** | Renders via `@resvg/resvg-js` + `beautiful-mermaid` Node.js stack |
| **Batch rendering** | Process directories in parallel with `--workers` |
| **Customizable** | Override theme colors with `--bg`, `--fg`, `--accent`, `--line`, `--surface`, `--border` |
| **Interactive** | XY chart tooltips when rendered as SVG with `--interactive` |
| **Transparent backgrounds** | `--transparent` flag for SVG and PNG |

## Usage Patterns

### Single Diagram → SVG

```bash
node scripts/render.mjs \
  --input diagram.mmd \
  --output diagram.svg \
  --theme tokyo-night
```

### Single Diagram → PNG

```bash
node scripts/render.mjs \
  --input diagram.mmd \
  --output diagram.png \
  --format png \
  --width 1200 \
  --theme github-dark
```

### Diagram → Terminal Text

```bash
node scripts/render.mjs \
  --input diagram.mmd \
  --output diagram.txt \
  --format ascii \
  --color-mode ansi256
```

Add `--use-ascii` if Unicode box-drawing characters are not supported.

### Batch Render a Directory

```bash
node scripts/batch.mjs \
  --input-dir ./diagrams \
  --output-dir ./rendered \
  --format svg \
  --theme dracula \
  --workers 4
```

### List Available Themes

```bash
node scripts/themes.mjs
```

Output: `zinc-light`, `zinc-dark`, `tokyo-night-light`, `tokyo-night`, `tokyo-night-storm`, `catppuccin-latte`, `catppuccin-mocha`, `github-light`, `github-dark`, `solarized-light`, `solarized-dark`, `nord`, `nord-light`, `dracula`, `one-dark`.

## Diagram Types & Starters

| Use Case | Type | Starter Syntax |
|----------|------|-----------------|
| Process, decisions, architecture | Flowchart | `flowchart LR` |
| API calls, messages, interactions | Sequence | `sequenceDiagram` |
| Lifecycle, FSM | State | `stateDiagram-v2` |
| Classes, modules, relationships | Class | `classDiagram` |
| Database entities | ER | `erDiagram` |
| Bars, lines, trends | XY Chart | `xychart-beta` |

## Useful Options

### Styling

- `--theme <name>` — apply built-in theme
- `--bg <hex>` — background color
- `--fg <hex>` — foreground/text color
- `--accent <hex>` — highlight color
- `--line <hex>` — connector color
- `--surface <hex>` — node fill
- `--border <hex>` — node stroke
- `--font <name>` — SVG font family

### SVG Only

- `--transparent` — no background
- `--padding <n>` — canvas margin
- `--node-spacing <n>` — horizontal spacing
- `--layer-spacing <n>` — vertical spacing
- `--component-spacing <n>` — disconnected component gap
- `--interactive` — enable XY chart tooltips

### PNG Only

- `--width <pixels>` — 100–10000, preserves aspect ratio
- `--transparent` — preserve transparent bg

### Terminal Output

- `--use-ascii` — plain ASCII instead of Unicode
- `--color-mode <mode>` — `none`, `auto`, `ansi16`, `ansi256`, `truecolor`, `html`
- `--padding-x <n>`, `--padding-y <n>` — diagram spacing
- `--box-border-padding <n>` — node interior padding

## Key Files & References

- `references/DIAGRAM_TYPES.md` — Mermaid syntax reference for all 6 types
- `references/THEMES.md` — theme definitions and color palettes
- `references/api_reference.md` — JavaScript API for `beautiful-mermaid`
- `docs/THEME_GALLERY.md` — visual gallery of all 15 themes
- `assets/example_diagrams/` — template `.mmd` files for each diagram type
- `scripts/render.mjs` — main renderer CLI
- `scripts/batch.mjs` — batch processor CLI
- `scripts/themes.mjs` — list themes CLI

## Validation Checklist

After rendering:

1. ✓ Command exits successfully; output file is non-empty
2. ✓ SVG starts with `<svg`; PNG opens as valid image; text output shows diagram
3. ✓ Visual layout correct (long labels, CJK text, separated components)
4. ✓ Arrows, cardinalities, states, and labels match source
5. ✓ Renderer limitations reported (unsupported syntax not silently dropped)

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Missing dependency | `npm install` in skill root |
| Unknown theme | Run `node scripts/themes.mjs` for exact names |
| Parse error | Check `references/DIAGRAM_TYPES.md`; reduce to failing statement |
| Crowded SVG | Increase `--node-spacing`, `--layer-spacing`, `--component-spacing` |
| PNG color mismatch | Use hex values, not CSS variables |
| Color codes in output | Add `--color-mode none` |

## AI Integration

Ready for: Claude Code, Cursor, Codex, Gemini CLI, Antigravity, OpenCode, qoder. Install as a skill via `skills.sh` and invoke from any AI agent prompt.

---

**Source**: [github.com/imxv/Pretty-mermaid-skills](https://github.com/imxv/Pretty-mermaid-skills)  
**License**: MIT  
**Requirements**: Node.js 16+
