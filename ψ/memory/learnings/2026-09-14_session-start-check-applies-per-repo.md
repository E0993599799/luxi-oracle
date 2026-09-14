---
pattern: A session-start repo/branch verification check must be re-run on every additional repository touched during a session, not just the one active when the session began — the check being satisfied once does not carry over to a second repo entered hours later.
date: 2026-09-14
source: "rrr: luxi-oracle (ARIGEO manual work + mission-control wrong-branch recovery)"
concepts: ["git", "session-start-protocol", "multi-repo", "process"]
---

# Session-start checks apply per-repo, not per-session

Ran the RTK Session Start Protocol (`git status --short` / `git branch --show-current`)
on `luxi-oracle` at the very start of a session. Hours later, mid-session, started
producing work destined for a *second* repository (`mission-control`) and committed
directly without re-running the same check there — landing the commit on
`feat/arigeo-mobile-ux-engineer-v1-20260912` (an unrelated in-progress feature branch)
instead of `main`. Recovery required a `git worktree` cherry-pick + conflict resolution
+ merge with `origin/main` — all avoidable with a 5-second branch check before the
first commit into that repo.

The protocol's own wording ("unconditional, not conditional on the task looking
substantial") is correct in spirit but easy to silently narrow to "the repo I checked
at session start" instead of "every repo I'm about to write to." The failure mode isn't
forgetting the rule exists — it's satisfying it once and treating that as covering the
whole session.

## How to apply

Before the *first* git write (commit, push, branch-affecting operation) into **any**
repository during a session — including a second, third, or later repo entered well
after the session began — run `git status --short` and `git branch --show-current` for
that specific repository, even if the same check already ran elsewhere this session.
Treat "I already did the session-start check" as scoped to one repo, not the session as
a whole.
