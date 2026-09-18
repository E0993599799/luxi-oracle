---
name: cms-arigeo-logo-theme-audit
description: cms-arigeo dashboard logo/theme consistency audit — PR #124 (draft) fixes the logo-contrast root cause, flags builder-v2's separate sage/cream palette as a much bigger unresolved finding
metadata:
  type: project
  ttl: 3mo
---

พี่เอก reported cms-arigeo pages don't share one theme direction, and the logo
doesn't contrast with its background. Audited the actual repo (not just the
live site) rather than guessing from symptoms.

## Root cause of the logo bug — fixed

`AdminNav.tsx` (the `/dashboard` sidebar, shared across every `/dashboard/*`
page) and `AdminPageBuilderLink.tsx` (the `/admin` "Open Builder Studio"
card) both hardcoded the **white dark-mode wordmark**
(`arigeo-logo-dark-mode.png`) unconditionally — no `[data-theme]` awareness
at all. In light mode (the default when no `payload-theme` cookie exists),
the sidebar background is `hsl(var(--card))` = white, so the white-on-white
logo was effectively invisible. The correct pattern already existed
elsewhere — `ArigeoLogo.tsx` (Payload's own `/admin` `graphics.Logo` slot)
renders both wordmarks, toggled by `AdminTheme.tsx`'s `[data-theme]` CSS —
that fix just never reached these two other spots.

Fixed in [cms-arigeo PR #124](https://github.com/E0993599799/cms-arigeo/pull/124)
(**draft**, branch `fix/dashboard-logo-theme-contrast`, not merged):
1. `AdminNav.tsx` — both wordmarks rendered, toggled via new CSS added to
   `dashboard-globals.css` (needed its own copy of the toggle because
   `AdminTheme.tsx`'s injected `<style>` only reaches Payload's `/admin`
   route tree, not `/dashboard`'s separate app-router tree).
2. `AdminPageBuilderLink.tsx` — now reuses `<ArigeoLogo />` directly.
3. `admin-preview/page.tsx` — was entirely hardcoded slate/blue Tailwind,
   disconnected from the shared tokens every other `/dashboard` page uses.
   Converted to `--card`/`--foreground`/`--primary`/`--border`.

## Bigger finding — NOT fixed, needs a decision

`/dashboard/builder-v2`'s own editor chrome (6 CSS files, ~1,226 lines:
`builder-v2-redesign.css`, `builder-v2-workspaces.css`,
`builder-v2-marcuz-inspector.css`, `builder-v2.css`, `builder-v2-hotfix.css`,
`builder-v2-unified-nav.css`, plus the shared asset-picker dialog in
`dashboard-globals.css`) uses an **entirely separate, hardcoded-light
sage/cream palette** (`#2b4f3d`, `#e5efe8`, `#f5f1ea`, …) with **zero
`data-theme` references anywhere** — a third visual language, disconnected
from both the ARIGEO-red and Control-Fleet-blue palettes used in the rest of
`/dashboard`, with no dark mode at all. Since builder-v2 is the canonical,
most-used editor surface (see [[2026-09-01_cms-arigeo-three-builder-systems-not-one]]),
this is almost certainly the single biggest contributor to "pages don't
share a theme" — bigger than the logo bug. **Open question for พี่เอก**: is
the sage/cream a deliberate, distinct "creative canvas" identity worth
keeping, or should it be unified into the red/Control-Fleet system with
dark-mode support added? Don't touch this without an answer — see the
incident note below for why.

## Process constraint — carried forward from the PR #121 incident

See [[2026-09-16_cms-arigeo-dashboard-shadcn-theme-unify]]: a clean
build/typecheck is **not** sufficient proof for a visual/theme change on
this repo. PR #119 had clean checks, shipped, and was reported "สีเพี้ยนมาก"
(colors very wrong) in production — had to be reverted. PR #124 was
deliberately opened as **draft** with an explicit test-plan requiring a real
authenticated SSO click-through on a dispatched `vercel-prebuilt-build` →
`-deploy` preview before merge.

## How to apply

Don't let PR #124 merge on green CI alone — it needs a real screenshot from
a human with SSO access first, same gate PR #121 used successfully after
PR #119's revert. If/when the builder-v2 palette question gets an answer,
treat it as its own separate, larger effort — do not fold it into #124.
