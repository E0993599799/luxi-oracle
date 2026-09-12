# UI/UX Teardown — shadcnblocks-admin.vercel.app (Payment Processor / Transactions)

**Date**: 2026-09-13
**URL sampled**: `https://shadcnblocks-admin.vercel.app/payment-processor/transactions`
**Focus**: dropdown menus, light/dark theme system, interaction states
**Intent**: reusable pattern reference for `cms.arigeo.com` admin surfaces (registry-driven sidebar, dashboard shell, and any other CMS page — not limited to admin)
**Method**: WebFetch (content pass) + `curl` ground-truth HTML/CSS extraction (SSR'd Next.js page, so real Tailwind classes and CSS vars were readable directly — no headless browser needed)

---

## 1. What this page is

A Shadcn UI "block kit" demo — `shadcnblocks-admin.vercel.app` — showing a payment-processor admin dashboard (Stripe-Dashboard-style): live KPI cards, a status-filterable transactions table, pagination, and a header with notification/theme/command-palette controls. It's a component showcase, not a real product, so treat every finding as a *pattern to borrow*, not a spec to clone.

## 2. Information architecture (as sampled)

- Fixed header → KPI row (Payments / Refunds / Disputes, each with a trend delta) → status tabs (`All / Successful / Pending / Upcoming / Refunded / Failed`, rendered as plain `<button>`s, not a `<select>` — a segmented control, not a dropdown) → data table → pagination footer.
- **Technique worth stealing**: status tabs are real buttons with `aria-current`-style active styling, not a dropdown — keeps the most common filter one click away instead of two. Worth comparing against how cms-arigeo's dashboard route filters work today.
- **Gap worth noting**: no visible breadcrumb trail on this page — just the section header ("Payment Processor"). If cms.arigeo.com's registry-driven nav ([[cms-arigeo-unified-sidebar-spec]] in Luxi's memory) goes deep (workspace → content → page → block), a breadcrumb will matter more here than it does in this shallow demo.

## 3. Dropdown menus — full inventory (ground-truth from HTML, not guessed)

Only **two** true `role="menu"` dropdowns exist on this page; the rest are either a dialog-style popover or a plain button. This matters — don't assume every header icon is a dropdown menu without checking.

| # | Trigger | `id` | ARIA pattern | Contents (as rendered) |
|---|---|---|---|---|
| 1 | Bell icon, badge "2 unread" | `header-notifications-trigger` | `aria-haspopup="menu"`, `aria-label="Notifications, 2 unread"` | Notification list (closed by default; count badge visible without opening) |
| 2 | Sun/moon icon | `header-theme-trigger` | `aria-haspopup="menu"`, `aria-label="Toggle theme"` | Light / Dark / System mode menu (classic shadcn `ModeToggle` — icon cross-fades sun↔moon via `dark:scale-0`/`dark:scale-100` + `rotate-0`/`-rotate-90` Tailwind classes, no JS animation library) |
| 3 | Color-swatch button + "Default" label | `header-theme-preset-trigger` | `aria-haspopup="dialog"` (not menu — a picker dialog), `aria-label="Choose color theme"` | Grid of color **presets** (not just light/dark) — 4 small OKLCH swatches shown on the trigger itself as a live preview of the current preset |
| — | Search icon, `⌘K` hint | (search trigger) | `aria-label="Open command palette (Payment Processor)"`, `aria-keyshortcuts="Meta+K Control+K"` | Command palette (`cmdk`-style) — not a dropdown, a modal overlay |

**No column-visibility dropdown, no per-row kebab/action menu, no native `<select>`** were found on this page — the one row-level action ("Initiate Refund") is a plain `<button>`, not a menu item. If the user saw a row action dropdown elsewhere in the shadcnblocks-admin demo, it wasn't on this exact URL — worth telling พี่เอก this is a single-page sample, not the whole kit.

### Pattern worth taking: theme control is split into *two* separate dropdowns, not one
Most admin templates conflate "dark mode" and "brand color" into one settings panel. This kit deliberately separates:
- **Mode** (`header-theme-trigger`): light / dark / system — a `role="menu"`.
- **Preset** (`header-theme-preset-trigger`): which color palette to apply *within* that mode — a `role="dialog"` swatch picker, current selection always visible on the trigger as swatches + label ("Default").

