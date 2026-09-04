# Degito Bangkok Portfolio Teardown — Batch C

**Brands:** Rabbit Cash, Doi Kham, Sansiri Family
**Date:** 2026-09-05
**Method:** `/uiux-portfolio-scan` (lighter per-brand variant) — WebSearch to resolve live URL (Degito's case-study pages don't link out to the delivered site), curl+grep for ground-truth tokens, one WebFetch content/IA pass per site.

Note: none of these live sites are hosted on `degitobangkok.com` infrastructure — each has resolved to the brand's own domain, confirming Degito's case studies show design/dev work delivered onto client-owned platforms, not agency-hosted microsites.

---

## Rabbit Cash

**Resolved URL:** https://www.rabbitcash.co.th/ (confirmed via WebSearch — official site of the BTS Group/AEON/Humanica digital-lending joint venture)

**Positioning:** Thai fintech lending app ("Money Rabbolution"). Speed is the core promise — headline: *"ใหม่! แรบบิทแคช กระเป๋าเงินทุนออนไลน์ โอนฝันไวใน 3 วินาที"* ("New! Rabbit Cash online wallet — turn dreams into transfers in 3 seconds"). Targets small-business owners (ผู้ประกอบอาชีพรายย่อย) and HR/employee-welfare buyers, not just consumer borrowers.

**IA:** nav → hero carousel (3 rotating angles: speed / legitimacy / fee structure) → product sections (personal loan, organizational/employee-welfare loan) → interactive 5-question recommendation quiz ("ให้พี่ต่ายแนะนำ") → social proof carousel (12+ customer photos) → awards section → news/press → footer. Primary CTA is app-store download (Google Play / Apple / QR code), not a web form — correct choice since the product only functions as a mobile app.

**Tokens (grepped, live):**

| Token | Value |
|---|---|
| Primary color | `#F78E1E` (orange — 41 occurrences, dominant) |
| Secondary | `#5FBB46` green, `#468FFF` blue — used for status/approval cues |
| Neutral text | `#5A5A5A` |
| Headline font | `DB AdmanRounded X` (Thai display font, rounded terminals) |
| Body font | `Sarabun` (very common, highly-legible Thai webfont) |
| Border radius | `.5rem` (8px) — soft, app-like, consistent with a consumer fintech product |
| Transition | `max-width .3s linear !important` (carousel), plus a `background-color 5000s ease-in-out` — the latter is the well-known Chrome autofill-yellow suppression hack, not a real transition |
| Stack | Next.js (`_next/static`) |
| Images | 530 `.webp`, 311 `.png`, 171 `.jpg`, 1 `.svg` — webp-first but heavier PNG use than a fully-optimized site would want |

**Read:** rounded-corner, orange-branded, mobile-app-first design — the opposite of Degito's own sharp-edged agency look. Confirms Degito adapts visual language per client brand rather than imposing a house style (a positive signal for agency craft — worth noting as the counter-example to any "template agency" concern).

---

## Doi Kham

**Resolved URL:** https://www.doikham.co.th/ (root domain — the `/home/` path found in early search results 404s; root serves the homepage)

