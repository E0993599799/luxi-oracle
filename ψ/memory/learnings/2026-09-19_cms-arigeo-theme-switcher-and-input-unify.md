---
pattern: cms-arigeo dashboard theme switcher + shared Input component unification (PR #128, draft)
date: 2026-09-19
source: "rrr: luxi-oracle (mission-memory record 872, backfilled 2026-09-20)"
concepts: [cms-arigeo, dashboard-theme, dry, shadcn, verification-gap]
---

## What shipped (in a draft PR, not yet merged)

พี่เอก asked for two things on cms.arigeo.com's `/dashboard`: a light/dark theme
switcher, and password-style inputs (show/hide toggle, per shadcnblocks'
"Input Types 2") applied site-wide.

`/dashboard` already had full light-mode CSS (since dashboard-theme-unify,
PR #121) and a cookie-based `getDashboardTheme()` reader, but no visible way to
toggle it from `/dashboard` itself — only Payload's own separate `/admin` nav
had a switch. `src/components/ui/input.tsx` already existed as a proper
theme-token-based shadcn `Input`; the ask was to actually use it everywhere and
add the missing password variant.

**Files**:
- `components/theme/ThemeSwitcher.tsx` (new) — writes the same `payload-theme`
  cookie Payload's own toggle uses, flips `data-theme` on `<html>` directly for
  an instant update with no server round-trip. Wired into `AdminNav.tsx`.
- `components/ui/password-input.tsx` (new) — wraps `<Input />` with a show/hide
  toggle. No current form needs it yet (auth is external ZITADEL/Payload) —
  available for the next one that does.
- Converted raw `<input>`/`<textarea>` to `<Input>`/`<Textarea>` across
  `SettingsEditor`, `ProductEditor`, `products/page.tsx` search filter,
  `MediaUploader`, `BrandEditor`, `AgentChat` composer — all of these had
  hand-copied the identical Tailwind classes already, so this is a DRY pass,
  not a visual change (values were already theme-correct; the swap only adds
  the focus-ring that was missing).
- Deliberately untouched: `<select>` elements, `UserAccessEditor` (checkboxes
  only), `AdminSearch` (its own CSS module, risky to restructure), and
  `builder-v2/pages/page.tsx` (already owned by the still-open PR #126 palette
  unification — touching it here would conflict).

## Why this is still a draft

Same wall as PR #127: `/dashboard` needs real ZITADEL-backed auth this
environment doesn't have, and preview deployments 500 on login cross-origin —
no live authenticated click-through was obtainable. Verified instead via the
compiled CSS token values from this branch's own `next build` output, rendered
in a standalone harness using the exact class names `Input`/`ThemeSwitcher`
emit — a deterministic proxy check, not a real render of the actual page.

**Next action**: get พี่เอก's confirmation against the real
preview/production dashboard before merging — this PR has only had the
compiled-token proxy verification, never a live authenticated check.

## Pattern this repeats

Third time this session cms-arigeo's preview-deploy cross-origin login wall
blocked a live click-through (see [[2026-09-19_cms-arigeo-dashboard-frame-fix]]
for the PR #127 instance). The workaround — verify via compiled build output
or a standalone harness using the exact real class names — is a reasonable
substitute for *deterministic* CSS checks, but is not equivalent to seeing the
actual page render, and should not be reported as "visually verified" without
that caveat attached.

## Status update (2026-09-21)

Verified via `gh pr view 128 --repo E0993599799/cms-arigeo`: **MERGED**
(no longer draft). Fourth instance this week of a "draft, pending live
confirmation" memory going stale before the next session checked it — see
the same correction on [[2026-09-19_cms-arigeo-builder-v2-palette-unify]]
and [[auth-arigeo-com-pr71-theme-work]].
