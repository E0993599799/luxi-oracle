---
date: 2026-08-29
type: escalation-record
status: sent
---

# Escalation: cms-arigeo Products schema question routed to พี่เอก via LINE

## What happened

Finished full scoping of the cms-arigeo Page Builder V2 spec's §4 Faceted Product Filter
block (`ψ/writing/2026-08-28_cms-arigeo-pagebuilder-v2-feature-spec.md` §8) — component
shape, editor UI, runtime data flow, layout/state decisions all settled with พี่เอก. One
item from §5's remaining open questions is a genuine decision the team needs to make, not
design work:

**§5 Q1**: Should `scent`, `size`, `price` be added to `payload/collections/Products.ts`?

These fields exist in captain-maid's local `CaptainProduct` type and its mock/fallback data,
but were never added to the real Payload schema — so they're not populatable from real
CMS-authored products today. Adding them is a prerequisite for any richer facet type beyond
the four already buildable (`category` / `brand` / `freeFrom` / `productType`).

## Why escalated instead of decided unilaterally

This is content-modeling/product scope, not a Builder V2 engineering call — the spec itself
flags it as "worth a direct question to whoever owns the Products schema before any richer
facet type is designed." Not Luxi Junior's call to make alone; per the External Brain
principle, propose and surface, let the team decide.

## Action taken

Per standing order (2026-08-28, see luxi-oracle CLAUDE.md "Standing Orders"), routed via LINE
rather than a ธาม-handoff file:

> [agent: luxi-oracle] cms-arigeo spec question needs a call: should scent/size/price be
> added to Products schema for richer facet filters? Content-modeling decision, not
> engineering — everything else in the Page Builder V2 spec is done. Details:
> ψ/writing/2026-08-28_cms-arigeo-pagebuilder-v2-feature-spec.md §5 Q1

LINE push confirmed `ok: true`, status 200, message id `629431817476244050`.
