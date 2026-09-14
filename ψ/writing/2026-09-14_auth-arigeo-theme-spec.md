# auth.arigeo.com Theme — Reconciliation with "Tasko" Reference

**Date**: 2026-09-14
**Sources**: `arigeo-auth/docs/tasko-theme-spec.md` (Tasko dashboard teardown, originally scoped for hr.arigeo.com) + ground-truth read of `arigeo-auth/app/globals.css` (the live auth.arigeo.com stylesheet)
**Ask**: use the Tasko spec as an example theme for auth.arigeo.com
**Method**: no browser pass needed — the actual production stylesheet was read directly, so every "current state" claim below is ground truth, not inference.

---

## 1. What auth.arigeo.com already is — don't mistake this for a blank slate

`app/globals.css` (229 lines) is a **mature, hand-rolled, ARIGEO-red-branded design system**, not boilerplate. Plain CSS custom properties, no Tailwind/shadcn dependency:

- Brand: `--arigeo-red: #e30613` (+ `-dark: #c70510`), used consistently as the one accent color across every surface.
- Neutral scale: `--ink-900/700/500`, `--line-300`, `--surface-100/50`, `--white` — a 6-step gray ramp, not the shadcn 2-value (`background`/`foreground`) model.
- Semantic: `--success #16a34a`, `--warning #f59e0b`, `--error #ef4444`, `--info #3b82f6` — flat, not paired with a `-foreground`/bg-tint the way shadcn tokens are.
- Two radius tokens only: `--radius-control: 8px` (inputs/buttons), `--radius-card: 24px` (cards) — no derived scale.
- Full page inventory already built: split-screen `auth-shell` (promise copy + feature list + glass card), `auth-card` login/signup form, alert banners, field/button/checkbox components, a post-login `portal-shell` with a module-card grid + trust strip + footer, an `admin-tile`, and a `create-user-form`.
- **Zero dark-mode code anywhere** — no `.dark`, no `[data-theme]`, no `prefers-color-scheme` block in the file.

This is a working, shipped system. The Tasko spec is useful here as a **methodology reference**, not a palette to import — auth.arigeo.com should stay ARIGEO red, not become Tasko green.

## 2. What Tasko's spec actually offers (methodology, not colors)

Per `tasko-theme-spec.md`, stripped of its literal green values:

1. **shadcn-convention variable naming** (`--background`, `--foreground`, `--primary`/`-foreground`, `--card`, `--secondary`, `--muted`, `--accent`, `--border`, `--ring`, `--chart-1..5`) — a naming contract, not a color contract. Adopting the *names* (with ARIGEO's own values) is what lets any future shadcn/ui component drop into auth.arigeo.com without edits, and is the same convention already used by `cms-arigeo`'s page-builder tokens (see companion doc, [[2026-09-14_cms-arigeo-payload-admin-theme-plan]]) — worth aligning on for the whole ARIGEO family, not just this app.
2. **Single base `--radius` token, everything else derived** (`1rem` → 14px buttons / 16px chips / 20px cards via calc). auth.arigeo.com currently hard-codes two unrelated radius values (`8px`, `24px`) with no derivation rule — Tasko's discipline is worth copying even though the actual radius numbers stay ARIGEO's own.
3. **One status-pill recipe, N color slots** (`bg-{c}-50/text-{c}-700/border-{c}-600/20` light, dark variant swaps shade steps) instead of Tasko's flat `--success`/`--warning`/`--error`. auth.arigeo.com's `.alert--info/warning/error/success` are hand-tinted banners (`background: #fef2f2` etc., separately from a token) — the same recipe idea would tighten this into one formula with 4 color slots instead of 4 separately-authored rules.
4. **"Hero tile" pattern**: make the single most important tile solid-brand-color while siblings stay neutral. auth.arigeo.com's `portal-module-card`/`admin-tile` are currently uniform white/red-tinted-gradient cards with no hierarchy — a hero treatment (e.g. the CMS module tile, if it's the primary action) is a cheap way to guide the eye on the post-login portal.
5. **Explicit font decision, not inherited default** — auth.arigeo.com already does this correctly (`Inter` deliberately set), so nothing to change here; noted only because Tasko's spec flagged the opposite mistake (fetched-but-unused Geist).
6. **The dark-mode gap**: Tasko's own reference has *no* dark mode either. So "use Tasko as the example" cannot mean "copy its dark mode" — there isn't one to copy. If auth.arigeo.com wants dark mode, tokens need to be authored from scratch. The closest ready-made template in the ARIGEO family that already does this well is `cms-arigeo`'s `builder-v2/theme/tokens.ts` (`defaultLightTokens`/`defaultDarkTokens`, same shadcn-shaped keys, dark already brand-aware not just inverted) — see the companion doc for detail. Structurally reusable as a starting shape even though auth.arigeo.com would plug in red, not blue.

## 3. Proposed token reconciliation (naming convention only — values stay ARIGEO's)

| Current (`globals.css`) | Proposed shadcn-convention name | Value (unchanged) |
|---|---|---|
| `--surface-50` (page bg) | `--background` | `#f9fafb` |
| `--ink-900` | `--foreground` | `#0f1115` |
| `--white` (card bg) | `--card` | `#ffffff` |
| `--ink-900` (on card) | `--card-foreground` | `#0f1115` |
| `--arigeo-red` | `--primary` | `#e30613` |
| *(new)* | `--primary-foreground` | `#ffffff` |
| `--surface-100` | `--secondary` / `--muted` | `#f3f4f6` |
| `--ink-500` | `--muted-foreground` | `#6b7280` |
| `--arigeo-red-dark` | `--accent` (hover/emphasis) | `#c70510` |
| `--line-300` | `--border` / `--input` | `#d1d5db` |
| `--error` | `--destructive` | `#ef4444` |
| *(new)* | `--destructive-foreground` | `#ffffff` |
| `--radius-control` | `--radius` (base) | `8px`, derive `--radius-sm`/`-lg` from it |
| *(new)* | `--chart-1..5` | a 5-step tint/shade ramp off `#e30613`, for any future admin-tile analytics/reporting surface |

This is a **rename-in-place migration** — no visual change, just a shared vocabulary with the rest of the ARIGEO stack (cms-arigeo's builder tokens, and any future shadcn/ui component that gets dropped into auth.arigeo.com).

## 4. Options for a human decision (not decided here)

1. **Rename-only migration** (§3) now, at zero visual risk, so auth.arigeo.com speaks the same token language as cms-arigeo's page-builder theme system.
2. **Status-pill consolidation** (§2.3): fold the 4 hand-tinted `.alert--*` variants into one Tailwind-style recipe with 4 color slots — cosmetic tightening, not a redesign.
3. **Hero-tile treatment** for one portal module card (§2.4) — a design call on *which* module is "the one," not a technical change.
4. **Dark mode** (§2.6): the biggest lift here — genuinely new tokens, not a port from either reference. Recommend deferring until there's an actual product ask for it, and if/when it happens, borrow `builder-v2/theme/tokens.ts`'s key shape (same names, ARIGEO red swapped in) rather than reinventing the schema a third time.

## 5. What NOT to change

- Don't adopt Tasko's green — auth.arigeo.com's red brand identity is settled and consistent across every surface.
- Don't restructure the layout system (`auth-shell`, `portal-module-grid`, etc.) — it's a complete, working design, not a gap Tasko needs to fill.
- Don't invent a dark mode by mechanically inverting the current light values — neither reference source supports that shortcut, and a naive invert reliably produces the "washed out" look `builder-v2/theme/tokens.ts`'s own comment explicitly calls out avoiding.
