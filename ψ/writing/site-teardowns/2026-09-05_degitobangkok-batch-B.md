# Client Portfolio UI/UX Notes — Batch B

**Batch:** BAAC, Amway (Thailand), ThaiNamthip, Chula Book
**Context:** these 4 brands appear in Degito Bangkok's homepage portfolio grid ([[2026-09-05_degitobangkok-uiux-research]]). Degito's own case-study pages for them do not link to the live delivered site, so each domain below was resolved via WebSearch, not taken from Degito's site.
**Method:** curl (raw HTML/CSS grep for real color/font/radius/transition tokens) + one WebFetch content/IA pass per site, per `/uiux-portfolio-scan`.

---

## BAAC (ธ.ก.ส. — Bank for Agriculture and Agricultural Co-operatives)

**Resolved URL:** https://www.baac.or.th/ (HTTP 200)

| Token | Value |
|---|---|
| Colors (top hex, by frequency) | `#26770E` (×16, primary green), `#0e3f2e` (×16, dark forest green), `#F5E6A8` (×8, cream/gold), `#E8F0E8` (×8, pale green), `#E8DCC4` (×8, tan), `#C5D9C8` (×8, sage), `#B8D4E3` / `#A8D5E5` (×8 each, pale sky blue) |
| Image formats | 12 `.png`, 5 `.webp` — low webp adoption vs. Degito's own site |
| Stack | `_next/static` present → Next.js. No CSS file could be resolved from the sampled `<link>` pattern in the time available — token table above is HTML-inline-derived only. |
| JSON-LD | none found |

**IA/positioning:** Standard financial-institution funnel — nav → rotating hero banners (flood relief, savings lottery, government loan programs, digital banking) → 9-bucket product categories filtered by customer segment (individual/SME/cooperative) → footer with governance/anti-fraud/whistleblowing links. Headline: *"ธ.ก.ส. ตอบโจทย์ทุกกลุ่ม ทุกความต้องการ ด้านการเงิน"* ("BAAC meets every group's every financial need") — universal-access positioning rather than a niche pitch, despite the agricultural core mandate. The green/earth-tone palette (found, not assumed) directly reflects the agricultural mission — a legible case of palette-as-brand-mission.

---

## Amway (Thailand)

**Resolved domain:** amway.co.th (confirmed as primary official TH domain via WebSearch — `amwayth.com` and `amwayshopping.com` also exist as secondary/portal domains)

**Status: BLOCKED.** Both `curl` and WebFetch received **HTTP 403** from a bot-detection challenge (the raw response for the curl attempt was a DataDome interstitial: `<p id="cmsg">Please enable JS and disable any ad blocker</p>` with a DataDome `dd={'rt':'c','cid':...}` payload). No content, color, or font data could be extracted — this is a genuine access block, not a missing-page 404. No values are reported for Amway to avoid fabricating anything past the domain confirmation itself.

---

## ThaiNamthip (Coca-Cola bottler, Thailand)

**Resolved URL:** https://www.thainamthip.co.th/en (HTTP 200)

| Token | Value |
|---|---|
| Colors (top hex) | `#000000` (×112), `#FFFFFF` (×66), `#009C9D` (×40, teal — brand accent distinct from Coca-Cola red), `#EC1C24` (×31, Coca-Cola red), `#333333`, `#101820`, `#919191` |
| Fonts | `Poppins`, `Prompt` (both geometric sans, Prompt is Thai-optimized) |
| Image formats | 225 `.webp`, 13 `.svg`, 5 `.png` — heavy WebP adoption, on par with Degito's own site |
| Border-radius (from CSS) | `0`, `2px`, `4px`, `50%` — mixed: sharp UI chrome plus fully-round elements (avatars/pills), not a single-radius system |
| Transitions (from CSS) | `all .4s ease`, `all 1s ease`, `box-shadow .25s ease-in-out, background .25s ease-in-out, border .25s ease-in-out` |
| Stack | `_next/static` → Next.js |

