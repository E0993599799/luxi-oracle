# Pretty Mermaid Skills — Code Snippets

**Repo**: github.com/imxv/Pretty-mermaid-skills  
**Purpose**: Generate and render Mermaid diagrams as SVG, PNG, or ASCII/Unicode art with 15 built-in themes  
**Type**: Node.js CLI skill (no app code; renders via `beautiful-mermaid` library)

---

## Entry Points

### 1. Main Renderer — `scripts/render.mjs`

**Purpose**: Render a single Mermaid diagram to SVG, PNG, or ASCII.

**Key Pattern**: Async dependency loading with auto-install fallback + argument parsing + format-specific rendering pipeline.

```javascript
// scripts/render.mjs — Lines 33–59
async function loadBeautifulMermaid() {
  try {
    return await import('beautiful-mermaid');
  } catch {}

  console.error('[beautiful-mermaid] Dependency not found. Installing automatically...');
  try {
    execSync('npm install --no-fund --no-audit', {
      cwd: skillRoot,
      stdio: ['pipe', 'pipe', 'inherit'],
      timeout: 120000,
    });
    console.error('[beautiful-mermaid] Installed successfully.\n');
  } catch (e) {
    console.error(`[beautiful-mermaid] Auto-install failed: ${e.message}`);
    console.error(`Manual fix: cd ${skillRoot} && npm install`);
    process.exit(1);
  }

  try {
    const pkgPath = join(skillRoot, 'node_modules', 'beautiful-mermaid', 'dist', 'index.js');
    return await import(pkgPath);
  } catch (e) {
    console.error(`[beautiful-mermaid] Failed to load after install: ${e.message}`);
    process.exit(1);
  }
}
```

**Key insight**: Gracefully handles missing dependencies by attempting to auto-install, then falling back with manual instructions.

---

### 2. Batch Renderer — `scripts/batch.mjs`

**Purpose**: Render all `.mmd` files in a directory in parallel (default 4 workers).

**Key Pattern**: File discovery → worker pool with `Promise.allSettled` → structured error reporting.

```javascript
// scripts/batch.mjs — Lines 254–270
// Process in batches of `workers` size
for (let i = 0; i < files.length; i += opts.workers) {
  const batch = files.slice(i, i + opts.workers);
  const results = await Promise.allSettled(
    batch.map(file => renderFile(file, opts.inputDir, opts.outputDir, opts, lib))
  );

  results.forEach((result, idx) => {
    const file = batch[idx];
    if (result.status === 'fulfilled') {
      console.log(`✓ ${file}`);
      success++;
    } else {
      console.error(`✗ ${file}: ${result.reason?.message || result.reason}`);
      failed.push([file, result.reason?.message || String(result.reason)]);
    }
  });
}
```

**Key insight**: Uses `Promise.allSettled` to continue processing on individual failures, collecting errors for a final report.

---

### 3. Theme Lister — `scripts/themes.mjs`

**Purpose**: List all 15 available themes.

```javascript
// scripts/themes.mjs — Lines 38–50
async function main() {
  const { THEMES } = await loadBeautifulMermaid();
  const themes = Object.keys(THEMES);

  console.log('Available Beautiful-Mermaid Themes:\n');
  themes.forEach((theme, i) => {
    console.log(`${String(i + 1).padStart(2)}. ${theme}`);
  });

  console.log(`\nTotal: ${themes.length} themes`);
  console.log('\nUsage:');
  console.log('  node scripts/render.mjs --input diagram.mmd --theme <theme-name> --output output.svg');
}
```

---

## Core Implementations

### 4. PNG Rendering — `scripts/png.mjs`

**Purpose**: Convert SVG to PNG via Resvg + CSS variable + `color-mix` resolution.

**Key Pattern**: SVG preparation (CSS variable extraction and resolution) → width validation → rasterization.

