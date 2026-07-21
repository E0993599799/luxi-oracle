# Oracle Session Metrics

Rule (parent CLAUDE.md §"Self-Evaluation Loop"): same friction 3 sessions → fix root cause, not another workaround.

| when | session | done | stuck | win | friction | error |
|---|---|---|---|---|---|---|
| 2026-07-21 00:25 | 8da80e12 | fixed cms-arigeo admin duplicate logo (custom.scss never imported), wired ArigeoIcon graphic, fixed icon height collapse, fixed icon aspect-ratio distortion via object-fit:contain — 3 commits pushed to cms-arigeo main | re-generating importMap.js via real payload CLI (no prod secrets in sandbox) | root-caused a 3-fix regression chain down to one dead-import bug, shipped and confirmed live | both local clones (cms-arigeo, arigeo-project) were stale vs. deployed, had to pull mid-diagnosis | assumed 'web arigeo' meant the marketing site, spent ~25min screenshotting wrong app before asking for URL |
