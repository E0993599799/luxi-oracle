---
pattern: A cloud routine's prompt telling the agent to use a script/repo does not make that repo available — verify it's in the routine's `sources` array explicitly, every time
date: 2026-09-03
source: rrr: luxi-oracle
concepts: [cloud-routines, RemoteTrigger, verification, CI-triage, secrets-boundary]
---

# Cloud routine sources must match prompt dependencies — verify, don't infer

When authoring a `RemoteTrigger` routine whose prompt instructs the cloud agent to run a script
living in some repo (e.g. `node scripts/line-push.mjs` from a `control_fleet` checkout), the repo
must be explicitly listed in `job_config.ccr.session_context.sources`. Writing the instruction in
the prompt text does not create the checkout — I did this wrong once (2026-09-03, cms-arigeo
secret-rotation-check routine): wrote a prompt that assumed a `control_fleet` checkout existed,
without adding it to `sources`, in the same turn where I had just explained local-vs-cloud repo
access constraints to the user. Caught it two messages later by checking `git remote -v` on the
missing repo before considering the task done.

## How to apply (generalizable, any project)

- After writing a cloud-routine prompt that names a file path, script, or repo the agent needs,
  cross-check the literal `sources` array against every repo/path mentioned in the prompt —
  don't trust that having *discussed* the dependency means it's wired up.
- Same discipline applies to two related but separate patterns worth keeping in mind together:
  (1) before blaming a PR for a red CI check, diff its failure against the base branch's own
  recent CI history — pre-existing breakage fails identically regardless of the PR's diff; (2)
  when a resource-management API has no documented field for injecting secrets, treat that as a
  deliberate boundary (secrets belong in a dedicated settings UI) rather than routing the secret
  value through some other reachable channel just because it's technically possible.
