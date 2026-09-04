# UI/UX Research — Degito Bangkok (degitobangkok.com)

**Researcher:** Luxi Junior Oracle
**Date:** 2026-09-05
**Sources inspected:**
- `https://www.degitobangkok.com/` (homepage, EN)
- `https://www.degitobangkok.com/th/services/uxui` (UX/UI service page, TH)
- Raw HTML + `/_next/static/css/*.css` fetched directly via curl (real colors, fonts, type scale — not inferred)

**Method:** WebFetch for content/IA reading + direct `curl` of HTML and compiled CSS/JS chunk filenames for ground-truth visual tokens and stack signals. This is a competitor/inspiration teardown, not a build — nothing here was copied verbatim; every pattern below is restated as a *technique* to weigh against Captain Maid 2.0's own [[design-system/MASTER.md]].

---

## 1. Who they are, positioned for whom

Degito is a Bangkok digital agency (web, mobile app, AI solutions, SEO) selling to **mid-to-large enterprises**, not SMEs or startups. Evidence: client roster is True, Big C, Bangkok Bank, BAAC, Uniqlo, Sansiri, Amway, ThaiNamthip — telecom, banking, retail, real estate. The whole page is built to make a corporate procurement buyer feel safe writing a check, not to charm a founder into a quick sale. That single positioning choice explains almost every design decision below.

## 2. Information architecture

**Homepage:** hero (value prop + CTA) → service overview (2 narrative blocks: web, mobile) → portfolio grid (14 named case studies, each tagged by service: Corporate Website / UX-UI / E-Commerce / SEO / AI Video) → lead-capture form → footer.

**Service page (UX/UI):** hero → market-context essay (why UX/UI matters in Bangkok right now, cites ~90% mobile adoption) → team credibility paragraph → 6 differentiator bullets → competitive-positioning narrative → 4-step process (Research & Analysis → IA Design → Prototyping & Testing → Visual Design & Handoff) → tools/standards paragraph (accessibility, design systems, mobile-first, AI-assisted design, microinteractions) → CTA to portfolio → closing pitch → 4 FAQs → footer.

**Technique worth stealing:** the *market-context essay* before the pitch. Instead of opening with "we do UX/UI," they open with "here's why UX/UI is a growing necessity in this market right now" — it pre-sells the category before selling the vendor. Good for any B2B service page where the client may not yet believe they need the service.

