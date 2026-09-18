---
name: auth-arigeo-com-pr71-theme-work
description: arigeo-auth PR #71 opened — shadcn token rename, alert recipe consolidation, full dark mode for auth.arigeo.com, mirroring hr.arigeo.com's PR #75 pattern
metadata:
  type: project
  ttl: 3mo
---

Implemented 3 of the 4 options from [[2026-09-14_auth-arigeo-theme-spec]] as
[arigeo-auth PR #71](https://github.com/E0993599799/arigeo-auth/pull/71)
(branch `theme/shadcn-rename-alert-recipe-dark-mode`), not yet merged as of
2026-09-19.

1. **Shadcn-convention token rename** (§3) — zero visual change.
2. **Alert recipe consolidation** (§2.2) — one deliberate minor visual change:
   `.alert--info` now gets its own tint instead of inheriting the page
   background.
3. **Full dark mode** (§2.6) — new. Brand red brightened to `#ff4c59` for
   dark contrast, matching hr.arigeo.com's PR #75 dark accent for
   cross-family consistency. Toggle scoped to the post-login portal topbar
   only; the sign-in page follows OS preference with no visible toggle.
4. **Hero-tile treatment** (§2.4) — explicitly skipped. Asked พี่เอก which of
   the 3 portal modules (Arigeo-HR / CMS-Arigeo / User Management) should be
   visually primary; answer was to skip it for now rather than guess.

## Non-obvious implementation constraint

`arigeo-auth` enforces a strict nonce-based CSP (`script-src` with no
`unsafe-inline`, see `lib/security/csp.ts` + `proxy.ts`). Any inline
`<script>` — like the theme-bootstrap flash-prevention script this PR adds to
`app/layout.tsx` — must read the nonce via `headers().get('x-nonce')` (the
same value `proxy.ts` puts in the CSP response header) and attach it
explicitly, or the browser silently blocks the script. `arigeo-hr` and
`cms-arigeo` don't have this constraint — don't port an inline-script pattern
from one ARIGEO repo to another without checking each repo's own CSP first.

## How to apply

Verified before pushing: `typecheck` clean, 202/202 unit tests passing,
`next build` clean. **Not** verified in a live browser — no login
credentials available from this environment. The PR carries a test-plan
checklist for a human to complete on the Vercel preview (same pattern PR #75
used). Before resuming this thread, re-check `gh pr view 71 --repo
E0993599799/arigeo-auth` rather than assuming it's still open — see
[[2026-09-19_hr-arigeo-com-theme-audit-resolved]] for why: memory said
hr.arigeo.com's own theme work was still pending when it had actually
already shipped.
