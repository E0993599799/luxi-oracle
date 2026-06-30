---
title: Dark Mode Implementation Guide — Dashboard Redesign
author: Khun-Ram Oracle (extracted from PaletaColor Pro + feedback)
date: 2026-06-28
status: REFERENCE — For Component Library (03)
source: https://paletacolorpro.com/en/dark-mode-converter
---

# Dark Mode Implementation Guide

> Reference guide for Luxi Oracle when filling in Component Library (03) dark mode specs.

---

## 🎨 Core Dark Mode Principles

### 1. **Background — Never Pure Black**

| What | Color | Reason |
|------|-------|--------|
| ✅ CORRECT | #121212 | Comfortable contrast (~15.4:1 with white text), reduces eye strain |
| ❌ WRONG | #000000 | Extreme contrast (21:1) causes eye fatigue |

**Rationale**: Pure black creates too much contrast with white text. Google Material Design recommends #121212.

### 2. **Surface — Elevation Via Lightness, Not Shadows**

In dark mode, shadows are invisible. Use lighter surfaces instead:

```
Base        #121212 (L≈7%)
Level 1     #1A1A1A (L≈10%)  — Cards, drawers
Level 2     #212121 (L≈13%)  — Modals, menus
Level 3     #292929 (L≈16%)  — Tooltips, snackbars
Level 4     #313131 (L≈19%)  — Focused elements
Level 5     #383838 (L≈22%)  — High elevation
```

Each level adds ~3% lightness for visual hierarchy.

### 3. **Text — Light Gray, Not Pure White**

| Context | Color | Why |
|---------|-------|-----|
| Body text | #E0E0E0 | Reduces eye strain, cleaner appearance |
| Secondary | #B0B0B0 | Slightly dimmer for hierarchy |
| ❌ Avoid | #FFFFFF | Too harsh, causes visual fatigue |

**Contrast with #121212 background**:
- #E0E0E0 text: 13.8:1 ratio ✅ **AAA** (exceeds WCAG AA minimum 4.5:1)
- #B0B0B0 text: 8.2:1 ratio ✅ **AA**

### 4. **Brand Colors — Lighten + Desaturate**

Don't invert. Adjust in two dimensions:

#### Example: Corporate Blue

**Light mode**:
- Color: #2563EB (bright, saturated)
- Background: #FFFFFF
- Contrast: Works well

**Dark mode conversion**:
- Lighten: #2563EB → #60A5FA (60% lighter)
- Desaturate: Reduce saturation by 10-20%
- Reason: Bright colors are too intense on dark backgrounds

#### Example: Error Red

**Light mode**: #DC2626 (warning color)

**Dark mode**: #F87171 (lighter, less intense)
- Keeps semantic meaning (still red)
- Reduces visual fatigue
- Maintains recognizability

### 5. **WCAG Contrast Requirements**

| Text Type | Size | Minimum Ratio | Dark Mode Example |
|-----------|------|---|---|
| Normal text | Any | 4.5:1 (AA) | #E0E0E0 on #121212 = 13.8:1 ✅ |
| Large text | >18px | 3:1 (AA) | #E0E0E0 on #121212 = 13.8:1 ✅ |
| AAA (enhanced) | Any | 7:1 | #E0E0E0 on #121212 = 13.8:1 ✅ |

**Dashboard requirement**: All text must meet **AA minimum (4.5:1)** per QA Checklist.

---

## 🎯 Semantic Role System

Map each color to its UI role, then convert:

| Role | Light Mode | Dark Mode | Lightness Change |
|------|-----------|----------|---|
| **Background** | #FFFFFF | #121212 | Invert |
| **Surface** | #F5F5F5 | #1E1E1E | Invert + lighter |
| **Primary** (brand) | #2563EB | #60A5FA | Lighten 60% + desaturate |
| **Secondary** | #7C3AED | #A78BFA | Lighten 50% + desaturate |
| **Text** (default) | #212121 | #E0E0E0 | Invert |
| **Text** (secondary) | #666666 | #B0B0B0 | Invert |

---

## 💡 Practical Conversion Steps

### Step 1: Start with Light Palette

Define your dashboard's light mode colors:
```
Background: #FFFFFF
Surface:    #F5F5F5
Primary:    #5B7FFF (dashboard brand blue from feedback)
Secondary:  #A78BFA (accent)
Text:       #212121
```

