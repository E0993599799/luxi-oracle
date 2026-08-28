---
date: 2026-08-28
type: escalation-record
status: sent
---

# Escalation: mission-control#286 routed to ธาม via LINE

## What happened

พี่เอก pasted https://github.com/E0993599799/mission-control/issues/286 mid-session
during a `/recap` in `luxi-oracle`. Pulled the issue and confirmed the referenced plan/spec
files exist in the `mission-control` repo:
- Plan: `docs/superpowers/plans/2026-08-28-man-os-maw-m1-truth-plane.md`
- Spec: `docs/superpowers/specs/2026-08-28-man-os-maw-gap-adoption-design.md`

Issue title: "[HERMES][SDD] MAN-OS MAW M1 Truth Plane — execute Tasks 1-7"

Scope: subagent-driven execution of a backend/infra plan — Forge event core, deterministic
payload digesting, JSONL store, projections, replay/integrity, Hermes Local proof/event
adapter, Mission Worker lifecycle/heartbeat/writeback, E2E replay proof. Explicit contract:
isolated worktree, fresh worker per task, per-task test+review gates, preserve Forge
invariants (THAM/MAN-OS authorizes, Hermes executor-only, monotonic lease_epoch, no
completion from executor text/exit code, proof-bound completion only), no merge to main
without sign-off.

## Why escalated instead of executed

This is entirely outside Luxi Junior's identity/scope — UI/UX design, React/Next.js,
Tailwind, accessibility. No runtime code in `luxi-oracle` to build against either. This is
squarely an orchestration/backend-infra execution task, i.e. ธาม's lane.

## Action taken

Per standing order (2026-08-28, see luxi-oracle CLAUDE.md "Standing Orders"), escalations
that would previously have been a `ψ/inbox/*_luxi-to-tham_*.md` handoff now go to พี่เอก
directly via LINE instead of an inbox file. Sent:

> [agent: luxi-oracle] GitHub issue mission-control#286 (MAN-OS MAW M1 Truth Plane,
> Hermes/Forge execution, Tasks 1-7) is backend/infra, outside Luxi's UI/UX scope. Routing
> to ธาม for execution — please assign.

LINE push confirmed `ok: true`, status 200, message id `629308064469877094`.

## Next step

Awaiting พี่เอก to assign issue #286 to ธาม (or another execution oracle). No further
action from Luxi on this unless redirected.
