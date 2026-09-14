# Pretty Mermaid Skills — Architecture

**Repository**: imxv/Pretty-mermaid-skills  
**Type**: Node.js CLI tool + skills.sh skill  
**Purpose**: Render Mermaid diagrams to SVG, PNG, and ASCII/Unicode format for AI agents and terminal environments  

---

## Directory Structure

```
.
├── scripts/                    # CLI entry points (Node.js scripts)
│   ├── render.mjs              # Single-file rendering (SVG, PNG, ASCII)
│   ├── batch.mjs               # Batch directory rendering with parallelization
│   ├── themes.mjs              # List all available themes
│   ├── png.mjs                 # PNG rendering utilities (Resvg integration)
│   ├── smoke-test.mjs          # Unit tests for core rendering pipeline
│   ├── validate-docs.mjs       # Documentation link validation
│   └── generate-theme-gallery.mjs  # Generate visual theme comparison
├── assets/
│   ├── example_diagrams/       # Six example .mmd files (one per diagram type)
│   ├── theme_gallery/          # Pre-rendered SVG samples for each theme
│   └── social-preview.png      # Marketing image
├── docs/
│   └── THEME_GALLERY.md        # Visual theme comparison (2.1 KB)
├── references/
│   ├── DIAGRAM_TYPES.md        # Mermaid syntax guide (six diagram types)
│   ├── THEMES.md               # Theme and custom color reference
│   └── api_reference.md        # beautiful-mermaid API reference
├── package.json                # Dependencies: beautiful-mermaid, @resvg/resvg-js
├── SKILL.md                    # Skill manifest + usage guide for AI agents
├── README.md                   # Project overview and quick start
└── [supporting docs]           # LICENSE, CONTRIBUTING, CHANGELOG, SECURITY, RELEASING
```

---

## Entry Points

### 1. **render.mjs** — Single-file rendering CLI

**Purpose**: Convert a single `.mmd` file to SVG, PNG, or ASCII output.

**Usage**:
```bash
render-mermaid --input diagram.mmd --output diagram.svg --theme tokyo-night
render-mermaid --input diagram.mmd --format png --width 1200
render-mermaid --input diagram.mmd --format ascii --color-mode ansi256
```

**Key Options**:
- **Format**: `svg` (default), `png`, `ascii`
- **Theming**: `--theme <name>` (15 built-in) or `--bg`, `--fg`, `--line`, `--accent`, `--muted`, `--surface`, `--border`
- **SVG styling**: `--padding`, `--node-spacing`, `--layer-spacing`, `--component-spacing`, `--transparent`, `--interactive`
- **PNG sizing**: `--width <100-10000>` (maintains aspect ratio)
- **Terminal output**: `--use-ascii` (pure ASCII vs. Unicode), `--color-mode <none|auto|ansi16|ansi256|truecolor|html>`, `--padding-x`, `--padding-y`, `--box-border-padding`

**Architecture**:
- Parses CLI arguments into an options object
- Auto-installs `beautiful-mermaid` dependency if missing
- Loads the target Mermaid file
- Routes to `renderMermaidSVG()` or `renderMermaidASCII()` from `beautiful-mermaid`
- For PNG: converts SVG → PNG via `png.mjs`
- Writes output to file or stdout

---

### 2. **batch.mjs** — Parallel batch rendering CLI

**Purpose**: Render all `.mmd` files in a directory with consistent styling, using worker pool.

**Usage**:
```bash
batch-mermaid --input-dir ./diagrams --output-dir ./output --theme dracula --workers 4
```

**Key Options**:
- Same as `render.mjs` plus `--workers <n>` (default 4)
- Output extension auto-mapped: `.mmd` → `.svg` | `.png` | `.txt`

**Architecture**:
- Reads all `.mmd` files from input directory
- Batches files into groups of `--workers` size
- Uses `Promise.allSettled()` for parallel processing
- Collects and reports success/failure for each file
- Exits with error status if any rendering fails

---

### 3. **themes.mjs** — Theme lister CLI

**Purpose**: List all 15 available themes.

**Usage**:
```bash
list-mermaid-themes
```

**Architecture**:
- Imports `beautiful-mermaid`
- Reads `THEMES` object keys and prints sorted list
- Shows usage hint

---

### 4. **png.mjs** — PNG rendering module

**Purpose**: Convert SVG to PNG using Resvg (a Rust-based SVG renderer compiled to WASM).

**Exports**:
- `renderSvgToPng(svg, width)` → PNG Buffer
- `prepareSvgForPng(svg)` → Resolves CSS custom properties and background
- `parsePngWidth(value)` → Validates width (100–10000 px)

**Architecture**:
- Extracts and resolves CSS custom properties (`--var`, `color-mix()`) from SVG `<style>` blocks
- Validates that no scoped/inline elements use custom properties (Resvg limitation)
- Parses hex colors and handles transparency (rgba)
- Implements `color-mix()` in sRGB color space with weighted blending
- Uses `@resvg/resvg-js` to render at target width with system fonts
- Returns PNG as Buffer with signature validation

---

## Core Abstractions

### **Rendering Pipeline**

Three rendering paths converge from `beautiful-mermaid`:

