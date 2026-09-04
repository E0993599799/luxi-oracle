# Live Token Audit — arigeo.com, captain-maid.com, cms.arigeo.com

**Date:** 2026-09-05
**Trigger:** พี่เอก asked whether the Degito/portfolio research suggests improvements for our own sites, constrained to **no structural or photo changes** — token/CSS-level only.
**Method:** same ground-truth curl+grep extraction used in [[2026-09-05_degitobangkok-uiux-research]] and [[2026-09-05_degito-client-portfolio-uiux-research]], run against our own live domains for the first time this session.

**Domains resolved:**
- `www.arigeo.com` (parent brand — household/skincare/everyday-care products)
- `www.captain-maid.com` (the product this repo's `design-system/MASTER.md` documents)
- `cms-arigeo.com` does **not** resolve (DNS failure). `cms.arigeo.com/admin` does (200) — an auth-gated CMS login shell; all tokens load from external JS/CSS bundles post-login, nothing meaningful extractable pre-auth. Flagging the domain mismatch in case `cms-arigeo.com` was assumed to be live somewhere.

---

## 1. captain-maid.com vs. its own `design-system/MASTER.md`

**This is the headline finding: the live site does not match the documented design system.**

| Token | MASTER.md says | Live site actually uses |
|---|---|---|
| Primary color | `#0F766E` (Trust Teal) | `#0079C1` — a full-saturation **blue** (155 occurrences, dominant fill) |
| Accent | `#0369A1` (Professional blue) | closest real match, but used as primary, not accent |
| Secondary | `#14B8A6` (Vibrant teal) | not found — replaced by `#FFC107` (**amber**, 90 occurrences) |
| Heading font | `Lexend` | `Roboto` (with correct `Roboto Fallback` pairing) |
| Body font | `Source Sans 3` | `Roboto` |
| Thai font | *(not specified as distinct)* | `Noto Sans Thai` + fallback — ✅ matches your standing order |
| Border radius | not explicitly scaled, but implied by "Vibrant & Block-based" | 8 different values in active use: `2px, 5px, .25rem, .5rem, .75rem, 1rem, 1.5rem, 9999px` — spans from sharp to fully-pill with no visible system |

**Read:** either the site shipped from an earlier design direction (blue+amber) before MASTER.md's teal system was written, or MASTER.md documents an intended future direction that hasn't been implemented yet. Either way, right now the spec and the shipped product describe two different brands. Worth a decision (not an action) on which one is current truth: update MASTER.md to match the shipped blue+amber palette, or treat this as a to-do list for actually applying MASTER.md to the live site.

**Two things worth checking regardless of which direction wins:**
- `#FFC107` (amber) against white background is roughly 1.6:1 contrast — fails WCAG even at AA for text. It's very likely used only as a button/icon *fill* with dark text on top (that would be fine), but given the "WCAG AAA compliance is non-negotiable" standing order, it's worth a quick manual check of every place amber touches text color directly.
- The border-radius spread (2px through 9999px, 8 distinct values) reads as accumulated component drift rather than a deliberate scale. Every client site in the Degito portfolio research that looked most polished (Rabbit Cash, True) committed to *one* radius philosophy. Consolidating to 2-3 radius tokens (e.g. small/medium/pill) would be a token-only change with no structural impact.

## 2. arigeo.com — cleaner discipline, but off-brand fonts

| Token | Found (live) |
|---|---|
| Palette | Near-black `#010101` + red `#D50306`/`#C50C15` + neutral grays — a genuinely well-rationed accent system, similar in spirit to the "one loud color" discipline praised in the Degito research |
| Border radius | 9 distinct values in use (`0, 2px, 3px, 4px, 8px, 10px, 14px, 50%, 999px`) — same fragmentation issue as captain-maid.com, worse in variety count |
| Type sizing | Mixes `rem` and raw `px` values for font-size in the same stylesheet (`12px, 14px, 16px...` alongside `.75rem, 1.25rem...`) — two competing unit systems, a token-hygiene smell more than a visual one |
| Fonts | **`Inter` + `Arimo` + `IBM Plex Sans Thai`** — none of these is Noto Sans Thai. This directly contradicts the repo's own standing order ("Use Noto Sans Thai for all text"). Worth flagging plainly: this is the one finding here that's an explicit rule violation, not just an inconsistency. |
| Structured data | **No JSON-LD found at all** — zero `application/ld+json` blocks. Compare: even Degito's own site carries `Organization`/`Service`/`Country` schema, and Foremost (a much less design-forward client site in the portfolio research) carries a full 10+ type schema set. This is a free, structure-safe SEO improvement — adding `Organization` + `Product`/`Brand` JSON-LD touches only `<head>`, no layout change. |

## 3. cms.arigeo.com

Auth-gated — the login shell itself gives no meaningful design signal (all styling loads from bundled CSS/JS after the page mounts). Not enough surface here to make a real suggestion without logging in; flagging as out of scope for this pass rather than guessing.

## 4. Prioritized suggestions (token-level only, no structure/photo changes)

1. **Resolve the MASTER.md-vs-live-palette conflict on captain-maid.com** — decide which palette (documented teal or shipped blue+amber) is the actual current brand, then update whichever side is stale. This is a decision for พี่เอก/the team, not something to silently pick.
2. **Consolidate border-radius on both sites** to a small named scale (e.g. 3 steps) instead of 8-9 ad-hoc values each — pure CSS-variable cleanup, zero layout risk.
3. **Swap arigeo.com's body/heading fonts to Noto Sans Thai** (or explicitly confirm Inter/Arimo/IBM Plex Sans Thai is an intentional exception to the standing order) — this is the one clear rule violation found.
4. **Spot-check `#FFC107` amber wherever it touches text color directly** on captain-maid.com for AAA contrast compliance.
5. **Add `Organization`/`Product` JSON-LD to arigeo.com** — free SEO/rich-result upside, `<head>`-only change.
6. **Unify font-size units** (pick rem or px, not both) on arigeo.com's stylesheets — token hygiene, no visual change if done as a 1:1 conversion.

None of the above touches page structure, section order, or imagery — every item is a CSS-token, font-loading, or `<head>`-metadata change.

## Confidence & limitations

- All values above are grepped directly from live HTML/CSS fetched during this session (URLs and file sizes recorded in-session), not inferred or remembered from MASTER.md.
- `cms-arigeo.com` (the domain name used in memory file titles like `2026-08-28_cms-arigeo-pagebuilder-v2-feature-spec.md`) does not resolve publicly — that may be a repo/project codename rather than the live domain, or the live domain may differ from what's in local memory file names. Worth a quick confirmation rather than assuming `cms.arigeo.com` is definitely the same system.
- Did not check whether captain-maid.com's blue+amber palette is a deliberate, already-decided pivot away from MASTER.md's teal system (i.e. MASTER.md may simply be outdated) — presenting this as an open question, not asserting either side is "wrong."