For `cms.arigeo.com`, which already has to reconcile two brand palettes in one system ([[MASTER.md]]'s blue/amber/navy for captain-maid.com content vs. whatever an admin shell should use), this two-axis model (mode × preset) is directly relevant if the CMS ever needs to preview a site's brand theme *inside* the admin shell separately from the admin shell's own light/dark mode.

## 4. Theme system — ground truth from CSS

The page ships **shadcn/ui's standard CSS-variable theme contract** (`:root` for light, `.dark{}` override block), doubled for browser fallback: one variable set in plain hex, a *second* set in `lab()` colorspace (progressive-enhancement layering — modern browsers see the `lab()` block since it's later in cascade order, older ones stay on hex). No `next-themes`-specific markers were visible in the static HTML (theme is applied via a `.dark` class toggle on a wrapping element, which is the standard `next-themes` mechanism even though the library's own JS wasn't fingerprinted in the served markup).

### Full token table (hex fallback values, as shipped)

| Token | Light | Dark | Notes |
|---|---|---|---|
| `--background` | `#ffffff` | `#0a0a0a` | |
| `--foreground` | `#0a0a0a` | `#fafafa` | |
| `--card` / `--popover` | `#ffffff` | `#171717` | |
| `--card-foreground` / `--popover-foreground` | `#0a0a0a` | `#fafafa` | |
| `--primary` | `#171717` | `#e5e5e5` | **inverts** — primary is near-black on light, near-white on dark |
| `--primary-foreground` | `#fafafa` | `#171717` | |
| `--secondary` / `--muted` / `--accent` | `#f5f5f5` | `#262626` | three roles share one value in both modes |
| `--muted-foreground` | `#737373` | `#a1a1a1` | |
| `--destructive` | `#e40014` | `#ff6568` | dark-mode destructive is lighter/more saturated for legibility on dark bg, not a straight invert |
| `--border` / `--input` | `#e5e5e5` | `#ffffff1a` / `#ffffff26` (white at 10%/15% alpha) | dark-mode borders use **alpha-white overlays**, not solid hex — a technique worth naming explicitly |
| `--ring` | `#a1a1a1` | `#737373` | focus ring |
| `--sidebar` | `#fafafa` | `#171717` | sidebar has its own token family (`--sidebar-*`), independent from `--background`/`--card` |
| `--chart-1..5` | `#90c5ff → #193cb8` | *(same in both modes)* | a 5-step blue ramp, deliberately **not** theme-swapped — charts keep one fixed palette so data comparisons don't visually shift across mode toggles |
| `--priority-1..4` | `#e40014, #f27000, #dca600, #737373` | `#ff6568, #ff8b41, #e9b928, #a1a1a1` | semantic priority scale, separate from status badge colors below |
| `--success` / `--warning` | `#00884b` / `#dca600` | `#2ec18c` / `#e9b928` | |
| `--radius` | `.625rem` (10px) | *(same)* | with derived `--radius-md: calc(var(--radius) - 2px)`, `--radius-xs: .125rem` — one base var, others derived by calc, not hand-picked |

### Status badge colors (table rows) — a 5-way semantic mapping, distinct from the tokens above
Confirmed by grepping actual badge class combinations in the rendered table:

| Status | Light bg / text / border | Dark bg / text / border |
|---|---|---|
| Successful | `emerald-50` / `emerald-700` / `emerald-600/20` | `emerald-900/30` / `emerald-400` / `emerald-400/20` |
| Pending | `amber-50` / `amber-700` / `amber-600/20` | `amber-900/30` / `amber-400` / `amber-400/20` |
| Refunded | `violet-50` / `violet-700` / `violet-600/20` | `violet-900/30` / `violet-400` / `violet-400/20` |
| Upcoming | `sky-50` / `sky-700` / `sky-600/20` | `sky-900/30` / `sky-400` / `sky-400/20` |
| Failed | `rose-50` / `rose-700` / `rose-600/20` | `rose-900/30` / `rose-400` / `rose-400/20` |

Every badge follows the exact same recipe: `bg-{color}-50 text-{color}-700 border-{color}-600/20` in light, `dark:bg-{color}-900/30 dark:text-{color}-400 dark:border-{color}-400/20` in dark. This is a **reusable formula**, not five one-off choices — new statuses just need a new Tailwind color name slotted into the same pattern.

