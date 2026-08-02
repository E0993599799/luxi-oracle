# Oracle Session Metrics

Rule (parent CLAUDE.md §"Self-Evaluation Loop"): same friction 3 sessions → fix root cause, not another workaround.

| when | session | done | stuck | win | friction | error |
|---|---|---|---|---|---|---|
| 2026-07-21 00:25 | 8da80e12 | fixed cms-arigeo admin duplicate logo (custom.scss never imported), wired ArigeoIcon graphic, fixed icon height collapse, fixed icon aspect-ratio distortion via object-fit:contain — 3 commits pushed to cms-arigeo main | re-generating importMap.js via real payload CLI (no prod secrets in sandbox) | root-caused a 3-fix regression chain down to one dead-import bug, shipped and confirmed live | both local clones (cms-arigeo, arigeo-project) were stale vs. deployed, had to pull mid-diagnosis | assumed 'web arigeo' meant the marketing site, spent ~25min screenshotting wrong app before asking for URL |
| 2026-07-27 22:18 | 44073121 | LatestCarousel, FeatureDuo, NewsRelease components | n/a | Shipped 3 Kao-parity components + bilingual data | Path confusion (assumed Windows limitation), screenshot delay, skipped config file lookup | Over-cautious about env constraints, assumed limitation instead of testing |
| 2026-07-28 04:23 | a01b3a54 | Fixed useLocale() runtime error, set up next-intl middleware/config/i18n, redeployed to production | n/a | Diagnosed client-side error in 1 min, implemented full i18n setup, deployed live (READY) | 3 deployment cycles needed (prerender issue → missing provider → fixed), client-side errors harder to debug than build errors | Should have verified hook dependencies + providers during initial component review, not just at deploy time |
| 2026-07-29 13:25 | a01b3a54 | LINE client verification (test message sent), HARD-RULE 5 committed, LINE bridge corrected plan (use durable queue) | Option B queue system decision pending | Caught infrastructure duplication pattern — user prevented webhook duplicate, saved learning to prevent recurrence | Assumption pattern (LINE existed, webhook existed), ephemeral storage architecture gap | Violated Rule 5 twice same day: assumed LINE config existed, then assumed webhook didn't exist. Caught by user both times, learned pattern |
| 2026-08-01 06:38 | 868e50c | Phase 1-3 live, Phase 4.F/A/E shipped | Phase 4.B-D deferred | Hero Showreel + CMS admin live | token budget invisible mid-work, integration blocker, scope creep accepted | overcommitted on scope (92% budget) |
| 2026-08-02 16:27 | ec727fd8 | smooth header menu animations (cubic-bezier 280ms), enlarged footer icons (56px, 8px radius), Vercel deployed | hero section copy broken (missing translations, deferred) | discovered critical hero blocker + converted best practices audit | git safety check skipped before push (forced rebase), no broadcast event for repo switch | assumed "git status up to date" = safe to push; skipped pre-flight fetch check |

## 🔁 Recurring Pattern Detected

**"Assumption-driven decisions without verification"** appeared in **4 of last 6 sessions** (error column: 2026-07-21, 2026-07-27, 2026-07-29, 2026-08-02):
- 2026-07-21: assumed 'web arigeo' meant wrong site
- 2026-07-27: assumed Windows limitation (didn't test)
- 2026-07-29: assumed LINE config + webhook existed/didn't exist
- 2026-08-02: assumed git status "up to date" = safe to push

**Pattern**: Skipping verification steps before major actions. I read protocols/docs, understand them, then fail to verify assumptions during execution.

**Per CLAUDE.md §"Self-Evaluation Loop"** — reached **≥3 threshold**. Suggests root cause: **habit loop prioritizing speed over verification**.

**Suggested action**: Establish pre-action checklist ritual (git-fetch, test-before-assume, ask-before-deciding-wrong-app). Consider raising with Boss during standup—this is a decision pattern, not a tool failure.

**Escalation**: Decision-error pattern (not operational friction). Flag for team discussion.
| 2026-08-03 02:22 | c2e0ce4d | Phase 1 complete (6/6), Phase 2 complete (6/6), 9 commits deployed | khun-ram Thai translations (expected, not blocking) | ARIGEO 7.1→9.2/10 production ready, dark mode + language switcher shipped | Vercel build loops (30-45s/cycle) | i18n architecture mismatch (server/client) | partial Thai deployment confused status | Integrated 2/6 Thai translations mid-session instead of all-or-nothing approach |
