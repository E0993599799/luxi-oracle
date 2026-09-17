---
name: cms-arigeo-secrets-still-unrotated-63-days
description: cms-arigeo/.env.staging still committed & unrotated 63 days after the leak, monitoring gap closed by re-checking manually and nudging via LINE
metadata:
  type: project
  ttl: 30d
---

`cms-arigeo/.env.staging` (DATABASE_URL, PAYLOAD_SECRET, BLOB_READ_WRITE_TOKEN, etc.) is still
git-tracked on `main` with the exact same blob hash (`6b1f22c...`) as the original leak commit
`33fe919f` (2026-07-17) — confirmed live 2026-09-18, full clone, no shortcuts. See
[[2026-09-01_escalation-cms-arigeo-committed-secrets]] for the full history (escalated 09-01,
nudged 09-03/09-04, LINE mechanism found broken 09-04).

**Why this memory exists**: the one-shot cloud routine that used to check this
(`trig_01LoStxhkXGDbE7smHHnSfP1`) fired once on 2026-09-04 and ended (`run_once_fired`) — there has
been no automated monitoring since. This session re-checked manually only because it happened to
have downtime, not because anything was watching. A fresh LINE nudge went out 2026-09-18
(message id `632235803099005032`) confirming credentials in `control_fleet/.env.local` now work
locally, even though the cloud routine's sandbox lacked them.

## How to apply

If this comes up again: don't assume the 2026-09-04 follow-up is still current — it's 2 weeks
stale by design (no recurring check exists). Re-verify `git ls-tree origin/main --
cms-arigeo/.env.staging` directly before reporting status. If พี่เอก wants this actually tracked
going forward, it needs a **recurring** cloud routine, not another one-shot — the one-shot pattern
is exactly what created this silent 2-week gap. Delete/archive this memory once the secrets are
actually rotated and the file is removed/gitignored (verify via blob hash change, not just a
gitignore commit — adding to `.gitignore` does not untrack an already-committed file).
