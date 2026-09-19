# Luxi Oracle Memories

> **Index of all persistent memories** — fast lookup, one-line hooks. < 200 lines.

**Last Updated**: 2026-09-19 · **Total Entries**: 24 · **Index Size**: ~600 tokens

---

## System & Process Documentation
- [Memory consolidation rules](MEMORY-RULES.md) — Systematic rules for what to save where, when, TTL (∞)
- [Worktree isolation protocol](learnings/worktree-isolation-protocol.md) — Git worktree workflow for large changes (∞)

## Project
- [Zeus Oracle retired](learnings/2026-08-28_zeus-oracle-retired.md) — Zeus no longer exists; don't escalate to Zeus or expect responses (project | ∞)
- [cms-arigeo = Visual Website OS](learnings/2026-08-28_cms-arigeo-visual-website-os-vision.md) — Payload=data, Builder V2/Puck=canonical page layer, Inspector=live identity editing (project | 3mo)
- [cms-arigeo unified sidebar spec](learnings/2026-08-28_cms-arigeo-unified-sidebar-spec.md) — registry-driven (not hard-coded nav), PagePlaceholder void-return breaks 11 routes not 1 (project | 3mo)
- [cms-arigeo: 3 builder systems, not 1](learnings/2026-09-01_cms-arigeo-three-builder-systems-not-one.md) — GATE-REPORT unverifiable/stale; builder-v2 confirmed canonical 2026-09-01, src/builder's fate still open (project | 3mo)

- [arigeo-auth main Verify broken](learnings/2026-09-03_arigeo-auth-main-verify-broken.md) — stale ui-admin.test.tsx/copy mismatch fails Verify on main since 2026-08-31; don't blame unrelated PRs for it (project | 1mo)

- [Cloud routine sources must match prompt deps](learnings/2026-09-03_cloud-routine-sources-must-match-prompt-deps.md) — a routine's prompt naming a script doesn't add its repo to `sources`; verify explicitly (∞)

