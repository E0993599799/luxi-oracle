---
name: 2026-09-22_pharmacy-maven-theme-superseded-by-bpmp
description: pharmacy-expiry-system Maven Finance theme reskin (PR #41) is stale — master already shipped a different "BPMP" grayscale theme; work paused, not abandoned
metadata:
  type: project
  ttl: 3mo
---

พี่เอก asked to research a Behance case study ("Maven Finance Management" by Orbix
Studio) for theme ideas and apply the palette to `pharmacy-expiry-system`. Did that:
sampled the real palette pixel-by-pixel (`#325cff` primary, `#fb3747` critical,
`#fb7319` warning), reskinned `app/globals.css`, committed (`cfc7081`), pushed, and
opened [PR #41](https://github.com/E0993599799/pharmacy-expiry-system/pull/41) on
branch `feat/pharmacy-production-excel-expiry-reorder`.

## What went wrong — discovered after the fact

1. **Branch was 10 days stale.** That branch forked from master at `bbec185`
   (2026-09-12) and never rebased. `origin/master` is now at `a217a3c`
   (2026-09-22) — 10 days and many commits ahead.
2. **Master already has a completely different, more recent theme.** A whole
   "BPMP" design system shipped to master since: `013058a style: modern blue +
   olive green theme`, `252e622 style: adopt feature355 theme and Pharmacy
   Management System naming`, IBM Plex Sans typography, and — despite the
   "blue + olive" commit message — the actual tokens
   (`--bpmp-blue`, `--bpmp-green`) both resolve to **grayscale zinc shades**
   (`#18181b`/`#f4f4f5`), not literal blue/green. A minimal, restrained,
   monochrome direction — the opposite of Maven's vivid saturated palette.
3. **Attempted cherry-pick of `cfc7081` onto fresh `origin/master` conflicted**
   in `app/globals.css` (expected — totally different file structure now).
   Aborted cleanly, no damage.
4. **This repo has heavy concurrent multi-workstream activity right now** —
   `git worktree list` showed 10+ active worktrees across
   `mission-control/backup/temp-time-load-doc/` and `/mnt/d/forge/worktrees/`:
   bpmp-create-ui-theme, security-hardening (×2), planner-fix,
   restore-expiry-runtime, export-dynamic-prod, pharmacy-user-management-rbac,
   pharmacy-admin-api-auth-gate, etc. — this branch's theme work is a small,
   now-outdated piece of a much larger, actively-moving effort, not an
   isolated feature branch.
5. Separately (same session): `pharmacy-expiry-system` issue #2
   ("SECURITY INCIDENT: rotate leaked credentials...", open since 2026-08-28,
   still blocked on Supabase re-authorization) explicitly says "prohibit
   feature implementation until all proof gates pass" — and PR #41 bundles
   the Maven theme commit together with the same phase0 commits that issue
   gates. Flagged to พี่เอก; not resolved this session.

## Decision (2026-09-22)

พี่เอก chose to **pause** the Maven theme work rather than (a) reapply the Maven
accent colors on top of the current BPMP base, or (b) discard it outright in
favor of BPMP. **PR #41 was left open, untouched, as-is** — not closed, not
edited further this session.

## How to apply

- Before touching `pharmacy-expiry-system` theme/UI work again: check whether
  master has moved further, and check `git worktree list` for what else is
  active — this repo moves fast and has many parallel agents/sessions on it.
- If Maven work resumes: re-derive the patch against master's *current*
  `app/globals.css` (BPMP `--bpmp-*` tokens), don't try to reuse `cfc7081`
  as-is — it targets a design system that no longer exists on master.
- See also [[2026-09-19_hr-arigeo-com-theme-audit-resolved]] and
  [[2026-09-19_cms-arigeo-builder-v2-palette-unify]] for the general pattern
  of "verify branch/PR state fresh before trusting an in-session assumption."
