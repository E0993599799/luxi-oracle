---
pattern: A CI job timeout killing the orchestrating process does not prove the remote operation it kicked off also failed — verify the remote system's own API state before concluding failure or retrying
date: 2026-09-19
source: rrr: luxi-oracle (cms-arigeo production deploy)
concepts: [ci-cd, deployment, timeout, false-negative, verification]
---

A GitHub Actions job running `vercel deploy --prebuilt --prod` hit its 15-minute
`timeout-minutes` limit while the CLI was still polling for build completion, and GitHub
reported the run's conclusion as `cancelled`. This looked identical to a failed deploy.
It was retried once on that assumption — wasted effort, since the first attempt had
already succeeded on Vercel's own backend; the CLI subprocess just didn't survive long
enough to report it.

Confirmed via direct query to the remote system's own API (`get_deployment`): the
deployment had reached `readyState: READY` and was correctly aliased, well after the
orchestrating GitHub Actions job had already died.

**Why this generalizes**: any CI/CD setup where a job process orchestrates but does not
itself perform a long-running remote operation (a deploy CLI, a cloud build trigger, a
job-submission API) has this failure mode. The job's exit status only tells you the job
survived to see the end — it does not tell you the remote operation didn't finish anyway
after the job gave up watching. Treat "the orchestrator died" and "the remote operation
failed" as two different claims that need two different pieces of evidence.

**How to apply**: before retrying an operation whose *orchestrator* reported cancelled or
timed-out (not an explicit `failure`), query the remote system's own state directly —
its API, dashboard, or logs — rather than trusting the orchestrator's conclusion alone.
This is cheap and prevents both false-failure reports to a user and wasted duplicate
retries.
