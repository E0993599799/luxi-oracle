---
project: cms-arigeo — Page Builder V2 feature additions
oracle: Luxi Junior (UI/UX Designer)
date: 2026-08-28
status: Approved by พี่เอก 2026-08-28 — grounded in a real read of cms-arigeo/arigeo-project/captain-maid source, not guesses. Ready for ธาม/repo-owner implementation scoping.
source_repos:
  - D:\01 Main Work\Boots\Agentic AI\mission-control\cms-arigeo (Builder V2/Puck + Payload backend — read directly)
  - D:\01 Main Work\Boots\Agentic AI\mission-control\arigeo-project (ARIGEO parent site — Builder V2 rendered)
  - D:\01 Main Work\Boots\Agentic AI\mission-control\captain-maid (Captain Maid site — hand-coded Next.js, same Payload backend)
  - Base44 BlockFlow app (reference/inspiration — inspected live via browser, 2026-08-28)
  - infolox.de Payload-partner page + embedded demo video (reference/inspiration — inspected live, 2026-08-28)
related_memory:
  - cms-arigeo-visual-website-os-vision
  - cms-arigeo-unified-sidebar-spec
---

# cms-arigeo Page Builder V2 — Feature Additions Spec (BlockFlow + INFOLOX-Inspired)

**Date:** 2026-08-28
**Oracle:** Luxi Junior (ลุกซี่)
**Status:** 🟢 Approved by พี่เอก (2026-08-28) — grounded in an actual read of the `cms-arigeo`,
`arigeo-project`, and `captain-maid` repos on disk (not just live-site observation or memory).
Still needs ธาม/repo-owner implementation scoping/sign-off before code changes land, and still
defers entirely to his locked Builder V2/Puck decision — this spec proposes additions inside it,
nothing that overrides it.

**พี่เอก's direction, in his words:** wants arigeo's builder to reach feature parity with what
INFOLOX's Payload-based pagebuilder demonstrates ("ทุก functions" — all the functions shown), and
wants this grounded in the actual projects (`cms-arigeo`, `arigeo-project`, `captain-maid`) so new
capability is easy to retrofit onto what already exists, not a rebuild.

---

## 0. Why this document exists, and what changed in this revision

Earlier drafts of this spec were based on live-site observation and memory of past architecture
decisions, with several items explicitly flagged "needs verification against the real repo." This
revision **did that verification** — read the actual source in `cms-arigeo` (Builder V2 code,
Payload collection schemas), `arigeo-project`, and `captain-maid` on disk. Several earlier
assumptions turned out wrong; this doc now reflects what's actually there.

Locked constraint, unchanged, still the frame for everything below (`cms-arigeo-visual-website-os-vision`,
verified against the real repo 2026-08-28):

> **"Builder V2 / Puck (`@measured/puck`) = visual page-composition layer — the ONLY canonical
> page-builder stack going forward. Do not propose or build a third page-builder system."**

Everything here is scoped as an addition inside Builder V2, or a precise fix to something already
half-built — never a parallel system.

---

## 1. Ground truth: what Builder V2 already has (read directly from `cms-arigeo/src/builder-v2/`)

This corrects the previous draft, which treated several of these as open questions. They aren't —
they're real, and I read the code:

