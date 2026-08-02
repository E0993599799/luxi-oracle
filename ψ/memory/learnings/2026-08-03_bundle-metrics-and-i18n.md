---
name: bundle-metrics-and-i18n
pattern: Bundle size ≠ shipped size; distinguish dev node_modules from production runtime
date: 2026-08-03
source: rrr: arigeo-project ARIGEO Phase 1 & 2
concepts: ["performance", "metrics", "measurement", "bundle-size", "next.js", "vercel", "i18n", "architecture"]
---

# Bundle Size Metrics & i18n Architecture Patterns

## Pattern: Bundle Size ≠ Shipped Size

When auditing production readiness, node_modules size (464MB in ARIGEO) is **not the metric that matters**. Vercel's build process automatically:
1. Separates dev dependencies (eslint, typescript, @types/*)
2. Runs `npm ci --omit=dev` during production build (373MB)
3. Outputs to `.next/` which gets shipped (~60MB, but only runtime ~2.8MB ships to users)

**Lesson**: Always measure shipped size (what users download), not installed size. For Next.js/Vercel:
- **Relevant metrics**: `.next/static` (client JS) + `.next/server` (serverless functions)
- **Irrelevant metrics**: node_modules total size, build cache size
- **Verification**: Check `.next/` breakdown and Vercel deployment logs, not package.json deps

**Application**: In future ARIGEO audits, report "2.8MB runtime" not "464MB node_modules" — the latter is a red herring.

---

## Pattern: i18n Context Requires Server-Side Components

next-intl provides i18n context through **server-side layout providers**. Components that call `useTranslations()` must:
1. Be server components (no `"use client"`)
2. Render within a locale segment (inside `[locale]`)
3. Receive context from a server parent

**Blocker**: Attempted to use `useTranslations()` in "use client" components. Error: "useTranslations() called outside i18n context."

**Root cause**: Client components run in browser; server-provided context doesn't cross the client boundary.

**Fix**: Removed `"use client"` from HomeIntroStatement and BrandCarouselSection. These components only display text (no interactivity), so server rendering is appropriate.

**Lesson**: Before adding `"use client"` to a component that uses hooks from a server-provided context, verify the hook is client-safe. For next-intl: `useTranslations()` requires server context, so it forces server-component design.

**Application**: Design i18n components as server-first. Add `"use client"` only when interactivity is needed (event handlers, state), not for static rendering.

---

## Pattern: Partial Deployments Confuse Status

Shipped Thai infrastructure (useTranslations hooked up, message files created) with only 2/6 components integrated, creating ambiguity:
- Status: "Thai page loads" (true, infrastructure works)
- User experience: "Thai page shows English" (true, content incomplete)
- Result: Confusion about whether "Thai is working"

**Lesson**: For features with visible user impact, choose either:
1. **All-or-nothing**: Wait for all 6 components translated before shipping ANY
2. **Infrastructure-only**: Ship without translations, document clearly ("awaiting content")

Mixing both creates false status—infrastructure works, content doesn't, but the deployed page looks broken.

**Application**: For khun-ram's remaining 5 components, either wait for all translations (true ship), or remove the 2 partial translations and document "awaiting translations" clearly. Don't ship half-working features.

---

## Verification

- ✅ Measured actual shipped size (2.8MB via `.next/` breakdown)
- ✅ Verified i18n context mismatch by diagnosis (removed `"use client"` from translation components)
- ✅ Documented Thai status ambiguity in retrospective
- ✅ Set task for khun-ram: complete 5 remaining components OR revert 2 partial translations

