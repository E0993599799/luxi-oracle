---
name: cms-arigeo-dashboard-frame-fix
description: cms-arigeo PR #127 (merged, live) — fixed dashboard main frame stuck light in dark mode, root-caused via live browser inspection
metadata:
  type: project
  ttl: 3mo
---

Follow-up to [[2026-09-19_cms-arigeo-logo-theme-audit]]. พี่เอก screenshotted
`cms.arigeo.com/dashboard/overview` in dark mode: sidebar and stat cards correctly dark,
but the main frame (`.admin-wrapper`/`.admin-main`) stuck light with barely-legible pale
text.

## Root cause — found via a real connected browser session

Connected to พี่เอก's own logged-in Chrome (`claude-in-chrome`) and checked directly —
not guessed from source. `getComputedStyle` confirmed `data-theme="dark"` and
`--background`/`--card` tokens were correctly dark, but `.admin-wrapper`/`.admin-main`
still computed to `rgb(255,255,255)`/`rgb(250,250,250)`. `document.styleSheets`
inspection found the cause: `src/app/dashboard/dashboard-layout.scss` defines its own
`.admin-wrapper`/`.admin-main` rules hardcoding `background: #ffffff`/`#fafafa` (and
`color: #1a1a1a`) — a leftover from before dashboard-theme-unify
([[2026-09-16_cms-arigeo-dashboard-shadcn-theme-unify]], PR #121, 2026-09-17). Imported
in `layout.tsx` *after* `dashboard-globals.css`, same specificity, later source order —
the stale rule silently won the cascade for every `/dashboard` page, in both themes
(light mode coincidentally looked fine).

## Fixed in [cms-arigeo PR #127](https://github.com/E0993599799/cms-arigeo/pull/127)

Removed the 2 hardcoded background/color lines, kept pure layout properties. Merged as
`6fb06a5d`, deployed to production, **verified live via the connected browser
post-deploy**: `.admin-main`/`.admin-wrapper` now compute to `rgb(9,9,11)`, matching the
dark token — the strongest verification any single fix got in this session, since it
checked the actual rendered page, not just deployment metadata.

## Related finding — NOT fixed

While tracing this, found a **third parallel admin shell** at `src/app/(admin)/*`
(root-level routes: `/settings`, `/users`, `/overview`, `/workflows`, etc. — no
`/dashboard` prefix). Reuses the same `AdminNav` component and same
`.admin-wrapper`/`.admin-main` class names, with its own separate stale hardcoded `#fff`
CSS (`admin-layout.scss`) and hardcodes `data-theme="dark"` unconditionally (no
theme-cookie logic, doesn't import `dashboard-globals.css` at all). Git history already
labels it "legacy admin shell" (commit `d032b79`), and nothing in the current in-app
navigation links to it — likely dead, not confirmed removable. Flagged in PR #127's
description for a decision (fix/delete/ignore), same pattern as the builder-v2 palette
flag.

## How to apply

Verify via a real connected browser (`getComputedStyle` + `document.styleSheets`) before
concluding a token system itself is broken — a second, later-loaded rule on the same
selector is a common leftover from an incomplete refactor. See
[[2026-09-19_stale-duplicate-css-rule-wins-cascade]] for the generalized lesson.
