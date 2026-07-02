# Phase 7: Performance Optimization

**Orry Serenity ERP — Speed & Efficiency Enhancements**

**Timeline**: 6-10 hours estimated  
**Budget**: Data-driven optimization (measure before & after)  
**Quality Target**: Lighthouse 95+, LCP < 2.5s, FID < 100ms, CLS < 0.1  
**Deadline**: No hard deadline (post-launch optimization)

---

## Phase Objectives

Optimize Orry Serenity for speed and efficiency:
- ✅ Fast page loads (LCP < 2.5s target, < 3.0s acceptable)
- ✅ Responsive interactions (FID < 100ms)
- ✅ Stable layout (CLS < 0.1)
- ✅ Reduced bundle size (< 100KB gzipped for critical path)
- ✅ Efficient database queries (no N+1 problems)
- ✅ Smart caching (assets, API responses)
- ✅ Lighthouse score 95+ (all metrics)

---

## Performance Metrics Explained

### Core Web Vitals (Google's main metrics)

**LCP (Largest Contentful Paint)** — When main content loads
- ✅ Good: < 2.5s
- ⚠️ Needs work: 2.5s - 4s
- ❌ Poor: > 4s
- **What affects it**: Hero images, fonts, JavaScript parsing

**FID (First Input Delay)** — Responsiveness to user input
- ✅ Good: < 100ms
- ⚠️ Needs work: 100ms - 300ms
- ❌ Poor: > 300ms
- **What affects it**: JavaScript blocking main thread

**CLS (Cumulative Layout Shift)** — Visual stability
- ✅ Good: < 0.1
- ⚠️ Needs work: 0.1 - 0.25
- ❌ Poor: > 0.25
- **What affects it**: Images without dimensions, late-loaded content

### Secondary Metrics

**TTFB (Time to First Byte)** — Server responsiveness
- Target: < 200ms
- Affected by: Server response time, network, CDN

**FCP (First Contentful Paint)** — When any content appears
- Target: < 1.8s
- Affected by: CSS, critical JavaScript

**TTI (Time to Interactive)** — When page is fully interactive
- Target: < 3.8s
- Affected by: JavaScript parsing, hydration

**TBT (Total Blocking Time)** — JavaScript blocking main thread
- Target: < 200ms
- Affected by: Large JavaScript tasks

---

## Audit: Current Performance State

**Baseline measurement**:
1. Run Lighthouse on production URL
2. Note all metrics (LCP, FID, CLS, TTI, etc.)
3. Identify bottlenecks (slowest components)
4. Profile with Chrome DevTools (Performance tab)
5. Measure bundle size (`bun build --analyze`)

**Key questions**:
- What's the largest JavaScript file?
- Which images are slowest to load?
- What JavaScript runs on page load?
- Are there N+1 database queries?
- How much CSS is unused?

---

## Optimization Areas

### 1. Code Splitting (HIGH IMPACT)

**Current State**: Likely all JavaScript loaded upfront  
**Target**: Load only what's needed for page

**Techniques**:
- ✅ Route-based code splitting (load route JS only when accessed)
- ✅ Component-level code splitting (lazy-load heavy components)
- ✅ Dynamic imports (`dynamic(() => import(...))` in Next.js)
- ✅ Vendor splitting (separate node_modules into own bundle)

**Example**:
```typescript
// Before: All loaded upfront
import Dashboard from './Dashboard';

// After: Loaded on route access
const Dashboard = dynamic(() => import('./Dashboard'), {
  loading: () => <Skeleton />,
});
```

**Impact**: 20-40% JavaScript reduction on initial page load

---

### 2. Image Optimization (HIGH IMPACT)

**Current State**: Likely serving full-size images  
**Target**: Optimized images for each device

**Techniques**:
- ✅ WebP format (smaller than PNG/JPG, 25-35% reduction)
- ✅ Responsive images (different sizes for mobile/desktop)
- ✅ Image lazy loading (`loading="lazy"` on images below fold)
- ✅ Image dimensions (prevent layout shift)
- ✅ Next.js Image component (automatic optimization)
- ✅ Compress before serving (ImageOptim, TinyPNG)