- [cms-arigeo secrets still unrotated, 63 days](learnings/2026-09-18_cms-arigeo-secrets-still-unrotated-63-days.md) — one-shot routine's follow-up expired 2 weeks ago; re-verified live, still unrotated, fresh LINE nudge sent (project | 30d)
- [cms-arigeo logo/theme fix — MERGED & LIVE](learnings/2026-09-19_cms-arigeo-logo-theme-audit.md) — PR #124 fixed white-on-white sidebar logo + admin-preview colors, live on cms.arigeo.com (project | 3mo)
- [cms-arigeo builder-v2 palette unify — PR #126 draft](learnings/2026-09-19_cms-arigeo-builder-v2-palette-unify.md) — mechanical HSL remap of 129 colors onto shared tokens, gets dark mode free, not yet visually verified (project | 3mo)
- [cms-arigeo deploy workflow timeout lesson](learnings/2026-09-19-cms-arigeo-deploy-timeout-lesson.md) — vercel-prebuilt-deploy.yml's 15min job timeout is too tight; "cancelled" ≠ deploy failed, always verify via Vercel API (reference | ∞)
- [cms-arigeo dashboard frame fix — MERGED & LIVE](learnings/2026-09-19_cms-arigeo-dashboard-frame-fix.md) — PR #127, stale dashboard-layout.scss overriding dark-mode tokens since PR #121, found via live browser inspection; 3rd legacy admin shell flagged (project | 3mo)
- [arigeo-hr module icons — MERGED & LIVE](learnings/2026-09-19_arigeo-hr-module-icons.md) — PR #79, 9-icon flat full-color SVG set hand-authored from reference PNG + spring-easing hover motion (project | 3mo)
- [cms-arigeo theme switcher + input unify — PR #128 draft](learnings/2026-09-19_cms-arigeo-theme-switcher-and-input-unify.md) — dashboard theme toggle + shadcn Input/password-input DRY pass; only compiled-token proxy verified, needs live confirmation before merge (project | 3mo)
- [Stale duplicate CSS rule wins the cascade](learnings/2026-09-19_stale-duplicate-css-rule-wins-cascade.md) — computed style disagreeing with correct custom properties means check document.styleSheets for a second later-loaded rule, not that the token system is broken (reference | ∞)
- ["Cancelled" CI job ≠ proof the remote op failed](learnings/2026-09-19_deploy-cancelled-not-proof-of-failure.md) — orchestrator timeout/cancelled only means the watcher died; verify the remote system's own API state before retrying (reference | ∞)

- [Size memory artifact to what it tracks](learnings/2026-09-03_size-memory-artifact-to-what-it-tracks.md) — don't reach for a full frontmatter'd file when a Next Steps line already covers a one-off reminder (∞)

- [hr.arigeo.com theme audit — RESOLVED](learnings/2026-09-19_hr-arigeo-com-theme-audit-resolved.md) — brand color (PR #75) + dashboard type scale (workspace-type-scale.css) both live in production; only spacing-base decision (4px vs 8px) still open (project | 3mo)
- [coachhcm.com payroll UI/UX teardown](../writing/2026-09-14_coachhcm-payroll-uiux-research.md) — reference material feeding the hr.arigeo.com audit above; restraint/contrast/type findings, not independently actionable (reference | 3mo)
- [auth.arigeo.com theme reconciliation — PR #71 open](learnings/2026-09-19_auth-arigeo-com-pr71-theme-work.md) — shadcn rename + alert recipe + full dark mode; not yet verified live, hero-tile skipped (project | 3mo)

## Reference
- [shadcnblocks-admin dropdown+theme patterns](learnings/2026-09-13_shadcnblocks-admin-dropdown-theme-patterns.md) — shadcn kit patterns for cms-arigeo reuse; PLUS: cms.arigeo.com's real admin is stock Payload theme, zero brand-color bleed, toggle unreachable w/o login (reference | ∞)
- [cms-arigeo orphaned Payload admin theme](learnings/2026-09-14_cms-arigeo-orphaned-payload-admin-theme.md) — 3 unrelated theme systems stacked + a dead 4th (Control Fleet override, reverted 2026-08-02, never cleaned up) (project | 3mo)
- [cms-arigeo dashboard shadcn theme unify](learnings/2026-09-16_cms-arigeo-dashboard-shadcn-theme-unify.md) — RESOLVED: retried after revert, gated on real preview + SSO click-through this time, merged beff915d; also cms-arigeo's Vercel git-deploy is disabled, use vercel-prebuilt-build/-deploy workflow_dispatch (feedback | 3mo)

## Debugging & Process Lessons
- [Ask for URL before exhaustive search](learnings/2026-07-21_ask-for-url-before-exhaustive-search.md) — Don't guess which app a bug report means; verify local-vs-deployed before diagnosing (∞)
- [Print/PDF pagination rules](learnings/2026-09-14_print-pdf-pagination-rules.md) — no orphaned headings (natural flow, not forced page-per-heading), tables split with repeating `<thead>`, figures capped under full-page height; use `mupdf` not `pdfjs+canvas` for PDF QA (∞)
- [Session-start check applies per-repo](learnings/2026-09-14_session-start-check-applies-per-repo.md) — re-run `git status`/`branch` on every repo touched, not just the one checked at session start; satisfying it once ≠ covering the session (∞)
- [Verification-pattern hook installed](learnings/2026-08-18_verification-pattern-hook-installed.md) — Global PreToolUse hook blocks unverified icon/library imports; needs `/hooks` reload to activate (∞)

---

**How to Use**:
1. Scan description for relevance
2. Load if <7 days old OR explicitly referenced
3. Archive expired memories to `memory/archive/YYYY-MM/` after 14 days

**Add New Memory**: Read `MEMORY-RULES.md` first. Save with frontmatter (name, description, type, ttl). Add pointer here.

---

**Related Locations**:
- Cache (L1): `~/.claude/projects/<project>/cache.json`
- Vault (persistent): `ψ/memory/{learnings,retrospectives,reference}/`
- Inbox (ephemeral): `ψ/inbox/{handoff,escalation}/` — expires 14d
