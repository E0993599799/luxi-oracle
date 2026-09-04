# Client Portfolio UI/UX Notes — Batch A (True, Big C, Uniqlo TH, Bangkok Bank)

**Part of:** Degito Bangkok client-portfolio scan (see [[uiux-portfolio-scan]])
**Date:** 2026-09-05
**Note:** None of these client sites are directly linked from Degito's case-study pages — Degito never discloses the live delivered URL in its case studies (confirmed by inspecting the embedded Next.js data on `/work/true`, `/work/big-c`, `/work/uniqlo`: only CMS/CDN screenshot assets, no outbound link/url/website field). URLs below were independently resolved via WebSearch, not sourced from Degito.

---

## True (True-dtac)

**Resolved URL:** https://www.true.th
**Fetch status:** OK (curl 200, WebFetch OK)

| Token | Value |
|---|---|
| Primary red | `#E00000` (8 occurrences) |
| Secondary blue | `#1976d2` (9 occurrences — likely retained dtac brand blue post True-dtac merger) |
| Neutrals | `#ffffff`, `#f9f9fc`, `#F3F3F6` |
| Custom typeface | `BetterTogether, sans-serif` — bespoke branded font, not a Google Font |
| Border radius | `100` / `25px` (pill-shaped buttons) — soft, consumer-friendly, opposite of Degito's own sharp 0–2px system |
| Motion | `transition:background-color .2s`; keyframes present for a date-picker component (`rdp-fade_in/out`, `rdp-slide_in/out_left/right`) |
| Images | 154 `.webp`, 142 `.png`, 102 `.jpg`, 14 `.svg` — partial WebP adoption, not full |
| Stack | Next.js (`_next/static`) |
| Structured data | `Organization`, `WebSite`, `ContactPoint` |

**IA/positioning:** Hero carousel leads with a flagship device (Samsung Galaxy Z Fold8) rather than an explicit CTA — visual-first, not conversion-first, above the fold. Four customer-segment shortcuts (lucky numbers, mobile packages, postpaid, prepaid) route different buyer intents immediately. Entertainment-partner logos (Netflix, YouTube, iQIYI) function as premium-positioning social proof rather than customer testimonials. Overall reads as targeting affluent, digitally-engaged consumers who want lifestyle bundling, not just connectivity.

**Contrast worth noting:** True's own brand red (`#E00000`) is nearly identical to Degito's agency red (`#E60000`) — likely coincidental (both are common "confident Thai corporate red" hues), not evidence Degito reused the client's palette for its own site.

---

## Big C Online

**Resolved URL:** https://www.bigc.co.th
**Fetch status:** OK (curl 200, WebFetch OK)

| Token | Value |
|---|---|
| Brand green | `#93d600` (72×), `#7db800` (70×), light green `#b8e986` (70×) — dominant, high-frequency, used as a fill color (not rationed like Degito's red) |
| Accent red | `#ed1c24`, `#e11d3f` — reserved for promo/sale tags |
| Neutrals | `#f3f3f3`, `#dbdbdb`, `#989898` |
| Font-family | none found in raw HTML grep (likely all in external/compiled CSS not sampled) |
| Images | 411 `.jpg`, 363 `.png`, 26 `.svg`, only 29 `.webp` — low modern-format adoption relative to Degito's own ~100% WebP discipline; consistent with a large legacy vendor/product-image pipeline |
| Stack | Next.js (`_next/static`) |
| Structured data | none found (no JSON-LD `@type` matches) |

**IA/positioning:** Classic e-commerce descending funnel — promo carousel → category grid → product carousels → 25+ supplier brand logos (Coca-Cola, Nestlé, P&G, Unilever) as supply-credibility proof → 50+ visible coupon codes → footer with payment/trust badges. Headline "สั่งง่าย ส่งไว ส่งฟรี" (easy order, fast ship, free delivery) plus a loyalty-point system ("บิ๊กพอยต์") — pure value/convenience positioning for price-conscious mass-market shoppers, no premium signaling at all. No customer reviews/ratings visible on the homepage itself.

---

## Uniqlo Thailand — **UNRESOLVED / BLOCKED**

**Resolved URL (candidate):** https://www.uniqlo.com/th/th/ (confirmed as the correct official Thailand storefront via WebSearch)
**Fetch status:** BLOCKED on both channels.
- `curl`: HTTP 403 — Akamai edge bot-mitigation ("Access Denied", reference `18.d15f32b8...`, edgesuite.net)
- `WebFetch`: two attempts (`/th/th/` and `/th/en/`), both timed out at 60s with no content returned

No content, colors, fonts, or IA notes could be gathered for this one. This is a genuine tooling limitation (aggressive bot protection), not a scope decision — flagging rather than guessing or fabricating what the page might contain.

---

## Bangkok Bank — **UNRESOLVED / BLOCKED**

**Resolved URL (candidate):** https://www.bangkokbank.com (confirmed via WebSearch)
**Fetch status:** BLOCKED on both channels.
- `curl`: TLS/HTTP2 connection reset (`HTTP/2 stream 1 was not closed cleanly: INTERNAL_ERROR`) over both HTTP/2 and forced HTTP/1.1 — consistent with TLS-fingerprint-based bot mitigation common on banking sites
- `WebFetch`: two attempts (root and `/en/Index`), both timed out at 60s

Same as Uniqlo — no data gathered, flagged rather than guessed. (Expected for a bank; financial sites are the most heavily bot-hardened category in this batch.)

---

## Batch summary

- **Completed:** True, Big C (full content + technical token extraction)
- **Blocked (tooling limitation, not skipped):** Uniqlo Thailand, Bangkok Bank — both resolved to correct URLs but return no content via curl or WebFetch due to bot-mitigation (Akamai/WAF + TLS fingerprinting). A real browser (headless Chrome with a residential-like fingerprint) would likely be needed to get past these; out of scope for the tools available in this session.
- **One cross-brand note:** True and Big C sit at opposite ends of the "color discipline" spectrum from Degito's own restrained one-accent-color style — Big C uses its brand green as a heavy fill across the whole page, True mixes two full-saturation brand colors (red + retained dtac blue). Neither rations color the way Degito's own site does. Worth keeping as a data point, not a verdict — different product category (retail promo vs. B2B agency) plausibly justifies the difference.