```
Input (.mmd file) → beautifulMermaid
                  ├→ renderMermaidSVG(source, { theme, colors, font, spacing, ... })
                  │  └→ SVG string (with CSS variables)
                  │
                  └→ renderMermaidASCII(source, { theme, useAscii, colorMode, ... })
                     └→ Text string (colored or plain)

SVG string → [if PNG]
          → prepareSvgForPng() [resolve CSS]
          → renderSvgToPng() [Resvg]
          └→ PNG Buffer
```

### **Theme & Color Abstraction**

- **Built-in themes**: 15 named theme objects in `beautiful-mermaid.THEMES`
  - Examples: `tokyo-night`, `dracula`, `github-dark`, `solarized-light`, `nord`
  - Each contains: `{ bg, fg, line, accent, muted, surface, border }`

- **Custom colors**: CLI flags override theme values
  - `toAsciiTheme()` adapter normalizes colors for terminal rendering (derives missing values from available ones)
  - CSS custom properties resolved at PNG conversion time

### **Dependency: beautiful-mermaid**

- Wraps Mermaid.js (diagram syntax parsing)
- Adds native SVG rendering without a browser
- Provides 15 pre-built themes and color APIs
- **Node module auto-install**: If missing, scripts run `npm install` on first use

### **Dependency: @resvg/resvg-js**

- Rust SVG renderer compiled to WASM
- Converts styled SVG (with resolved colors) to PNG
- Reads system fonts; supports transparency

---

## Dependencies

```json
{
  "beautiful-mermaid": "^1.1.3",
  "@resvg/resvg-js": "^2.6.2"
}
```

**Runtime Requirements**: Node.js ≥ 16

**No Build Step**: Scripts are plain `.mjs` (ES modules, executed directly).

---

## Data Flow Examples

### Single SVG Render
1. User: `render-mermaid --input flowchart.mmd --theme tokyo-night`
2. `render.mjs` parses args → loads `flowchart.mmd` → calls `renderMermaidSVG(input, THEMES['tokyo-night'])`
3. Returns SVG string → written to stdout or `--output` file

### Batch PNG Render with Custom Colors
1. User: `batch-mermaid --input-dir diagrams/ --output-dir out/ --format png --bg #000 --fg #fff --workers 2`
2. `batch.mjs` reads all `.mmd` files → splits into batches of 2
3. For each file:
   - `renderMermaidSVG(source, { bg: '#000', fg: '#fff', ... })`
   - `prepareSvgForPng(svg)` resolves colors → `{ svg, background }`
   - `renderSvgToPng(svg, width=800)` → PNG Buffer
   - Write to `diagrams/file.png`
4. Report success/fail count

### ASCII Terminal Render
1. User: `render-mermaid --input sequence.mmd --format ascii --color-mode ansi256`
2. `render.mjs` calls `renderMermaidASCII(input, { colorMode: 'ansi256', theme: ... })`
3. Returns colored text string → printed to stdout (or file)

---

## Testing & Validation

**Scripts**:
- `npm test` → `smoke-test.mjs`
  - Renders all 6 example diagrams in all formats
  - Validates SVG signature, PNG dimensions, ASCII output length
  - Tests CSS variable resolution, color mixing, width validation
  - Checks for 15 themes and 6 example files

- `npm run validate` → `validate-docs.mjs`
  - Crawls all `.md` files
  - Validates internal links exist
  - Checks theme references match `beautiful-mermaid.THEMES`

---

## Integration Points

### **As a Global Skill** (skills.sh)

- Registered as `pretty-mermaid` on skills.sh
- Installed globally via `npx skills add imxv/pretty-mermaid-skills@pretty-mermaid -g`
- Binaries exposed: `render-mermaid`, `batch-mermaid`, `list-mermaid-themes`
- **SKILL.md**: Full usage guide for AI agents (Claude, Cursor, Gemini CLI, etc.)

### **Standalone Use**

- Clone or npm install; run `node scripts/*.mjs` directly
- No build step required
- Auto-installs `beautiful-mermaid` on first run if missing

---

## Design Principles

1. **No Browser/DOM Required**: Mermaid diagrams rendered server-side via Rust + WASM
2. **Three Outputs, One Source**: SVG (scalable), PNG (shareable), ASCII (terminal-friendly)
3. **Theme Flexibility**: 15 built-in + arbitrary custom colors via CLI
4. **AI-Agent Friendly**: Designed for programmatic use by Claude, Cursor, and similar tools
5. **Minimal Dependencies**: Only `beautiful-mermaid` and `@resvg/resvg-js`
6. **Parallel Batch Processing**: Worker pool for fast multi-file rendering

---

## Known Limitations

- **PNG Custom Properties**: CSS `var()` and `color-mix()` must resolve to concrete hex/rgba at render time (Resvg limitation)
- **Scoped CSS**: Custom properties on non-root SVG elements not supported for PNG
- **Theme Scope**: 15 pre-built themes; custom theme creation requires direct `beautiful-mermaid` API
- **Diagram Types**: 6 supported (Flowchart, Sequence, State, Class, ER, XY Chart); others from Mermaid not exposed

---

**Last Updated**: 2026-09-14
