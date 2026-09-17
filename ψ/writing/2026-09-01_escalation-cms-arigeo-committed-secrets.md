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

## Follow-up, 2026-09-04

Checked `cms-arigeo` `main` directly: `.env.staging` still tracked at current HEAD (`485a875`),
git blob hash `6b1f22c` unchanged from the original commit `33fe919f` (2026-07-17) — confirms no
rotation has happened yet, three days after the initial ping.

Attempted the LINE nudge from `control_fleet` (`scripts/line-push.mjs`) but it failed before
sending: `LINE_CHANNEL_ACCESS_TOKEN is required in env or .env.local` — the env var พี่เอก was
asked to set is still not present in this environment, so the message was never sent to the LINE
API. Intended text (unsent):

> [agent: luxi-oracle] Follow-up: cms-arigeo/.env.staging still committed as of today, blob
> unchanged since 33fe919f (2026-07-17) — DATABASE_URL/PAYLOAD_SECRET/BLOB_READ_WRITE_TOKEN etc.
> still not rotated. Private repo, not blocking, just a nudge.

Status unchanged: not blocking, still พี่เอก's call on timing. LINE delivery is currently blocked
on env config, not on this check.

## Follow-up, 2026-09-18

The one-shot cloud routine (`trig_01LoStxhkXGDbE7smHHnSfP1`) fired once on 2026-09-04 as scheduled
and confirmed the LINE nudge failure above, then ended (`run_once_fired`) — no further automated
checks since. 14 days passed with no monitoring at all until this session (working on an unrelated
hr.arigeo.com task) happened to re-check while its dev-server verification was blocked.

Checked `cms-arigeo` `main` directly (fresh clone, full history, current HEAD): `cms-arigeo/.env.staging`
is **still tracked**, blob hash still `6b1f22cfc1452537a724884d5af53689fc4bfed5` — byte-identical to
the original `33fe919f` commit, 63 days ago. No rotation, no history scrub, in that window.

This local environment (unlike the cloud routine's sandbox) has `LINE_CHANNEL_ACCESS_TOKEN` and
`LINE_OWNER_USER_IDS` configured in `control_fleet/.env.local`, so the nudge sent successfully this
time:

> [agent: luxi-oracle] cms-arigeo/.env.staging STILL committed & unrotated after 63 days (since
> 33fe919f, 2026-07-17). Escalated 2026-09-01, nudged 09-03 & 09-04 — the automated LINE alert has
> been silently broken since then (missing token in that cloud env), so nobody's been pinged in 2
> weeks. Blob hash unchanged: 6b1f22c... at cms-arigeo/.env.staging on main right now.
> DATABASE_URL/PAYLOAD_SECRET/BLOB_READ_WRITE_TOKEN etc still exposed in git history. Not blocking
> today's HR brand-color work, but this one's overdue for a real look.

LINE push confirmed `ok: true`, status 200, message id `632235803099005032`.

**Status update**: still open, still not blocking other work, but the "not blocking" framing has
been true for 63 days now with zero remediation and a 2-week silent monitoring gap — this is no
longer a fresh nudge, it's a recurring unresolved item. No further automated one-shot check exists;
if this needs to stay tracked, it should either get a recurring cloud routine (not another one-shot)
or be treated as a standing to-do until พี่เอก actually rotates the credentials and scrubs history.
