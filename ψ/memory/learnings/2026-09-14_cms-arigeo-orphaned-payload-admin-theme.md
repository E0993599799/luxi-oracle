---
name: cms-arigeo-orphaned-payload-admin-theme
description: cms-arigeo has 3 unrelated theme systems stacked (Payload admin, /dashboard shell, page-builder canvas) plus a 4th dead one (Control Fleet admin override) orphaned since a 2026-08-02 emergency revert — don't assume "unmodified Payload theming" is the whole story.
metadata:
  type: project
  ttl: 3mo
---

Full plan: [[2026-09-14_cms-arigeo-payload-admin-theme-plan]] (`ψ/writing/2026-09-14_cms-arigeo-payload-admin-theme-plan.md`)

## The correction to the 2026-09-13 teardown

[[2026-09-13_shadcnblocks-admin-dropdown-theme-patterns]] concluded cms.arigeo.com's admin is "unmodified stock Payload theming end to end." That was true for the **public login page only** (unauthenticated). Reading the actual `cms-arigeo` repo (not just the live site) found a customization was built 2026-07-27 (`AdminTheme.tsx`, a "Control Fleet" dark-palette override wired via `admin.components.providers`), then unwired 2026-08-02 in an emergency "restore payload admin runtime" commit during a bigger ecommerce-template meltdown — the files (`src/components/admin/AdminTheme.tsx`, `AdminPageBuilderLink.tsx`) were never deleted, just orphaned. Confirmed via `git log -p -- payload.config.ts` tracing the exact add/remove commits, and repo-wide grep showing zero live references today.

## Why it matters beyond this one repo

- **Don't trust a live-site teardown alone as "the whole picture" for a repo you can also read directly** — the public page showed stock Payload because the customization is dead code, not because it was never attempted. When the actual repo is available, check git history for "was this tried and reverted" before concluding a system is unmodified.
- **A CSS override that hardcodes one selector for both `data-theme='light'` and `data-theme='dark'`** silently defeats a working native light/dark toggle rather than extending it — a bug pattern worth checking for in any theme-injection component, not just this one.
- **cms-arigeo's editor journey crosses 3 non-communicating theme systems** (Payload admin chrome, `/dashboard` shell frozen in permanent light "Vercel" mode with zero dark CSS, and the page-builder canvas's own dark-aware `--v2-*` tokens in `builder-v2/theme/tokens.ts`) — any future "make the admin feel cohesive" ask should start from this map rather than re-deriving it.

## How to apply

Before proposing any Payload-admin-facing customization in cms-arigeo, check this entry and the full plan first — the reusable insight is "tie any admin theme override to the page builder's own `BuilderThemes`/`ThemeTokens` model, branch light/dark correctly, and land it as an isolated commit" given the track record of this exact area causing an admin outage once already.
