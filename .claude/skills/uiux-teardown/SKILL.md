---
name: uiux-teardown
description: Run a competitor/inspiration UI/UX research teardown on one or more website URLs — content/IA read + ground-truth visual/technical extraction via curl+grep — and produce a report in ψ/writing/, with concrete comparison against design-system/MASTER.md.
installer: create-shortcut
created_at: 2026-09-05T03:40:11+07:00
---

# /uiux-teardown

Deep UI/UX research teardown of an external website (competitor or inspiration), producing an evidence-based report saved to `ψ/writing/`. Use for design research, not for reviewing Captain Maid 2.0's own code (that's a different task) and not for pure Lighthouse/performance-only audits with no design-content angle.

**Trigger phrases**: "uiux teardown", "research this website's UI/UX", "inspect [url] for UI/UX", "competitor UI/UX research", "design teardown".

## Step 0: Init

```bash
date "+🕐 %H:%M %Z (%A %d %B %Y)" && git -C "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" status --short
```

## Inputs

- One or more URLs from the user (typically a homepage + one specific product/service page). If only one URL is given, still proceed — just note in the report that only one page was sampled.
- If the user gives no URL at all, ask for one before doing anything (this skill needs a real target — never fabricate a site to analyze).

## Step 1 — Content & IA read (WebFetch)

For **each** URL, call WebFetch twice with distinct prompts:

**(a) Content/IA pass** — ask for: overall structure and section order, headline/copy tone and language, navigation structure, hero content and CTA, how services/portfolio are presented, social proof (client logos, testimonials, case studies), footer contents, lead-capture mechanisms, and brand positioning/target-audience signals.

**(b) Service/product-detail pass** (skip if the URL is a pure marketing homepage with no service page) — ask for: process/methodology explained, deliverables, pricing/engagement model if mentioned, differentiators, testimonials, and specific trends/tools/techniques named (design systems, accessibility, performance, AI usage, etc.). Quote key non-English phrases with translation if present.

## Step 2 — Ground-truth technical/visual extraction (curl + grep)

WebFetch content is markdown-summarized and can miss real visual tokens — always back it with raw HTML/CSS inspection. Use the scratchpad directory for downloads, not `/tmp` directly and not the repo.

```bash
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
curl -s -A "$UA" "<URL>" -o page.html -w "HTTP %{http_code} size=%{size_download}\n"
```

If a fetch returns a non-200 or empty body, **note it as a blocker in the report's Limitations section** — do not silently skip or fabricate what the page might contain.

Then grep the downloaded HTML for:
- Hex colors ranked by frequency: `grep -oiE '#[0-9a-f]{6}\b' page.html | sort | uniq -c | sort -rn`
- `font-family:` declarations
- `<link rel="stylesheet" href=...>` CSS file URLs — fetch at least one such CSS file and grep it too for colors, `font-family`, `font-size:`, `border-radius:`, `transition:`, `@keyframes`, `cubic-bezier`
- `<meta name="viewport">`, favicon/apple-touch-icon links
- JSON-LD `"@type":"..."` values (structured data / schema.org)
- Analytics/tag-manager hints (`gtag`, `googletagmanager`, `facebook.net`, `hotjar`, `clarity.ms`, `tiktok`)
- Image format counts: `grep -oiE '\.(webp|avif|svg|png|jpg)"' page.html | sort | uniq -c`
- JS chunk filenames (`<script src=...chunks/...>`) and, for a handful of the larger ones, fetch + grep for animation-library fingerprints (`gsap`, `ScrollTrigger`, `framer-motion`, `swiper`, `embla`, `lenis`, `locomotive-scroll`, `aos`, `lottie`) and framework signals (Next.js `_next/static` chunk naming, hashed CSS-Modules classnames like `header_navbar__xxxxx` vs Tailwind utility classes, Webflow/WordPress/Elementor markers).

## Step 3 — Read this repo's own design system for comparison

```bash
cat design-system/MASTER.md 2>/dev/null
```

If it exists, every "what to take into Captain Maid 2.0 / Luxi's practice" point in the report must be phrased as a concrete comparison against a specific MASTER.md value (color token, type-scale step, radius, spacing, motion duration) — not a generic observation.

## Step 4 — Write the report

Save to `ψ/writing/YYYY-MM-DD_<site-slug>-uiux-research.md` (use the actual current date, and a slug derived from the domain). Structure:

1. **Who they are / positioned for whom** — inferred from copy + client roster + tone, one paragraph.
2. **Information architecture** — section order per page sampled, plus one named "technique worth stealing" and one named "gap worth noting (don't repeat)" if found.
3. **Visual design tokens** — a real Markdown table: color (hex + where used), typography (font-family, type-scale steps as actually found), border-radius, spacing/scale if derivable, motion/transition durations. Every value must be cited from Step 2's actual grep output — never invent a plausible-sounding value.
4. **Stack & technical signals** — framework, CSS approach, image format adoption, structured data, analytics, animation libraries (or their absence).
5. **Content/copy techniques** — headline formulas, trust-building patterns, process-as-differentiator, etc.
6. **What to take into Captain Maid 2.0 / Luxi's practice** — 3-6 concrete, actionable bullets, each cross-referenced against a specific `design-system/MASTER.md` value where applicable. Phrase every bullet as an option/learning point for a human decision ("worth considering", "recorded for a future rebrand conversation") — never as something already changed or implemented. Never fabricate statistics, testimonials, or client names; only report what was actually found in the fetched content.
7. **Confidence & limitations** — note that WebFetch is not a headless browser, so purely visual judgments (exact spacing rhythm, real hover/scroll motion, art direction) are inferred from CSS tokens and copy, not eyeballed pixels. List any URL that failed to fetch as a blocker.

## Step 5 — Close out

Tell the user the report file path, and give a 3-5 line summary of the single most useful technique found (not a full re-statement of the report). If any URL was unreachable or a step was blocked, say so plainly rather than glossing over it.

## Anti-patterns

- Don't guess colors/fonts/spacing from vibes — every visual claim must trace to a Step 2 grep result.
- Don't skip the MASTER.md comparison — a teardown with no link back to Luxi's own system is just trivia.
- Don't treat this as a build task — it produces a report only. No code/config in the target's stack should be copied verbatim.
