# Captain Maid Landing Page — Design Audit & Recommendations

**Date:** 2026-07-14  
**Auditor:** Luxi Junior Oracle  
**Page:** Captain Maid Homepage (Thai/English)  
**Status:** 5 Recommendations Ready for Implementation

---

## Executive Summary

Captain Maid's landing page has **strong foundation** (product-focused, clear sections, trust signals) but needs **5 key improvements** to match professional design standards:

1. 🎨 **Color System** — Introduce teal palette (#0F766E primary)
2. 📐 **Spacing** — Increase section gaps to 48px+
3. ✨ **Motion** — Add hover effects, 200-300ms transitions
4. ♿ **Accessibility** — Full WCAG AAA audit needed
5. 🎯 **CTA Clarity** — Reduce competing calls-to-action

---

## Strengths ✅

1. **Product-led design** — Hero immediately shows cleaning products + family use case
2. **Multiple trust signals** — Stats (1M+ customers), testimonials, badges
3. **Content hierarchy** — Clear flow (Hero → Solutions → Products → Trust → Blog)
4. **Localization** — Thai/English parity, proper typography
5. **Professional photography** — High-quality lifestyle + product images

---

## Gaps vs. Design System

| Aspect | Current | Target | Priority |
|--------|---------|--------|----------|
| Color palette | Blue-heavy | Teal + blue accent | P0 |
| Section spacing | 24–32px | 48px+ gaps | P1 |
| Motion/effects | Minimal | 200-300ms transitions | P1 |
| Accessibility | Unaudited | WCAG AAA | P0 |
| CTA consolidation | Multiple CTAs | 1 primary per section | P1 |

---

## Top 5 Recommendations

### 1. Implement Teal Color System (CRITICAL)

**Why:** Current blue is professional but doesn't align with design system's trust + energy blend.

**Action:**
```css
--color-primary: #0F766E;        /* Trust teal */
--color-secondary: #14B8A6;      /* Vibrant teal */
--color-accent: #0369A1;         /* CTA blue */
```

**Apply to:**
- Primary nav button
- Trust badges
- Hover states
- Section backgrounds (soft teal)

**Timeline:** 1 day

---

### 2. Refactor Solutions Section (HIGH)

**Why:** 8 problem cards are too text-heavy; icons should be primary signal.

**Current:**
- Problem name + description (2 lines)
- Cramped at 12px gap

**Improved:**
- Large icon (40×40px) + 1-line label
- 16–24px card gap
- Hover: icon scales, card lifts
- Touch targets ≥ 48px

**Timeline:** 2–3 days

---

### 3. Add Micro-Interactions (MEDIUM)

**Why:** Static feel; needs hover feedback & motion.

**Add:**
- Button hover: color shift (200ms) + lift (2px)
- Card hover: lift (4px) + shadow
- Scroll animations: fade-in + slide-up on viewport enter
- Respect `prefers-reduced-motion`

**Example:**
```css
transition: all 200ms ease-out;

&:hover {
  background: var(--color-secondary);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(15, 118, 110, 0.2);
}
```

**Timeline:** 2–3 days

---

### 4. WCAG AAA Accessibility Audit (CRITICAL)

**Checklist:**
- [ ] Text contrast ≥ 4.5:1
- [ ] Focus rings visible (2–4px)
- [ ] Icon-only buttons have `aria-label`
- [ ] Form labels linked via `for`
- [ ] Keyboard nav works (Tab, Enter, Escape)
- [ ] Screen reader testing (VoiceOver/NVDA)
- [ ] Alt text on all images
- [ ] Heading hierarchy correct (h1 → h2 → h3)

**Timeline:** 2–3 days

---

### 5. Consolidate CTAs (HIGH)

**Current issue:** Multiple "Shop Now" / "View All" / "Explore" buttons competing.

**Recommendation:**
- **Hero:** 1 primary CTA ("Shop Now")
- **Solutions:** Cards link directly (no button)
- **Products:** "View All" primary + cards link to detail
- **Trust:** Optional "Contact us" secondary
- **Footer:** Navigation only, no product CTAs

**Timeline:** 1 day

---

## Section-by-Section Analysis

### Hero ✅ Strong
- Clear value prop
- Good visual hierarchy
- **Improve:** Add scroll-down indicator, lazy-load hero image

### Solutions ⚠️ Refactor Needed
- Too text-heavy
- **Improve:** Use icons as primary, reduce copy, add hover effects

### Products ✅ Good
- Clear cards
- **Improve:** Add rating stars, lazy-load images, WebP format

### Trust ✅ Strong
- Multiple signals
- **Improve:** Verify icon accessibility, add hover effects

### Blog ✅ Decent
- 3 latest posts
- **Improve:** Add reading time, author photo alt text

### FAQ ⚠️ Accessibility Check
- Accordion functional
- **Improve:** Verify ARIA, keyboard nav (Escape to close)

### Footer ✅ Standard
- Links present
- **Improve:** Group by category, ensure keyboard accessible

---

## Implementation Roadmap

### Phase 1: Foundation (Week 1)
- Implement teal color system
- Audit & fix contrast ratios
- Add focus ring styles

### Phase 2: Interaction (Week 2)
- Add hover effects to buttons & cards
- Implement smooth transitions (200ms)
- Add scroll animations

### Phase 3: Content Refactor (Week 2–3)
- Redesign Solutions section (icons + minimal text)
- Add CTA consolidation
- Lazy-load images

### Phase 4: Accessibility (Week 3)
- Full WCAG AAA audit
- Screen reader testing
- Keyboard navigation testing

### Phase 5: Delivery (Week 4)
- A/B test color changes
- Lighthouse scoring (target > 90)
- Deploy to staging → production

---

## Key Metrics

| Metric | Current | Target | Strategy |
|--------|---------|--------|----------|
| Lighthouse | TBD | > 90 | Image optimization, code splitting |
| LCP | TBD | < 2.5s | Hero WebP/AVIF, lazy-load below-fold |
| CLS | TBD | < 0.1 | Reserve space for images, use transform |
| Accessibility | TBD | WCAG AAA | Full audit + screen reader testing |

---

## Quick Wins (1–3 Days)

1. ✅ Apply teal color system (CSS variables)
2. ✅ Add focus ring styles
3. ✅ Consolidate CTAs
4. ✅ Add button hover effects (color + lift)

---

## Next Steps

1. **Review this audit** with پی‌عک (Ekkarat)
2. **Approve priorities** (P0 vs. P1 vs. P2)
3. **Create MASTER.md** (design system source of truth)
4. **Begin Phase 1** (color system + focus rings)

---

**Prepared by:** Luxi Junior Oracle  
**Status:** Ready for implementation  
**Golden Path:** 🛤️ Sūang, mǒng klai, ꥙ꥑꥲꥎꥄ
