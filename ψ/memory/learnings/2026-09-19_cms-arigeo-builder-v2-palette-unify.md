---
name: 2026-09-19_cms-arigeo-builder-v2-palette-unify
description: cms-arigeo PR #126 (draft) — mechanical HSL-based unification of builder-v2's separate sage-green/cream palette onto the shared dashboard token system, per พี่เอก's decision
metadata:
  type: project
  ttl: 3mo
---

Follow-up to [[2026-09-19_cms-arigeo-logo-theme-audit]]. That audit flagged
`/dashboard/builder-v2`'s editor chrome as using an entirely separate,
hardcoded-light sage-green/cream palette with zero dark-mode support —
the single biggest contributor to "pages don't share a theme." พี่เอก's
decision: **unify it onto the shared palette, don't keep it distinct.**

## Implementation

[cms-arigeo PR #126](https://github.com/E0993599799/cms-arigeo/pull/126)
(draft, branch `unify/builder-v2-brand-palette`), touching 6 CSS files
(`builder-v2.css`, `-redesign.css`, `-workspaces.css`,
`-marcuz-inspector.css`, `-hotfix.css`, `-unified-nav.css`) plus the shared
asset-picker dialog block in `dashboard-globals.css`.

**Method**: wrote a Node script that computed HSL for every literal
hex/rgb color found (129 distinct values, ~350 occurrences: 224 hex + 125
rgb/rgba) and classified each by role via lightness/hue thresholds, then
mechanically substituted every occurrence with the matching
`dashboard-globals.css` token — `--background`/`--card`/`--muted`/
`--border`/`--foreground`/`--muted-foreground`/`--primary`/`--accent`,
wrapped as `hsl(var(--x))` or `hsl(var(--x) / alpha)`. Deliberately left
untouched: the already-correct status colors (error/warning/info, plus a
separate vivid "success" green ramp distinct from the brand-green family)
— universal semantics, not brand identity.

Doing this mechanically (not hand-edited) meant every recurring exact
hex/rgb value maps to exactly one token consistently across all 6 files —
preserves the original hand-authored file's relative-lightness/role
structure, just recolors it. Caught and fixed one real bug mid-process: a
double-`hsl(hsl(...))` wrap from the classify function self-wrapping one
branch's return value — caught via `grep "hsl(hsl("` before committing.

**Net effect**: builder-v2 gets dark-mode support for free — zero
`data-theme` selectors existed in these files before; every replaced color
now routes through `dashboard-globals.css`'s existing
`html[data-theme='dark']` block.

## Verified vs. not verified

- `npx tsc -p tsconfig.typecheck.json --noEmit` — 18 pre-existing baseline
  errors, none in these files.
- `next build` (`PAYLOAD_SKIP_DB_CHECK=true`) — clean, zero errors.
- **Not verified visually.** ~350 individual color rules is a much larger
  surface than PR #124's targeted fix — opened as **draft**, per this
  repo's incident history (a clean build has never been sufficient proof
  for a visual change here, see
  [[2026-09-16_cms-arigeo-dashboard-shadcn-theme-unify]]).

## How to apply

Given the scale, expect this to need more than one round of visual
feedback, unlike #124's single pass — don't be surprised if the first
preview needs adjustments. Re-check `gh pr view 126 --repo
E0993599799/cms-arigeo` before assuming current state.

## Status update (2026-09-21)

Verified via `gh pr view 126 --repo E0993599799/cms-arigeo`: **MERGED**
(no longer draft). Visual review apparently completed and resolved between
2026-09-19 and this check.
