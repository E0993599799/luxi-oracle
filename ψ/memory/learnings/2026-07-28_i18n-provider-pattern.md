---
pattern: Framework hooks require their providers at the config layer before runtime
date: 2026-07-28
source: rrr: arigeo-project deployment fix
concepts: ["next-intl", "provider-pattern", "i18n", "framework-hooks", "deployment"]
---

# Pattern: Framework Hooks Need Config-Layer Providers

When a component uses framework hooks (e.g., `useLocale()`, `useTranslations()`, `useRouter()`), the provider *cannot* be added retroactively at the component level. It must be set up at the **config layer** during initialization:

- Middleware for routing-aware features
- Wrapper plugin in next.config.ts
- Message files in the right directory structure

## Why This Matters

**Build success ≠ Runtime success.** A Next.js build can complete without errors while components fail at runtime if their hooks lack providers. This is a "silent failure in deploy" — the build system doesn't validate hook-provider relationships.

## The Fix Pattern (next-intl example)

1. Create `middleware.ts` with locale routing
2. Add next-intl plugin to `next.config.ts`:
   ```typescript
   import createNextIntlPlugin from "next-intl/plugin";
   export default createNextIntlPlugin()(nextConfig);
   ```
3. Create `i18n.ts` config file
4. Add message files (`src/messages/en.json`, `src/messages/th.json`)

## Verification Checklist

- [ ] Grep codebase for framework hook imports (useLocale, useTranslations, etc.)
- [ ] Find the provider/config files for each hook
- [ ] If missing, add them at config layer *before* first build
- [ ] Test with multiple locale routes (/en, /th) to verify provider works

## Escalation

For new projects using framework hooks, include hook-provider setup in initial scaffold. Add a pre-deploy checklist item: "Verify all imported hooks have providers configured."
