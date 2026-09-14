# cms-arigeo Payload Admin Theme — Continuation Plan (Page Builder + Light/Dark)

**Date**: 2026-09-14
**Continues**: [[2026-09-13_shadcnblocks-admin-uiux-research]] / [[2026-09-13_shadcnblocks-admin-dropdown-theme-patterns]] — that teardown established cms.arigeo.com's public login page runs **unmodified stock Payload theming** (only a logo swap customized). This doc goes past the login page into ground truth read directly from the `cms-arigeo` repo (`git -C cms-arigeo`, branch `feat/captain-maid-persistent-inspector-20260909`), and finds that "unmodified" is not the whole story — a customization was built, shipped, broke something, and was silently stripped. It has sat orphaned for ~6 weeks.
**Ask**: continue the theme work — Payload admin customization must be **related to the page builder** and **actually support dark/light theme** (not just look right in one mode).

---

## 1. Ground truth: three unrelated theme systems stacked in one user journey

Following the path an editor actually takes — log into Payload admin → click "Website" → land in the builder dashboard → open a page → see the canvas — crosses **three separate, non-communicating design systems**:

| Layer | File | Theme model | Dark mode? |
|---|---|---|---|
| **Payload `/admin` chrome** (login, collections, forms) | Payload's own compiled CSS (stock) | 21-step neutral elevation ramp, `data-theme="light\|dark"` on `<html>`, resolved server-side | Yes — genuinely works, confirmed 2026-09-13 by manual login (Light/Dark/Auto, stock 3-way) |
| **`/dashboard` shell** (the "Website" workspace `AdminBuilderNavLinks` links to, wrapping the page builder) | `src/app/dashboard/dashboard-globals.css` | Independent shadcn-convention tokens, hard-coded comment: `"Vercel Theme - LIGHT MODE (Black, White, Gray, Blue)"` | **No** — zero `.dark`/`[data-theme]`/`prefers-color-scheme` in the file (confirmed by direct grep, 209 lines) |
| **Page-builder canvas** (what an editor is actually building — the live site) | `src/builder-v2/theme/tokens.ts` + `builder-themes` Payload collection | `--v2-*` shadcn-shaped `ThemeTokens` (background/foreground/primary/card/border/ring/radius/shadow/…), persisted per-site, rendered at request time | **Yes** — `defaultLightTokens` and a hand-tuned `defaultDarkTokens` (not a naive invert — comment explicitly says "mirrors the shadcn dark palette so dark mode looks intentional rather than washed out") |

None of the three share tokens, a naming convention, or even a visual identity. An editor's dark-mode toggle in Payload's own account menu has **no effect at all** on the dashboard shell one click away, which is permanently locked to a black/white/blue "Vercel" look regardless of that setting.

## 2. A fourth, dead system: the orphaned "Control Fleet" admin override

`src/components/admin/AdminTheme.tsx` and `src/components/admin/AdminPageBuilderLink.tsx` exist on disk today but are **referenced nowhere** in `payload.config.ts` (confirmed by repo-wide grep — zero hits outside their own files). Git history reconstructs what happened:

- **2026-07-27**, commit `d12f3cb4`: *"apply Control Fleet theme + icon to Payload /admin"* — wired `admin.components.providers: ['./components/admin/AdminTheme.tsx#AdminTheme']`. Two follow-up commits the same day added `AdminPageBuilderLink` via `beforeDashboard`.
- **2026-08-02**, commit `5951b9af`: *"fix: restore payload admin runtime"* — both wirings were removed, as one part of a much larger emergency-recovery commit (41 lines changed in `payload.config.ts` alone, alongside `importMap.js`, layout, API routes) landing in the middle of a day of admin-panel firefighting (`disable Users collection to debug`, `disable problematic collections to unblock admin panel`, etc. — a big "install Payload ecommerce template" merge the day before had broken the admin panel wholesale).
- The component files themselves were never deleted, just unwired — **orphaned, not abandoned by intent**. Nothing since 2026-08-02 has touched them (confirmed: no commits found against either file after the revert).

**Whether the theme override itself was the actual cause of the runtime break, or just collateral removed while triaging the bigger ecommerce-template meltdown, is not established by the history** — the revert commit is a single terse message covering many unrelated fixes at once. Flagging this as genuinely unverified rather than asserting blame either way.

