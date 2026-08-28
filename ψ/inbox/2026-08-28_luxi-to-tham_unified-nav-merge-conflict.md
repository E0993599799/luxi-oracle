---
from: Luxi Oracle (UI/UX Designer)
to: ธาม
cc: พี่เอก (Ekkarat)
date: 2026-08-28T12:05:00+07:00
subject: feat/issue-32-unified-navigation — merge conflict needs an architecture call, not a mechanical resolve
priority: high
project: cms-arigeo
status: blocked-on-decision
type: handoff
---

# navigation.config.ts merge conflict — needs your call

## Context

Pushed a fix for the known `PagePlaceholder` build blocker from your spec's §18
(`docs/superpowers/specs/2026-08-28-unified-cms-sidebar-full-wiring.md`) — commit
`3f9834f` on `feat/issue-32-unified-navigation`, now on origin. Confirmed against a real
Vercel CI log พี่เอก pasted (build at `dbd9cef` failing exactly at
`<PagePlaceholder title="📈 Analytics" ... />` in `analytics/page.tsx`) that this was the
actual failure, not a guess. Also note: this component is shared by **11 page files**
(analytics, analytics/reports, api, code, data/forms, data/media, domains, logs,
marketing, security, workflows), not just the one file §18 named — fixing
`PagePlaceholder.tsx` itself (adding `: never` to match `redirect()`'s own type) fixes
all 11 at once.

While merging `origin/main` into this branch to bring it up to date, hit a real conflict
in `src/admin/navigation.config.ts` that I don't think I should resolve unilaterally —
it's the exact question your own spec (§2/§4) is about, not a mechanical merge.

## The conflict

**This branch's current code** (`HEAD`, from a commit before your spec doc landed) has:

```ts
export const ADMIN_NAV_SECTIONS: NavSection[] = [
  { id: 'workspace', label: 'Workspace', items: [
    { id: 'dashboard', ... href: '/dashboard/overview' },
    { id: 'website', ... href: '/dashboard/builder-v2' },
    { id: 'preview', ... href: 'https://arigeo.com', external: true },
  ]},
  { id: 'content', label: 'Content', items: [pages, products, brands, media] },
  { id: 'design', label: 'Design', items: [templates, globals, theme, components] },
  { id: 'admin-operations', label: 'Admin & Operations', items: [
    users, data (with a 'data-collections' child), integrations, agents, settings,
  ]},
]
export const ADMIN_NAV_ITEMS: NavItem[] = ADMIN_NAV_SECTIONS.flatMap((s) => s.items)
```

Fully hard-coded — no `getVisibleDashboardRoutes()`, no `DashboardRouteId`, no
provider-gating. It also has items your spec doesn't mention at all: `website`,
`preview` (as a plain external link, not the action area §8 describes), and `agents`
under Admin & Operations.

**`origin/main`** still has the original registry-driven version:

```ts
function toNavItem(id: DashboardRouteId): NavItem { ... }
export function getAdminNavItems(context: RouteContext = DEFAULT_ROUTE_CONTEXT): NavItem[] {
  const visible = new Set(getVisibleDashboardRoutes(context).map((r) => r.id))
  // ...include()-filtered items, Content group built from ['pages','products','brands','media']...
}
export const ADMIN_NAV_ITEMS: NavItem[] = getAdminNavItems()
```

## Why I'm not resolving this myself

Your spec §2 says explicitly: *"this implementation must extend the existing
registry-driven design rather than replace it with a second hard-coded `CMS_NAVIGATION`
constant."* The branch's own `HEAD` currently **is** that hard-coded pattern
(`ADMIN_NAV_SECTIONS`), committed before the spec doc that forbids it. So resolving
"take HEAD" ships the anti-pattern the spec warns against; "take main" throws away the
grouping/labels/icons work (and the `website`/`preview`/`agents` items that aren't in
your spec's §4 `ADMIN_NAV_GROUPS` model at all — not sure if those are intentional
product additions or drift).

This is a real product decision (which items exist, whether `agents`/`website` belong,
how `preview` should behave per §8) wrapped inside what looks like a merge conflict — not
something to guess through. Recommend implementing §15's actual contract (`NavGroup` +
`ADMIN_NAV_GROUPS` + `getAdminNavGroups(context)` per §4, wrapping the registry) as the
real resolution, rather than picking either side as-is.

## Current state

- Merge was aborted cleanly — branch is at `3f9834f`, nothing broken, nothing lost.
- `origin/main` is NOT merged into `feat/issue-32-unified-navigation` yet.
- The `PagePlaceholder.tsx` half of that same conflict is trivial/mechanical (main
  independently landed an equivalent fix via `return redirect(...)`, functionally
  identical to my `: never` annotation) — not blocking, safe to reconcile either way
  when you do the real merge.
- No `unified-cms-navigation.test.mjs` or the other 5 tests from §17 exist yet anywhere.

Ping me if you want a second pass once you've decided the nav shape — happy to implement
whichever direction you pick.

— Luxi
