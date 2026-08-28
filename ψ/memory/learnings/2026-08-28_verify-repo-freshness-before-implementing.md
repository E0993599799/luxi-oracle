---
pattern: Before writing code in a checked-out repo you don't actively maintain, git fetch and diff local vs. remote first — a repo present on disk is not the same claim as a repo being current.
date: 2026-08-28
source: rrr: luxi-oracle (cms-arigeo cross-repo work)
concepts: [git, staleness, implementation-workflow, cross-repo]
metadata:
  type: feedback
  ttl: ∞
---

Implemented a real feature (`saveCurrentPageAsTemplateAction` + UI) against the local `cms-arigeo`
checkout, committed it, and only discovered while preparing to open a PR that local `main` was
**193 commits behind** `origin/main` — the entire editor toolbar (`Shell.tsx`, `EditorClient.tsx`,
`LeftRail.tsx`) had been substantially rewritten upstream in the meantime. Had to re-read the real
current source and rebuild the feature from scratch in an isolated worktree branched off actual
`origin/main`.

**Why**: I treated "the repo exists as a checkout on this machine" as equivalent to "the repo is
current." Those are different claims. A `git fetch` + `git log main..origin/main --oneline` takes
seconds and would have surfaced the staleness before I wrote a single line, not after.

**How to apply**:
- Before implementing anything in a repo you don't actively work in every session (sibling repos,
  cross-project work, repos another oracle/human owns), run `git fetch` and compare local branch
  to its remote tip first. Don't assume the working copy reflects "real" — verify it.
- This is especially load-bearing when reading source to *ground a design decision* (as in
  [[cms-arigeo-pagebuilder-v2-feature-spec]]-adjacent work) — stale reads produce confidently wrong
  conclusions about what already exists vs. what's a real gap.
- If staleness is discovered mid-task: don't force-apply the stale diff. Re-read the actual current
  files and rebuild against them — cherry-picking a stale commit onto a fresh branch off the real
  remote tip (via an isolated `git worktree`, to avoid disturbing the original stale checkout's
  working tree) is a clean way to recover without losing the underlying design intent.
- Secondary, same session: when a repo's working tree already has substantial unrelated
  uncommitted changes (someone else's in-flight work), never `git add -A` — stage only the exact
  paths you touched, and leave the rest untouched.