**Example**:
```typescript
// Before: Full-size JPG
<img src="/hero.jpg" alt="Hero" />

// After: Optimized with Next.js Image
import Image from 'next/image';

<Image
  src="/hero.jpg"
  alt="Hero"
  width={1200}
  height={600}
  priority // Load immediately (for LCP)
  placeholder="blur" // Show blur while loading
/>
```

**Impact**: 30-60% image size reduction, improved LCP

---

### 3. Bundle Size Reduction (MEDIUM IMPACT)

**Current State**: Unknown, likely > 150KB gzipped  
**Target**: < 100KB gzipped for critical path

**Techniques**:
- ✅ Remove unused dependencies (audit with `npm audit`)
- ✅ Tree-shake unused code (ensure build configured correctly)
- ✅ Replace heavy libraries with lighter alternatives:
  - moment → date-fns (90KB → 13KB)
  - lodash → lodash-es (70KB → 20KB)
- ✅ Minify and compress (Bun does this automatically)
- ✅ Analyze bundle (see what's taking space)

**Analyze bundle**:
```bash
cd /mnt/d/01\ Main\ Work/Boots/Agentic\ AI/mission-control/orry-serenity
bun run build
# Bun outputs bundle analysis automatically
```

**Impact**: 20-40% bundle reduction depending on findings

---

### 4. Font Optimization (MEDIUM IMPACT)

**Current State**: Likely loading Google Fonts (Noto Sans Thai)  
**Target**: Optimized font loading strategy

**Techniques**:
- ✅ Font display strategy (`font-display: swap` for FOUT vs. FOIT)
- ✅ Subset fonts (load only characters used in Thai/English)
- ✅ Self-host fonts (vs. Google Fonts CDN for faster TTFB)
- ✅ Preload critical fonts (`<link rel="preload">`)
- ✅ Variable fonts (single file for multiple weights)

**Example**:
```css
@font-face {
  font-family: 'Noto Sans Thai';
  src: url('/fonts/noto-sans-thai.woff2') format('woff2');
  font-display: swap; /* Show fallback immediately, swap when loaded */
  font-weight: 400;
  font-style: normal;
}
```

**Impact**: 0.5-1.0s improvement to LCP (font-dependent)

---

### 5. Critical CSS (MEDIUM IMPACT)

**Current State**: All CSS loaded upfront  
**Target**: Inline critical CSS above the fold, defer rest

**Techniques**:
- ✅ Identify critical CSS (first viewport's styles)
- ✅ Inline in `<head>` (no network request)
- ✅ Defer non-critical CSS (load asynchronously)
- ✅ CSS-in-JS optimization (styled-components, emotion)

**Example**:
```html
<!-- Critical CSS inlined -->
<style>
  .hero { padding: 2rem; background: linear-gradient(...); }
  .nav { display: flex; gap: 1rem; }
</style>

<!-- Non-critical CSS deferred -->
<link rel="preload" href="/non-critical.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
```

**Impact**: 0.3-0.7s improvement to FCP

---

### 6. JavaScript Execution (MEDIUM IMPACT)

**Current State**: Likely parsing all JavaScript on load  
**Target**: Parse/execute only what's needed, defer rest

**Techniques**:
- ✅ Script tags: `<script async>` (load in parallel, execute ASAP)
- ✅ Script tags: `<script defer>` (load in parallel, execute after DOM)
- ✅ Break long tasks (avoid > 50ms blocking on main thread)
- ✅ Web Workers (offload heavy computation to background thread)
- ✅ Prerender (generate static HTML for common routes)

**Example**:
```html
<!-- Critical (above fold) — execute immediately -->
<script>critical-code.js</script>

<!-- Analytics/non-critical — defer execution -->
<script defer src="analytics.js"></script>

<!-- Very non-critical — async (may execute late) -->
<script async src="third-party.js"></script>
```

**Impact**: 0.5-1.5s improvement to TTI/FID

---

### 7. Caching Strategy (MEDIUM IMPACT)

**Current State**: Likely limited or no caching  
**Target**: Aggressive caching for static assets, smart for dynamic

**Techniques**:
- ✅ Browser caching (set Cache-Control headers)
- ✅ CDN caching (serve from edge, not origin)
- ✅ Service Worker caching (offline support + speed)
- ✅ API response caching (avoid repeated requests)
- ✅ Database query caching (Redis for hot data)

**Cache headers**:
```typescript
// Static assets (CSS, JS, images) — cache forever
response.headers.set('Cache-Control', 'public, max-age=31536000, immutable');

// HTML — cache briefly, revalidate frequently
response.headers.set('Cache-Control', 'public, max-age=3600, stale-while-revalidate=86400');

// API responses — cache for 1 minute
response.headers.set('Cache-Control', 'public, max-age=60, stale-while-revalidate=300');
```

**Impact**: 50-90% faster repeat visits, reduced server load

---

### 8. Database Query Optimization (MEDIUM IMPACT)

**Current State**: Unknown, likely N+1 query problems  
**Target**: Minimal queries, efficient joins

**Techniques**:
- ✅ Identify N+1 queries (query inside loop)
- ✅ Use Supabase `select()` efficiently (only needed columns)
- ✅ Batch queries (load all related data at once)
- ✅ Add indexes (on frequently queried columns)
- ✅ Pagination (don't load all records at once)

**Example (N+1 problem)**:
```typescript
// Bad: Query in loop (N+1 queries)
const users = await db.users.findAll();
for (const user of users) {
  user.orders = await db.orders.findByUserId(user.id); // N additional queries!
}

// Good: Batch query (1 query)
const users = await db.users.findAll({
  include: { orders: true }, // Join in single query
});
```

**Impact**: 30-60% faster API responses for list views

---

### 9. Lazy Loading (LOW-MEDIUM IMPACT)

**Current State**: All content loaded on page load  
**Target**: Load below-fold content only when visible

**Techniques**:
- ✅ Intersection Observer API (detect when element visible)
- ✅ `loading="lazy"` on images (browser native)
- ✅ React Suspense (lazy load components)
- ✅ Infinite scroll (load more as user scrolls)

**Example**:
```typescript
// Before: All images loaded
<img src="/image1.jpg" alt="1" />
<img src="/image2.jpg" alt="2" /> {/* Below fold */}

// After: Second image lazy-loaded
<img src="/image1.jpg" alt="1" />
<img src="/image2.jpg" alt="2" loading="lazy" />
```

**Impact**: 10-30% faster initial load for image-heavy pages

---

### 10. Monitoring & Alerting (FOUNDATION)

**Current State**: Likely no performance monitoring  
**Target**: Real-time visibility into performance metrics

**Tools**:
- ✅ Google Analytics (RUM — Real User Monitoring)
- ✅ Vercel Analytics (built-in, shows Core Web Vitals)
- ✅ Sentry (error tracking + performance monitoring)
- ✅ DataDog or New Relic (advanced monitoring)

**Setup**:
```typescript
// Vercel Analytics (built-in)
import { Analytics } from '@vercel/analytics/react';

export default function App() {
  return (
    <>
      <YourApp />
      <Analytics />
    </>
  );
}
```

**Impact**: Visibility to catch regressions, data-driven optimization

---

## Implementation Strategy

### Phase 7.1: Performance Audit (1-2 hours)

**Step 1: Establish baseline**
```bash
# Run Lighthouse on production
# Document all metrics (LCP, FID, CLS, etc.)
# Run Chrome DevTools profiling
# Measure bundle size
```

**Step 2: Identify bottlenecks**
- Screenshot Lighthouse report
- Use Chrome DevTools to profile:
  - Performance tab (timeline)
  - Coverage tab (unused CSS/JS)
  - Network tab (slow assets)
- Analyze bundle with `bun build --analyze`

**Step 3: Prioritize optimizations**
- Quick wins (font loading, images)
- High impact (code splitting, bundle reduction)
- Medium effort (caching, queries)

### Phase 7.2: Implement Optimizations (4-7 hours)

**Priority order**:
1. Image optimization (1-2 hours) — High impact, quick
2. Code splitting (1-2 hours) — High impact, medium complexity
3. Bundle reduction (1-2 hours) — High impact, medium complexity
4. Font optimization (30 min - 1 hour)
5. Caching strategy (1 hour)
6. Database queries (1 hour)
7. Lazy loading (30 min - 1 hour)
8. Critical CSS (30 min)

### Phase 7.3: Measure & Iterate (1-2 hours)

**Step 1: Re-measure after each optimization**
- Run Lighthouse again
- Compare metrics to baseline
- Document improvements

**Step 2: Identify remaining bottlenecks**
- Repeat profiling
- See what's new slowest

**Step 3: Iterate**
- Implement next optimization
- Measure again
- Repeat until target metrics reached

---

## Success Criteria

| Metric | Target | Status |
|--------|--------|--------|
| **Lighthouse Score** | 95+ | TBD |
| **LCP** | < 2.5s | TBD |
| **FID** | < 100ms | TBD |
| **CLS** | < 0.1 | TBD |
| **TTI** | < 3.8s | TBD |
| **TTFB** | < 200ms | TBD |
| **Bundle Size** | < 100KB gzipped | TBD |

**Measurement tool**: Google Lighthouse (`bun run build && bun run start`, then run Lighthouse)

---

## Testing Checklist

### Measurement Tests
- [ ] Establish baseline (Lighthouse score, Core Web Vitals)
- [ ] Measure after each optimization
- [ ] Document before/after metrics
- [ ] Check mobile performance (likely slower than desktop)

### Core Web Vitals Tests
- [ ] LCP < 2.5s on fast network (desktop)
- [ ] LCP < 4s on 4G (mobile)
- [ ] FID < 100ms (responsive to clicks)
- [ ] CLS < 0.1 (no unexpected shifts)

### Browser Tests
- [ ] Chrome (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Edge (latest)
- [ ] Mobile Chrome
- [ ] Mobile Safari

### Device Tests
- [ ] Desktop (modern, fast)
- [ ] Laptop (older, slower)
- [ ] Mobile (high-end)
- [ ] Mobile (low-end, 4G connection)

### Network Tests
- [ ] Fast network (cable, fiber)
- [ ] Slow network (4G, 3G)
- [ ] Offline (Service Worker caching)

---

## Git Workflow

### Branch
```bash
git checkout -b feat/performance-optimization
```

### Commits (per optimization)
1. `feat: Optimize images (WebP, responsive sizes, lazy loading)`
2. `feat: Implement code splitting (route-based, component-based)`
3. `feat: Reduce bundle size (remove unused deps, tree-shake)`
4. `feat: Optimize fonts (preload, font-display: swap)`
5. `feat: Implement caching strategy (browser, CDN, service worker)`
6. `feat: Optimize database queries (batch, indexes)`
7. `feat: Implement lazy loading (Intersection Observer)`
8. `feat: Extract critical CSS (inline above fold)`
9. `feat: Set up performance monitoring (Vercel Analytics)`
10. `fix: Final performance optimizations and tuning`

### PR Strategy
- Single PR with all optimizations
- Include Lighthouse reports (before/after)
- Document performance improvements
- Verify no regressions

---

## Timeline Breakdown

| Task | Duration |
|------|----------|
| Performance audit | 1-2 hours |
| Image optimization | 1-2 hours |
| Code splitting | 1-2 hours |
| Bundle reduction | 1-2 hours |
| Font & CSS optimization | 1 hour |
| Caching strategy | 1 hour |
| Database optimization | 1 hour |
| Lazy loading | 30 min - 1 hour |
| Monitoring setup | 30 min |
| Measure & iterate | 1-2 hours |
| **TOTAL** | **6-10 hours** |

---

## Next Steps

1. ✅ **Specification complete** (this document)
2. ⏳ **User decision**: Any performance targets beyond defaults?
3. ⏳ **Delegation to codex-rider** for execution
4. ⏳ **Baseline measurement** — Establish current performance
5. ⏳ **Progressive optimization** — Measure after each step
6. ⏳ **Final validation** — Verify target metrics achieved

---

## Notes for Execution

- **Measure first** — You can't optimize what you don't measure
- **Profile before fixing** — Identify real bottlenecks, not guesses
- **Test on slow devices** — Performance on iPhone SE, Android mid-range
- **Test on slow networks** — 4G throttling in DevTools
- **Iterate progressively** — One optimization at a time, measure impact
- **Monitor production** — Set up alerts for performance regressions
- **Document decisions** — Record why each optimization was chosen

---

**Phase 7 Specification Ready**

Next: Confirm performance targets + delegate to codex-rider (after Phase 6)

*Luxi Oracle — 2026-07-03*