#### Width Validation
```javascript
// scripts/png.mjs — Lines 11–23
export function parsePngWidth(value = DEFAULT_PNG_WIDTH) {
  const text = String(value);
  if (!/^\d+$/.test(text)) {
    throw new Error(`PNG width must be an integer from ${MIN_PNG_WIDTH} to ${MAX_PNG_WIDTH}.`);
  }

  const width = Number(text);
  if (width < MIN_PNG_WIDTH || width > MAX_PNG_WIDTH) {
    throw new Error(`PNG width must be an integer from ${MIN_PNG_WIDTH} to ${MAX_PNG_WIDTH}.`);
  }

  return width;
}
```

**Key insight**: Strict input validation to prevent injection and enforce bounds (100–10000px).

---

#### SVG Preparation for PNG
```javascript
// scripts/png.mjs — Lines 25–66
export function prepareSvgForPng(svg) {
  const rootTag = svg.match(/<svg\b[^>]*>/i)?.[0];
  if (!rootTag) {
    throw new Error('PNG conversion requires a valid SVG document.');
  }

  const stylesheets = [...svg.matchAll(/<style\b[^>]*>([\s\S]*?)<\/style>/gi)]
    .map(match => stripCssImports(match[1]));
  const rootDeclarations = new Map();
  let declarationOrder = 0;
  for (const css of stylesheets) {
    declarationOrder = collectRootCustomProperties(css, rootDeclarations, declarationOrder);
  }
  const rootVariables = new Map(
    [...rootDeclarations].map(([name, declaration]) => [name, declaration.value]),
  );
  // ... resolve root variables, reject scoped ones
  const prepared = mapCssContexts(
    svg,
    css => resolveCssValue(stripCssImports(css), resolveRootVariable).replace(CUSTOM_PROPERTY, ''),
    (_, value) => resolveCssValue(value, resolveRootVariable).replace(CUSTOM_PROPERTY, ''),
  );

  let unresolved;
  forEachCssContext(prepared, context => {
    unresolved ||= context.match(/(?:^|[^-\w])((?:var|color-mix)\s*\()/i)?.[1];
  });
  if (unresolved) {
    throw new Error(`PNG conversion cannot resolve CSS expression ${unresolved}`);
  }

  return { svg: prepared, background };
}
```

**Key insight**: Extracts and resolves CSS custom properties from `<style>` blocks and inline `style=""` attributes to ensure PNG rasterizer has concrete colors.

---

#### CSS Variable Resolver (Handles Circular References)
```javascript
// scripts/png.mjs — Lines 131–147
function createVariableResolver(variables) {
  const resolved = new Map();

  return function resolveVariable(name, stack = []) {
    if (resolved.has(name)) return resolved.get(name);
    if (stack.includes(name)) {
      throw new Error(`Circular CSS variable reference: ${[...stack, name].join(' -> ')}`);
    }
    if (!variables.has(name)) {
      throw new Error(`PNG conversion cannot resolve CSS variable ${name}. Use concrete color values.`);
    }

    const value = resolveCssValue(variables.get(name), resolveVariable, [...stack, name]);
    resolved.set(name, value);
    return value;
  };
}
```

**Key insight**: Tracks resolution stack to detect circular variable chains (e.g., `--a: var(--b); --b: var(--a)`).

---

