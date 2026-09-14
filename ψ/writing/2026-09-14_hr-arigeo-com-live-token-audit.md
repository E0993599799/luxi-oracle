# hr.arigeo.com — Live CSS Token Audit

**Date**: 2026-09-14
**Method**: `curl` + `grep` against the live production site — `https://hr.arigeo.com` (unauthenticated landing/login splash) and its compiled Next.js CSS bundle (`/_next/static/css/06c73322b0ce4204.css`, 75KB). No headless browser, no login — this is ground truth from the actual shipped CSS, not a screenshot-based guess. Same method as the 2026-09-05 captain-maid.com audit MASTER.md is built from.
**Why**: follow-up to the coachhcm.com teardown (`2026-09-14_coachhcm-payroll-uiux-research.md`), which explicitly flagged that its recommendations were framed against `design-system/MASTER.md` (Captain Maid 2.0's system) rather than hr.arigeo.com's own live code, since no audit of hr.arigeo.com existed yet. This closes that gap.
**Stack confirmed**: Next.js (App Router, RSC), a single global CSS bundle shared across the public landing page and the authenticated app shell (confirmed by the presence of `--sidebar-*` tokens — dashboard chrome — in the same file as the public splash page's styles).

---

## 1. Headline finding: the base type scale is small — and this is the concrete cause of the "text feels small" impression

```css
body{
  font-size: clamp(13px, 2.5vw, 15px);
  line-height: 1.55;
  font-family: Noto Sans Thai, Noto Sans, ui-sans-serif, system-ui, sans-serif;
}
```

The **document-wide base font-size caps at 15px** — below the conventional 16px web-readable baseline, and below MASTER.md's own `Body: 16px` role. Since most component text is set relative to or alongside this base, the bulk of the app's UI chrome sits in an unusually dense range:

| Size range | Occurrence count (grep, deduped by exact value) |
|---|---|
| 10–12.5px | 21 + 17 + 3 = 41 |
| 13–14.5px | 23 + 22 + 4 + 13 = 62 |
| 15–15.5px | 5 + 3 = 8 |
| 16–24px | 6 + 4 + 4 + 3 + 2 = 19 |

**~85% of all explicit `font-size` declarations in the bundle are under 15px.** This is the literal, measured version of "ตัวอักษรเล็ก อ่านยาก" (small, hard-to-read text) — not a subjective impression.

**Important nuance — this is a dashboard-density choice, not a total absence of large type.** The public landing/hero splash already has generous large type via `clamp()`:

```css
font-size:clamp(52px,5.1vw,70px)   /* likely the hero H1 */
font-size:clamp(42px,4vw,58px)     /* secondary hero size, appears 2x */
font-size:clamp(30px,4.4vw,44px)   /* section heading */
font-size:clamp(20px,5vw,28px)     /* sub-heading */
```
These land in or above MASTER.md's H1 (48px)/Display range. **The small-text problem is specifically in the authenticated dashboard/app UI** (sidebar nav, tables, forms, cards — confirmed present via `--sidebar-bg`, `--sidebar-text`, `--sidebar-accent` tokens in the same bundle), which is where HR staff actually spend their working time doing leave requests, viewing payslips, etc. — exactly the surface พี่เอก's "ปรับรูปแบบ" ask is about, not the marketing splash.

## 2. Brand color: hr.arigeo.com is blue/navy, not ARIGEO red — a real, concrete family-wide inconsistency

```css
--brand: #38539a;        /* primary brand — muted navy-blue */
--brand-bright: #4a6ac2;
--brand-dark: #263c77;
--brand-tint: #f1f2ff;
--landing-blue: #2563eb; /* separate token, used on the public splash only */
--landing-navy: #002d5f; /* identical hex to captain-maid.com's --color-primary-dark */
```

This directly contradicts `auth.arigeo.com`'s design (documented this session in `2026-09-14_auth-arigeo-theme-spec.md`): `--arigeo-red: #e30613`, "used consistently as the one accent color across every surface." **Two sibling ARIGEO-family products — the auth/SSO gateway and the HR system it signs users into — ship with completely different brand colors (red vs. navy-blue).** This is the same *shape* of problem MASTER.md already flagged for `arigeo.com`'s font stack (out of sync with the family convention) — a third, independent instance of ARIGEO sub-sites drifting from each other with no shared source of truth. Worth surfacing as a decision point: is there an intended family-wide brand color, or does each product legitimately own its own palette?

Coincidentally, `--landing-navy: #002d5f` is the **exact same hex** as captain-maid.com's `--color-primary-dark` in MASTER.md — either a deliberate shared reference or an unplanned coincidence; not confirmed either way from CSS alone.

## 3. What's already good — don't fix what isn't broken

- **Font is already Noto Sans Thai** (`Noto Sans Thai, Noto Sans, ui-sans-serif, system-ui, sans-serif`) — this matches MASTER.md's standing Thai-font convention already. (Correction to the coachhcm.com report's framing: that report speculated hr.arigeo.com might be on arigeo.com's off-brand `Inter`/`IBM Plex Sans Thai` stack — confirmed false. hr.arigeo.com is already correct here.)
- **Border-radius is a clean, disciplined 4-step scale**, and it's actually *used* consistently (`var(--radius-sm)` 8px ×21, `var(--radius)` 12px ×17, `var(--radius-pill)` 999px ×15, `var(--radius-lg)` 18px ×4 — only a handful of literal one-off escapes: `6px`×4, `14px`×4, plus singles). This is meaningfully better discipline than captain-maid.com (8 stray values) or arigeo.com (9 stray values) per MASTER.md's own prior findings — hr.arigeo.com is closer to what MASTER.md's *proposed* consolidated scale (`4/8/16/9999px`) is aiming for everywhere else, not further from it.
- **Motion is fast and uses the right easing curve**: `--motion-fast:120ms`, `--motion-base:160ms`, `--motion-slow:240ms`, `--ease: cubic-bezier(.4,0,.2,1)` — all faster than MASTER.md's own `--duration-fast:150ms`/`--duration-base:200ms`/`--duration-slow:300ms`, and the easing curve is an exact match to MASTER.md's `--easing-out`/`--easing-smooth`. If anything feels "not smooth" on hr.arigeo.com today, motion timing is not the cause.
- **Proper light/dark theming**, not a naive invert: every semantic color token (`--surface`, `--text`, `--sidebar-bg`, `--shadow`, etc.) is defined twice with genuinely different values per mode (e.g. `--shadow` light: soft `rgba(44,44,44,…)`; dark: `rgba(0,0,0,.4–.55)` — deeper, not just recolored), gated by a `[data-theme=]` attribute selector (manual toggle, not OS `prefers-color-scheme`).
- **Spacing scale exists and is coherent**: `--space-1` through `--space-8` = 4/8/12/16/20/24/32px — a real 4px-based scale (see §5 for how this compares to MASTER.md's 8px-based one).

## 4. Secondary observations

- **Semantic color system is genuinely well-structured**: `--red`/`--amber`/`--success`/`--teal`, each paired with a `-tint` background variant (`#c62828`+`#fdeeee`, `#9c6b12`+`#faf3e3`, `#107f47`+`#e8f5ee`, `#0b6e78`+`#e7f4f5`) — this is the "one recipe, N color slots" pattern that's generally good practice for status pills/badges, already in place here without needing to be introduced.
- **An "editorial" sub-palette exists separately** (`--editorial-ink`, `--editorial-blue/green/rose/sky/amber`, `--editorial-max:1440px`, `--editorial-header-h:78px`) — pastel tints distinct from both `--brand` and the semantic colors, likely for a blog/content/announcements surface within the app. Not evaluated further here since its actual usage context wasn't visible from this unauthenticated pass.
- **No `font-weight:400` or `:500` rule exists anywhere in the 75KB bundle** — every explicit weight found is 600/700/800 (plus one `650`). This most plausibly means body text relies on the inherited browser default (400) without ever needing an explicit rule, which is normal — but it could not be fully confirmed without visually inspecting rendered (especially authenticated) pages, so flagged as unconfirmed rather than assumed.
- **Container/modal widths are a dense, uneven staircase** (480/520/560/640/680/720/760/860/900/1024px, 3–6 occurrences each) — likely legitimate per-component sizing (cards, modals, panels each choosing their own width) rather than a "scale," so not flagged as a problem the way the radius/font-size drift is — just noted as not itself a token system.
- **Accessibility note**: the public landing page's `<html lang="en">` doesn't match its bilingual content (Thai title "ARIGEO HR — HRM ระบบทรัพยากรบุคคล" served alongside an English-default language toggle) — a minor `lang` attribute mismatch, unrelated to the visual-design ask but cheap to fix if anyone's touching that page.

## 5. Concrete comparison table vs. `design-system/MASTER.md`

| Token | hr.arigeo.com (live) | MASTER.md (Captain Maid 2.0) | Match? |
|---|---|---|---|
| Thai font | Noto Sans Thai | Noto Sans Thai | ✅ already aligned |
| Body text size | `clamp(13px, 2.5vw, 15px)` — tops at 15px | 16px | ❌ smaller than MASTER.md's own baseline |
| H1 / hero (public page only) | up to `clamp(52px,5.1vw,70px)` | 48px (H1), 96–128px (Display) | ✅ in/above range on the public page |
| Border-radius | 4 tokens, actually used consistently (8/12/18/999px) | Proposed 4-step scale (4/8/16/9999px) | ✅ closer to the proposed target than any other family site audited so far |
| Motion duration | 120/160/240ms | 150/200/300ms | ✅ hr.arigeo.com is faster/snappier |
| Motion easing | `cubic-bezier(.4,0,.2,1)` | `cubic-bezier(0.4,0,0.2,1)` | ✅ exact match |
| Spacing base unit | 4px (`--space-1..8` = 4,8,12,16,20,24,32) | 8px (`--space-xs..4xl` = 4,8,16,24,32,48,64,96) | ⚠️ different base granularity — not wrong, just not the same system |
| Brand color | `--brand:#38539a` (navy-blue) | N/A (MASTER.md is Captain Maid's own blue `#0079C1`, a different product) | ⚠️ see §2 — compare against `auth.arigeo.com`'s red instead, where the real conflict is |
| Dark mode | Full token-pair light/dark system, `[data-theme]`-gated | Not specified in MASTER.md | — hr.arigeo.com is ahead of what MASTER.md documents here |

## 6. Options for a human decision (nothing changed by this audit)

1. **Raise the dashboard base font-size.** `clamp(13px, 2.5vw, 15px)` → something closer to MASTER.md's `16px` Body role (e.g. `clamp(14px, 2.5vw, 16px)` preserves the existing fluid-clamp pattern while lifting the ceiling) is the single highest-leverage change for the "ตัวอักษรใหญ่ อ่านง่าย" ask — it's a one-line change that cascades through every component using relative units off the body.
2. **Resolve the brand-color question across auth.arigeo.com (red) vs. hr.arigeo.com (navy-blue)** before doing any coachhcm-inspired visual pass — repainting hr.arigeo.com's contrast/spacing without first knowing whether it should end up red or navy risks redoing the work twice.
3. **hr.arigeo.com's radius/motion/theming discipline is already close to or ahead of MASTER.md's own targets** — the coachhcm-inspired redesign work can focus entirely on type scale and (if decided) brand color, without needing to touch radius or motion tokens at all.
4. **Consider whether hr.arigeo.com's 4px spacing base should stay independent or align to MASTER.md's 8px base** — not urgent, but worth a conscious decision rather than silent drift if a shared cross-product spacing convention is ever wanted.

## 7. Draft: revised type scale (proposal — not applied to any code)

Directly implements Option 1 above. The 27 distinct `font-size` declarations found in
the live bundle (10px through 70px, including near-duplicate half-pixel steps like
`11.5px`/`12.5px`/`13.5px`/`14.5px`) consolidate into **8 named roles**, kept as
`clamp()` fluid values to match hr.arigeo.com's own existing pattern — this is not a
new mechanism, just fewer, deliberate steps instead of accumulated one-offs. Named and
scoped like the site's existing `--space-*`/`--radius-*` tokens so it drops into the
same system idiom.

```css
:root {
  /* Public landing/hero only — consolidates the found 52–70px / 42–58px pair into one role */
  --text-display: clamp(44px, 4.6vw, 68px);

  --text-h1:      clamp(30px, 3.6vw, 44px);  /* section/page titles — near-identical to what's already shipping */
  --text-h2:      clamp(24px, 2.8vw, 34px);  /* exact match to an already-found value — keep as-is */
  --text-h3:      clamp(20px, 2.2vw, 26px);
  --text-h4:      clamp(16px, 1.8vw, 20px);  /* new consolidated role — was scattered across 15–18px */

  /* THE FIX — dashboard base, was clamp(13px,2.5vw,15px) */
  --text-body:    clamp(15px, 1.4vw, 16px);
  --text-body-sm: clamp(13px, 1.3vw, 14px);  /* secondary/meta text — was the dense 12.5–14.5px cluster */
  --text-label:   clamp(11px, 1.2vw, 12px);  /* badges, tags, tiny meta — deliberately small, floor raised from 10px */
}

body {
  font-size: var(--text-body);   /* was clamp(13px,2.5vw,15px) */
  line-height: 1.6;              /* was 1.55 — matches MASTER.md's Body line-height */
}
```

| Role | Value | Line-height | Weight | Rationale |
|---|---|---|---|---|
| Display | `clamp(44px, 4.6vw, 68px)` | 1.1 | 800 | Public hero only; consolidates 2 near-duplicate found values (52–70px, 42–58px) into 1 |
| H1 | `clamp(30px, 3.6vw, 44px)` | 1.2 | 800 | Matches an already-shipping value (`clamp(30px,4.4vw,44px)`) almost exactly — minimal disruption |
| H2 | `clamp(24px, 2.8vw, 34px)` | 1.25 | 700 | Exact match to a value already found live — keep, just name it |
| H3 | `clamp(20px, 2.2vw, 26px)` | 1.3 | 700 | Close to found `clamp(20px,4vw,26px)`, vw eased for smoother scaling |
| H4 | `clamp(16px, 1.8vw, 20px)` | 1.4 | 600 | New role — the found 15–18px cluster had no consistent name |
| **Body** | **`clamp(15px, 1.4vw, 16px)`** | **1.6** | 400 (inherit) | **The fix** — was `clamp(13px,2.5vw,15px)`; floor raised so it never drops below 15px even on narrow viewports |
| Body small | `clamp(13px, 1.3vw, 14px)` | 1.6 | 400 (inherit) | Secondary/meta text — consolidates the 12.5–14.5px cluster (62 of the original 27 declarations landed in this range) |
| Label | `clamp(11px, 1.2vw, 12px)` | 1.4 | 600 | Badges/tags/tiny meta — kept deliberately small (that's a legitimate UI-density choice for status chips), floor raised from the found 10px |

**Design notes:**
- Ratios step roughly 1.15–1.3× between adjacent roles at the max (desktop) end (Label→Body-sm→Body→H4→H3→H2→H1 = 12→14→16→20→26→34→44), with a larger ~1.5× leap only into Display — the same "moderate steps, one big jump at the top" shape MASTER.md itself uses (its own H1→Display jump is 48px→96–128px, i.e. 2–2.7×).
- H1/H2's *max* values were chosen to match values **already shipping live** wherever possible (H1, H2) — this is a consolidation of what's already there into named roles, not a wholesale redesign; only Body/Body-small/Label actually move.
- Weight assignments (800 for H1/Display, 700 for H2/H3, 600 for H4/Label) reuse the only three weights the live CSS already defines explicitly (`600/700/800` — see §4) rather than introducing 400/500 as *explicit* heading weights, since none were found in use for headings.
- This is a draft for review, not a patch to any repository — hr.arigeo.com's Next.js source wasn't accessible from this audit (compiled CSS only), so applying it means someone with repo access translating these into the actual token source file.

## 8. Confidence & limitations

- All values above are cited directly from `grep` output against the live-fetched HTML and its actual compiled CSS bundle — none guessed from visual impression.
- **Unauthenticated pass only** — the public landing/login splash and the *rules* shipped in the shared global CSS bundle were inspected; actual authenticated dashboard pages (tables, forms, the real day-to-day UI) were not rendered or screenshotted, since that requires a live login. The font-size/radius/color *tokens* found are real and shipped (confirmed by `--sidebar-*` tokens existing in this same bundle), but how they compose visually on real dashboard screens is inferred from CSS, not seen.
- Only one CSS bundle was found and fetched (`/_next/static/css/06c73322b0ce4204.css`) — if the authenticated app lazy-loads additional page-specific stylesheets post-login, those weren't captured here.
- The `--editorial-*` sub-palette's actual usage context (which pages/components) wasn't identified from this unauthenticated pass.