**Gap worth noting (don't repeat):** the service page has **zero case studies, testimonials, or pricing** in-page — it only links out to a generic portfolio. For a page that spends three sections building trust rhetorically, that's a self-inflicted wound; a reader has to leave the page to get proof. Captain Maid 2.0's own pages should keep at least one concrete proof point (metric, quote, or before/after) on every service/landing page rather than deferring it.

## 3. Visual design tokens (extracted from live CSS, not guessed)

| Token | Value | Note |
|---|---|---|
| Primary red | `#E60000` | Used ~28–31 times across both pages — dominant brand accent, not a background color (used on CTAs, links, tags) |
| Secondary/warm accent | `#D54E05` | Burnt orange, used sparingly — secondary emphasis |
| Neutrals | `#6C6C6C`, `#707070`, `#D8D8D8`, `#D9D9D9` | Mid-gray body text + light-gray dividers/borders |
| Soft accent set | `#FF8B93`, `#FDD3C3`, `#E7FAEA` | Pastel pink/peach/mint — small doses, likely tag chips or illustration fills, not primary UI |
| Base | `#FFFFFF` / `#000000` | Pure white ground, pure black for max-contrast text |
| Border radius | `0` and `2px` only | **Sharp-edged, editorial system.** No pill buttons, no soft `rounded-2xl` SaaS look. This is a deliberate anti-trend choice that reads as "serious agency," not "friendly app." |
| Type scale | `1rem → 1.125 → 1.25 → 1.375 → 1.5 → 1.75 → 2 → 2.25 → 2.75 → 3 → 3.25 → 3.75 → 7.5rem` | Long, fine-grained scale culminating in a **120px (7.5rem) display size** — a single oversized hero numeral/headline is a current big-agency trend (see also: Pentagram, most 2025-26 studio sites) |
| Headline typeface | `DM Sans` (Latin) + `Noto Sans Thai` (Thai), with explicit `*-Fallback` font-face pairs | Correct bilingual practice: separate fallback metrics per script avoids layout shift (CLS) when the real webfont loads |
| Icon font | Custom `degito-icon` + `FC Iconic` | Bespoke icon font rather than an off-the-shelf icon library — signals design-system maturity |
| Transitions | `box-shadow .25s ease-in-out, background`, `transform .3s ease-in-out`, `transform .5s ease-in-out` | Restrained, functional durations (250–500ms), no exotic easing curves in the compiled CSS |

**Read on the palette:** one loud primary (`#E60000`) carrying almost all brand weight, a boring-on-purpose gray body-text system, and pastels held in reserve for small decorative moments. This is the "one hero color, everything else recedes" formula — it's why the red reads as confident rather than garish: it's rationed, not everywhere.

## 4. Stack & technical signals

- **Next.js** (React), CSS Modules (hashed class names like `header_navbar__tshBC`) — **not** Tailwind/utility-CSS. Confirms a component-scoped styling discipline rather than utility soup.
- Images: **419 `.webp`** references vs. 3 `.png` / 1 `.jpg` / 32 `.svg` — near-total WebP adoption for photographic/product imagery, SVG reserved for icons/logos. This is table-stakes for LCP performance in 2026 and should be non-negotiable in any Captain Maid page too.
- `JSON-LD` structured data: `Organization`, `Service`, `Country` types present — local-SEO groundwork for a Bangkok-specific service query ("UX UI design กรุงเทพ").
- A **preloader**: CSS class names `load-page`, `logo-load`, `progress-bar-container`, `progress-bar` on first paint — an animated logo + progress bar while the Next.js bundle hydrates. This is a deliberate "first impression" moment for a premium/creative-agency brand; it's a legitimate technique for a portfolio-led site, but it's also literally the thing performance guidance normally warns against (adds a perceived-wait step) — only justified because the brand promise here is *craft*, not *speed*. Would not recommend for Captain Maid 2.0 (booking/transactional flow needs speed to win over spectacle).
- No animation library fingerprint (no GSAP/Framer Motion/Lenis/AOS strings) found in the sampled JS chunks — the motion is handled with plain CSS transitions, not a heavyweight animation runtime. Lighter dependency footprint than it visually implies.
- Analytics: Google Tag Manager present; no Meta Pixel/Hotjar/Clarity strings detected in the sampled markup.

## 5. Content/copy techniques

- **All-caps, benefit-first headline formula:** "EXPERTS IN [X], [Y], [Z], AND [W]" — front-loads the service list so a scanning visitor self-qualifies in the first two seconds (the "3-second understanding" test Luxi already holds as a golden-path principle).
- **Three-pillar value prop repeated on the service page:** Completeness + Experience (10+ years) + Strategic differentiation. Numbers (10+ years) used as a trust anchor even without named case studies.
- **Process section as a differentiator, not just documentation:** the 4-step methodology (Research → IA → Prototype/Test → Visual+Handoff) doubles as proof of rigor for a buyer who can't evaluate design taste directly but can evaluate "do they have a real process."
- Explicit accessibility + design-system + mobile-first + AI-assisted-design language in the sales copy itself — these are being sold as *service line items*, not just internal craft values. Notable: this validates that WCAG/design-system rigor is now a market-facing selling point in the Bangkok agency space, not just an internal best practice — useful ammunition when pitching accessibility work internally.

## 6. What to actually take into Captain Maid 2.0 / Luxi's practice

1. **Ration the accent color.** MASTER.md's `--color-accent: #0369A1` and `--color-secondary: #14B8A6` are used generously across the current teal system; Degito's one-loud-color discipline (red only on CTA/links/tags, never as a fill) is worth auditing against — check current Captain Maid components for over-use of accent-as-background.
2. **Add one oversized display type step** (equivalent of their 7.5rem) to the type scale for a single hero moment per landing page — MASTER.md's H1 currently tops out at 48px, which is conservative next to the current "huge hero numeral" trend. Consider a `--font-display: 96–120px` token reserved for exactly one use per page (hero headline or a single stat), not general H1.
3. **Never ship a service/landing page without at least one in-page proof point** (metric, quote, mini case study) — Degito's own service page proves how much trust leaks away without it. This is directly actionable for any current cms-arigeo or Captain Maid landing pages Luxi reviews.
4. **Bilingual font-fallback pairing** (`Noto Sans Thai` + explicit fallback metrics) is already a Luxi standing order — confirmed here as current market practice, not just an internal preference; good validation, no change needed.
5. **Preloader/progress-bar intros are a brand-craft flex, not a booking-flow pattern.** Do not adopt for Captain Maid 2.0's transactional screens (cleaning booking flow) — the FID/LCP budget in MASTER.md's own implied performance bar doesn't leave room for a deliberate hydration-wait moment. Fine to consider only for a one-off portfolio/about page if ever built.
6. **Sharp-radius (0–2px) editorial look vs. Captain Maid's current soft/vibrant block style** — deliberately different target audiences (enterprise-procurement vs. Thai-families-booking-a-service), so this is a *contrast to note*, not a pattern to copy. Recorded here so a future rebrand conversation has the comparison on file.

## 7. Confidence & limitations

- WebFetch renders markdown from server HTML; no headless-browser screenshot was taken, so purely visual judgments (exact spacing rhythm, real hover/scroll motion, actual imagery art-direction) are inferred from CSS tokens and copy, not eyeballed pixels. If a pixel-accurate visual audit is needed later, that requires an actual browser render (out of scope for this pass — no browser-automation tool was available in this session).
- No stuck points or blockers encountered — both target URLs were reachable (HTTP 200) and yielded HTML/CSS directly.

---
*Filed by Luxi Junior Oracle — competitor/inspiration research, not a build task. Nothing above should be treated as implemented; it's input for a future design discussion (Rule: propose options, humans decide).*
