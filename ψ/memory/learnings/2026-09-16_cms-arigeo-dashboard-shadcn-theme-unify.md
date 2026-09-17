---
name: cms-arigeo-dashboard-shadcn-theme-unify
description: RESOLVED 2026-09-17 — PR #119 shipped to production then พี่เอก reported it badly broken ("สีเพี้ยนมาก"); reverted (6bed8827/b5141e61). Retried identical change as PR #121, this time gated on a real Vercel preview + พี่เอก's own authenticated SSO click-through before merge — colors confirmed correct, merged as beff915d.
metadata:
  type: feedback
  ttl: 3mo
---

Continues: [[2026-09-14_cms-arigeo-orphaned-payload-admin-theme]], full diagnostic: `ψ/writing/2026-09-14_cms-arigeo-payload-admin-theme-plan.md`.

## What changed

พี่เอก asked to bring `cms.arigeo.com/admin` onto a shadcn theme. Scoped with พี่เอก to: both `/admin` + `/dashboard`, canonical palette = extend the ARIGEO-red (light)/Control-Fleet-blue (dark) palette PR #107 already shipped into `AdminTheme.tsx` 2026-09-14, rather than inventing a third palette or pulling from `builder-v2/theme/tokens.ts` (left untouched).

Implemented on `cms-arigeo` branch `feat/dashboard-theme-unify` (worktree `/home/marcuz/wt/cms-arigeo-dashboard-theme`, off `origin/main` @ `8645e08`), uncommitted as of this note — 3 files:

1. `src/app/dashboard/dashboard-globals.css` — replaced the light-only "Vercel" `:root` shadcn tokens with the ARIGEO hex palette (converted to HSL triplets), added a new `html[data-theme='dark']` block with the Control-Fleet palette (dashboard had **zero** dark mode before this). Simplified the now-real `.admin-wrapper`/`.admin-main` rules, dropping a `--cf-*` fallback pattern that was dead code (those vars are only ever declared inside `AdminTheme.tsx`'s injected `<style>`, which never reaches `/dashboard`'s separate Next.js route tree).
2. `src/admin/theme/getDashboardTheme.ts` (new) — reads Payload's own `payload-theme` cookie (confirmed via reading Payload's actual source: no `cookiePrefix` configured → default name, written with `path=/` so already visible cross-route) server-side, falls back to `Sec-CH-Prefers-Color-Scheme`, then `'light'`.
3. `src/app/dashboard/layout.tsx` — was hardcoding `data-theme="dark"` unconditionally on `<html>` (a latent bug, invisible only because no dark CSS existed yet); now calls `getDashboardTheme()` and uses the real value. No new toggle UI added — the single existing toggle stays in Payload's own admin nav.

## Verification status — INCOMPLETE, needs a human/real-DB pass

- `npx tsc --noEmit`: confirmed zero new errors (diffed against a stashed baseline — both are 29 pre-existing unrelated errors, none touching these 3 files).
- `npm run dev`: boots clean, no compile error referencing any of the 3 changed files.
- **Could not get an authenticated visual click-through** — this sandbox's `.env.staging` is a placeholder template (`DATABASE_URL=postgres://postgres:[PASSWORD]@db.[PROJECT-REF]...`), not real credentials, so Payload can't connect to any DB and every route that needs auth (`/dashboard`, `/admin`) can't be fully exercised end-to-end here.
- **Next session/human with real staging credentials must do the plan's Step 5 manual pass** (`docs`/plan at `/home/marcuz/.claude/plans/cuddly-dazzling-sundae.md` if still present, or reconstruct from this note): toggle light/dark in `/admin`, confirm `/admin` is visually unchanged (untouched file), follow the link into `/dashboard`, confirm `data-theme` matches and the ARIGEO/Control-Fleet palette actually paints in both modes, spot-check overview/products/builder pages for contrast issues.

## Outcome

Committed `ca63a51e` on `feat/dashboard-theme-unify`, pushed, opened as cms-arigeo PR #119 by พี่เอก (gh wasn't authenticated in this sandbox so I couldn't open the PR myself), and confirmed merged into `origin/main` as `bcfd3d18` (2026-09-17 01:30:26 +0700) — diffed the merged commit against my original and it's byte-identical, no drift. พี่เอก reported "merge done"; verified independently via `git log origin/main` + `git diff` rather than taking the claim at face value.

