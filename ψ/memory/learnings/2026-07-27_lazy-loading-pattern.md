---
name: lazy-loading-wrapper-pattern
description: Lazy-loading wrappers enable component refactoring without breaking pages
metadata:
  type: learning
  ttl: ∞
  tags: [next.js, react, performance, patterns, refactoring]
---

# Lazy-Loading Wrapper Pattern for Component Refactoring

## The Pattern

A **lazy-loading wrapper** (dynamic import with `ssr: false`) decouples your page's import from your component's implementation. The page always imports the wrapper. The wrapper can swap out the underlying component without the page knowing.

```tsx
// LazyLatestCarousel.tsx (wrapper — stable interface)
const LatestCarousel = dynamic(() => import("./LatestCarousel"), {
  ssr: false,
  loading: () => <div className="carousel-loading" />,
});

export default LatestCarousel;
```

The page imports **the wrapper**, not the component:

```tsx
// page.tsx
import LatestCarousel from '@/components/home/LazyLatestCarousel';

export default async function Home() {
  return <LatestCarousel />; // still works after refactor
}
```

## Why This Matters

**Scenario**: Your carousel was a continuous scroll with arrow buttons. You want to ship a paged carousel with dot pagination instead. Both accept the same props. Both render in the same place.

**Without the wrapper**: You refactor LatestCarousel.tsx, but now the page might break if signatures changed (new required props, changed structure, different data shape).

**With the wrapper**: You refactor LatestCarousel.tsx completely. The page still imports LazyLatestCarousel. The wrapper defers loading until client-side, old code never runs on the server. You can iterate on the carousel without touching page.tsx.

## Implementation Details

- **`dynamic()`** = Next.js Code Splitting — component loads as a separate chunk
- **`ssr: false`** = Don't render on server, only client hydration — good for interaction-heavy components (carousels, tooltips, modals)
- **`loading`** prop = Placeholder while chunk loads — reserves vertical space, prevents layout shift

## When to Use

✅ Reusable carousel/hero/testimonials that might need refactoring  
✅ Components below the fold (above-the-fold should render on server for LCP)  
✅ Interaction-heavy UI (no benefit to server-rendering a click handler)  

❌ SEO-critical content (server render instead)  
❌ Essential above-the-fold elements (delays FCP)  

## Lesson for Next Time

If a component is likely to change (design reference updates, A/B tests, brand refreshes), wrap it in a lazy-loading wrapper **from day one**. Saves refactoring friction later. The cost is negligible (one extra file, ~15 lines).

## Related

- [[react-component-props-contract]] — stable interfaces across refactors
- [[next-js-dynamic-imports]] — code splitting patterns