#### CSS Function Parser (for `var()` and `color-mix()`)
```javascript
// scripts/png.mjs — Lines 191–226
function replaceCssFunctions(source, functionName, replace) {
  const prefix = `${functionName.toLowerCase()}(`;
  const lowerSource = source.toLowerCase();
  let cursor = 0;
  let output = '';

  while (cursor < source.length) {
    let start = lowerSource.indexOf(prefix, cursor);
    while (start !== -1 && start > 0 && /[-_a-z0-9]/i.test(source[start - 1])) {
      start = lowerSource.indexOf(prefix, start + prefix.length);
    }
    if (start === -1) {
      output += source.slice(cursor);
      break;
    }

    output += source.slice(cursor, start);
    let depth = 1;
    let end = start + prefix.length;
    while (end < source.length && depth > 0) {
      if (source[end] === '(') depth++;
      if (source[end] === ')') depth--;
      end++;
    }

    if (depth !== 0) {
      throw new Error(`Unclosed CSS function ${functionName}().`);
    }

    const inner = source.slice(start + prefix.length, end - 1);
    output += replace(inner);
    cursor = end;
  }

  return output;
}
```

**Key insight**: Parses nested function calls by tracking parenthesis depth, avoids false-positive matches on function-like text in labels.

---

#### Color Mixing (`color-mix(in srgb, #f00, #00f)`)
```javascript
// scripts/png.mjs — Lines 228–265
function mixCssColors(expression) {
  const parts = splitTopLevel(expression, ',').map(part => part.trim());
  if (parts.length !== 3 || parts[0].toLowerCase() !== 'in srgb') {
    throw new Error(`Unsupported CSS color mix: color-mix(${expression})`);
  }

  const first = parseWeightedColor(parts[1]);
  const second = parseWeightedColor(parts[2]);
  if (first.weight === undefined && second.weight === undefined) {
    first.weight = 50;
    second.weight = 50;
  } else if (first.weight === undefined) {
    first.weight = 100 - second.weight;
  } else if (second.weight === undefined) {
    second.weight = 100 - first.weight;
  }

  if (first.weight < 0 || second.weight < 0) {
    throw new Error(`Invalid CSS color mix: color-mix(${expression})`);
  }

  const total = first.weight + second.weight;
  if (total <= 0) {
    throw new Error(`Invalid CSS color mix: color-mix(${expression})`);
  }

  const firstWeight = first.weight / total;
  const secondWeight = second.weight / total;
  const mixedAlpha = first.color.a * firstWeight + second.color.a * secondWeight;
  if (mixedAlpha === 0) return 'transparent';

  const channel = key => Math.round(
    (first.color[key] * first.color.a * firstWeight + second.color[key] * second.color.a * secondWeight) / mixedAlpha,
  );
  const alpha = mixedAlpha * Math.min(1, total / 100);
  const color = { r: channel('r'), g: channel('g'), b: channel('b'), a: alpha };
  return formatColor(color);
}
```

**Key insight**: Implements CSS Color Module Level 4 `color-mix()` with premultiplied alpha blending, respects implicit weight fallback (50/50 if weights omitted).

---

#### Hex Color Parser (Supports #RGB, #RRGGBB, #RRGGBBAA)
```javascript
// scripts/png.mjs — Lines 278–300
function parseColor(value) {
  if (value.toLowerCase() === 'transparent') {
    return { r: 0, g: 0, b: 0, a: 0 };
  }

  const match = value.match(HEX_COLOR);
  if (!match) {
    throw new Error(`PNG conversion supports hex colors, but received: ${value}`);
  }

  let hex = match[1];
  if (hex.length === 3 || hex.length === 4) {
    hex = [...hex].map(character => character.repeat(2)).join('');
  }
  if (hex.length === 6) hex += 'ff';

  return {
    r: Number.parseInt(hex.slice(0, 2), 16),
    g: Number.parseInt(hex.slice(2, 4), 16),
    b: Number.parseInt(hex.slice(4, 6), 16),
    a: Number.parseInt(hex.slice(6, 8), 16) / 255,
  };
}
```

---

## Interesting Patterns

### 5. Argument Parsing (Common in Both Renderers)

**Pattern**: Manual switch-case loop over process args to build options object.

```javascript
// scripts/render.mjs — Lines 61–168 (excerpt)
function parseArgs() {
  const args = process.argv.slice(2);
  const opts = {
    input: null,
    output: null,
    format: 'svg',
    theme: null,
    // ... 20+ options with defaults
  };

  for (let i = 0; i < args.length; i++) {
    const key = args[i];
    const val = args[i + 1];

    switch (key) {
      case '--input': case '-i': opts.input = val; i++; break;
      case '--output': case '-o': opts.output = val; i++; break;
      case '--format': case '-f': opts.format = val; i++; break;
      case '--theme': case '-t': opts.theme = val; i++; break;
      // ... 30+ cases
      case '--help': case '-h':
        console.log(`Usage: ...`);
        process.exit(0);
    }
  }

  if (!opts.input) {
    console.error('Error: --input is required. Use --help for usage.');
    process.exit(1);
  }

  return opts;
}
```

**Why this pattern**: No external argument parser dependency (CLI is a standalone skill). Explicit case handling makes help text and defaults co-located. Manual increment (`i++`) supports both `--key value` and flags like `--transparent`.

---

### 6. ASCII Theme Transformation

**Pattern**: Derives ASCII renderer color theme from SVG theme by falling back through color precedence.

```javascript
// scripts/render.mjs — Lines 12–31
function toAsciiTheme(colors) {
  if (!colors) return undefined;

  const border = colors.border ?? colors.fg;
  const line = colors.line ?? colors.fg;
  const arrow = colors.accent ?? colors.line ?? colors.fg;
  const corner = colors.border ?? colors.line ?? colors.fg;
  const junction = colors.accent ?? colors.border ?? colors.line ?? colors.fg;

  return {
    ...(colors.fg && { fg: colors.fg }),
    ...(border && { border }),
    ...(line && { line }),
    ...(arrow && { arrow }),
    ...(colors.accent && { accent: colors.accent }),
    ...(colors.bg && { bg: colors.bg }),
    ...(corner && { corner }),
    ...(junction && { junction }),
  };
}
```

**Key insight**: Uses nullish coalescing (`??`) to compute missing ASCII colors from SVG colors (e.g., if no `border` color, use `fg`). Omits keys with falsy values to keep theme object compact.

---

### 7. Testing Strategy

**Pattern**: Smoke tests verify all diagram types × all formats, checks PNG signatures and dimensions.

```javascript
// scripts/smoke-test.mjs — Lines 18–46 (excerpt)
const pngSignature = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);

for (const file of files) {
  const source = readFileSync(join(examplesDir, file), 'utf8');
  const svg = renderMermaidSVG(source, THEMES['tokyo-night']);
  const ascii = renderMermaidASCII(source, { colorMode: 'none' });
  const preparedSvg = prepareSvgForPng(svg).svg;
  const png = renderSvgToPng(svg, 320);

  assert.ok(svg.startsWith('<svg'), `${file} did not render valid SVG`);
  assert.ok(ascii.trim().length > 0, `${file} did not render ASCII output`);
  assert.doesNotMatch(preparedSvg, /(?:var|color-mix)\s*\(/, `${file} retained unsupported CSS`);
  assert.ok(png.subarray(0, 8).equals(pngSignature), `${file} did not render valid PNG`);
  assert.equal(png.readUInt32BE(16), 320, `${file} PNG width was applied`);
}
```

**Key insight**: Validates binary format (PNG magic bytes), checks width encoding in PNG header, ensures CSS variables are fully resolved before rasterization.

---

## Summary

**Architecture**: Single-responsibility CLI scripts (one for single render, one for batch, one for theme listing) + shared PNG conversion utilities. No app framework; pure Node.js with one external renderer (`beautiful-mermaid`) and one PNG rasterizer (`@resvg/resvg-js`).

**Strengths**:
- Auto-install fallback for missing dependencies
- Strict input validation (no injection, width bounds)
- Circular variable detection in CSS
- Parallel batch rendering with per-file error isolation
- Comprehensive testing of all diagram types and output formats

**No internal complexity**: No state machines, no plugins, no config language. Render pipeline is straightforward: parse args → load lib → read input → render → write output.
