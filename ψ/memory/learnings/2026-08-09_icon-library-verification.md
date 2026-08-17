---
name: icon-library-verification
description: Verify icon availability before importing — prevents deployment failures
metadata:
  type: feedback
  category: process
  ttl: ∞
  priority: medium
---

# Icon Library Verification Before Import

**Pattern**: Checking icon names against library docs first, not via deployment errors.

**Why**: When integrating a UI icon library (lucide-react, FontAwesome, Material Icons), the assumption is that "icon library = all common icons." Not true. Lucide-react omits brand-specific icons (Facebook, Instagram, Twitter, Youtube) due to trademark concerns. Discovering this via failed deployment (3x retry cycle) instead of docs lookup costs 15+ minutes and breaks focus flow.

**How to apply**: Before editing any file that imports from an icon library, run a quick verification:

```bash
# For lucide-react:
npm list lucide-react && node -e "
const icons = require('lucide-react');
const needed = ['Facebook', 'Instagram', 'Twitter', 'Youtube'];
needed.forEach(i => console.log(i, ':', i in icons ? '✓' : '✗'));
"
```

Or for any icon library, read the docs for "complete icon list" or search the package README for "brand" or "social."

**Trade-off**: 10 seconds of verification vs. 15 minutes of deployment failures + context-switch tax.

**Related**: [[lucide-react-available-alternatives]] (if created: use Globe for website/social, Camera for photo/instagram, AtSign for handles, Video for youtube)

---

## Session Context

**Session**: 2026-08-09 Captain Maid Icon Modernization  
**Lesson source**: Deployment failure #1 when contact page tried to import `Youtube`, `Facebook`, `Instagram`, `Twitter` icons.

**Evidence**:
- Commit: `ede2372` (first fix: Youtube → Video)
- Commit: `beba9ac` (second fix: all social icons → generic alternatives)
- Deployment errors: 3 "not exported from lucide-react" failures before resolution

**Impact**: If verified upfront, would have prevented 2/3 failed deployments and saved 15 minutes. TypeScript type-checking passes (syntax OK), but runtime import fails (icon doesn't exist in library).

---

## Generalization

This applies to **any third-party library with large option sets**:
- Icon libraries (Feather, Material, Font Awesome, Heroicons)
- Color palettes (Tailwind, Material Design)
- Font families (Google Fonts, web safe fonts)
- Component libraries (shadcn/ui, Chakra, MUI)

Before writing code that depends on a specific named resource from a large library, verify the resource exists. A 10-second check beats a 30-second deployment failure.

---

## Next Session Application

When working on Captain Maid Phase 4 (payment integration), check icon availability for:
- `CreditCard`, `Lock`, `CheckCircle` (or variants) in lucide-react
- Do this *before* updating components

Apply: `node -e "const icons = require('lucide-react'); ['CreditCard', 'Lock', 'CheckCircle2'].forEach(i => console.log(i, i in icons ? '✓' : '✗'))"`

If any are missing, choose alternatives or use a different library.