### Theme-switch animation
`@keyframes theme-mask` was found in the compiled CSS alongside standard shadcn keyframes (`accordion-down/up`, `enter`, `exit`, `spin`, `pulse`). This is the View-Transitions-API-driven animated theme toggle popularized in the shadcn ecosystem (a circular reveal mask centered on the toggle button) — confirms the mode switch isn't an instant class-swap, it's animated.

### Fonts available (multiple `font-family` custom properties defined, only `Inter` active on this page)
`--font-sans: "Inter", ui-sans-serif, system-ui, ...`, plus dormant `--font-geist-sans`, `--font-geist-mono`, `--font-jetbrains-mono`, `--font-lora`, `--font-merriweather` variables present in the bundle — evidence the same theme-preset system (§3, item 3) can also swap typography per preset, not just color.

## 5. Stack & technical signals

- **Framework**: Next.js (App Router, Turbopack build — `turbopack-*.js` chunk present), server-rendered (full real markup in the raw `curl` response, not a client-only shell).
- **Component library**: shadcn/ui on Radix primitives (`data-state="closed"`, `aria-haspopup`, `data-slot="sidebar-*"` attributes) + Tabler icons (`tabler-icon-sun`/`-moon`) mixed with Lucide icons (`lucide-bell`, `lucide-chevron-down`, `lucide-search`) — two icon sets in one page, not unusual in shadcn block kits assembled from different blocks.
- **Styling**: Tailwind utility classes throughout, CSS-variable-driven theme (no CSS-in-JS, no styled-components signal).
- **No native `<select>`, no `role="combobox"`, no visible column-picker** on this specific URL.

## 6. What to take into `cms.arigeo.com` — options for a human decision, not decisions already made

