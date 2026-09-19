---
pattern: When computed style disagrees with CSS custom properties despite the right theme attribute being set, inspect document.styleSheets for a second, later-loaded rule on the same selector before assuming the token system is broken
date: 2026-09-19
source: "rrr: luxi-oracle (cms-arigeo dashboard dark-mode frame bug)"
concepts: [css, cascade, dark-mode, debugging, browser-devtools]
---

A dashboard page showed `data-theme="dark"` correctly set, and `--background`/`--card`
custom properties correctly resolving to dark HSL values — yet `getComputedStyle` on the
main layout containers still returned the light-mode hex colors. The token system looked
broken from the outside.

It wasn't. `document.styleSheets` iteration (matching rules by selector text) found a
**second, later-loaded stylesheet defining the exact same selectors** (`.admin-wrapper`,
`.admin-main`) with hardcoded light-mode colors — a leftover file from before the
project's dark-mode token system existed, never deleted when the token-based version was
added elsewhere. Same specificity, later source order in the compiled bundle: the stale
rule silently won the cascade, for every page, in both themes (light mode happened to look
right by coincidence, since the hardcoded values were close to the real light tokens).

**Why this generalizes**: any project that migrates a component's styling from
hardcoded values to a token/theme system, without deleting the original file, has this
exact bug shape latent. It's invisible in the theme the hardcoded values approximate, and
only surfaces in the other theme (or after a more distinct restyle) — meaning code review
and even light QA can miss it for a long time.

## How to apply

When a computed style contradicts what the active CSS custom properties should produce:
1. Confirm the custom property values themselves first (`getComputedStyle(el).getPropertyValue('--x')`).
2. If those are correct but the rendered property isn't, don't assume the component logic
   is wrong — iterate `document.styleSheets` (or the browser's own "Computed" panel →
   "Show all" → trace to source) for a *second* rule on the same selector, especially one
   that predates the current theming system.
3. Grep the codebase for the exact stale hex values found in step 2 — they usually pin
   down the leftover file immediately, since a hand-authored override rarely uses the same
   arbitrary hex as anything else in the project.