**IA/positioning:** Notably not hero-banner-led — the focal point is an **interactive product search bar** ("Let us help you find it"), followed by three parallel CTA cards for distinct audiences (contact/business partnership/careers) shown with equal visual weight. Product carousel spans the full Coca-Cola-portfolio breadth (Coke variants, Fanta, Sprite, Schweppes, energy drinks) rather than a single hero product. Footer and nav both signal a **multi-stakeholder** site (B2B retailers, employees, consumers, investors) rather than a single-audience consumer site — unusual for a beverage brand and a deliberate IA choice worth noting: search-as-hero works when the audience is heterogeneous enough that no single promotional message fits everyone.

---

## Chula Book (Chulabook.com — Chulalongkorn University Book Center)

**Resolved URL:** https://www.chulabook.com/ (HTTP 200)

| Token | Value |
|---|---|
| Colors (top hex) | `#050505` (×16, near-black), `#f11946` (×1, red accent — likely a single "sale/bestseller" badge color, not a dominant brand fill) |
| Fonts | `Kanit-all` (Kanit is a widely-used Thai geometric display font; the `-all` suffix suggests every weight is loaded as one family bundle) |
| Image formats | 1059 `.svg`(!), 252 `.jpg`, 88 `.png`, 51 `.JPG`, 8 `.webp` — SVG-dominant is unusual; likely icon-per-category and placeholder/rating-star icons rather than photographic content, plus low WebP adoption for an e-commerce product catalog (product photography still largely `.jpg`) |
| Stack | `_next/static` → Next.js. A secondary CSS chunk (`styles.de20eccd.chunk.css`) was tiny (2.7KB) and yielded no radius/transition matches — likely a fragment, not the full stylesheet; not enough to characterize motion/radius tokens for this site. |
| JSON-LD | none found |

**IA/positioning:** Transactional-first, not narrative — dual-layer nav (Books/E-books/Online Courses/Lifestyle + a 15+-branch mega-menu for exam-prep/medical/business/literature categories), rotating promo carousel instead of a value-prop hero, then three merchandising rails (Bestsellers, New Arrivals, Recommended Categories) with standard e-commerce product cards (thumbnail, title, author, price, stock status, add-to-cart). Heavy signal toward Thai students at specific pressure points (TGAT/GAT-PAT exam bundles, Science Olympiad materials, nursing/medical texts) — a much more segment-literal IA than a general bookstore.

---

## Cross-brand notes (Batch B only)

- **All 4 resolved sites run Next.js** (`_next/static` present in BAAC, ThaiNamthip, Chula Book; Amway's stack is unconfirmed due to the block) — consistent with Degito's own stack choice on their agency site, suggesting either a genuine agency-wide tech standard or simply that Next.js is now the default choice across this market segment regardless of agency.
- **Palette discipline varies a lot by sector**: BAAC's earth-tone palette is thematically tight (mission-driven), ThaiNamthip runs a stark black/white/teal/red system with the brand's real red rationed to accents only (same "ration the accent" pattern flagged in the main Degito report), while Chula Book's near-black-plus-one-red-accent is the most restrained of all three resolved sites.
- **Amway's block is itself a finding**: a consumer direct-selling brand running DataDome bot-protection on its public marketing homepage is a notably aggressive posture for a non-transactional page — worth flagging as an outlier if this pattern recurs elsewhere in the portfolio.

## Confidence & limitations

- BAAC: content/IA read complete; only partial technical-token extraction (no CSS file resolved in the time available, so no radius/transition/type-scale data for BAAC specifically).
- Amway: **fully blocked** — domain confirmed, nothing else. Do not treat the domain confirmation as validated design content.
- ThaiNamthip, Chula Book: both fully accessible; Chula Book's CSS sample was too small to characterize motion/radius fully — flagged above, not silently omitted.
- No fabricated values anywhere in this file — every token traces to an actual grep match or WebFetch response captured during this session.
