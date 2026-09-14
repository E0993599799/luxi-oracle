---
name: print-pdf-pagination-rules
description: Three standing pagination rules for any book/manual/report rendered to print CSS + PDF — no orphaned headings, tables split with a repeating header row, and figures/diagrams must never approach a full page's height. Given by พี่เอก 2026-09-14 after reviewing the ARIGEO Account Manual PDFs.
metadata:
  type: feedback
  ttl: ∞
---

When producing any print-CSS-driven PDF (headless-Chrome `--print-to-pdf` or equivalent), apply all three:

1. **No orphaned headings.** A heading must never sit alone at the bottom of a page with nothing following it. Prefer *natural flow* (`break-after: avoid` / `page-break-after: avoid` on headings) over forcing every heading to start a fresh page — a forced `break-before: page` on every h2 trivially satisfies "never orphaned" but wastes pages with large empty gaps (measured: it inflated a 13-page doc to 19 pages). Natural flow + orphan-avoidance is both correct and materially more compact.

2. **A long table splits across pages, header row repeats.** Don't set `break-inside: avoid` on `<table>` — that either forces the whole table to jump to a fresh page (wasting space) or, if it's taller than one page, breaks unpredictably. Instead: restructure the table into real `<thead>`/`<tbody>` (a bare first `<tr>` does **not** auto-repeat — only a real `<thead>` does), set `table { break-inside: auto }`, `thead { display: table-header-group }`, and `tr { break-inside: avoid }` so only whole rows stay intact and the header row reprints on every page the table spans.

3. **Figures/diagrams must never approach a full page's height.** `break-inside: avoid` on a figure only works if the figure can actually fit within one page. A screenshot or diagram that's *taller* than the printable page area breaks the engine's ability to also honor `break-after: avoid` on the heading right before it — Chrome will drop that heading-glue hint rather than fail to keep the oversized figure whole, orphaning the heading on the previous page. Fix: cap image height in print (e.g. `img { max-height: 200mm; width: auto; max-width: 100% }`, tuned to leave slack under the page's content height) so every figure+heading pair always fits together.

## A related, separate bug this surfaced — not a pagination issue

While building custom SVG diagrams with a title drawn above translated body content (`<g transform="translate(0,y0)">…</g>` + a title `<text>`), the SVG's own `viewBox` height must include that `y0` offset. Passing only the *content* height as the viewBox height silently clips the bottom `y0` px of the diagram (invisible in a live HTML preview if body height leaves slack, but visible as a cut-off bottom row once content is tight — e.g. a 4-branch role-flow diagram lost ~36px, cutting into the last branch box). Always compute `viewBox height = content height + title offset`.

## How to apply

Before shipping any print-CSS PDF, don't just screenshot the live HTML (pagination isn't visible there — it only exists in the print/PDF fragmentation pass) and don't trust `pdfjs-dist` + node `canvas` for PDF QA (it silently drops embedded custom-font text and crashes on gradient/shading patterns on ~30% of pages in practice). Use `mupdf` (npm `mupdf`, WASM-based) to rasterize every real PDF page and visually check each one — that's what caught all of the above.