| Capability | Where | Status |
|---|---|---|
| **Component registry** (Puck component config) | `builder-v2/registry/{primitives,arigeo,dynamic}.ts` | ✅ Real. Primitives (Heading/Text/Button/Image/Card/Grid/...), ARIGEO-specific components (HeroCarousel/ProductGrid/BrandGrid/Footer/...), and **dynamic CMS-bound components** (ProductQuery/NewsQuery/BrandQuery/CMSCollection/RelatedItems/Repeater/Conditional). |
| **Templates** | `builder-v2/templates/{registry,actions,insert}.ts`, `TemplatePicker.tsx`, Payload `BuilderTemplates` collection | ⚠️ **Half-built.** Built-in templates (kind: page/section/saved_block/starter/industry) are real, stored as pure Puck JSON, and `createPageFromTemplateAction` can create a new page from one. **But there is no "save current page as a new template" action** — `templates/actions.ts` only reads built-ins, never writes. See §3. |
| **Draft/publish/version history** | `builder-v2/versions/{VersionHistory.tsx,useVersions.ts}`, `/api/builder-v2/versions*` routes, `BuilderPageVersion` Payload type | ✅ Real and wired. List/create/restore versions via a real API, not aspirational. |
| **Roles/permissions** | `builder-v2/permissions/guards.ts` (reuses V1 `src/builder/permissions/roles.ts`) | ✅ Real, and **richer than BlockFlow's admin/user binary**: viewer/translator/editor/designer/admin, with separate verbs (`canEditContent`, `canEditStructure`, `canPublish`, `canManageTheme`, `canManageTemplates`). |
| **Live Inspector** | `builder-v2/inspector/`, `builder-v2/preview/` | ✅ Real (matches the vision-doc description). |
| **Editor-time product filtering** | `builder-v2/components/dynamic/ProductQuery.tsx` | ✅ Real, but scoped differently than expected — see §2 and §4.1. An editor can filter *which products a block shows* (brand/category/productType/freeFrom/status + an "Advanced Filters" array), but this produces a fixed, pre-filtered list at publish time — it is **not** a visitor-facing interactive facet UI. |
| **Legacy/orphaned template CRUD** | `src/lib/db/repo/template-repo.ts` (raw Postgres SQL, `builder_templates` table) | ⚠️ **Dead code.** Full CRUD (create/update/delete/findByCategory) exists here, but it is imported nowhere else in the codebase. This looks like an earlier, non-Payload template system that was superseded by `builder-v2/templates/` + the `BuilderTemplates` Payload collection, and never deleted. Flag for cleanup, don't build on it. |

---

## 2. Feature-by-feature mapping onto Builder V2 (BlockFlow-derived) — corrected

| BlockFlow capability | Builder V2 reality (verified) | Verdict |
|---|---|---|
| Ordered, typed content blocks, drag-reordered | Puck does this natively; registry confirmed rich (primitives + ARIGEO components + dynamic CMS components). | ✅ Already covered, and broader than BlockFlow's 6 fixed block types. |
| Block renderer + editor pair per type | `ComponentConfig` per component (`fields` + `render`), same pattern as Puck everywhere. | ✅ Already covered. |
| Draft/published status | `versions/` subsystem, live API routes. | ✅ **Confirmed real**, not just "should exist." |
| Save current layout as reusable template | Built-in templates exist and can be applied; **saving the current page as a new template does not exist yet** — the write path is missing, and there's an orphaned SQL repo that could be reused or should be cleaned up either way. | 🆕 **Real, narrow gap.** See §3 — much smaller than "build templates," it's "add one missing write action + one UI button." |
| Public-facing render by slug | Confirmed live on both `arigeo.com/en/products` (Builder V2-rendered) and `captain-maid.com/th/products` (hand-coded Next.js, same Payload backend). | ✅ Working in production, via two different rendering paths — see §1.3-equivalent detail in §4.2. |
| Role-gated admin hint | N/A — cms-arigeo's role model is already far more granular than BlockFlow's cosmetic-only role field. | ⛔ Nothing to port. |

---

## 3. Proposed addition: "Save current page as template" (the real gap, narrowed)

### 3.1 What's actually missing

Not a new templates system — `builder-v2/templates/` already has the registry, the Payload
collection (`BuilderTemplates`), the picker UI, and the apply-a-template flow. The **one missing
piece** is a server action that takes a page's current live Puck `data` and writes it as a new
`BuilderTemplates` document (`kind: 'saved_block'` or `'page'`), plus a "Save as template" button
in the editor UI to trigger it.

### 3.2 Proposed shape

A new action alongside `templates/actions.ts`'s existing `createPageFromTemplateAction`:

```ts
// builder-v2/templates/actions.ts — new function, same file, same pattern
export async function saveCurrentPageAsTemplateAction(
  puckData: Data,           // the editor's live state, passed from the client
  name: string,
  kind: TemplateKind,       // 'page' | 'section' | 'saved_block'
  options?: { description?: string; thumbnail?: string },
): Promise<{ ok: boolean; templateId?: string; error?: string }>
```

Write through Payload's own API for the `BuilderTemplates` collection (not the orphaned
`template-repo.ts` raw-SQL path — that system is superseded and should not gain new callers).

### 3.3 Explicitly out of scope

- No changes to the built-in template registry, no changes to `TemplatePicker.tsx`'s read side —
  only adding the write path.
