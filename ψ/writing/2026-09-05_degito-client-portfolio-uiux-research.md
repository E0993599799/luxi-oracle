# UI/UX Research — Degito Bangkok Client Portfolio (14 brands)

**Researcher:** Luxi Junior Oracle
**Date:** 2026-09-05
**Scope:** the 14 client projects featured on `degitobangkok.com`'s homepage portfolio grid (not the full 67-item `/work` archive — see [[2026-09-05_degitobangkok-uiux-research]] for the agency's own site teardown, and [[uiux-portfolio-scan]] for the method used here).
**Method:** 4 parallel research passes, one per batch of 3-4 brands — WebSearch to resolve each brand's real live URL (Degito's case studies never link out to the delivered site — confirmed empirically by inspecting the embedded Next.js data on `/work/true`, `/work/big-c`, `/work/uniqlo`, `/work/amway`: only CDN screenshot assets, no `url`/`website`/`link` field anywhere), then curl+grep for ground-truth color/font/radius/motion/stack tokens plus one WebFetch content/IA pass per resolved site.
**Batch files:** `ψ/writing/site-teardowns/2026-09-05_degitobangkok-batch-{A,B,C,D}.md` (full per-brand detail; this file is the synthesis).

---

## 1. Coverage

| # | Brand | Resolved URL | Status |
|---|---|---|---|
| 1 | True | true.th | ✅ Full |
| 2 | Big C | bigc.co.th | ✅ Full |
| 3 | Uniqlo Thailand | uniqlo.com/th/th/ | ⛔ Blocked (Akamai 403, both curl + WebFetch) |
| 4 | Bangkok Bank | bangkokbank.com | ⛔ Blocked (TLS reset, both curl + WebFetch) |
| 5 | BAAC | baac.or.th | 🟡 Partial (IA read done, no CSS-file tokens) |
| 6 | Amway (TH) | amway.co.th | ⛔ Blocked (DataDome bot-challenge) |
| 7 | ThaiNamthip | thainamthip.co.th | ✅ Full |
| 8 | Chula Book | chulabook.com | ✅ Full |
| 9 | Rabbit Cash | rabbitcash.co.th | ✅ Full |
| 10 | Doi Kham | doikham.co.th | 🟡 Partial (tokens only, WebFetch 403'd) |
| 11 | Sansiri Family | family.sansiri.com | ✅ Full |
| 12 | Sansiri Sustainability | sansiri.com/en/sustainability | ✅ Full |
| 13 | Foremost (TH) | foremostthailand.com | ✅ Full |
| 14 | Max Me | *(none — app-only)* | ⚪ Unresolved as a website (correctly identified as PTG Energy's app-only super-app; a domain look-alike, `maxme.co.th`, was found and rejected as an unrelated squatted site) |

**9 full, 2 partial, 3 blocked, 1 genuinely not a website.** Every blocked/unresolved case is a named tooling or scope limitation, not a silent gap or a guess dressed up as data.

## 2. Standout finding per brand

| Brand | Standout token/pattern |
|---|---|
| True | Bespoke branded typeface (`BetterTogether`), pill-radius buttons, retained dtac blue alongside True red — visible post-merger brand blending |
| Big C | Brand green used as a heavy dominant fill (`#93d600`, 72×) — opposite of a rationed-accent system; classic mass-market e-commerce |
| BAAC | Palette-as-mission: green/earth-tone palette directly legible as "agricultural bank" without reading any copy |
| ThaiNamthip | Search-bar-as-hero instead of a promotional banner — the right call for a multi-stakeholder (B2B + consumer + investor) audience |
| Chula Book | 1059 SVGs vs. only 8 WebP — SVG-for-icons discipline is strong, but product photography itself is still un-optimized JPG |
| Rabbit Cash | Fully rounded, orange, app-first design — the clearest evidence that delivered work does *not* inherit Degito's own sharp-edged house style |
| Doi Kham | LINE-green OA button + royal-project heritage palette (blue/green/orange) reading institutional-trustworthy over trendy |
| Sansiri Family | Licensed Graphik typeface + Vue/Element-UI stack — the only non-Next.js, non-React site in the whole portfolio |
| Sansiri Sustainability | Still on a legacy jQuery/AOS/Slick stack — noticeably older than Sansiri Family's build, despite same parent brand |
| Foremost | WordPress + Elementor, PNG-heavy — least image-optimized site of the entire sample, worse even than the two legacy-jQuery sites |
| Max Me | Doesn't exist as a website at all — the UI/UX artifact is inside an app store binary, which this method (curl/grep + WebFetch) structurally cannot reach |

## 3. Cross-brand patterns

1. **The "ration the accent color" pattern recurs independently.** ThaiNamthip (teal + red-as-accent-only) and Chula Book (near-black + single red badge) both show the same restrained-accent discipline flagged in Degito's own site in the earlier report. Big C and True are the counter-examples (full-saturation color used as heavy fill) — plausibly because retail/telco promo pages *need* color-as-attention in a way a B2B agency site or a university bookstore doesn't. Read this as **category-dependent, not a universal rule** — useful nuance for Luxi's own practice: the "one loud color" lesson applies most directly to service/institutional pages, less to mass-retail promo pages.

2. **No shared "Degito house style" across delivered work.** Border-radius alone ranges from Degito's own 0-2px, to Rabbit Cash's 8px, to True's and Sansiri Family's ~25px pill shapes, to Doi Kham's mixed system. Frontend stack ranges from Next.js (most common) to Vue/Element-UI (Sansiri Family) to WordPress/Elementor (Foremost) to legacy jQuery/AOS/Slick (Sansiri Sustainability). This is a **positive signal for agency craft** — each site's visual language traces to its own brand, not a template — but see the attribution caveat in §5 before treating this as proof of what Degito itself builds today.

3. **Bot-protection clusters by sector, not randomly.** All 3 fully-blocked sites (Uniqlo — global retail chain, Bangkok Bank — regulated financial institution, Amway — direct-selling/MLM) sit in categories with strong reasons to harden against automated scraping (competitor price-scraping, fraud/credential-stuffing risk, lead-scraping by rival distributors respectively). BAAC (a *government* bank) and ThaiNamthip (also handles B2B ordering) were **not** blocked — so it's not "finance/scale" alone driving the block, more likely a specific prior abuse history per brand.

4. **Image-optimization discipline varies more than any other single metric — and several client sites underperform Degito's own site on it.** Degito's homepage: 419 WebP vs. 4 non-WebP (~99%). Compare: Big C (29 WebP / ~774 other), Foremost (10 WebP / ~62 other), Chula Book (8 WebP / ~1400 other), BAAC (5 WebP / 12 PNG). If "performance for speed and SEO" is a line item Degito sells (it is — see the earlier service-page report), this portfolio shows the delivered result doesn't always match the agency's own standard. Worth remembering as a genuine, checkable claim the next time image-optimization work gets deprioritized on a Captain Maid 2.0 page — a client-facing agency's own portfolio shows this trade-off doesn't stay invisible.

## 4. Comparison against `design-system/MASTER.md`

- **Border-radius diversity across real, successful client products** (0-2px through 25px pill, depending on brand personality) supports treating Captain Maid 2.0's own radius choice as a *brand* decision, not a technical default — worth keeping in mind if a future rebrand conversation revisits MASTER.md's current radius values.
- **Rabbit Cash's `8px` radius + rounded `DB AdmanRounded X` headline font + orange palette** is the closest analog in this whole sample to Captain Maid 2.0's own "vibrant & block-based... energetic" classification (`design-system/MASTER.md` §System Classification) — both are consumer-facing, mobile-first, trust-through-friendliness products. If a friendly-competitor reference is ever wanted for Captain Maid, Rabbit Cash is a closer stylistic match than Degito's own agency site was.
- **The recurring "ration the accent" pattern (§3.1)** reinforces the same open question raised in the original Degito report: whether MASTER.md's `--color-accent` / `--color-secondary` are currently used as fills rather than rationed accents in built components — still worth an audit, now with two independent data points instead of one.

## 5. Confidence & limitations

- **Attribution caveat (important):** WebSearch + curl/WebFetch confirms what each brand's site looks like **today**, not necessarily the exact version Degito originally delivered — redesigns happen, and some case studies may be years old. Cross-brand pattern claims above (§3) describe the current live portfolio, not a verified Degito output history.
- Uniqlo Thailand, Bangkok Bank, Amway: URLs correctly resolved via WebSearch, but **zero content retrieved** — Akamai/TLS/DataDome bot-mitigation blocked every fetch attempt on both channels. No colors, fonts, or IA claims are made for these three; getting past this would need a real headless browser with a residential-like fingerprint, out of scope for this session's tools.
- BAAC: IA/content read is solid; technical tokens are HTML-inline-only (no CSS file was resolved in time), so no radius/transition/type-scale data exists for this brand.
- Doi Kham: technical tokens are solid (curl succeeded); the WebFetch content/IA pass hit an HTTP 403 specific to that fetch method (curl with a browser UA worked fine on the same URL), so no structured IA description exists for this brand.
- Max Me: not a tooling failure — verified via app-store listings that the product is app-only. A rejected domain (`maxme.co.th`, an unrelated squatted "coming soon" page) is recorded so it isn't mistaken for the real thing later.
- No color, font, statistic, or claim anywhere in this file or its 4 batch files was invented — every token traces to an actual grep match, curl response, or WebFetch result captured during this session.

---
*Filed by Luxi Junior Oracle — competitor/inspiration research across an agency's real client deliverables, not a build task. Every "worth considering" point above is input for a future design discussion; nothing here has been implemented (Rule 3 — External Brain, Not Command).*
