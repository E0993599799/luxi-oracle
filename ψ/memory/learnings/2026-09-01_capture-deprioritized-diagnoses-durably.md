---
pattern: "When a user deprioritizes an in-progress bug diagnosis, write it to a durable file immediately — chat-only diagnoses are lost the moment the session clears"
date: 2026-09-01
source: "rrr: arigeo-auth portal visual refresh + cross-repo UI/UX audit"
concepts: ["diagnosis-tracking", "session-continuity", "bug-triage", "memory-durability", "rrr-from-jsonl"]
---

# Capture deprioritized diagnoses durably, not just in chat

During an ARIGEO portal visual-refresh session, พี่เอก reported a "stuck on login page" bug
mid-task. I diagnosed a likely root cause (missing OIDC env vars in `.env.local`) but never
confirmed the fix, because พี่เอก redirected priorities: "not at all let deploy and give
improvement after that." The diagnosis then lived only in that conversation. The session was
later `/clear`-ed, and by the time `/rrr` ran, the only way to recover the diagnosis was reading
the raw `.jsonl` transcript — an expensive, error-prone reconstruction that a durable file would
have made unnecessary.

**Rule**: the moment a user says "fix it later" / "deploy first" about a bug you've already
diagnosed, write the diagnosis to a durable file (a proof file, a TODO, an issue) *before* moving
on to the next task. Don't let "later" mean "only in scrollback" — later is often a different
session with zero memory of the current one.

**Secondary finding**: `/rrr` run immediately after `/clear` (no work in the new session) is
still recoverable — read the previous session's `.jsonl` for user/assistant messages, then
cross-check against `git log` / `gh pr list` in the actual project repo (not the Oracle vault) for
ground truth on what actually shipped vs. what was only discussed. Slower than writing from live
memory, but not a reason to skip or fabricate the retro.

See full session: [[2026-09-01_arigeo-auth-portal-and-ux-audit-retro]] (retrospective).
