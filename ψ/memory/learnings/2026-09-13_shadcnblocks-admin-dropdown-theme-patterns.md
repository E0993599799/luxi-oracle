---
name: shadcnblocks-admin-dropdown-theme-patterns
description: Ground-truth dropdown + light/dark theme token inventory from shadcnblocks-admin.vercel.app (payment-processor/transactions AND /customers), captured as reusable reference for cms.arigeo.com admin/CMS UI work.
metadata:
  type: reference
  ttl: ∞
---

Full teardown: [[2026-09-13_shadcnblocks-admin-uiux-research]] (`ψ/writing/2026-09-13_shadcnblocks-admin-uiux-research.md`) — now covers **two pages**: `/payment-processor/transactions` and `/payment-processor/customers`.

## No settings/users route exists on this deployment

Every `/settings*` and `/users*` guess 404'd (checked directly, don't re-probe). Root `/` redirects to `/ecommerce/dashboard-1`, whose sidebar has **zero nav links in server HTML** (client-populated only). `/payment-processor/customers` (HTTP 200) is the closest stand-in for a "users" page and is the one actually sampled below.

## Second-page findings (`/customers`) — richer dropdown set than the transactions page

- **Per-column "⋯" dropdown** on every column header (6 columns) — the standard shadcn `DataTableColumnHeader` menu (sort/hide-column, by convention — item labels not directly observed, Radix doesn't render closed menu content). WebFetch's summary missed this entirely; only found via `curl` + `aria-label` grep.
- **Status filter** and **Date Range filter** buttons are both `aria-haspopup="dialog"` (Popover pattern), NOT `aria-haspopup="menu"` — confirms a shadcn convention: **filter controls use Popover/dialog semantics, action/settings lists use DropdownMenu/menu semantics.** Useful rule of thumb for building cms-arigeo's own table filters consistently.
- Header controls (`header-notifications-trigger`, `header-theme-trigger`, `header-theme-preset-trigger`) have **identical `id`s on both pages sampled** — hard proof the header is one shared component, not duplicated per-route markup. Directly analogous to [[cms-arigeo-unified-sidebar-spec]]'s "one sidebar owner, one search" rule.
- **Two independent color-rotation systems, same Tailwind palette**: avatar initials use an identity-keyed rotation (blue/emerald/violet/amber/rose) that is NOT the same as the status-badge semantic rotation (`Active`=emerald, `Review`=amber, `Blocked`=rose — a 3-of-5 subset of the transactions page's 5-status set). Keep "identity color" and "semantic/status color" conceptually separate in any cms-arigeo token doc — a colored avatar should never be mistakable for a status meaning.
- The 3-status set here reusing the exact same class recipe as the 5-status set on the transactions page is the strongest evidence the badge formula is a **system primitive**, not a per-page choice — reinforces the "reuse the one recipe" guidance below.
- No `role="combobox"` or `<select>` found anywhere across either page — search boxes are plain `<input>`s, not comboboxes.

## What was captured

Sampled `https://shadcnblocks-admin.vercel.app/payment-processor/transactions` (a shadcn/ui block-kit demo) via `curl` ground-truth (SSR'd Next.js, real markup — not WebFetch's paraphrase, which under-reported the dropdowns) for two things พี่เอก asked to remember: **all dropdown menus** and **all theme variants**.

## Dropdowns (only 2 real `role="menu"` on this page — don't assume more)

1. **Notifications** (`header-notifications-trigger`, bell icon, badge count visible on trigger without opening).
2. **Theme mode** (`header-theme-trigger`, sun/moon icon, `aria-haspopup="menu"`) — Light/Dark/System, classic shadcn `ModeToggle`.
3. A third control, **color-theme preset picker** (`header-theme-preset-trigger`), is `aria-haspopup="dialog"` not `menu` — a swatch-grid popover, separate from mode. Current preset always previewed as small OKLCH swatches + label ("Default") right on the trigger.
4. Command palette (`⌘K`) is a dialog, not a dropdown — first-class header affordance with visible keyboard-shortcut badge.

No column-visibility dropdown, no per-row kebab menu, no native `<select>` on this URL — the one row action ("Initiate Refund") is a plain button.

## Theme system (shadcn/ui standard CSS-var contract, `:root` + `.dark{}`)

- Full token table (hex, light→dark) is in the full report — `--background #fff→#0a0a0a`, `--primary` inverts (near-black→near-white), `--destructive #e40014→#ff6568` (re-tuned not straight-inverted), `--border` in dark mode uses **alpha-white overlays** (`#ffffff1a`) rather than a solid hex — adapts to whatever surface sits under it.
- `--chart-1..5` (a 5-step blue ramp) is **identical in light and dark** — charts deliberately don't theme-swap so data stays visually comparable across mode toggle.
- Status badges use one reusable Tailwind recipe across 5 semantic colors (emerald/amber/violet/sky/rose): `bg-{c}-50 text-{c}-700 border-{c}-600/20` light, `dark:bg-{c}-900/30 dark:text-{c}-400 dark:border-{c}-400/20` dark.
- `--radius: .625rem` is one base var; `--radius-md`/`--radius-xs` are `calc()`-derived from it, not hand-picked per component.
- Animated theme toggle confirmed via `@keyframes theme-mask` in the compiled CSS (View-Transitions-API circular-reveal pattern, not an instant class swap).
- Multiple font-family CSS vars are defined but dormant (`--font-geist-sans`, `--font-lora`, `--font-merriweather`, etc.) alongside the active `Inter` — evidence the preset system can swap typography per preset too, not just color.

## Why this was asked to be remembered

พี่เอก wants this available as a pattern reference for **cms.arigeo.com — all pages, admin and non-admin** — not a one-off audit. Most directly relevant to [[cms-arigeo-unified-sidebar-spec]] (the header/search/one-sidebar contract already locked for cms-arigeo) and to the still-unreconciled brand-palette question in `design-system/MASTER.md` (captain-maid.com blue/amber/navy vs. cms-arigeo's own admin-shell theming, and arigeo.com's separately-flagged out-of-sync font stack).

## Companion finding: cms.arigeo.com's ACTUAL admin is Payload CMS, not shadcn — don't conflate the two

Checked `cms.arigeo.com/admin` directly (captain-maid.com itself has no `/admin`; cms.arigeo.com is the real admin per [[cms-arigeo-visual-website-os-vision]]). Only the public **login page** is reachable without credentials (`app-header` — Payload's authenticated chrome class — appears 0 times in the response), so the real in-app theme toggle was **not observed**. What the login page + compiled CSS confirm:

- **Different theme mechanism entirely**: `data-theme="light"|"dark"` attribute, resolved **server-side before first paint** (RSC prop `"data-theme":"$12"`, not a client `localStorage` read) — a stronger anti-flash pattern than the shadcn kit's blocking inline script above.
- **No toggle control visible anywhere on the public login page** (exhaustive grep — no sun/moon icon, no Light/Dark/Auto text). Payload's stock theme selector lives in the authenticated `.app-header__account` dropdown — unreachable without login.
- **Zero brand-color bleed**: none of `design-system/MASTER.md`'s captain-maid.com tokens (`#0079C1`/`#002D5F`/`#FFC107`) appear anywhere in the admin CSS. It's Payload's stock 21-step neutral elevation ramp (`:root` raw `rgb()`, walked in reverse for dark mode) plus stock semantic accents (`success` is blue/teal `rgb(21,135,186)`, **not green** — a Payload convention worth knowing before assuming green=success anywhere in this admin). The **only** brand customization present is a logo swap (`.arigeo-admin-logo__light`/`__dark`, matches the known 2026-07-21 logo-fix retro) — everything else is unmodified stock Payload.
- **Practical implication**: the shadcn dropdown/theme patterns above are from a genuinely different stack than what Payload's own admin chrome runs on — they apply directly to cms-arigeo's *custom-built* pages (builder-v2/Puck screens, bespoke dashboards) but NOT to Payload's stock admin UI itself, which would need a separate Payload-admin-theme customization (CSS variable overrides / `admin.css`) if brand alignment there is ever wanted.
- **Confirmed 2026-09-13** (พี่เอก logged in manually and checked): the Account-menu control is **Light / Dark / Auto** — stock Payload three-way default, nothing added or removed. Closes the loop: mechanism, palette, AND the control itself are all unmodified stock Payload — the logo swap remains the only real customization anywhere in this admin's theme.

## How to apply

- Before proposing dropdown/menu UI for any cms.arigeo.com page, check this entry first — the mode-vs-preset split is a concrete two-axis model worth considering if the CMS ever needs "admin shell theme" and "previewed site brand theme" to vary independently; the filter-vs-action (dialog-vs-menu) split is a concrete rule for choosing dropdown semantics consistently.
- Before inventing new status-badge colors in cms-arigeo, reuse the one-recipe-multiple-colors formula above rather than ad hoc per-status choices; keep any avatar/identity color rotation visually and conceptually distinct from it.
- **Two URLs sampled** (transactions + customers), not a full site audit — no `/settings*` route exists on this deployment at all (confirmed, don't re-probe). If further shadcnblocks-admin pages are wanted, they need their own fetch pass.
