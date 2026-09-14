# COACH HCM (coachhcm.com) — UI/UX Teardown for hr.arigeo.com Reference

**Date**: 2026-09-14
**Sampled**: `https://coachhcm.com/th/payroll-software/` (one page — product/solution detail, Thai locale)
**Ask**: พี่เอก wants hr.arigeo.com adjusted toward this page's feel — "ตัวอักษรใหญ่ อ่านง่าย สีตัดสีพื้นกับตัวอักษร ไม่ปวดตา มีพื้นหลัง graphic บางๆ ไม่หนักเว็บ เว็บลื่น โหลดเร็ว" (large readable type, strong text/background contrast that doesn't strain the eyes, subtle light background graphics, not a heavy page, smooth/fast-loading).
**Method**: WebFetch content pass ×2 + ground-truth `curl`+`grep` against the live HTML and the site's own compiled Elementor CSS — no headless browser, so exact pixel spacing/motion is inferred from CSS tokens, not eyeballed.

---

## 1. Who they are / positioned for whom

COACH HCM is a Thai payroll/HRM software vendor (part of a broader HR/HRD/Payroll/Analytics/AI product suite) selling to mid-to-large enterprises and multi-branch SMBs that need Thai-regulation-compliant payroll automation. The copy leans on regulatory correctness (กท.20 tax form compliance, automatic updates when Thai law changes), security certifications (ISO 27001/27701/27017/29110), and enterprise trust signals (PTT, Viriyah, Supalai, Denso, BCPG logos) rather than emotional/lifestyle marketing. This is a B2B procurement audience — HR directors and IT/security reviewers — not an HR *end-user* self-service audience, which is worth flagging since hr.arigeo.com's actual users are more likely to be the latter (employees checking payslips/leave), a different UX job than this page is solving.

## 2. Information architecture

Top-to-bottom: sticky bilingual nav → hero (headline + dashboard screenshot) → feature blocks (icon + short copy) → bank-integration/security callouts → client-logo trust strip → 6-item FAQ → contact CTA → footer.

**Technique worth stealing**: the FAQ block doubles as content marketing *and* objection-handling ("what is payroll software," "how is this different from manual," "is it secure") — for an HR self-service portal like hr.arigeo.com, an equivalent "common questions" pattern (e.g. "ทำไมเงินเดือนของฉันถึงมาช้า" / "ขอลาอย่างไร") would do real support-deflection work, not just SEO copy.

