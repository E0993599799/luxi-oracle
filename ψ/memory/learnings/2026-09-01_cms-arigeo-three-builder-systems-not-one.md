---
name: cms-arigeo-three-builder-systems-not-one
description: cms-arigeo main has THREE parallel builder systems live (V1 legacy, undocumented src/builder, and src/builder-v2/Puck), not one canonical stack as the 2026-08-28 vision doc assumed. builder-v2 confirmed canonical 2026-09-01. Prior BUILDER-V2-GATE-REPORT.md is stale/unverifiable.
metadata:
  type: project
  ttl: 3mo
---

**Supersedes the "ONLY canonical page-builder stack" premise** in
[[cms-arigeo-visual-website-os-vision]] — that was the target/locked *decision*, verified against
source on 2026-08-28. This entry (2026-09-01, fresh `gh repo clone`, direct `npm ci`/`tsc`/`jest`/
`next build` execution against HEAD `6fcf67e0364b0af68d36ea41e17e589d425e2686`) found the decision
had not actually been fully executed on `main`: **three parallel builder implementations were
still live**, not one.

## What's actually there (as of `6fcf67e`)

- **V1 (frozen legacy)** — `/dashboard/page-builder/builder` + `/dashboard/builder-studio`, ~5
  files, no commits in 32+ days, explicitly documented as intentionally frozen in
  `BUILDER_V2/07-migration-gate.md`.
- **`src/builder/*`** ("Builder-first Architecture") — `/dashboard/builder` route, **47 files**, a
  full separate hand-built stack (own document/schema/registry/renderer/inspector/history/
  mutations), **last commit 2 days before HEAD**, and **not mentioned anywhere** in any
  `BUILDER_V2/*.md` doc or `BUILDER-V2-GATE-REPORT.md`. This was a genuine blind spot in the
  2026-08-28 spec — it was read as "just permissions get reused from V1," not recognized as an
  actively-developed parallel editor.
- **`src/builder-v2/*`** (Puck, `@measured/puck`) — 135 files, the documented/GATE-REPORT'd system.

One real coupling point exists between the two active systems:
`src/builder/mutations/journal.test.ts` is included in builder-v2's own `test:live-inspector`
script.

## `BUILDER-V2-GATE-REPORT.md` (2026-07-28, "10/10 gates passing, production ready") is not usable as evidence

- Cites no commit SHA anywhere.
- Signed off by "Zeus (Root Orchestrator)" — see [[zeus-oracle-retired]], confirmed gone by
  พี่เอก independently of this finding.
- Its own same-day sibling doc (`BUILDER_V2/07-migration-gate.md`) admits 3 of the 10 gates
  needed "deployed environment + manual verification" not yet done when the headline was written.
- 589 commits stale vs. `6fcf67e`; post-report commits include multiple `fix(auth)` patches —
  direct evidence the system wasn't actually stable when "production ready" was claimed.

## What IS independently verified as of `6fcf67e` (I ran these myself, not cited from docs)

- `npm ci` succeeds (flaky/slow — stalled twice before a third attempt with longer timeouts
  completed; not a hard blocker, just needs patience/retry budget).
- `tsc -p tsconfig.typecheck.json --noEmit` **fails**: 7 errors across 3 files, including a real
  type incompatibility between `src/builder`'s `PageDocument`/`BuilderBlock` and
  `LegacyPageInput`/`LegacyBlockInput` — concrete proof the two systems have diverged at the type
  level, not just by directory convention.
- `npm run test:live-inspector` (7 suites covering builder-v2's inspector bridge/patch/publish-
  guard/persistence/canonical-adapter + builder's journal): **24/24 tests pass.**
- `npm run gate:live-inspector` and `npm run gate:dashboard-real-routes` (the custom scripts
  `BUILDER-V2-GATE-REPORT.md`'s claims were likely based on): **both pass fresh, current HEAD.**
- `npm run test:critical` (collections/migrations/auth): 156/157 pass — the one failure is a
  pre-existing test-assertion bug in `api-authentication.test.ts`, unrelated to the builder.
- A from-scratch, DB-less production build (`PAYLOAD_SKIP_DB_CHECK=true npx next build`, matching
  what the repo's own CI does) **succeeds** — and its route manifest is the hard evidence for the
  three-systems finding above (all routes for all three compile as live routes, plus two parallel
  public renderers, `/pages/[slug]` and `/pages/[slug]/v2`).
- Full browser/E2E proof (click through insert→select→inspect→save→reload→publish) was **not**
  obtainable — no live Postgres in the auditing sandbox. Honestly marked unverified, not assumed.

## Decision, 2026-09-01

**builder-v2 (Puck-based) confirmed canonical going forward**, direct question to พี่เอก in-session.
`src/builder/*` left untouched pending a separate archive/investigate decision — not deleted, not
built on further. `@measured/puck` is deprecated upstream in favor of `@puckeditor/core@0.23.0` —
flagged as a real migration item, not a false alarm (`npm view @measured/puck deprecated` confirms).

Full detail: PR https://github.com/E0993599799/cms-arigeo/pull/51
(`docs/builder/CURRENT_BUILDER_TRUTH.md`, `docs/builder/PAGE-BUILDER-ARCHITECTURE.md`).

## How to apply

- Don't cite `BUILDER-V2-GATE-REPORT.md` as current-state evidence for anything — treat it as
  historical only, per this finding.
- When scoping any future cms-arigeo builder work, confirm `src/builder/*`'s fate has been decided
  (archived or not) before assuming builder-v2 is the *only* thing touching page rendering —
  it wasn't, as of this audit.
- A markdown report claiming "production ready" is not proof — this session's method (clone fresh,
  run the actual commands, read the actual exit codes past pipe/tee gotchas that silently swallow
  them) is the pattern to repeat for any future cms-arigeo builder audit.
