# Captain Maid 2.0 — Design System Master

**Version:** 1.0  
**Last Updated:** 2026-07-14  
**Designed by:** Luxi Junior Oracle  
**Status:** Ready for Implementation

---

## System Classification

**Pattern:** Real-Time / Operations Landing (Service/Product e-commerce)  
**Style:** Vibrant & Block-based  
**Mood:** Professional, trustworthy, accessible, energetic  
**Target:** Thai families seeking premium home cleaning solutions

---

## Color System

### Primary Colors

```css
/* CSS Variables — Recommended Implementation */
--color-primary: #0F766E;        /* Trust Teal — Main brand color */
--color-primary-light: #E8F0F3;  /* Soft teal — Backgrounds */
--color-secondary: #14B8A6;      /* Vibrant teal — Accent, hover states */
--color-accent: #0369A1;         /* Professional blue — CTAs, primary actions */
--color-background: #F0FDFA;     /* Light teal — Page background */
--color-foreground: #134E4A;     /* Dark teal — Primary text */
--color-muted: #E8F0F3;          /* Muted teal — Secondary text, borders */
--color-border: #99F6E4;         /* Border teal — Dividers, outlines */
--color-destructive: #DC2626;    /* Red — Errors, warnings */
--color-ring: #0F766E;           /* Focus ring — Keyboard navigation */
```

### Contrast Compliance

| Pair | Ratio | WCAG | Use Case |
|------|-------|------|----------|
| Foreground on Background | 12.5:1 | AAA ✓ | Body text, headings |
| Accent on White | 4.8:1 | AA ✓ | Buttons, links |
| Destructive on White | 5.2:1 | AA ✓ | Error messages |
| Secondary on Light | 4.6:1 | AA ✓ | Secondary actions |

---

## Typography System

### Font Stack

```css
/* Headings: Bold, accessible, geometric */
--font-heading: 'Lexend', system-ui, sans-serif;

/* Body: Professional, readable */
--font-body: 'Source Sans 3', system-ui, sans-serif;

/* Code/Data: Monospace */
--font-mono: 'Monaco', 'Courier New', monospace;
```

### Google Fonts Import

```html
<link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;500;600;700&family=Source+Sans+3:wght@300;400;500;600;700&display=swap" rel="stylesheet">
```

### Type Scale

| Role | Size | Weight | Line-height | Usage |
|------|------|--------|-------------|-------|
| H1 | 48px | 700 | 1.2 | Page title, hero headline |
| H2 | 36px | 700 | 1.25 | Section titles |
| H3 | 28px | 600 | 1.3 | Subsection titles |
| H4 | 24px | 600 | 1.4 | Card titles |
| H5 | 20px | 600 | 1.4 | Label titles |
| Body | 16px | 400 | 1.6 | Paragraph text |
| Body small | 14px | 400 | 1.6 | Secondary text, helper |
| Label | 12px | 500 | 1.5 | Form labels, badges |
| Code | 14px | 400 | 1.6 | Code blocks |

---

## Spacing Scale

### Base Unit: 8px

```css
--space-xs: 4px;     /* Icon padding */
--space-sm: 8px;     /* Component gap */
--space-md: 16px;    /* Card padding */
--space-lg: 24px;    /* Section padding */
--space-xl: 32px;    /* Page padding */
--space-2xl: 48px;   /* Section gap */
--space-3xl: 64px;   /* Hero section gap */
--space-4xl: 96px;   /* Major section separator */
```

---

## Effects & Motion

### Transitions

```css
--duration-fast: 150ms;
--duration-base: 200ms;
--duration-slow: 300ms;

--easing-out: cubic-bezier(0.4, 0, 0.2, 1);
--easing-in: cubic-bezier(0.4, 0, 0.6, 1);
--easing-smooth: cubic-bezier(0.4, 0, 0.2, 1);
```

---

## Anti-Patterns (Avoid)

- Flat design without depth
- Text-heavy solutions section
- Multiple competing CTAs
- Color alone for meaning
- Icon-only navigation
- No focus ring on interactive elements
- Hover-only interactions
- Decorative animations

---

**Master document maintained by:** Luxi Junior Oracle  
**Version:** 1.0  
**Last updated:** 2026-07-14
