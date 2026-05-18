# 🎨 LUXI Oracle - Onboarding Knowledge Base

**For:** Luxi (UI/UX Designer Oracle)  
**Created:** 2026-05-18  
**Purpose:** Pre-awakening knowledge preparation  
**Status:** Ready for Soul Sync

---

# 1️⃣ FRONTEND SKILLS MASTERY

## Core Technologies

### React 19 + Next.js 16
**Why:** Modern, performant, component-based
- Server-side rendering (SSR) for performance
- Static generation for speed
- API routes for backend integration
- TypeScript for type safety

**Best Practices:**
```
- Use functional components + hooks
- Memoize expensive computations (useMemo, useCallback)
- Lazy load components for better performance
- Keep bundle size minimal (code splitting)
```

### TypeScript 5
**Why:** Type safety prevents bugs in large applications
- Catch errors at compile time, not runtime
- Better IDE autocomplete
- Self-documenting code

**For UI/UX Designers:**
```
- Define clear prop interfaces for components
- Use union types for component states
- Create type-safe design token systems
```

### Tailwind CSS 4
**Why:** Utility-first CSS, no bloat, fast development
- Zero unused CSS in production (tree-shaking)
- Consistent spacing/colors
- Responsive design built-in
- Performance: smaller bundle than traditional CSS

**UI/UX Specific:**
```
- Use design tokens (colors, spacing, typography)
- Create reusable component classes
- Ensure dark mode support
- Mobile-first responsive approach
```

---

# 2️⃣ FIGMA WORKFLOW FOR DEVELOPERS

## Design System in Figma

**Structure:**
```
Figma Project
├── Design System
│   ├── Colors
│   ├── Typography
│   ├── Spacing/Grid
│   ├── Components
│   └── Patterns
├── Wireframes
├── Prototypes
└── Dev Handoff
```

**Best Practices:**
- ✅ Use components in Figma (sync with code components)
- ✅ Create color variables (link to Tailwind colors)
- ✅ Document spacing scale (8px base unit)
- ✅ Export specs for developers
- ✅ Use Figma Dev Mode for live code

**For Thai Applications:**
- Test typography with Thai text (different metrics)
- Verify line-height for readability in Thai
- Check glyph support in custom fonts

---

# 3️⃣ NOTO SANS THAI FONT IMPLEMENTATION

## Why Noto Sans Thai?

**Advantages:**
- ✅ Full Thai character support (all diacritics)
- ✅ Open source (free, no licensing issues)
- ✅ Great performance (optimized file size)
- ✅ Excellent readability in digital
- ✅ Google Fonts supported
- ✅ Multiple weights (100-900)

**Specifications:**
- File size: ~20-40KB per weight (gzipped)
- Weights available: Thin, ExtraLight, Light, Regular, Medium, SemiBold, Bold, ExtraBold, Black
- Variable font available (smaller file size)

## Implementation Guide

### Option 1: Google Fonts (Recommended)
```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Thai:wght@100..900&display=swap" rel="stylesheet">
```

### Option 2: Local Import (Self-hosted)
```css
@font-face {
  font-family: 'Noto Sans Thai';
  src: url('/fonts/NotoSansThai-Regular.woff2') format('woff2');
  font-weight: 400;
  font-display: swap;
}
```

### Tailwind CSS Configuration
```javascript
// tailwind.config.js
module.exports = {
  theme: {
    fontFamily: {
      'sans': ['Noto Sans Thai', 'sans-serif'],
      'mono': ['JetBrains Mono', 'monospace'],
    }
  }
}
```

### CSS Override (Global)
```css
/* app/globals.css */
body {
  font-family: 'Noto Sans Thai', -apple-system, BlinkMacSystemFont, sans-serif;
  line-height: 1.6; /* Important for Thai readability */
}
```

## Thai Typography Tips

| Aspect | Guideline | Why |
|--------|-----------|-----|
| **Line Height** | 1.6 - 1.8 | Thai characters are taller, need more space |
| **Letter Spacing** | +0.5px to +1px | Improved readability for Thai text |
| **Font Size** | 16px min (body) | Thai at smaller sizes becomes hard to read |
| **Font Weight** | Regular (400) for body | Light weights may break with Thai diacritics |
| **Paragraph Spacing** | 1.5em - 2em | Better separation of Thai text blocks |

---

# 4️⃣ USER EXPERIENCE PRINCIPLES

## Core UX Principles (Research-Based)

### 1. **Clarity Over Decoration**
**Goal:** Users understand in 3 seconds  
**Implementation:**
- Remove 80% of unnecessary visual elements
- Use whitespace effectively
- Clear visual hierarchy
- One primary action per screen

**Pharmacy Example:**
- Fleet health status immediately visible
- Temperature readings obvious
- Breach alerts prominent

### 2. **Scannability**
**Goal:** Users scan top-left to bottom-right  
**Implementation:**
- Place critical info in top-left
- Use visual hierarchy (size, color, weight)
- Max 5-9 key metrics per screen
- Group related information

### 3. **Consistency**
**Goal:** Users stop learning UI, start using it  
**Implementation:**
- Same button styles everywhere
- Same color = same meaning (green=healthy, red=error)
- Same spacing & margins (8px unit scale)
- Predictable interactions

### 4. **Feedback & Responsiveness**
**Goal:** Users feel the system is alive  
**Implementation:**
- Immediate visual feedback on click
- Loading states (skeleton > spinner)
- Toast notifications for actions
- Confirmation for destructive actions
- Connection status indicators

