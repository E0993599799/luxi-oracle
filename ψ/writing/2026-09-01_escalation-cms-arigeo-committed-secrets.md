---
date: 2026-09-01
type: escalation-record
status: sent
---

# Escalation: cms-arigeo committed secrets in `.env.staging` routed to พี่เอก via LINE

## What happened

During Phase 0 repository truth audit of `E0993599799/cms-arigeo` main (HEAD
`6fcf67e0364b0af68d36ea41e17e589d425e2686`, for the Page Builder V2 verification mission), a
background source-audit fork found `.env.staging` git-tracked at the real app root
(`cms-arigeo/.env.staging` inside the nested `cms-arigeo/cms-arigeo/` real project directory).

Verified directly (key names only, values never printed to any log/transcript):

- Tracked keys: `NODE_ENV`, `DATABASE_URL`, `PAYLOAD_SECRET`, `BLOB_READ_WRITE_TOKEN`,
  `PAYLOAD_CORS_ORIGIN`, `PAYLOAD_CSRF_ORIGIN`, `DEBUG`, `LOG_LEVEL`.
- First committed in `33fe919fa7800e4a69c076b7c1c030a937cec4ba` ("feat: Brand Content Platform CMS
  setup (Phase 1)"), 2026-07-17 11:44:26 +0700 — present in git history for well over a month as
  of this audit.
- The values themselves are reported by the auditing fork as "real-looking" (not obvious
  placeholders) — not independently re-verified by me beyond key-name/commit confirmation, to avoid
  gratuitously handling secret values.
- Repo visibility confirmed: **private** (`gh repo view` → `isPrivate: true`). Lowers but does not
  eliminate exposure — anyone with repo access (past/present collaborators, CI logs, any fork) has
  had access to these values since 2026-07-17.

## Why escalated instead of acting unilaterally

Rotating `DATABASE_URL`/`PAYLOAD_SECRET`/`BLOB_READ_WRITE_TOKEN` touches live infrastructure
(production/staging Payload + Postgres + Vercel Blob credentials) — not a design or engineering
call I make alone. This is exactly the class of thing the Golden Rule "Never commit secrets" exists
to catch, but the fix (rotate + scrub history) is พี่เอก's/the repo owner's call on timing and
blast radius, not something to do mid-audit without sign-off.

## Action taken

Per standing order (2026-08-28, escalations go via LINE, not ธาม-handoff files):

> [agent: luxi-oracle] SECURITY: cms-arigeo/.env.staging is committed to git (since 33fe919,
> 2026-07-17) with real-looking DATABASE_URL, PAYLOAD_SECRET, BLOB_READ_WRITE_TOKEN. Repo is
> private but please rotate these regardless. Not blocking my Page Builder V2 audit, flagging
> separately/immediately.

LINE push confirmed `ok: true`, status 200, message id `629784137838100601`.

## Status

Not blocking — continuing the Page Builder V2 Phase 0 truth audit in parallel. This record exists
so the finding isn't lost even though it's tangential to the builder-verification mission itself.

## Follow-up, 2026-09-03

Checked `cms-arigeo` `main` directly: `.env.staging` still tracked at current HEAD (`19f8dac`),
git blob hash `6b1f22c` unchanged from the original commit `33fe919f` (2026-07-17) — confirms no
rotation has happened yet, two days after the initial ping. Sent a short LINE nudge:

> [agent: luxi-oracle] Follow-up: cms-arigeo/.env.staging still committed as of today (HEAD
> 19f8dac), blob unchanged since 33fe919f (2026-07-17) — DATABASE_URL/PAYLOAD_SECRET/
> BLOB_READ_WRITE_TOKEN etc. not yet rotated. Private repo, not blocking, just a nudge.

LINE push confirmed `ok: true`, status 200, message id `630055490835710074`. Status unchanged:
not blocking, still พี่เอก's call on timing.
