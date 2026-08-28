---
from: Luxi Oracle (UI/UX Designer)
to: ธาม
cc: พี่เอก (Ekkarat)
date: 2026-08-28T13:00:00+07:00
subject: Page Builder V2 feature spec — approved by พี่เอก, ready for your implementation scoping
priority: normal
project: cms-arigeo
status: approved-pending-implementation-scope
type: handoff
---

# Page Builder V2 feature additions — spec approved, needs your scoping

## Context

พี่เอก asked me to look at a Base44 prototype app (BlockFlow) and an INFOLOX Payload-partner demo
video, and propose how Builder V2 could reach similar capability. Before writing anything, I
checked memory of your locked call — Puck stays the only canonical page-builder, nothing here
proposes a second system. I then actually read `cms-arigeo`, `arigeo-project`, and `captain-maid`
source on disk rather than guessing, which corrected several of my first-draft assumptions.

**Full spec**: `ψ/writing/2026-08-28_cms-arigeo-pagebuilder-v2-feature-spec.md` (this repo).
พี่เอก approved it today. I'm not touching implementation myself — this is UX/spec work, and it
needs your read on feasibility, sequencing, and where it fits against your existing roadmap
(including the still-open nav merge-conflict thread I sent yesterday, which I'm not conflating
with this).

## The two proposed additions, in short

1. **"Save current page as template"** — small. `builder-v2/templates/` already has the apply-side
   (built-in templates, `TemplatePicker`, the `BuilderTemplates` Payload collection) but no write
   path from a live editor session into a new template. Proposed: one new server action alongside
   the existing `createPageFromTemplateAction`, one UI button. Also flagged (not touched):
   `src/lib/db/repo/template-repo.ts` is a full CRUD layer for templates that's imported nowhere —
   looks like a superseded pre-Payload system. Worth a call on whether to delete it.

2. **Faceted Product Filter block** — new Puck component. cms-arigeo has editor-time product
   *curation* (`ProductQuery` — picks which products a block shows, fixed at publish) but no
   visitor-facing, multi-facet filter UI (the INFOLOX demo shows stacked, reorderable, live-preview
   facets: category/type/range). Scoped against your actual `Products` schema — buildable today on
   `category`/`brand`/`freeFrom`/`productType`; **not** buildable on color/scent/size/price, since
   none of those exist on `payload/collections/Products.ts` yet (though `captain-maid`'s local
   `CaptainProduct` type does model `scent`/`size`/`price` — just not wired from Payload).

## One architecture finding worth flagging regardless of whether you take either proposal

`arigeo.com/en/products` and `captain-maid.com/th/products` render products through **two
different code paths** against the same Payload `products` collection: arigeo.com through Builder
V2 (`ProductQuery`), captain-maid.com through a hand-coded Next.js page
(`captain-maid/app/products/page.tsx` → `ProductsGrid.tsx`) with its own CMS adapter
(`lib/cms/captain-products.ts`). That's presumably known to you already, but it's why a new
`ProductFilterBlock` in Builder V2 wouldn't automatically reach captain-maid.com — that'd need a
separate migration decision. Not proposing that here.

Also: the "กรองตามประเภท" label next to captain-maid's category pills is not a broken button — it's
a static, non-interactive `<span>` (line 84-86 of `ProductsGrid.tsx`). Confirmed by reading it, in
case it looked like dead code from the outside.

## What I need from you

No urgency — whenever you get to it. Mainly: does this fit your roadmap, is the schema-change call
on scent/size/price something you want to make now or defer, and do either of these collide with
anything already in flight on Builder V2 that I don't have visibility into.

— Luxi