- No navigation/sidebar changes (still ธาม's unresolved call).
- Cleaning up `src/lib/db/repo/template-repo.ts` is a separate, small, unrelated chore — worth
  flagging to whoever owns that code, not bundled into this feature.

---

## 4. Proposed addition: Faceted Product Filter block (INFOLOX-inspired, corrected against real schema)

### 4.1 What the reference demo shows vs. what Builder V2 already has

INFOLOX's demo ("Produktfinder/Produktfilter im Pagebuilder konfigurieren," 1:43, watched in full)
shows an editor stacking typed facet rows (color swatch, type tabs, length/height range sliders)
that render as an **interactive filter UI for the site visitor**, live-previewed in a split pane,
bound to real product fields.

cms-arigeo's `ProductQuery` component (§1) is **not** this — it's an editor-time content-curation
filter: the editor picks which products a block shows (by brand/category/productType/freeFrom),
and that selection is fixed at publish time. A site visitor gets a static, pre-filtered product
list with no facet controls of their own. That's the real, confirmed gap.

### 4.2 Confirmed by reading both frontends, not just observing them live

- **`arigeo.com/en/products`** is rendered through Builder V2 using (most likely) `ProductQuery` —
  explains the flat, unfiltered, generic-placeholder-image grid seen live: it's exactly what that
  component produces today, no visitor-facing filter.
- **`captain-maid.com/th/products`** is **not** rendered through Builder V2 at all — it's a
  hand-coded Next.js route (`app/products/page.tsx` → `components/products/ProductsGrid.tsx`) that
  calls `getCaptainProducts('th')` from `lib/cms/captain-products.ts`, a **custom Payload adapter**
  hitting the same `products` collection. Its category-pill filter is hand-built React state
  (`useState` + `.filter()`), not a Builder V2 component at all.
- The **"กรองตามประเภท" text next to the pills is not a button** — it's a static `<span>` label
  with a `SlidersHorizontal` icon (`ProductsGrid.tsx` line 84-86), decorative, not wired to
  anything. That's why nothing happened when I clicked it live — it was never meant to be
  clickable. This closes out that open question definitively; nothing is broken or dead-code there.

**Implication:** a new `ProductFilterBlock` Puck component would only reach pages actually rendered
through Builder V2 (arigeo.com today; wherever else Builder V2 gets deployed). It would **not**
automatically appear on captain-maid.com unless/until captain-maid's product page is migrated onto
Builder V2 — that's a separate, larger decision (replacing a working hand-coded page with a
CMS-driven one) and out of scope here.

### 4.3 What fields actually exist to filter on (`payload/collections/Products.ts`, read directly)

```ts
name, slug, brand (relationship → brands), category (relationship → product-categories),
solutions (relationship, hasMany → solutions), productType (text), launchCollection (text),
intro/usage (richText), technology/keyBenefits/suitableFor (arrays of text),
freeFrom (select, hasMany: phosphate | paraben | ammonia | formaldehyde | sls),
safetyRemark, claimsSupport, images, relatedProducts, contentStatus, seo
```

