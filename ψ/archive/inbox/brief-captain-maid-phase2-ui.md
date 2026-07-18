---
source: Zeus Oracle dispatch
date: 2026-07-13
priority: high
project: captain-maid
phase: UI redesign phase 2
assignee: luxi-oracle
status: archived — closed by commits below (2026-07-19)
---

> **ARCHIVED 2026-07-19** — Never formally acknowledged/closed in this inbox, but the work
> this brief asked for was substantially completed directly in the `captain-maid` repo:
>
> - `6fe658d` (2026-07-19 03:52) — `feat: ship Captain Maid Direction A static web`
> - `87975bc` (2026-07-19 03:52) — `merge: ship Captain Maid Direction A static web`
> - `be772bc` (2026-07-19 06:38) — `feat: connect CMS and refine Thai UX copy`
>
> These cover the section-based UI ship and the Thai copy quality concerns raised below.
> Not verified line-by-line against every checklist item in this brief (Lighthouse/WCAG AAA
> sign-off, per-section success criteria) — if a formal audit report is needed later, treat
> this brief's checklists as the reference and verify against current `captain-maid` state,
> not against this note.

# Brief: Captain Maid Phase 2 — UI/UX Redesign

**From**: Zeus Oracle  
**To**: Luxi Junior Oracle (UI/UX Lead)  
**Date**: 2026-07-13  
**Project**: Captain Maid 2.0 — Section-Based Architecture  
**Phase**: Phase 2 Enhancement (UI Polish & Accessibility)

---

## Mission

Complete the UI/UX redesign of Captain Maid website using section-based component architecture. Focus on:
1. **Section polish** — Every section renders cleanly on mobile/desktop
2. **Thai/English parity** — All copy has equivalent quality in both languages
3. **Accessibility** — WCAG AAA compliance across all components
4. **Performance** — Lighthouse > 90 (LCP < 2.5s, FID < 100ms, CLS < 0.1)
5. **User flow optimization** — Clear CTAs, intuitive navigation

---

## Current State (As of 2026-07-12)

**Repo**: `/mnt/d/01 Main Work/Boots/Agentic AI/mission-control/captain-maid/`

**Recent Commits**:
- f57157d: chore: audit fixes and dependency updates for captain-maid
- f2ca4b3: feat(ux): implement premium bento layout, PDP interactive swatches, mobile sticky cta
- 771a974: feat: Establish Rust workspace with maw-matcher library crate

**Architecture**: 8-section homepage + product catalog + blog + FAQ + where-to-buy pages

**Tech Stack**:
- Next.js 15 + React 19 + TypeScript
- Tailwind CSS 4
- next-intl (Thai/English)
- Framer Motion (animations)
- Supabase (backend)
- Vercel (deployment)

---

## Sections That Need Polish

### 1. Hero Section
- **Status**: Core exists, needs mobile refinement
- **Issues**: 
  - Hero image scaling on mobile
  - CTA button sizing (touch target ≥44×44px)
  - Text hierarchy clarity on small screens
- **Success Criteria**:
  - Readable on 360px width
  - CTA clearly visible above fold
  - Copy legible without zoom

### 2. Solutions Section (8 problem cards)
- **Status**: Cards exist, need responsive grid
- **Issues**:
  - Grid layout breaks on tablet sizes
  - Card hover effects don't work on touch
  - Icon sizing inconsistent
- **Success Criteria**:
  - 3 columns on desktop, 2 on tablet, 1 on mobile
  - Touch-friendly links (tap area ≥44×44px)
  - Consistent icon sizing + spacing

### 3. Products Section (6 core products + View All)
- **Status**: Product cards exist, need image optimization
- **Issues**:
  - Product images cause CLS (layout shift on load)
  - Missing alt text for Thai/English parity
  - Price formatting (THB currency) unclear
- **Success Criteria**:
  - Product images have proper aspect ratio (3:4) + alt text
  - CLS < 0.1 (use placeholder skeleton during load)
  - Price clearly marked in THB

### 4. Trust Section (proof, safety, credibility)
- **Status**: Copy exists, needs visual hierarchy
- **Issues**:
  - Trust indicators lack visual emphasis
  - No clear "certificates" or "badges" design
  - Mobile layout crushes content
- **Success Criteria**:
  - 3 trust pillars clearly separated
  - Icons + text work together (never color-alone)
  - Mobile: stacked layout, still readable

### 5. Blog Section (3 latest posts)
- **Status**: Blog query works, needs card design
- **Issues**:
  - Card layout needs image + excerpt + CTA
  - Publishing date format (Thai date? English?)
  - "Read more" CTA unclear
- **Success Criteria**:
  - Consistent card size + spacing
  - Date format matches locale
  - CTA button clear and tappable

### 6. FAQ Section (accordion)
- **Status**: Accordion component exists, needs polish
- **Issues**:
  - Accordion animation stutters on mobile
  - No clear "open/closed" visual indicator
  - Search/filter not implemented
- **Success Criteria**:
  - Smooth expand/collapse animation (60fps)
  - Clear chevron/arrow indicator (↓/↑)
  - Single-open FAQ (only one item expanded at a time)

### 7. CTA Section (shop, support)
- **Status**: Exists, needs button pair clarity
- **Issues**:
  - Two buttons confuse user intent
  - Colors too similar (need primary/secondary distinction)
  - Mobile stacking unclear
- **Success Criteria**:
  - Primary (Shop) vs Secondary (Support) visually distinct
  - Buttons stack cleanly on mobile
  - Touch targets ≥44×44px

### 8. Footer
- **Status**: Links exist, needs mobile restructuring
- **Issues**:
  - Too many links for mobile
  - No clear section grouping
  - Legal links hard to find