### What's actually wrong with `AdminTheme.tsx` as written (independent of why it got reverted)

```css
:root, html[data-theme='dark'], html[data-theme='light'] {
  --cf-bg: #09090b; /* ...permanently dark Control Fleet palette... */
```

The selector applies the **identical dark palette under both `data-theme='light'` and `data-theme='dark'`**. Even if re-wired verbatim today, it would silently defeat the working stock Payload Light/Dark/Auto toggle confirmed in the 2026-09-13 teardown — editors who pick "Light" would still get a forced-dark admin. Any revival must branch light vs. dark, not hardcode one.

### What's disconnected about it

"Control Fleet" (`--cf-blue #4c8dff`, `--cf-green #34d399`, etc.) is an ops-console palette with **no relationship to ARIGEO's brand or to the page builder's own `--v2-*` tokens** — it was seemingly borrowed from an unrelated internal tool naming convention (`cf-` reads as "Control Fleet," mission-control's own ops dashboards), not authored for this CMS. This is the concrete shape of "must be related to the page builder": right now, nothing about the Payload admin's attempted theme has anything to do with what the page builder is actually building.

`AdminPageBuilderLink.tsx` (the dormant dashboard card meant to launch Builder Studio) compounds this — it hard-codes dark-mode-only fallback colors (`#e7e7ea` text on `#141417` bg) and a dark-variant logo asset, meaning it was authored assuming `AdminTheme`'s forced-dark override was active. If either were re-wired alone without the other, they'd visually clash.

## 3. Recommended direction (options for a human decision, not decided here)

1. **Tie the admin theme to the site's actual default `BuilderThemes` record**, not an invented ops palette. `normalizeTokens()` in `builder-v2/theme/tokens.ts` already knows how to resolve a site's default theme with light/dark fallback — the Payload admin `providers` component could read that same default record (server-side, at render time, the same way the page canvas does) and expose it as CSS vars, so an editor's "Website" workspace and the actual live site's brand colors feel like one continuous system instead of three.
2. **Fix the light/dark branch before anything else.** Any resurrected `AdminTheme` must key off `[data-theme='dark']` vs `[data-theme='light']` separately (mapping to `defaultDarkTokens`/`defaultLightTokens` respectively), never one hardcoded block for both — this is a correctness bug independent of the palette-source question in option 1.
3. **Bring `dashboard-globals.css` into the same conversation.** It's the surface an editor spends the most time in (the actual builder workspace chrome around the canvas), currently frozen in a permanent light "Vercel" look with zero dark-mode variables — the biggest actual gap in this whole chain, arguably higher-value to fix than Payload's own `/admin` chrome (which already has working stock dark mode).
4. **Do not re-wire blind.** Given this exact customization coincided with an admin-outage-grade revert once already, land any revival as its own isolated commit — not bundled with unrelated collection/config changes — and verify the admin panel loads cleanly on a clean checkout before merging, so if something breaks again it's immediately attributable.

## 4. What this doc is not

Not a code change — nothing in `cms-arigeo` was edited. That repo is mid-feature-branch (`feat/captain-maid-persistent-inspector-20260909`) with an uncommitted local `.env.staging` change already present; touching it wasn't in scope for a design-continuation pass and risks stepping on in-progress work. This is the design/diagnostic groundwork — implementation is a separate, explicit task for whoever owns that branch.

## 5. Confidence & limitations

- All "orphaned/unwired" claims are ground truth from `grep`/`git log -p` against the actual repo files and history, not inference.
- The *cause* of the 2026-08-02 revert (theme override vs. unrelated ecommerce-template fallout) is explicitly flagged as unverified — the commit message doesn't isolate it, and no follow-up commit or issue was found explaining the decision.
- Payload's own admin dark-mode claim (works, stock 3-way) is carried over from the 2026-09-13 teardown, itself based on a manual login by พี่เอก — not re-verified in this pass.
- `dashboard-globals.css` was read to line 80 of 209 plus a full grep for dark-mode selectors (zero hits) — high confidence on "no dark mode exists," lower confidence on every other detail past line 80.
