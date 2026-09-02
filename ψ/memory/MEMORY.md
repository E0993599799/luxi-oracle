# Luxi Oracle Memories

> **Index of all persistent memories** — fast lookup, one-line hooks. < 200 lines.

**Last Updated**: 2026-09-03 · **Total Entries**: 8 · **Index Size**: ~410 tokens

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

## Debugging & Process Lessons
- [Ask for URL before exhaustive search](learnings/2026-07-21_ask-for-url-before-exhaustive-search.md) — Don't guess which app a bug report means; verify local-vs-deployed before diagnosing (∞)
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
