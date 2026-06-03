---
from: tham-node:luxi
to: luxi-junior
timestamp: 2026-05-30T00:22:31.122Z
read: false
---

[tham-node:luxi] # Luxi Brief — Dashboard UI/UX Redesign

From: ธาม (orchestrator) · For: Luxi · Date: 2026-05-28 · Mode: YOLO

## Mission
Redesign the Mission Control dashboard UI/UX to **world-class** level and IMPLEMENT it (not mock).

## Target dashboard
Investigate and pick the ACTIVE one:
- `src/components/dashboard/` (Next.js — most likely active)
- `apps/dashboard/`
- `tham-oracle/dashboard-next/`

Confirm by checking which is referenced by Next.js routes in `src/app/` or `app/`.

## Phases
1. **Scan (10-15 min)** — `ls` candidates, read `mission-control-board.tsx`, `sidebar.tsx`, `nav-rail.tsx`, 2 panels. Read `tailwind.config.*` + `globals.css` for tokens.
2. **Design notes** — save to `DESIGN_NOTES_LUXI_2026-05-28.md` at workspace root. Pick ONE cohesive style (recommended: Modern Dark + Subtle Glassmorphism + Bento). Define color palette (5-7 hex), typography scale, spacing rhythm (4/8/12/16/24/32/48), radius scale, shadow tokens, motion principles.
3. **Implement** — refactor top 4-6 components. Priorities:
   - mission-control-board
   - sidebar / nav-rail
   - 2 key panels (agent-squad, session-details, standup)
   Rules: more whitespace, strong hierarchy, rounded-2xl cards, soft shadows, subtle gradients, glass blur where appropriate, micro-interactions via Tailwind `transition-*`. NO new packages unless absolutely required.
4. **Verify** — `npm run build` or `npx next build`. Fix any TS errors from your changes. If passes, optionally `npm run dev` and describe screenshot.

## Constraints
- Edit existing files, do NOT create lots of new ones.
- No git commits — leave in working tree.
- Backend untouched (except tiny TS prop updates if forced).
- If you can't identify active dashboard, pick `src/components/dashboard/` and go.

## Report back to ธาม via `maw hey local:tham`
1. Directory chosen + why
2. Path to DESIGN_NOTES
3. List of refactored components (paths)
4. Build status (pass / fail + errors)
5. One paragraph: before vs after

## Note
A previous sub-agent run was killed (rule violation: I should only use tmux panes). It may have left partial edits in the working tree — review `git status` and either incorporate or revert as you see fit. You are the canonical owner of this work.
