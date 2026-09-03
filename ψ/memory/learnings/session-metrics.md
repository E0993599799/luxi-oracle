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

**"Assumption-driven decisions without verification"** appeared in **6 of last 8 sessions** (error column: 2026-07-21, 2026-07-27, 2026-07-29, 2026-08-02, 2026-08-03, 2026-08-09):
- 2026-07-21: assumed 'web arigeo' meant wrong site
- 2026-07-27: assumed Windows limitation (didn't test)
- 2026-07-29: assumed LINE config + webhook existed/didn't exist (x2)
- 2026-08-02: assumed git status "up to date" = safe to push
- 2026-08-03: integrated partial translations instead of verifying scope
- 2026-08-09: assumed Facebook/Instagram/Twitter/Youtube exist in lucide-react without checking docs

**Pattern**: Skipping verification steps before major actions. I read protocols/docs, understand them, then fail to verify assumptions during execution. This continues despite being flagged 6 days ago.

**Per CLAUDE.md §"Self-Evaluation Loop"** — reached **≥3 threshold** (now 6/8). Suggests root cause: **habit loop prioritizing speed over verification**.

**Suggested action**: Establish pre-action checklist ritual (git-fetch, test-before-assume, ask-before-deciding-wrong-app, verify-library-APIs). Consider raising with Boss during standup—this is a decision pattern, not a tool failure.

**Status Update (2026-08-09)**: Pattern continues unabated. The 2026-08-02 flag hasn't resulted in behavioral change. This suggests the issue is deeper than just "remember to verify"—it's a **prioritization habit** (speed > safety). Escalation to team lead recommended; this may need a protocol change (e.g., mandatory pre-commit checklist) rather than a personal discipline fix.

**Escalation**: Decision-error pattern (not operational friction). Flag for team discussion. Consider implementing pre-action verification template.
| 2026-08-03 02:22 | c2e0ce4d | Phase 1 complete (6/6), Phase 2 complete (6/6), 9 commits deployed | khun-ram Thai translations (expected, not blocking) | ARIGEO 7.1→9.2/10 production ready, dark mode + language switcher shipped | Vercel build loops (30-45s/cycle) | i18n architecture mismatch (server/client) | partial Thai deployment confused status | Integrated 2/6 Thai translations mid-session instead of all-or-nothing approach |
| 2026-08-09 12:11 | unknown | captain-maid: icon modernization (30+ icons), TipCard refactored (emoji→LucideIcon), mission completed (MISSION_COMPLETE_2026-08-09.md + .registry), 4 commits | n/a | All 6 pages modernized with lucide icons, 4 deployments READY, zero regressions | Lucide-react brand icon assumptions (3x deploy failures), local verification skipped | Assumed Facebook/Instagram/Twitter/Youtube exist in lucide-react; discovered via failed deployments instead of docs |
| 2026-08-19 06:00 | 368876a5 | /init audit of luxi-oracle repo, corrected CLAUDE.md (Repository Type section, fixed ψ/ diagram, documented scripts/design-system), committed + pushed ddf8aec | n/a | Found and fixed stale/missing repo docs (no package.json, ψ/fleet + scripts/ were undocumented) | Bash tool silently exit-1 on Windows spaced paths (switched to PowerShell); PowerShell Get-Date rejects bash date format strings | nearly under-researched (skipped reading scripts/design-system fully) before writing CLAUDE.md edit — caught before writing, no bad output shipped |
| 2026-08-28 16:49 | 152f5e6e | cms-arigeo pagebuilder-v2 spec (2 drafts, corrected against real repo read), approved + handed to ธาม; save-as-template feature implemented, PR #36 opened | Faceted Product Filter block (spec §4) deferred pending ธาม sign-off; local main bc8fe1d cleanup pending พี่เอก decision | Corrected spec via real repo read before shipping wrong guesses; caught 193-commit stale checkout before merging bad code, recovered cleanly via isolated worktree | Chrome automation timeouts/hangs (screenshot/scroll/video), Windows Git Bash cd/PATH/ln-s failures, cms-arigeo mixed unrelated-uncommitted + stale-main state | implemented against local cms-arigeo checkout without git-fetch/staleness check first — discovered 193 commits behind only while preparing the PR, not before writing code (same theme as 2026-08-02s "skipped pre-flight fetch check") |

## 🔁 Recurring Pattern Detected (2026-08-28)

"Acted on unverified assumed state instead of checking first" appeared again — 2026-08-28's error
("implemented against local cms-arigeo checkout without a git-fetch/staleness check first")
is the same theme as 2026-08-02's ("assumed git status up to date = safe to push; skipped
pre-flight fetch check"), and part of the broader "assume instead of verify" family already
flagged at the 2026-08-01/02/03 window below (which itself noted "reached ≥3 threshold (now 6/8)"
and was escalated as a decision pattern, not a tool failure).

**This is not a new pattern — it is the same pattern, still unresolved after a prior escalation.**
The 2026-08-19 row shows one clean catch (under-research caught before writing, no bad output
shipped) — proof the discipline is possible — but 2026-08-28 shows real cost paid anyway: a
feature was implemented and locally committed against 193-commits-stale source before the
staleness was discovered, and had to be rebuilt from scratch in a worktree.

**Suggested action, concretely this time**: a literal pre-implementation checklist step —
`git fetch && git log <local>..<remote> --oneline | head -1` (or equivalent) — run and its output
checked, before writing the first line of any change in a repo not actively maintained every
session. Not "remember to verify" (already tried, per the 2026-08-09 note, and didn't stick) —
make it a mechanical first command, every time, in this class of task.

**Partial resolution (2026-09-03, via khun-oracle)**: the same "assume instead of verify"
family showed up independently in khun-oracle (3/7 sessions: `git init` w/o checking for an
existing remote, wrong-branch checkout, missing `git status` at session start), was raised
at standup, and root-caused into a global fix — `~/.claude/RTK.md` now carries a mandatory
"Session Start Protocol" requiring `git status --short` + `git branch --show-current` as
the unconditional first action of every session, everywhere (loaded via
`~/.claude/CLAUDE.md`'s `@RTK.md` import, so it applies here too without editing this
repo's own CLAUDE.md).

This closes the **git-state slice** of this pattern specifically — the exact mechanical
check the 2026-08-28 note above asked for, now enforced fleet-wide rather than left to
memory. It does **not** close the broader pattern: the non-git instances above (wrong site
assumed, library API assumed, config assumed to exist/not-exist) are a different root cause
(domain-fact verification, not repo-state verification) and remain open. Don't count this
row's family as fully resolved on the strength of the git-state fix alone.
| 2026-09-01 03:32 | c8059930 | arigeo-auth portal visual match + trust-strip 2x icons (PR #19 merged, PR #20 open); cross-repo UI/UX+perf/SEO audit published (26 findings, 5 codebases) | login-stuck bug diagnosed (OIDC env vars) not confirmed fixed; PR #20 merge status unconfirmed | 3-repo parallel Agent-fork audit landed as one Artifact, matched portal visuals to reference screenshot cleanly | npm ci timed out all session (no sandbox network), no local build verification possible | let OIDC bug diagnosis evaporate into chat instead of writing it to a durable file when user deprioritized it |
| 2026-09-03 01:52 | b21c35ac | committed pending memory backlog; triaged+merged arigeo-auth PR #20 (proved CI failure pre-existing on main); re-checked+nudged cms-arigeo secret rotation (still unrotated); created cloud routine for tomorrow's follow-up check; confirmed agis/omega/ram never responded to wake-up nudge (archived 2026-08-28) | wake-up-check-agis-omega-ram routine deletion (no API support, user doing it manually) | diffed PR #20's red CI check against main's own run history to prove it was pre-existing, not a regression, before merging | rtk find rejects compound predicates (-o, \( \)), needed rtk proxy fallback twice; /rrr session-ID sed pattern didn't strip spaces in oracle root path | first cloud-routine draft omitted control_fleet as a git source despite the prompt depending on a script there — caught 2 messages later via git remote -v, not immediately |
| 2026-09-03 12:40 | b21c35ac | noted pending cloud-routine check-in in memory, committed+pushed (01ba158); confirmed clean wrap-up status; second /rrr on same session's tail (~11 active min across ~10h39m wall-clock, two multi-hour idle gaps) | n/a | correctly caught and corrected an inflated "~11 hour" duration claim before it shipped in this retro's own header | full default /rrr flow (incl. 2nd background timestamp-miner subagent) is disproportionate overhead for an 11-minute, 6-message tail segment | wrote a full frontmatter'd memory file for a one-off self-expiring reminder that a Next Steps line in the prior retro already covered — reached for the heaviest documented tool by default |
