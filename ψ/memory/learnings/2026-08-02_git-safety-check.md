---
name: git-safety-before-push
description: Always fetch remote state before pushing; "git status up to date" only checks local tracking
metadata:
  type: feedback
  source: rrr session arigeo-project UI fixes
  session: ec727fd8
---

# Git Safety Check Before Push — Non-Negotiable Habit

## The Rule

**Before ANY `git push`**, run:
```bash
git fetch origin
git diff origin/$(git rev-parse --abbrev-ref HEAD)...HEAD --name-only
```

If output is non-empty, you have commits ahead of remote. If empty, you're synced.

**Never trust `git status "Your branch is up to date with origin/..."`** — that line checks your local tracking branch, not the actual remote. Remote state is the authority.

## Why It Matters

**Incident**: Pushed to arigeo-project master. Got rejection: "failed to push some refs" + "Updates were rejected because the remote contains work that you do not have locally."

**Root cause**: Assumed local master = remote master because `git status` said "up to date." But 4 commits had landed on remote since my last fetch. My push would have overwritten teammates' work.

**Recovery cost**: Ran `git rebase origin/master`, resolved merge conflict in globals.css, re-pushed. Added 5 minutes of friction.

**Preventable?** Yes. If I'd checked remote divergence first, I'd have rebased *before* attempting push, avoiding the rejection.

## When It Bites

- **Multi-person teams** — Remote changes land between your `git pull` and your `git push`
- **CI/CD pipeline** — Automated commits (version bumps, changelogs) land on main
- **Concurrent feature branches** — You and teammate both push to master or develop simultaneously
- **Stale local tracking** — Network hiccup during clone/pull leaves tracking branch outdated

## Pattern: Local vs. Remote Authority

| What | Authority | Checked By |
|---|---|---|
| Your commits ahead of local master | Local history | `git log --oneline -5` |
| Your local master vs. your tracking branch | Local tracking state | `git status` |
| **Your tracking branch vs. ACTUAL remote** | **Actual remote** | **`git fetch` + `git diff origin/...`** |

`git status` output is stale immediately after remote changes land. Trust the fetch.

## Actionable Habit

```bash
# Before: git push
# Do this instead:

git fetch origin
DIVERGE=$(git diff origin/$(git rev-parse --abbrev-ref HEAD)...HEAD --name-only | wc -l)
if [ "$DIVERGE" -gt 0 ]; then
  echo "⚠️ $DIVERGE commits on remote. Rebasing..."
  git rebase origin/$(git rev-parse --abbrev-ref HEAD)
else
  echo "✓ Local matches remote. Safe to push."
fi
git push origin $(git rev-parse --abbrev-ref HEAD)
```

Or just make it muscle memory: `git fetch && git status && git push`

## Zeus Protocol Alignment

This rule is **explicitly stated in arigeo-project CLAUDE.md §"PRE-WORK GIT SAFETY CHECK"**:

> "BEFORE starting ANY task on ANY project, MANDATORY CHECK: `git fetch origin && git diff origin/$(git rev-parse --abbrev-ref HEAD)..HEAD --name-only`"

I read the rule, understood it, then failed to apply it during actual push. **Knowing ≠ Doing.**

## Lesson for Other Oracles

If you see a sibling oracle skip this check, flag it. It's not about speed—it's about not silently destroying teammate work.

---

**Session**: arigeo-project UI fixes (ec727fd8)  
**Date**: 2026-08-02  
**Severity**: Medium (recoverable, but preventable)  
**Related**: [[zeus-commit-gate]] | [[git-safety-protocol]]
