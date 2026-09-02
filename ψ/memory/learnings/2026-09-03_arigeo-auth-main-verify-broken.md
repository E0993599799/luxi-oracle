---
name: arigeo-auth-main-verify-broken
description: arigeo-auth's Verify CI workflow has been failing on main since at least 2026-08-31 on a stale test/copy mismatch, unrelated to any PR's own changes
metadata:
  type: project
  ttl: 1mo
---

`main`'s last 5+ `Verify` GitHub Actions runs (2026-08-31 through 2026-09-01, latest checked
`14c2b54`) all fail on the same `npm run test` error: `tests/ui-admin.test.tsx` looks for a link
accessibly named `/account management/i`, but the rendered admin tile says **"User Management
Module"** — a stale test/copy mismatch, not a real regression.

## Why this matters

A red `verify` check on any arigeo-auth PR does **not** by itself mean the PR broke something —
confirmed for PR #20 (`style(portal): double trust-strip icon size`, CSS-only diff) by diffing
its failure against main's own failing history: identical error, same file, predates the PR.

## How to apply

- Before treating a red `verify` check on an arigeo-auth PR as a real regression, check whether
  `main`'s own recent Verify runs are already failing the same way (`gh run list --branch main
  --workflow Verify`).
- Don't block/hold merges on this specific `ui-admin.test.tsx` failure alone if the PR's diff
  doesn't touch admin-tile copy or `tests/ui-admin.test.tsx`.
- Noted, not escalated (พี่เอก's call, 2026-09-03) — someone still needs to fix the test/copy
  mismatch eventually, just not urgent.
