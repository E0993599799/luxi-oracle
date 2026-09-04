# Captain Maid 2.0 — Design System Master

**Version:** 2.0  
**Last Updated:** 2026-09-05  
**Designed by:** Luxi Junior Oracle  
**Status:** Reconciled with live site (see note below)

> **2026-09-05 reconciliation note:** v1.0 of this document (teal system below, now superseded) did not match what was actually shipped on captain-maid.com. A live token audit (curl+grep against the production HTML/CSS, see `ψ/writing/2026-09-05_arigeo-captainmaid-live-token-audit.md`) found the real live palette is blue/amber/navy, not teal. พี่เอก decided: **the live site is current truth — this document is updated to match it**, not the other way around. Typography and border-radius below are updated on the same principle (documented reality > stale spec). If the live site changes again, re-run the audit and update this file again — don't let it drift a second time.

---

## System Classification

**Pattern:** Real-Time / Operations Landing (Service/Product e-commerce)  
**Style:** Vibrant & Block-based  
**Mood:** Professional, trustworthy, accessible, energetic  
**Target:** Thai families seeking premium home cleaning solutions

---

## Color System

### Primary Colors — as shipped on captain-maid.com (extracted 2026-09-05)

```css
/* CSS Variables — matches live production tokens */
--color-primary: #0079C1;        /* Brand Blue — dominant fill, 155 occurrences in live CSS */
--color-primary-dark: #002D5F;   /* Navy — headings, high-contrast text */
--color-primary-alt: #0460AB;    /* Secondary blue tint */
--color-secondary: #FFC107;      /* Amber — accents, highlights (fill/icon use only, see contrast note) */
--color-background: #F9FBFD;     /* Near-white page background */
--color-surface: #E6F3FA;        /* Light blue tint — cards, panels */
--color-surface-alt: #EEF7FC;    /* Alt light blue tint */
--color-border: #D9EDF8;         /* Border blue — dividers, outlines */
--color-muted: #526B7F;          /* Muted gray-blue — secondary text */
--color-foreground: #002D5F;     /* Primary text — use navy, not pure black */
```

`#0F766E` teal / `#14B8A6` / `#0369A1` (this document's v1.0 palette) are **not** present in the live site's CSS as of the 2026-09-05 audit — superseded, kept only in git history.

### Contrast Compliance (recomputed against the tokens above, 2026-09-05)

| Pair | Ratio | WCAG | Use Case |
|------|-------|------|----------|
| `--color-primary-dark` (#002D5F) on white | 13.63:1 | AAA ✓ | Body text, headings — prefer this over pure black |
| `--color-primary` (#0079C1) on white | 4.66:1 | AA ✓ / AAA ✗ | Buttons, links — passes AA only; do not use for small body text where AAA is required |
| `--color-muted` (#526B7F) on white | 5.57:1 | AA ✓ / AAA ✗ | Secondary text — passes AA only |
| `--color-secondary` (#FFC107) on white | **1.63:1** | **FAILS AA** | **Fill/icon/background use only — never as text color or on white without a dark overlay.** Confirm every live usage keeps amber off direct text. |

**Action item, not yet verified in the live DOM:** the amber failure above is a computed math fact about the color pair, not a confirmed live violation — it's only a problem if `#FFC107` is ever applied as a `color` (text) rather than `background`/`fill`. Worth a manual pass over captain-maid.com's rendered pages to confirm no text uses amber directly.

---

## Typography System

### Font Stack — as shipped on captain-maid.com (extracted 2026-09-05)

```css
/* English: live production font, with matching fallback metrics to avoid CLS */
--font-english: 'Roboto', 'Roboto Fallback', system-ui, sans-serif;

/* Thai: matches the repo's Noto Sans Thai standing order — already correct on this site */
--font-thai: 'Noto Sans Thai', 'Noto Sans Thai Fallback', sans-serif;

/* Combined stack as actually used in live CSS */
font-family: var(--font-english), var(--font-thai), 'Roboto', 'Noto Sans Thai', sans-serif;

/* Code/Data: unchanged */
--font-mono: 'Monaco', 'Courier New', monospace;
```

`Lexend` / `Source Sans 3` (this document's v1.0 fonts) are **not** present in captain-maid.com's live CSS — superseded. Note: **arigeo.com** (the parent brand site, separate from captain-maid.com) loads `Inter` + `Arimo` + `IBM Plex Sans Thai` instead of Noto Sans Thai — that site is out of sync with both this document and the repo's own standing order; flagged in `ψ/writing/2026-09-05_arigeo-captainmaid-live-token-audit.md`, not yet resolved.

### Type Scale

Live CSS confirms font-sizes up to `8rem` (128px) are already in use on captain-maid.com — larger than the H1 role below covers. Adding a `Display` role above H1 rather than inflating H1 itself keeps H1 usable for ordinary page titles while covering the oversized hero case already shipped:

| Role | Size | Weight | Line-height | Usage |
|------|------|--------|-------------|-------|
| Display | 96–128px (`6rem`–`8rem`) | 700 | 1.1 | One-per-page hero moment only — confirmed in live CSS, not previously documented |
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

## Border Radius

**Not previously documented in v1.0 — added 2026-09-05 after a live audit found 8 distinct radius values in active use on captain-maid.com (`2px, 5px, .25rem, .5rem, .75rem, 1rem, 1.5rem, 9999px`) with no visible system.** That's live reality, not a target — it reads as accumulated component drift, not a deliberate scale. Proposed consolidation (not yet applied to the live site — a follow-up task, tracked separately from this doc update):

```css
--radius-sm: 4px;     /* inputs, small chips */
--radius-md: 8px;     /* buttons, cards */
--radius-lg: 16px;    /* panels, modals */
--radius-full: 9999px; /* pills, avatars, badges only */
```

arigeo.com has the same problem independently (9 distinct values: `0, 2px, 3px, 4px, 8px, 10px, 14px, 50%, 999px`) — same proposed 4-step scale applies there too.

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
**Version:** 2.0 — reconciled with live captain-maid.com tokens  
**Last updated:** 2026-09-05
