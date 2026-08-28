---
name: cms-arigeo-visual-website-os-vision
description: cms-arigeo is not "just a CMS" — it's a Visual Website Operating System (Payload = data engine, Builder V2/Puck = visual editing layer). Canonical architecture confirmed by ธาม against the real repo, 2026-08-28.
metadata:
  type: project
  ttl: 3mo
---

**ธาม verified this directly against the `cms-arigeo` repo (not docs) on 2026-08-28.** Supersedes the more skeptical build-failure-chain read from earlier the same session — that read was about deploy stability, this is about product/architecture direction. Both are true simultaneously: the vision below is the target architecture; the repo also has an unresolved Payload-build-tracing issue and 18 days of uncommitted pnpm-migration work (see session context).

## Reframe

Not a CMS. A **Visual Website Operating System**:
- **Payload CMS** (3.87, Postgres via `@payloadcms/db-postgres`, Vercel Blob for media) = canonical data/content backend (Products, Brands, Media, Pages, Users, Settings — CRUD-shaped content)
- **Builder V2 / Puck** (`@measured/puck`) = visual page-composition layer — the ONLY canonical page-builder stack going forward. Do not propose or build a third page-builder system; this design is locked/approved.
- **Live Inspector** = the differentiator vs. a normal CMS — click a real element on the live site (arigeo.com / Captain Maid), it resolves to a stable identity (`data-cms-section` / `-component` / `-field` / `-instance`, e.g. `site=arigeo page=home component=hero instance=hero-main field=heading locale=th revision=183`), opens the right control, edits, previews, saves draft, publishes.

## Runtime boundary (don't collapse this)

Payload Admin = low-level collection CRUD. Custom Dashboard/Builder = editorial + visual workspace. **Unify UX/navigation/branding/linking between them — do NOT merge them into one runtime.**

## Component contract (schema-driven, not freeform HTML/CSS)

Every builder component normalizes to: `content` (heading/subtitle/image/CTA) / `layout` (maxWidth/padding/alignment) / `style` (background/typography/borderRadius) / `responsive` (desktop/tablet/mobile). Computed CSS from the Inspector is **inspection context only** — never a source of truth; every write must round-trip through normalized schema fields.

## Pipeline

```
Puck component → component contract → normalized props → page revision → Payload/DB → renderer → arigeo.com / Captain Maid
```

Build already gates on Live Inspector checks before Payload generates types/importmap, before Next build.

## 8 domains an AI needs to operate this site (not just "know Next.js")

1. Website semantic model (page→section→component→field→responsive variant→datasource)
2. Puck/Builder component contract (props, editable fields, responsive vs. inherited vs. locked values)
3. Payload schema (collections/fields/relationships/access control/localization/hooks/versions/drafts/media)
4. Live Inspector protocol (stable identity, iframe bridge, `postMessage`, origin validation, token, selection, bounding box, computed style)
5. CSS/layout engine (flexbox/grid/intrinsic sizing/typography/responsive/object-fit/overflow/stacking context)
6. Design system (spacing/token/font/color/radius/breakpoint — when to use a token vs. an exact px)
7. Revision & publishing semantics (draft ≠ production, stale-revision conflicts, rollback, immutable history, publish gates)
8. Visual verification (inspect the actual production page, screenshot desktop/tablet/mobile, visual diff, runtime verification — not just "code compiled")

## Refinement: 6 axes (not 8) for "AI that can actually fix the website" — same day, ธาม

Tighter reframe of the 8 domains above, scoped specifically to *fixing* the live site (not just knowing the stack):

1. **Website structure** — `site → page → section → component → field → responsive variant`; map an on-screen element back to its CMS record/field
2. **Page Builder / Puck** — component contract per block: what props exist, what's editable, what's responsive, what's inherited, what's off-limits (so AI doesn't freehand CSS)
3. **Page Inspector** — identify a real element via `data-cms-*`, bounding box, computed style, viewport, instance id; map click → Builder/Payload field
4. **Payload CMS** — collections/fields/relationships/localization/media/users-roles/draft-version/hooks/API — fix the *data source*, never the rendered output
5. **Web layout/design** — real CSS literacy (flex/grid/spacing/typography/image crop/object-position/overflow/breakpoints/tokens) to diagnose *why* something broke, not just that it looks broken
6. **Preview → Proof → Publish lifecycle** — draft first, preview across devices, visual-regression check, schema/auth/site-scope gate, publish, verify production

**Added layer**: learn the *actual* ARIGEO/Captain Maid site patterns (Hero, Product Grid, Brand Page, Navigation, mobile layout, typography/spacing conventions) so the AI has a baseline for "what normal looks like" on these specific sites, not just generic web literacy.

**Target flow**: `user intent → inspect real page → identify element → map to component/schema → diagnose layout/content issue → safe patch → preview desktop/tablet/mobile → visual proof → save draft → publish → verify production`

Boiled down: **how the site looks, how Builder stores it, how Payload stores data, how to change it without breaking production** — those 4 have to be rock solid.

## How to apply

- When producing design specs or briefs touching cms-arigeo/ARIGEO, target Builder V2's component-contract shape (content/layout/style/responsive), not raw markup.
- Treat Payload Admin and the Builder/Inspector dashboard as UX-unified but runtime-separate — don't design flows that assume one process handles both.
- If proposing a new component or editing pattern, express it as identity (`data-cms-*`) + schema fields, not CSS selectors.
- This is a decision/vision snapshot from พี่เอก via ธาม, not something to re-derive from code — but re-verify against the repo if it's been >3 months or something looks inconsistent with current source.