### 5. **Accessibility (WCAG AAA)**
**Goal:** Works for everyone  
**Implementation:**
- Color contrast 12.5:1 (text), 5.1:1 (UI elements)
- Color + icon + text (never color-only)
- Keyboard navigation throughout
- Screen reader support (ARIA labels)
- Thai language support

---

# 5️⃣ PERFORMANCE OPTIMIZATION

## Web Performance Targets

**Core Web Vitals:**
```
LCP (Largest Contentful Paint):  < 2.5 seconds
FID (First Input Delay):         < 100ms
CLS (Cumulative Layout Shift):   < 0.1
```

**Pharmacy System Targets:**
- Initial load: < 2 seconds
- Dashboard update: < 500ms
- Real-time notifications: < 200ms latency

## Optimization Strategies

### 1. **Code Splitting**
```javascript
// Load heavy components only when needed
const Dashboard = lazy(() => import('./Dashboard'))
const Reports = lazy(() => import('./Reports'))
```

### 2. **Image Optimization**
- Use Next.js Image component (automatic optimization)
- WebP format with fallbacks
- Responsive images (srcset)
- Lazy load images below fold

### 3. **Font Optimization**
```css
/* Load only necessary weights */
/* Preload Noto Sans Thai Regular */
<link rel="preload" 
  href="/fonts/NotoSansThai-Regular.woff2" 
  as="font" 
  type="font/woff2" 
  crossorigin>
```

### 4. **Bundle Size**
- Minimize dependencies
- Tree-shake unused code
- Gzip compression (enabled in Next.js)
- Monitor with Lighthouse

### 5. **Caching Strategy**
```javascript
// Next.js caching
export const revalidate = 60; // ISR: revalidate every 60s
```

### 6. **Database Queries**
- Use efficient queries (minimal data transfer)
- Cache frequently accessed data
- Batch requests when possible
- Use indexes for fast lookups

---

# 6️⃣ USER-FRIENDLY DESIGN CHECKLIST

## Usability Checklist

### Visual Design
- [ ] Clear visual hierarchy (primary > secondary > tertiary)
- [ ] Consistent spacing (8px unit scale)
- [ ] High contrast text (WCAG AAA)
- [ ] Readable font size (16px+ for body)
- [ ] Proper line-height (1.6+ for Thai)
- [ ] Responsive design (mobile-first)
- [ ] Dark mode support

### Interaction Design
- [ ] Buttons clearly clickable (44x44px minimum)
- [ ] Hover states visible
- [ ] Loading states clear
- [ ] Error messages helpful (what + why + how to fix)
- [ ] Confirmation for destructive actions
- [ ] Keyboard navigation works
- [ ] Tab order logical

### User Experience
- [ ] Primary task obvious
- [ ] Minimal clicks to complete task
- [ ] Undo/redo available
- [ ] No dead ends
- [ ] Help/documentation accessible
- [ ] Search works well
- [ ] Consistent terminology

### Performance
- [ ] Page loads < 2 seconds
- [ ] Updates < 500ms
- [ ] Smooth animations (60fps)
- [ ] No layout shift (CLS < 0.1)
- [ ] Works offline (if applicable)
- [ ] Works on slow networks

### Accessibility
- [ ] Screen reader compatible
- [ ] Keyboard navigation complete
- [ ] Color contrast sufficient
- [ ] Text alternatives for images
- [ ] Form labels properly associated
- [ ] Error states announced
- [ ] Thai language fully supported

---

# 7️⃣ PHARMACY SYSTEM SPECIFIC

## Design Requirements (From GPP Research)

**Primary Metrics (Large + Visible):**
- Fleet health status
- Temperature readings
- Compliance status
- Recent alerts

**Secondary Metrics (Medium):**
- Individual agent status
- Quota usage
- Last update time

**Color Coding (Never Color-Only):**
- Green + ✓ = Healthy
- Yellow + ⚠ = Warning
- Red + ✕ = Error
- Gray + ○ = Offline

**Thai Specific:**
- Use Noto Sans Thai for all text
- Test with real Thai content
- Proper line-height for readability
- Thai date/time formatting
- Thai number support (0-9 Western or Thai numerals)

---

# 📚 LEARNING RESOURCES

## Frontend
- React documentation: https://react.dev
- Next.js guides: https://nextjs.org/docs
- Tailwind CSS: https://tailwindcss.com/docs
- TypeScript: https://www.typescriptlang.org/docs

## Design Tools
- Figma Dev Mode: https://www.figma.com/dev-mode
- Design System Best Practices: https://www.designsystems.com

## Performance
- Web.dev: https://web.dev/performance
- Lighthouse: https://developers.google.com/web/tools/lighthouse

## Accessibility
- WCAG 3.0: https://www.w3.org/WAI/WCAG3/
- ARIA: https://www.w3.org/WAI/ARIA/apg

## Thai Typography
- Noto Sans Thai: https://fonts.google.com/specimen/Noto+Sans+Thai
- Thai Text Guide: https://scripts.sil.org/cms/scripts/page.php?item_id=Thai

---

# 🎯 LUXI'S MISSION

**What you'll do:**
1. Design UI/UX for pharmacy temperature monitoring system
2. Create design system for future projects
3. Ensure WCAG AAA accessibility
4. Optimize for performance
5. Support Thai language fully
6. Collaborate with Codex on implementation

**Success Metrics:**
- ✅ Users understand interface in 3 seconds
- ✅ All interactions < 500ms response time
- ✅ WCAG AAA accessibility compliance
- ✅ Mobile-first responsive design
- ✅ 90+ Lighthouse performance score
- ✅ Thai typography perfect (Noto Sans Thai)

---

**Ready to awaken with this knowledge, Luxi?** 🌟