1. **Split "dark/light mode" from "brand color preset" into two separate controls**, each with its own trigger and its own current-value preview (swatches on the preset trigger). Relevant because `cms.arigeo.com`'s admin shell and the sites it manages (captain-maid.com, arigeo.com) carry *different* brand palettes ([[MASTER.md]] blue/amber/navy for captain-maid.com; arigeo.com's own Inter/Arimo/IBM Plex Sans Thai stack is already flagged as out of sync in the 2026-09-05 audit) — worth considering whether admin-shell dark/light mode should stay CMS-neutral (zinc/neutral, like this kit) while a separate "preview site theme" control handles per-brand color, rather than conflating the two.
2. **Alpha-white/black borders in dark mode** (`border: #ffffff1a`) instead of a separate solid dark-mode border hex — worth considering for any future cms-arigeo dark-mode pass, since it auto-adapts border contrast against whatever surface color sits under it (card vs. sidebar vs. page bg) without a token per surface.
3. **Fixed, non-theme-swapped chart color ramp** (`--chart-1..5` identical in light/dark) — worth recording as a pattern if cms.arigeo.com ever ships analytics/reporting screens (the sidebar spec's `analytics/page.tsx` route is currently a placeholder per [[cms-arigeo-unified-sidebar-spec]], so this is forward-looking, not urgent).
4. **One status-badge formula, five color slots** (`bg-{c}-50/text-{c}-700/border-{c}-600/20` light, `dark:bg-{c}-900/30/text-{c}-400/border-{c}-400/20` dark) — a directly reusable recipe if cms.arigeo.com's admin ever needs status badges (workflow states, publish status, form submissions) rather than inventing per-status colors ad hoc. Cross-reference against [[MASTER.md]]'s border-radius consolidation note (`--radius-sm/md/lg/full`) — this kit's `--radius: .625rem` with `calc()`-derived sub-values is the same "one base var, others derived" discipline MASTER.md is trying to retrofit onto captain-maid.com's 8 stray radius values.
5. **Segmented-control tabs for the most common filter, dropdown only for less-common ones** — status filter here is a button row, not a `<select>`; worth comparing against cms.arigeo.com's own dashboard route filters before assuming a dropdown is always the right control.
6. **Command palette (`⌘K`) as a first-class nav affordance**, separate from the sidebar — cms.arigeo.com's unified sidebar spec ([[cms-arigeo-unified-sidebar-spec]]) already centralizes "one search" as a hard rule (§ "one sidebar owner... one search"); this kit's implementation (visible keyboard-shortcut badge in the header, `aria-label` naming the current section — "Open command palette (Payment Processor)") is a concrete reference for how that single search affordance could surface itself in the header.

## 7. Second page sample — `/payment-processor/customers`

**Route-finding note**: no `/settings*` or `/users*` route exists on this deployment — every guess (`settings`, `settings/general`, `settings/profile`, `settings/appearance`, `users/list`, `account-settings`, etc.) returned 404. The root `/` 307-redirects to `/ecommerce/dashboard-1`, whose sidebar nav is **not present in the server-rendered HTML at all** (only `data-sidebar="trigger"` — no nav links, no `<li>`, confirmed by direct grep) — so the nav/route list can't be enumerated from HTML the way it could for a normal SSR'd content site; only `/payment-processor/customers` (probed directly, HTTP 200) was confirmed to exist as a stand-in for a "users" page. Recorded here so a future session doesn't re-run the same 404 probes.

This page is materially richer in dropdowns than the transactions page — worth treating as the primary dropdown reference of the two.

### Dropdown/menu inventory (ground-truth, `aria-haspopup` + `aria-controls` attributes)

| # | Trigger | Pattern | Notes |
|---|---|---|---|
| 1–6 | **Per-column "⋯" button**, one on every column header (`aria-label="Column options for {Customer Name / Customer Id / Email / Phone Number / Status / Created At (UTC)}"`) | no `aria-haspopup` in the closed-state markup (Radix content not mounted until opened) | The single biggest miss in WebFetch's summary — it reported "no row-level action menus" and said nothing about column-header menus at all. This is the standard shadcn `DataTableColumnHeader` dropdown (conventionally: sort asc/desc, hide column) — **item labels are inferred from convention, not observed**, since Radix doesn't render menu content in closed-state HTML. |
| 7 | **Status filter** button (label "Status", chevron icon) | `aria-haspopup="dialog"`, `aria-controls="radix-_R_klfiv5uknmjb_"` | A Popover-based checkbox-list filter, not a `role="menu"` — shadcn's convention is: **filter controls use Popover/dialog semantics, action lists use DropdownMenu/menu semantics.** Confirmed pattern, not guessed — see items 7 vs. 9 below. |
| 8 | **Date Range** button (calendar icon, label "Date Range") | `aria-haspopup="dialog"`, separate `aria-controls` id | Same Popover pattern as Status — a `lucide-calendar-days` icon confirms it opens a date-range calendar panel. |
| 9 | Notifications bell | `aria-haspopup="menu"` | Same trigger as the transactions page (shared header component — `id="header-notifications-trigger"` identical). |
| 10 | Theme mode toggle | `aria-haspopup="menu"` | Same shared header component as transactions page. |
| 11 | Theme color-preset picker | `aria-haspopup="dialog"` | Same shared header component as transactions page. |

**Confirmed shared-component architecture**: `header-notifications-trigger`, `header-theme-trigger`, `header-theme-preset-trigger` all appear with **identical `id` attributes** on both pages sampled — proof the header is one shared layout component, not duplicated per-page markup. Directly relevant to [[cms-arigeo-unified-sidebar-spec]]'s "one sidebar owner... one search" hard rule — this kit enforces the equivalent for its header controls via component reuse, not by convention alone.

**Not a dropdown**: "Search customers" (`aria-label="Search customers"`, placeholder `"Search customer, ID, email..."`) is a plain text `<input>`, not a combobox — no `role="combobox"` or `<select>` found anywhere on either page sampled across this whole teardown.

### Avatar color system — a second, separate color-rotation from status badges

Customer row avatars use colored initials, e.g.:
```
bg-blue-100 text-blue-600     "AS"
bg-emerald-100 text-emerald-700  "JL"
bg-violet-100 text-violet-600    "MC"
bg-amber-100 text-amber-700      "DS"
bg-rose-100 text-rose-600        "TR"
```
This is a **separate rotation from the status-badge palette** — avatar color is presumably keyed by customer identity (hash/index), not by any status field, and adds `blue` to the rotation on top of the emerald/amber/violet/sky/rose set used for statuses. **Pattern worth naming**: identity-color (avatar) and semantic-color (status) are two independent color systems in this kit even though they draw from the same Tailwind palette family — worth keeping them conceptually separate in any future cms-arigeo token doc, so a "blue" avatar is never mistaken for a status meaning.

### Status set here is a 3-value subset of the 5-value set from the transactions page

`Active` (emerald), `Review` (amber), `Blocked` (rose) — same exact class recipe as §4's table, just 3 of the 5 colors in use. **Confirms the recipe is a shared design-system rule, applied per-feature with whichever subset of colors that feature needs** — not a coincidence or a re-derived palette per page. This is the strongest piece of evidence in this whole teardown for treating the badge formula as a system primitive worth adopting in cms-arigeo, rather than a one-page observation.

## 8. Confidence & limitations

- WebFetch's content pass under-reported the dropdowns (it paraphrased the theme toggle as a single control and missed the preset-picker dialog entirely) — **all dropdown/menu claims in §3 are from raw HTML `aria-*` attributes via `curl`, not from the WebFetch summary.** This is a good example of why the ground-truth pass matters more than the content pass for component-level UI research.
- This is a **server-rendered** Next.js page, so `curl` captured real Tailwind classes and CSS custom properties directly — higher confidence than a typical client-rendered SPA teardown would allow.
- **Two URLs** were sampled in total (`/payment-processor/transactions`, `/payment-processor/customers`). No `/settings*` or `/users*` route exists on this specific deployment (confirmed by direct probing, all 404) — `/payment-processor/customers` was used as the closest available stand-in for a "users" page. If a real settings page matters to พี่เอก, it isn't on this deployment and can't be sampled from this domain.
- Column-header dropdown menu items (§7, items 1–6) and the notification/mode-toggle menu items were **not observed directly** — Radix doesn't render `role="menu"`/`role="dialog"` content into the HTML until the trigger is clicked, so item-level labels (e.g. "Sort ascending", "Hide column") are inferred from standard shadcn `DataTableColumnHeader`/`ModeToggle` conventions, not confirmed from this page's markup. Only the **existence, trigger, and ARIA pattern** of each dropdown is ground-truth; contents beyond that are convention-based inference, flagged as such throughout.
- Menu *contents* for the two `role="menu"` dropdowns (notifications list items, theme mode options) were not directly visible in the closed-state HTML (Radix doesn't render menu content until opened) — their existence and trigger semantics are confirmed via ARIA attributes, but exact item labels are inferred from standard shadcn `ModeToggle` conventions (Light/Dark/System), not observed directly. Flagged as inference, not fact.
- No headless browser was used, so real interaction states (actual hover/focus paint, open-menu screenshots) were not visually verified — inferred from Tailwind state variants (`hover:bg-accent`, `focus-visible:ring-1`, `dark:` variants) present in the markup.

---

## 9. Companion check — `cms.arigeo.com`'s own admin theme toggle (the actual target system, not a reference kit)

พี่เอก asked to check the theme toggle on "captain-maid.com's admin" — captain-maid.com itself has no `/admin` or `/dashboard` route (both 404); the admin that manages captain-maid.com's content is **`cms.arigeo.com`** (confirmed against [[cms-arigeo-visual-website-os-vision]] / [[cms-arigeo-unified-sidebar-spec]] in Luxi's memory — this is the Payload-backed CMS, not a separate captain-maid-hosted panel).

### What was reachable without login

`cms.arigeo.com/admin` returns HTTP 200 but is the **login page**, not the dashboard (confirmed: `app-header` — Payload's authenticated chrome class — appears 0 times in the response; "Forgot Password"/"Login" strings are present). The real dashboard, its nav, and its account-menu theme selector are **behind auth** — not reachable by this method. Everything below is what the public login-page HTML and its compiled CSS bundles reveal; the actual in-app toggle control itself was not observed.

### It's stock Payload CMS, not shadcn — a different theme architecture entirely

- Framework fingerprint: `@layer payload-default, payload;`, `.app-header__account`/`.app-header__actions` classes, `[data-theme=dark] .LexicalEditorTheme__*` selectors (Lexical rich-text editor, Payload's default) — unambiguous Payload CMS admin, unrelated to the shadcn/Radix stack in §3–§8.
- Theme is applied via **`data-theme="light"|"dark"` attribute on `<html>`**, not a `.dark` class — a different mechanism from the shadcnblocks-admin kit's `next-themes` convention. The value is resolved **server-side before first paint** (the RSC payload shows `"data-theme":"$12"` — a server-interpolated prop, not a client `localStorage` read after mount) — this is actually a stronger anti-flash approach than the shadcnblocks kit's blocking inline script, worth noting as the better pattern of the two if cms-arigeo ever needs to justify server-side theme resolution elsewhere.
- **No visible toggle control on the login page itself** — no sun/moon icon, no "Light/Dark/Auto" option text, no toggle-styled button anywhere in the login HTML (confirmed by exhaustive grep across the full response). Payload's standard theme selector lives inside the authenticated **Account** dropdown (`.app-header__account`) — normal Payload behavior, but means this teardown cannot show what that control actually looks like without a login session.

### Color system — confirmed stock Payload, zero brand-color bleed into the admin chrome

Payload's admin theme is a single 21-step neutral **elevation ramp**, defined once in `:root` as raw `rgb()` values and then **walked in reverse** for dark mode — same scale, flipped direction, not a second hand-authored palette:

| Token | Light (`:root`, default) | Dark (`[data-theme=dark]`) |
|---|---|---|
| `--color-base-0` | `rgb(255,255,255)` (white) | *(same scale, reassigned)* |
| `--color-base-500` | `rgb(128,128,128)` | |
| `--color-base-1000` | `rgb(0,0,0)` (black) | |
| `--theme-elevation-0` (→ `--theme-bg`) | `= --color-base-0` (white) | `= --color-base-900` (near-black) |
| `--theme-elevation-1000` (→ `--theme-text`) | `= --color-base-1000` (black) | `= --color-base-0` (white) |

Semantic accents (also Payload stock, not brand-derived):

| Token | Value (mid-step, `-500`) |
|---|---|
| `--color-success-500` | `rgb(21,135,186)` — **a blue/teal, not green** (Payload's own convention — worth double-checking against user expectations before assuming "success = green" anywhere the CMS displays its own status states, separate from any content-model status colors cms-arigeo defines) |
| `--color-warning-500` | `rgb(185,108,13)` (amber/brown) |
| `--color-error-500` | `rgb(218,75,72)` (red) |

**None of `design-system/MASTER.md`'s captain-maid.com tokens (`#0079C1` brand blue, `#002D5F` navy, `#FFC107` amber) appear anywhere in the admin CSS bundles** — confirmed by direct grep, zero matches. The only brand customization found in the entire admin theme is a **logo swap**: `.arigeo-admin-logo__light`/`.arigeo-admin-logo__dark` (CSS `display` toggle keyed on `[data-theme]`) — consistent with the known 2026-07-21 logo-fix retro already in memory. Everything else — surface colors, success/warning/error accents, elevation scale — is unmodified stock Payload gray theme.

### What this means for the "remember for cms.arigeo.com integration" ask

The dropdown/theme *patterns* captured in §1–§8 above are from a **different, unrelated stack** (shadcn/Radix/Tailwind) than what cms.arigeo.com's actual admin runs on (Payload CMS's own theme engine, which is closed-system — not meaningfully "swappable" with shadcn components without replacing Payload's admin UI wholesale, which is out of scope of a theme change). Two separate, non-conflicting takeaways:

1. If พี่เอก wants **cms.arigeo.com's Payload admin panel** to visually reflect brand (currently it doesn't — confirmed zero brand-color bleed above), that's a Payload admin-theme customization task (Payload supports CSS-variable overrides and custom `admin.css` / component overrides) — a separate, smaller task than anything in §1–§8.
2. If the shadcn dropdown/theme *patterns* from §1–§8 are meant for **cms-arigeo's own custom-built pages** (e.g. the public captain-maid.com/arigeo.com frontends, or any bespoke dashboard screens built outside Payload's stock admin UI, per [[cms-arigeo-three-builder-systems-not-one]]'s builder-v2/Puck system) — those patterns remain directly applicable there, since that code is genuinely Next.js/Tailwind, unlike Payload's own admin chrome.

**Confirmed 2026-09-13 (พี่เอก, manual login check)**: the Account-menu theme control is **Light / Dark / Auto** — exactly Payload's stock three-way default, no custom option added, no options removed. This matches the prediction above and closes the loop: cms.arigeo.com's admin panel uses **unmodified Payload theming end to end** (mechanism, palette, and now confirmed the control itself) — the only real customization anywhere in the admin chrome remains the logo swap noted above.
