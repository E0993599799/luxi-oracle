---
pattern: When a visual bug report can't be reproduced after 2-3 targeted checks, ask for the exact URL/page before expanding the search — and verify local code matches what's actually deployed before diagnosing
date: 2026-07-21
source: "rrr: luxi-oracle (work in arigeo-project + cms-arigeo)"
concepts: [debugging, bug-reproduction, deployment-verification, git-staleness, css-object-fit]
---

# Ask for the URL before exhaustive search; verify deployed-vs-local before diagnosing

## The pattern

พี่เอก reported "web arigeo มีโลโก้ซ้อนกันสองอันอีกแล้วนะ" (duplicate logo again) with no URL. I assumed it meant the ARIGEO marketing site (the more prominent property) and spent ~25 minutes screenshotting every page/viewport/locale of `arigeo.vercel.app` — homepage, brands, about, products, newsroom, mobile, mobile-menu-open — all clean. The actual bug was on a *different app*, the Payload CMS admin login page (`cms-arigeo.vercel.app/admin/login`), which happens to share the "arigeo" brand name.

Two compounding mistakes:
1. **Didn't ask for the URL early enough.** After the first 2-3 checks came back clean, that was the signal to ask for specifics, not to keep expanding page/viewport/locale coverage on the same guessed target.
2. **Diagnosed from stale local code.** Both local clones (`cms-arigeo` and `arigeo-project`) were behind their respective `origin/main` / deployed commit. Reading `payload.config.ts` and `ArigeoLogo.tsx` before pulling would have shown code that wasn't actually live, producing a confidently-wrong diagnosis.

## Why it matters

A brand name is not an app identifier — a company can have multiple deployed apps (marketing site, CMS admin, internal tools) sharing a name. Vague bug reports about "the X site" should trigger a clarifying question once initial reproduction attempts fail, not a broader guess-and-check sweep. Separately, "shipped fix isn't working" reports specifically warrant checking local-vs-deployed drift (`git status`, or diffing local HEAD against the hosting provider's reported deployment commit SHA) *before* reading source to diagnose — otherwise you're debugging code the user isn't even looking at.

## How to apply

- After 2-3 targeted checks on a bug report fail to reproduce, stop and ask for the exact URL/page/screenshot rather than expanding coverage (more pages, more viewports, more locales) on the same assumed target.
- Before diagnosing a "regression" or "fix didn't work" report in any repo, run `git fetch` + `git status` (behind/ahead check) and compare against the actual deployed commit (e.g. via `list_deployments` on Vercel) before reading source — stale local code invalidates the diagnosis.
- For CSS sizing/ratio bugs in a framework-owned UI you can't fully inspect live (e.g. Payload admin, a component library's internals), isolate the exact markup + your CSS in a minimal static HTML repro and stress-test it against adversarial assumptions (a hostile ancestor rule forcing conflicting dimensions, an `overflow:hidden` clipped container) — `object-fit: contain` is a more robust general fix for aspect-ratio-under-uncertainty than trying to out-specify an unknown framework rule.

Related: [[2026-07-16_rtk-protocol-token-budget]] if it exists — this session's investigation cost would have been reduced by the same "ask before exhaustive search" discipline the RTK protocol encourages for token budget reasons, though the root motivation here is correctness, not tokens.