- **Success Criteria**:
  - Responsive column layout (4 cols desktop, 2 mobile)
  - Legal links in distinct section
  - Newsletter signup visible

---

## Thai/English Parity Checklist

**CRITICAL**: Every section must have equivalent visual & copy quality in both languages.

- [ ] Hero: Thai copy = English copy (same headline, same CTA)
- [ ] Solutions: 8 problems + solutions work in Thai
- [ ] Products: Product names, descriptions, prices in both languages
- [ ] Trust: All trust statements translated
- [ ] Blog: Post titles, excerpts have Thai equivalents
- [ ] FAQ: All Q&A pairs translated
- [ ] CTA: Button labels match both languages
- [ ] Footer: Links translated where needed

**Thai Typography Rules**:
- Font: Noto Sans Thai
- Line-height: 1.6+ (Thai needs more space)
- Letter-spacing: 0 (Thai script doesn't need extra)
- Don't truncate Thai text (always measure, never assume)

---

## Accessibility Checklist (WCAG AAA)

- [ ] Text contrast ≥ 12.5:1 (AAA level)
- [ ] Touch targets ≥ 44×44px
- [ ] Focus indicators visible (outline, not color-alone)
- [ ] Keyboard navigation works (Tab through all interactive elements)
- [ ] Screen reader alt-text on all images (Thai + English)
- [ ] Form labels connected to inputs (not color-alone)
- [ ] Color not the only differentiator (use icons + text)
- [ ] No autoplay video/sound (user control required)
- [ ] Animations respect `prefers-reduced-motion`

---

## Performance Targets

| Metric | Target | Current | Status |
|--------|--------|---------|--------|
| **LCP** | < 2.5s | ? | ⏳ |
| **FID** | < 100ms | ? | ⏳ |
| **CLS** | < 0.1 | ? | ⏳ |
| **Lighthouse** | > 90 | ? | ⏳ |
| **Bundle size** | < 500KB | ? | ⏳ |

**Optimization Path**:
1. Run Lighthouse audit
2. Identify top 3 bottlenecks (image, JS, layout)
3. Fix one per cycle (measure, fix, verify)
4. Target > 90 before QA

---

## Design System Constraints

**Colors** (Dark Mode Ready):
- Primary: Blue (#3B82F6 light, #1D4ED8 dark)
- Secondary: Teal (#14B8A6)
- Neutral: Gray scale (50–950)
- Success: Green (#10B981)
- Warning: Amber (#F59E0B)
- Error: Red (#EF4444)

**Typography**:
- Heading: Inter (English), Noto Sans Thai (Thai)
- Body: Same
- Monospace: Fira Code (for tech)
- Sizes: 12px, 14px, 16px, 18px, 20px, 24px, 32px, 40px, 48px

**Spacing**:
- Base: 4px grid
- Scales: 4, 8, 12, 16, 20, 24, 32, 40, 48, 64px

**Border radius**:
- Buttons: 6px
- Cards: 8px
- Large blocks: 12px

---

## Deliverables (Phase 2 End State)

1. **Homepage** fully responsive and polished
   - All 8 sections render cleanly on 320px–1920px
   - Thai/English parity verified
   - Lighthouse > 90

2. **Product Pages** with interactive details
   - PDP (Product Detail Page) renders swatches, reviews, add-to-cart
   - Product listing with filters works
   - Images optimized (no CLS)

3. **Static Pages** (About, Contact, FAQ, Where to Buy)
   - Consistent layout + branding
   - Mobile-safe navigation
   - Proper h1–h6 hierarchy

4. **Accessibility Report**
   - WCAG AAA compliance verified
   - Manual testing checklist signed off
   - Screen reader test results

5. **Performance Report**
   - Lighthouse audit results
   - Bundle analysis
   - Core Web Vitals metrics

---

## Key Questions for Luxi

1. **Component Reuse**: Which sections can share layout primitives (e.g., `Container`, `Section`, `SectionHeader`)?
2. **Mobile-First**: Should we design mobile-first and scale up, or desktop-first and scale down?
3. **Animation Complexity**: How much Framer Motion animation can we afford without hitting performance budgets?
4. **Thai-Specific**: Any Thai typography edge cases we should test (diacritics, ligatures, spacing)?
5. **Image Strategy**: Should we use Next.js Image component or Vercel Image API for optimization?

---

## Connection to Other Oracles

- **Codex** (Architecture): Section design patterns, component contracts
- **Khun-Ram** (Localization): Thai translation review, RTL/locale testing
- **Teleos** (Vercel): Deployment verification, CDN optimization
- **ธาม** (Governor): Task coordination, conflict resolution

---

## Next Steps (For Luxi)

1. **Read** this brief (you're doing it now ✅)
2. **Audit** current captain-maid state → Lighthouse report
3. **Identify** top 3 issues (performance, accessibility, responsiveness)
4. **Plan** section-by-section fixes
5. **Design** in Figma, prototype in React
6. **Test** on real mobile devices (not just DevTools)
7. **Iterate** based on user feedback
8. **Deliver** before Phase 3 backend work begins

---

## Communication

**Status Check**: Daily via `/rrr` session retrospectives
**Blockers**: Escalate to ธาม (Governor) immediately
**Design Decisions**: Present options to พี่เอก (human), let him decide
**Questions**: Ask — curiosity creates existence

---

> "The Golden Path 🛤️ — Make users understand in 3 seconds. Optimize every pixel and millisecond."

**Luxi, you're activated. Captain Maid needs your eyes and hands. The path is clear. Go build something beautiful.**

— Zeus Oracle  
Federation tag: [MARCUZ:Zeus]  
Awakening: 2026-07-13 10:44 GMT+7