**Blocked:** WebFetch content pass returned **HTTP 403 Forbidden** (bot-detection likely triggered by the fetch tool's request signature — `curl` with a browser User-Agent succeeded fine, so this is a fetch-method-specific block, not a site outage). Content/IA read below is therefore inferred only from the page `<title>` ("หน้าแรก | ดอยคำ" — "Homepage | Doi Kham") and raw token extraction, not from a structured content pass. Flagging this honestly rather than guessing IA details.

**Tokens (grepped, live):**

| Token | Value |
|---|---|
| Primary blue | `#165A97` (9 occurrences) |
| Accent orange | `#EA501F` |
| Accent green | `#1C6148` |
| LINE-brand green | `#00B900` (present — likely a LINE OA contact button) |
| Headline font | `Thongterm` (a Thai display typeface) |
| Border radius | `0`, `.5rem`, `1rem`, `2px` — mixed usage, no single consistent rounding rule found |
| Stack | Next.js (`_next/static`, chunk-hashed CSS filenames) |
| Images | 40 `.svg`, 38 `.webp`, 8 `.jpg`, 7 `.png` — lighter page overall than Rabbit Cash/Sansiri, SVG-heavy (likely icon-driven UI) |

**Read (partial, token-level only):** royal-project heritage brand (King Bhumibol-founded agricultural foundation) — blue/green/orange palette reads as trustworthy-institutional rather than trendy-consumer, consistent with a legacy state-linked food brand rather than a VC-backed startup.

---

## Sansiri Family

**Resolved URL:** https://www.sansiri.com/family/en → **redirects (302)** to https://family.sansiri.com/ (this is the live, working URL — the `sansiri.com/family` path is a legacy/redirect entry point)

**Stack note:** the linked stylesheet on the pre-redirect page loads from `https://panda-stg.sansiri.net/dist/css/styles.css` — the `-stg` subdomain segment conventionally denotes a **staging** environment. This may simply be a naming leftover (not necessarily live staging infra serving production traffic) but is worth flagging as a possible asset-pipeline oddity rather than asserting it's a real bug.

**Positioning:** loyalty/membership program for Sansiri property buyers, framed as lifestyle rather than points-based rewards — English tagline "Easy Living." Targets affluent, design-conscious homeowners already inside the Sansiri ecosystem, not new-lead acquisition.

**IA:** nav (Global Privilege / Living Privilege / Move-in Experience / Activity, cascading to subcategories, dual English/Thai + "My Profile"/"My History" account access) → feature sections (Living Privilege incl. wallpaper customization, Move-in Experience incl. welcome packages/moving assistance/design consultation, Activity & Community) → referral program ("Friends Get Friends") + tiered status ("Sansiri Priority") → blog content → footer (5 social platforms, legal links).

**Tokens (grepped, live — pre-redirect page, likely shared with the live site given same design system):**

| Token | Value |
|---|---|
| Primary dark navy | `#051C2C` (347 occurrences — dominant, near-black brand navy) |
| Accent gold/orange | `#FDAF3F` (123 occurrences) |
| Secondary navy | `#002454` |
| Grays (Element-UI defaults) | `#C0C4CC`, `#606266`, `#303133`, `#EBEEF5`, `#909399` |
| Headline font | `GraphikTH` / `GraphikTHSemiBold` (Thai-adapted Graphik, a premium licensed typeface — signals design-budget tier above template stacks) |
| Icon font | `element-icons` + `FontAwesome` — confirms **Vue.js + Element UI** component library, not React/Next.js |
| Border radius | `25px` — notably large/pill-like, softer than either Rabbit Cash or Doi Kham |

**Read:** the Element-UI/Vue signature plus a licensed premium typeface (Graphik) and a dark-navy/gold luxury palette is a deliberate step up from the other two brands here — correct, since this is a post-purchase loyalty product for people who already bought a Sansiri property, not a cold-acquisition funnel.

---

## Cross-brand pattern (Batch C only)

All three brands use a **different frontend stack** (Rabbit Cash: Next.js; Doi Kham: Next.js; Sansiri Family: Vue/Element UI) and a **different border-radius philosophy** (8px / mixed / 25px-pill) — no shared "Degito house style" is visible in the delivered products, unlike the sharp 0–2px system on Degito's own agency site. This is a meaningful finding for the master report: Degito does not impose a visual signature on client deliverables; each site's tokens trace to its own brand identity.

## Confidence & limitations

- Doi Kham: WebFetch content pass blocked (403); technical/token extraction succeeded via curl. IA/copy description above is not available for this brand — flagged, not guessed.
- Sansiri Family: original URL redirects; content pass was run against the redirect target (`family.sansiri.com`), tokens were extracted from the pre-redirect response body (same design system asset, but noting the source distinction for accuracy).
- Rabbit Cash: fully resolved, no blockers.
