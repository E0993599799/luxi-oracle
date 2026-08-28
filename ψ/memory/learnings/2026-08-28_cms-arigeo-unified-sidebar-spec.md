---
name: cms-arigeo-unified-sidebar-spec
description: Canonical, complete v1.0 spec for cms.arigeo.com unified sidebar, committed to the repo itself (not just pasted). Registry-driven, not a hard-coded nav array. Known build blocker affects 11 files, not 1.
metadata:
  type: project
  ttl: 3mo
---

**Supersedes the earlier version of this memory**, which was reconstructed from corrupted paste
fragments and got the core mechanism wrong (guessed a hard-coded `CMS_NAVIGATION` array). The real
spec is the opposite: extend the *existing* registry, never replace it.

**Source of truth**: `docs/superpowers/specs/2026-08-28-unified-cms-sidebar-full-wiring.md`,
committed directly to the `cms-arigeo` repo at `dbd9cef66b66be4340705d21a4eadef727ede026` on branch
`feat/issue-32-unified-navigation`. Read via `git show dbd9cef:.../....md` — full 21 sections, no gaps
(the earlier pasted versions were missing §3-12/§17-20). Status: "implementation contract" for Issue #32.
See also [[cms-arigeo-visual-website-os-vision]].

## The corrected mechanism (§2-4) — this is the part that changed

`src/admin/routes/registry.ts` + `src/admin/routes/types.ts` + `src/admin/navigation.config.ts` are the
**existing canonical route source** (`DASHBOARD_ROUTES`, `getVisibleDashboardRoutes(context)` — already
handles readiness/provider-gating). The spec does **not** replace this with a new hard-coded nav array.
Instead: add a grouping layer on top —
```ts
export type NavGroupId = 'workspace' | 'content' | 'design' | 'admin'
export interface NavGroup { id: NavGroupId; label: string; routeIds: DashboardRouteId[] }
export const ADMIN_NAV_GROUPS: NavGroup[] = [...]
```
`getAdminNavGroups(context)` = call `getVisibleDashboardRoutes(context)` → filter each group to visible
routes → drop empty groups → map to presentation items → never duplicate a route id across groups.
This preserves existing provider-gate/readiness/permission logic in one place instead of forking it.

## Same hard rules as before (still true)
One sidebar owner (dashboard CMS shell), one brand header, one search, one Dashboard/Preview action,
one active-route system, one responsive drawer. No Builder-owned application sidebar, no duplicate
Payload nav rendered in parallel, no dead/placeholder/coming-soon routes. Fixing the double-sidebar with
CSS `display:none` alone is explicitly forbidden (§10, §20) — must remove nav *responsibility* from
Builder's layout code (`src/app/dashboard/builder-v2/layout.tsx` must not render its own `<aside>` or
`BuilderV2Nav.tsx`), not just hide it visually.

## §21 Definition of Done (this is the checklist to hold any PR against)
One application sidebar across dashboard + Builder routes. One nav/search system owns all destinations.
Route visibility stays registry/provider-driven. Builder V2 no longer owns a nav rail. Payload stays
canonical collection backend. All visible routes real/wired. Strict production build passes. Production
deploy verified with fresh visual proof (desktop + mobile screenshots, one nav system).

## Known build blocker (§18) — I verified it's WORSE than the spec states

Spec names one file: `src/app/dashboard/analytics/page.tsx` uses `PagePlaceholder`, whose inferred
component return type is `void`, failing the strict Next.js production build. **I checked the branch tip
(`origin/feat/issue-32-unified-navigation`) directly and confirmed this is still unfixed as of 2026-08-28,
AND it's not just analytics** — `PagePlaceholder` (`src/app/dashboard/PagePlaceholder.tsx`, which just
calls `redirect('/dashboard/overview')` as a bare statement, no `return`) is used by **11 page files**:
`analytics/page.tsx`, `analytics/reports/page.tsx`, `api/page.tsx`, `code/page.tsx`, `data/forms/page.tsx`,
`data/media/page.tsx`, `domains/page.tsx`, `logs/page.tsx`, `marketing/page.tsx`, `security/page.tsx`,
`workflows/page.tsx`. Every one of these will hit the same strict-build failure, not just analytics.
This is almost certainly why all 3 substantive commits on `feat/issue-32-unified-navigation`
(`cb43064`/`974b554`/`0efbac3`) produced Vercel build ERROR before the spec doc was even added.

## How to apply
- Before touching sidebar/nav code, check whether `getAdminNavGroups()` / `ADMIN_NAV_GROUPS` already
  exist on the branch (§15 file-level contract lists exactly what to modify) — don't re-propose the
  hard-coded-array approach again, it was explicitly rejected.
- The `PagePlaceholder` void-return issue blocks the build for 11 routes, not 1 — fixing just
  `analytics/page.tsx` per the spec's literal wording will not get a green build; all 11 need the same fix
  (or fix `PagePlaceholder` itself once, since it's the shared root cause).
- §17 lists 6 required test files (`unified-cms-navigation.test.mjs`,
  `builder-v2-single-sidebar.test.mjs`, `navigation-route-health.test.mjs`,
  `navigation-active-match.test.mjs`, `admin-search-index.test.mjs`, `no-production-placeholder.test.mjs`)
  — none existed as of 2026-08-28's check.