### Step 2: Apply Semantic Conversion

Use PaletaColor Pro's Dark Mode Converter:
1. Paste light palette
2. Select "Material" preset
3. Adjust primary/secondary manually if needed
4. Review contrast analysis

### Step 3: Verify WCAG Compliance

Check each text pairing:
- Text on Background: ≥4.5:1 ✅
- Text on Surface: ≥4.5:1 ✅
- Text on Primary: ≥3:1 (if large) ✅
- Text on Secondary: ≥3:1 (if large) ✅

**Tool**: Use PaletaColor Pro's WCAG Contrast calculator

### Step 4: Test Across Devices

- Desktop monitor
- Laptop screen
- Mobile device
- Tablet
- Different lighting conditions

### Step 5: Export CSS

Generate `prefers-color-scheme` CSS:

```css
:root {
  /* Light mode (default) */
  --bg: #FFFFFF;
  --surface: #F5F5F5;
  --primary: #5B7FFF;
  --text: #212121;
  --text-secondary: #666666;
}

@media (prefers-color-scheme: dark) {
  /* Dark mode */
  :root {
    --bg: #121212;
    --surface: #1E1E1E;
    --primary: #60A5FA;
    --text: #E0E0E0;
    --text-secondary: #B0B0B0;
  }
}

/* OR use data attribute for manual toggle */
[data-theme="dark"] {
  --bg: #121212;
  --surface: #1E1E1E;
  --primary: #60A5FA;
  --text: #E0E0E0;
  --text-secondary: #B0B0B0;
}
```

---

## ⚠️ Common Dark Mode Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Pure black background (#000) | Eye strain | Use #121212 instead |
| Pure white text (#FFF) | Too harsh | Use #E0E0E0 instead |
| Bright saturated colors | Visual fatigue | Lighten + desaturate by 10-20% |
| Shadows for elevation | Invisible | Use lighter surfaces |
| No contrast testing | WCAG failures | Test all text pairings |
| Hard-coded colors | Can't toggle dark mode | Use CSS variables |

---

## 🛠️ Tools for Dark Mode Design

| Tool | Purpose | Cost |
|------|---------|------|
| [PaletaColor Pro Dark Mode Converter](https://paletacolorpro.com/en/dark-mode-converter) | Auto-convert light → dark palettes | Free |
| [PaletaColor Pro WCAG Contrast](https://paletacolorpro.com/en/contrast-calculator) | Verify contrast ratios | Free |
| [Material Design 3](https://material.io/design) | Reference implementation | Free |
| Browser DevTools | Test with `prefers-color-scheme` | Built-in |

---

## 📋 Checklist for Component Library (03)

When Luxi completes the Component Library, include:

- [ ] Light mode color palette defined (hex codes)
- [ ] Dark mode palette converted (hex codes)
- [ ] WCAG contrast analysis for all text pairings
- [ ] Elevation scale (6 levels with hex codes)
- [ ] CSS implementation with `prefers-color-scheme`
- [ ] `[data-theme="dark"]` attribute fallback
- [ ] Mobile/tablet/desktop color specifications
- [ ] Error/success/warning state colors (both modes)
- [ ] Thai text rendering tested (line-height adjusted)
- [ ] Dark mode preview screenshots (light + dark side-by-side)

---

## 🎯 For Day 1 (2026-06-29)

**Luxi's Task**:
1. Define light mode palette (5-10 colors minimum)
2. Use PaletaColor Pro to convert to dark mode
3. Verify WCAG compliance
4. Add results to Component Library (03)

**Khun-Ram's Task** (Supporting):
- Verify dark mode specs meet QA Checklist requirements
- Document any custom conversions in Architecture (01)
- Flag any contrast failures for QA team

---

## References

**Source**: https://paletacolorpro.com/en/dark-mode-converter
**WCAG 2.1 Contrast**: https://www.w3.org/WAI/test-evaluate/contrast-checker/
**Material Design 3 Dark Theme**: https://material.io/design/color/the-color-system.html#color-usage-and-palettes
**CSS prefers-color-scheme**: https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme

---

**[MARCUZ:Khun-Ram]** — Dark Mode Reference Guide  
*Extracted from PaletaColor Pro + dashboard feedback. Ready for Component Library integration.*
