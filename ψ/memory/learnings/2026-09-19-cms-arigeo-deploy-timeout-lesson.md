---
name: 2026-09-19-cms-arigeo-deploy-timeout-lesson
description: cms-arigeo's vercel-prebuilt-deploy.yml 15-minute job timeout is too tight for production deploys — a "cancelled" GH Actions conclusion does not mean the Vercel deploy actually failed
metadata:
  type: reference
  ttl: ∞
---

Dispatching `vercel-prebuilt-deploy.yml` with `environment=production` for
`cms-arigeo` took the Vercel CLI (`vercel deploy --prebuilt --prod`) about
**14 minutes** between printing "Building…" and "Completing…" — both times
this happened while shipping [[2026-09-19_cms-arigeo-logo-theme-audit]]'s
PR #124. The job's `timeout-minutes: 15` killed the GitHub Actions run right
at that point both times, reported as workflow conclusion **"cancelled"**
(log line: `The operation was canceled`) — not "failure".

**The underlying Vercel deploy kept going and succeeded anyway**, both
times, confirmed via the Vercel API (`get_deployment` on `cms.arigeo.com`)
well after the GH Actions job had already died: `aliasError: null`,
`readyState: READY`, correct `githubCommitSha`.

## How to apply

- A "cancelled" conclusion on this specific workflow is **not proof the
  deploy failed** — before retrying or reporting failure, check the actual
  Vercel deployment state directly (`get_deployment` on the production
  domain or the printed preview/production URL), not just the GitHub
  Actions run conclusion.
- Retrying blindly when the first attempt may have already succeeded just
  creates extra orphaned `READY` deployments on Vercel — harmless clutter,
  but wasted time. Check Vercel's state first.
- Root cause of the ~14-minute "Building…" wait is **not** confirmed (could
  be SSL/domain propagation, a Vercel platform queue, or something specific
  to this project's function count) — worth investigating if this recurs.
  A real fix would be raising `timeout-minutes` in
  `.github/workflows/vercel-prebuilt-deploy.yml`, or having the workflow
  poll Vercel's API directly for readiness instead of trusting the CLI
  process to survive long enough to report it.