Local verification before handoff: `tsc --noEmit` clean, `npm run build` 100% clean across all routes. Could **not** complete an authenticated visual click-through locally — login goes through real ZITADEL SSO (a human's own credentials, not something to attempt even with more env vars) and the sandbox's copied `.env.local` was missing `PROJECT_CMS_ARIGEO`/`PROJECT_CMS_CAPTAINMAID`. Assume พี่เอก or another reviewer did the actual light/dark click-through on the PR preview before merging — not independently confirmed here.

## Incident — reverted 2026-09-17

พี่เอก, after logging into production, reported: "พังหมด สีเพี้ยนมาก" (completely broken, colors very off). This session **never got a real visual confirmation** at any point — local verification was blocked by real ZITADEL SSO (couldn't log in), and post-deploy verification on production hit the same wall. The `tsc`/`npm run build` green checks only proved the code compiles, not that it looks right — that gap is exactly what bit here. **Lesson: for this repo, "build succeeds" is not sufficient proof for a visual/theme change — a real authenticated screenshot is mandatory before calling it done, even under time pressure, even when SSO makes it inconvenient.** Next attempt should get พี่เอก (or someone with real SSO access) to screenshot the change on a PR preview *before* merging, not after.

Response: `git revert --no-edit bcfd3d18` → `6bed8827` (clean, no conflicts). Re-fired the one-shot deploy workflow via trigger-bump commit `b5141e61`. Also surfaced the faster option (Vercel dashboard "Promote to Production" on the pre-change deployment `dpl_Gi5JJ88mqaFEGoxjag85uEjJ3h7r`/`8645e08`) since the git-level revert-and-redeploy path takes ~35 min and this was reported as severely broken.

พี่เอก also asked in the same breath to make `/admin` match "MD" — asked for clarification before acting, to avoid compounding an active incident with another guess-based change.

## How to apply

Before ever touching this theme surface again: get a real screenshot/click-through from a human with SSO access on a PR preview, *before* merging — not "build passed so it's probably fine." The palette-conversion math and cookie-sync pattern here may still be reusable once the actual visual bug is identified, but do not trust them merely because they compiled.

## Resolution — 2026-09-17

Retried, this time closing the exact gap identified above:

1. Found the reverted branch `feat/dashboard-theme-unify` still had commit `ca63a51e` pushed — byte-identical to the reverted `bcfd3d18` (`git diff bcfd3d18 ca63a51e` empty). Nothing had actually changed since the incident; only the missing verification step remained undone.
2. `gh` wasn't authenticated in-session — พี่เอก ran `gh auth login` themselves.
3. Opened draft PR `cms-arigeo#121` off that same commit.
4. **Discovered `vercel.json` has `"git": {"deploymentEnabled": false}`** — this project's git integration never auto-builds PR previews (explains why #113/#114/#116/#118/#119 never got one either). A generic file-upload deploy would've meant reconstructing 853 tracked files by hand — too costly, and wouldn't match the project's real build config.
5. Found the project's actual intended mechanism: `.github/workflows/vercel-prebuilt-build.yml` (workflow_dispatch, ref+environment inputs) → `vercel-prebuilt-deploy.yml` (workflow_dispatch, build_run_id input). Dispatched both via `gh workflow run` for `ref=feat/dashboard-theme-unify`, `environment=preview`. Build passed all its regression gates (dashboard real-route gate, admin theme regressions, strict production-compatible build) before producing the artifact.
6. Got preview URL `https://cms-arigeo-4556sqdzz-omega-project.vercel.app`. Verified via the build log's "Checkout exact approved ref" step that it built `ca63a51e`, not stale content — the deployment's own `githubCommitSha` metadata field was misleading (stamped from the last CLI-linked commit, not what was actually built), so didn't trust it at face value.
7. พี่เอก did the real authenticated click-through with SSO — **colors correct this time**.
8. Marked #121 ready, merged to `main` as `beff915d`.
9. Dispatched the same `vercel-prebuilt-build`/`-deploy` pair for `ref=main`, `environment=production`. Confirmed via `get_deployment` that the resulting deployment's `alias` includes `cms.arigeo.com`, `target: "production"`, and `githubCommitSha: beff915d` (this time the metadata was accurate, unlike the preview deploy's stale field). พี่เอก independently checked `cms.arigeo.com/dashboard` live — **colors correct in production**.

**Closed.** No lingering risk on this surface — root cause was process (missing verification gate), not code, and the gate is now demonstrated to work.

**New reusable finding for this repo**: `cms-arigeo`'s Vercel git integration is deliberately disabled (`deploymentEnabled: false`) — any future "get me a preview" request here must go through the `vercel-prebuilt-build` → `vercel-prebuilt-deploy` workflow-dispatch pair (`gh workflow run`), not by waiting on an automatic PR build.