**No `color`, `scent`, `size`, or `price` field exists on Payload's `products` collection.**
Interestingly, captain-maid's own local `CaptainProduct` type (`lib/captain-products.ts`) *does*
model `scent`, `size`, `price`, `rating`, `reviews` — but the CMS adapter (`lib/cms/captain-products.ts`)
that maps real Payload documents into that shape **does not populate them from Payload** (they
aren't in the `PayloadProduct` interface it reads), so today those richer fields only exist for the
static/mock fallback data, not for real CMS-authored products.

**This means my earlier illustrative facets (`colorSwatch`, `range` for length/height) don't map to
anything real today.** Corrected, buildable-now facet set:

```ts
{
  content: {
    facets: [
      { type: 'category',    sourceField: 'category',    label: 'หมวดหมู่' },   // relationship — matches captain-maid's existing pills conceptually
      { type: 'category',    sourceField: 'brand',        label: 'แบรนด์' },     // useful cross-brand on arigeo.com
      { type: 'multiSelect', sourceField: 'freeFrom',     label: 'ปราศจาก' },   // genuinely good: phosphate/paraben/ammonia/formaldehyde/sls checkboxes
      { type: 'text',        sourceField: 'productType',  label: 'ประเภทสินค้า' },
    ],
  },
}
```

A `scent` or `size`/`price` range facet is **not buildable today without a schema change** —
adding those fields to `payload/collections/Products.ts` is a prerequisite, not part of this block.

### 4.4 UX flow

1. Editor adds `ProductFilterBlock` to a product/category page in Builder V2.
2. Facet-config panel: add/remove/reorder facet rows, each picked from a fixed facet-type registry
   (`category` / `multiSelect` / `text`, extensible later), each bound to a real field via a
   dropdown sourced from the Products collection schema — never free text for the field name.
3. Live preview updates as facets are added/reordered, consistent with Builder V2's existing
   Inspector/preview pattern.
4. Publish → the rendered facet UI on the live page must match the editor preview exactly (the
   part INFOLOX's demo proves at the end, and the bar any implementation should be held to).

### 4.5 Explicitly out of scope

- No freeform "any field is a filter" builder — facet types stay a fixed, curated registry.
- Does not migrate captain-maid.com onto Builder V2 — separate decision, not bundled here.
- Does not add `scent`/`size`/`price` fields to the Products schema — flagged as a prerequisite for
  richer facets, not undertaken by this block itself.

---

## 5. Remaining open questions

Most of the previous draft's open questions are now answered (§1). What's left:

1. **Should `scent`/`size`/`price` be added to `payload/collections/Products.ts`?** This is a
   product/content-modeling decision, not a Builder V2 engineering one — worth a direct question to
   whoever owns the Products schema before any richer facet type is designed.
2. **Should `src/lib/db/repo/template-repo.ts` be deleted?** It's confirmed dead/unreferenced. Low
   risk, but flag to the repo owner rather than deleting unilaterally.
3. **Where should `saveCurrentPageAsTemplateAction`'s UI trigger live** (§3) — a button in
   `Shell.tsx`'s toolbar, `BottomBar.tsx`, or elsewhere? Needs a look at the actual editor chrome,
   which I have not inspected pixel-by-pixel.
4. **Is there an existing facet-registry pattern anywhere else in the codebase** (e.g. in `dynamic.ts`
   or `binding/fieldMap.ts`) that a new `ProductFilterBlock` should reuse rather than duplicate? I
   read `ProductQuery.tsx`'s filter shape (`CmsFilter`, `OPERATOR_OPTIONS` from `binding/fieldMap.ts`)
   but did not fully audit `binding/` for a reusable facet abstraction — worth a closer look before
   implementation starts, since `CmsFilter`/`useCmsQuery` may already be 80% of what a facet needs.

---

## 6. Summary for พี่เอก

- I read the actual `cms-arigeo`, `arigeo-project`, and `captain-maid` source on disk (previously I
  only had live-site observation + memory). Several earlier guesses were wrong — corrected above.
- Builder V2 is much more complete than the first draft assumed: templates (apply side), full
  draft/publish/version history, and a granular 5-role permission model **all already exist and are
  wired**, not just planned.
- **Two real, narrow gaps** remain, both now scoped precisely against real code:
  1. **"Save current page as template"** (§3) — the templates *apply* path exists; the *save* path
     doesn't. One new server action + one UI button, reusing everything else that's already built.
  2. **Faceted Product Filter block** (§4) — cms-arigeo has editor-time product *curation*
     (`ProductQuery`), but no visitor-facing, multi-facet filter UI like INFOLOX's demo. Buildable
     today against `category`/`brand`/`freeFrom`/`productType` — **not** against color/scent/size,
     which don't exist in the Products schema yet.
- Concrete architecture finding worth knowing regardless of this spec: **arigeo.com and
  captain-maid.com render products through two entirely different code paths** hitting the same
  Payload `products` collection — arigeo.com through Builder V2/`ProductQuery`, captain-maid.com
  through a hand-coded Next.js page with its own CMS adapter. A `ProductFilterBlock` would only
  reach the Builder V2 path unless someone later decides to migrate captain-maid.com onto it too.
- The "กรองตามประเภท" button I flagged as possibly broken in the previous draft is not broken — it
  was never a button, just a label. Confirmed by reading the component, not guessing.
- I did **not** touch navigation/sidebar — that's ธาม's live, unresolved call — and did not delete
  or modify `template-repo.ts` despite confirming it's dead code; that's a call for its owner.