**Gap worth noting (don't repeat)**: zero actual testimonials — client logos are shown with no attributed quotes, which is a weaker trust signal than it could be. If hr.arigeo.com ever adds social proof, a named quote beats a logo wall.

## 3. Visual design tokens (ground truth from `curl` + `grep`, not eyeballed)

| Token | Value | Source / where used |
|---|---|---|
| Brand blue | `#1863DC` (44 combined occurrences, upper+lowercase) | Dominant fill — buttons, links, accents |
| Primary text | `#212121` (25 occurrences) | Body/heading text — near-black, not pure `#000` |
| Background | `#FFFFFF` / `#ffffff` (47 combined) | Page background |
| Secondary navy | `#001664`, `#00186F`, `#000080`, `#0056A7` | Footer / darker accent variants (inconsistent — 4 near-identical navies in active use, not one token) |
| Neutral fill | `#F4F4F4`, `#EBEBEB` | Section background tint |
| Font — Latin | `Poppins` | `font-family: Poppins, 'Noto sans Thai'` — one explicit rule |
| Font — Thai | `Noto Sans Thai` (via Elementor global-typography CSS vars, 7 occurrences) | Body + primary + accent typography roles |
| Border-radius | `2px, 3px, 4px, 5px, 6px, 10%, 50%` | Elementor component CSS — no single consolidated scale, same "accumulated drift" pattern MASTER.md already flagged on captain-maid.com and arigeo.com |
| Transition | `.3s` (majority), one `.4s` transform, one `1s` opacity fade | `transition:all .3s` is the dominant pattern — short, standard ease, nothing flashy |
| Shadow | 1 `box-shadow` rule in the entire compiled frontend CSS | Very restrained — the "clean/light" feel is mostly flat color + whitespace, not depth effects |
| Viewport | `width=device-width, initial-scale=1.0, maximum-scale=1.0` | Standard responsive meta; `maximum-scale=1.0` blocks pinch-zoom — an accessibility minus worth *not* copying |

## 4. Stack & technical signals

- **WordPress + Elementor page builder** (`e-global-typography-*` CSS custom properties, `custom-frontend.min.css`), theme "ogeko."
- **RevSlider** (`sr7.css`, v6.7.29) — a known heavy, animation-driven legacy slider plugin — plus **Swiper.js** (Elementor's bundled carousel) running alongside it.
- **Four separate icon-font libraries loaded simultaneously**: Dashicons, Elusive, Font Awesome 5.15.4, Foundation Icons, Genericons — near-total redundant overlap, pure WordPress-plugin accumulation.
- **WPML** (multilingual), **Contact Form 7** + an extension plugin, **Popup Maker**, **MetaSlider** — five more plugins each shipping their own CSS/JS.
- Images: 14 `.png`, 7 `.svg`, 6 `.webp`, 5 `.jpg` referenced — `.webp` adoption is partial (~19%), not the page's main weight-saving lever.
- Structured data: one `Organization` JSON-LD block only — no `Product`/`SoftwareApplication`/`FAQPage` schema despite having an FAQ section (a missed SEO opportunity, not a design one).
- Analytics: light footprint in the raw HTML (2 hits across the scanned patterns) — no heavy tag-manager chain visible in the static markup.

**The honest technical picture cuts against the "เว็บลื่น โหลดเร็ว" (smooth, fast) impression**: the raw HTML alone is 243KB, and the plugin stack (4 icon fonts + RevSlider + Swiper + WPML + Popup Maker + MetaSlider, all on one page) is the classic shape of a WordPress site that *feels* fast because the visual design is clean and uncluttered, not because the underlying payload is actually light. Worth separating those two things for hr.arigeo.com: the "feels fast" quality พี่เอก is reacting to is almost certainly the **typography/whitespace/restraint**, not the tech stack — which is good news, since that part is cheap to adopt without inheriting any of COACH HCM's plugin weight.

## 5. Content/copy techniques

- **Headline formula**: role + benefit, not feature — "โปรแกรมเงินเดือนสำหรับ HR ยุคใหม่" (payroll program *for modern HR*) names the audience directly in the H1.
- **Benefit-first feature blocks**: every feature is framed as an outcome ("ลดข้อผิดพลาด" — reduces errors) before any technical detail, icon + short copy pairing rather than dense paragraphs.
- **Implicit competitive positioning without naming competitors**: "not localized for Thai context" reads as a jab at foreign HR platforms without ever naming one — a safe way to differentiate.
- **Trust via certification badges** (ISO numbers) rather than narrative case studies — quick-scan credibility for a procurement audience.

## 6. What to take into hr.arigeo.com — options for a human decision

None of these are applied yet; each is a concrete option, cross-referenced against `design-system/MASTER.md`'s already-established tokens (hr.arigeo.com itself has no independent live-token audit in this repo yet — this compares COACH HCM against Luxi's *general* system, not against hr.arigeo.com's current live CSS, which would need its own `curl`+`grep` pass to state precisely).

1. **Lean on restraint, not decoration, for the "light/fast" feel.** COACH HCM's entire compiled frontend CSS has exactly one `box-shadow` rule and a flat, short `.3s` transition pattern — the clean impression comes from color/whitespace discipline, not effects. MASTER.md's own `--duration-fast: 150ms` / `--duration-base: 200ms` are already faster and more restrained than COACH HCM's `.3s` default; hr.arigeo.com doesn't need to add motion to feel smoother, it needs to keep interactions this short and skip drop-shadow-heavy card treatments.
2. **Adopt Noto Sans Thai as the sole Thai font family, matching COACH HCM's approach** — this is already MASTER.md's standing Thai-font order for the Captain Maid 2.0 system, and the audit note flags that `arigeo.com` (the parent brand site) currently loads `Inter + Arimo + IBM Plex Sans Thai` instead, out of sync with both MASTER.md and this convention. If hr.arigeo.com currently follows arigeo.com's font stack rather than Noto Sans Thai, unifying on Noto Sans Thai would both match COACH HCM's readability approach *and* resolve an already-flagged internal inconsistency — worth a follow-up live-token check on hr.arigeo.com specifically.
3. **High-contrast, near-black (not pure black) body text on a plain white/near-white background** — COACH HCM uses `#212121` on `#FFFFFF`; MASTER.md's own contrast table already prefers `--color-primary-dark` (a near-black navy, 13.63:1 AAA) over pure black on white for the same "readable, not eye-straining" reason. This is the single most directly transferable finding — it's exactly the "สีตัดสีพื้นกับตัวอักษร ไม่ปวดตา" quality being asked for, and MASTER.md already encodes the right pattern (dark-but-not-pure-black text, verified AAA), just needs applying consistently on hr.arigeo.com.
4. **Consolidate border-radius to one small scale rather than accumulating one-off values.** COACH HCM shows the exact same drift pattern MASTER.md already caught on captain-maid.com (8 values) and arigeo.com (9 values) — COACH HCM's `2px/3px/4px/5px/6px` mess is a live example of what *not* to let happen; MASTER.md's proposed 4-step scale (`--radius-sm: 4px / --radius-md: 8px / --radius-lg: 16px / --radius-full: 9999px`) is the right target to hold hr.arigeo.com to instead.
5. **Icon + short benefit-copy blocks over paragraph-heavy feature lists** — directly matches MASTER.md's own Anti-Patterns list, which already flags "Text-heavy solutions section" as something to avoid. COACH HCM's feature presentation (icon, one short benefit line, done) is a working example of following that existing rule, useful as a concrete reference when a feature/benefits section on hr.arigeo.com needs a model to point to.
6. **Do not copy `maximum-scale=1.0` in the viewport meta tag.** COACH HCM blocks pinch-zoom, which actively works against "readable, not eye-straining" for any user who needs to zoom — this is a pattern to explicitly avoid, not adopt, despite otherwise being a reasonable reference site.

## 7. Confidence & limitations

- Every color/font/radius/transition value above is cited directly from `grep` output against the live-fetched HTML and the site's own compiled `custom-frontend.min.css` — none were guessed from visual impression.
- WebFetch (not a headless browser) was used for the content/IA reads — real hover states, scroll-triggered motion, and exact spacing rhythm were not visually inspected; the "clean, flat, restrained" motion/shadow conclusion is inferred from the CSS tokens found (one `box-shadow` rule, `.3s` transitions), which is strong but not a substitute for actually loading the page.
- Only one page was sampled (`/th/payroll-software/`) — the homepage or other product pages may use different visual treatments; this is a single-page snapshot, not a site-wide audit.
- **hr.arigeo.com itself was not independently audited in this pass** — every "what to take" recommendation above is framed against `design-system/MASTER.md`'s existing tokens and principles, not against hr.arigeo.com's current live CSS (which this repo does not yet have a ground-truth audit of). A follow-up `curl`+`grep` pass against hr.arigeo.com's own production site would be needed before claiming any of these are gaps *specific to* the current hr.arigeo.com build, rather than general good-practice alignment.
