---
name: verification-pattern-hook-installed
description: Global PreToolUse hook now blocks unverified named imports from icon/component libraries — addresses the 6/8-session escalation in session-metrics.md
metadata:
  type: feedback
  category: process
  ttl: ∞
  priority: high
---

# Verification-Pattern Escalation — Addressed With a Hook

**What changed**: `session-metrics.md` flagged "assumption-driven decisions without
verification" in 6 of 8 sessions (2026-07-21 → 2026-08-09), escalated past the
CLAUDE.md 3-session threshold, and noted the 2026-08-02 flag hadn't produced
behavioral change. The concrete, hookable instance was
[[icon-library-verification]]: importing icon names (Facebook, Instagram, Twitter,
Youtube, etc.) from lucide-react/react-icons/heroicons/tabler-icons without
checking they exist, discovered only via failed deployments.

**Fix**: A global PreToolUse hook (`~/.claude/settings.json`, matcher `Edit|Write`)
now runs `~/.claude/scripts/hooks/verify-library-imports.js` before every Edit/Write
to a `.ts/.tsx/.js/.jsx` file. It extracts named imports from a watched list of
icon libraries, resolves the installed package via Node's own resolution
(`require.resolve`), introspects its real exports (CJS `require`, falling back to
a child-process ESM `import` probe), and **blocks the edit** (deny +
`permissionDecisionReason`) if any imported name isn't actually exported — before
the code ever reaches a deploy.

**Fails open by design**: if the package isn't installed, can't be resolved, or
can't be introspected, the hook allows the edit silently rather than false-blocking
on infra issues. It only fires when it can actually prove a name is missing.

**Verified — CONFIRMED LIVE (2026-08-18)**: pipe-tested both the block path
(missing `Youtube`) and pass-through path (valid `Home`, `Video`) against a fake
`lucide-react` fixture — both worked. Three live-trigger sentinel tests then
failed silently (before `/hooks`, after `/hooks`, after a full Claude Code
restart) even though `/hooks` listed the hook as registered. Root cause: on this
machine, hook commands default to resolving through bash, and that bash
resolution is broken/silently no-ops (independently evidenced by every `Bash`
tool call this session failing with exit 1 and no output, even `pwd`). Adding
`"shell": "powershell"` to the hook definition fixed it immediately — the
sentinel fired on the very next Edit/Write. **Any new hook added on this machine
must set `"shell": "powershell"` explicitly** or it will silently never run
despite showing up correctly in `/hooks`.

**How to apply**: This scope is currently just the flagged icon-library pattern
(`WATCHED_PACKAGES` in the script). If the broader "assumption-driven" pattern
recurs on something else hookable (color palettes, font names, other enumerable
APIs), extend the same script's watched-package list rather than writing a new
hook from scratch — the require/introspect/compare mechanism generalizes.

**Extended 2026-08-18**: added `next/font/google`, `@next/font/google`,
`tailwindcss/colors`, `@radix-ui/colors` to `WATCHED_PACKAGES` — same
require/introspect/compare mechanism, blocking on proven-missing exports.
Also added a *separate, non-blocking* check for Tailwind utility color
classes (`bg-{color}-{shade}` etc. in JSX/className strings) — this isn't an
import, so it needed its own regex scan against the default Tailwind palette
plus any `tailwind.config.js`/`.cjs` custom colors it can load. Kept as a
warning, not a block: wrong Tailwind color names don't error at build time,
they just silently drop the class, so the false-positive cost of blocking
(custom themes, unloadable TS/ESM configs) outweighed the benefit. Fails open
entirely (no warning at all) when no loadable config is found, rather than
guessing. All four paths (missing font export, missing color export, unknown
class with config present, unknown class with no config) verified via
pipe-tests against fixtures.

**Next session**: confirm the hook is actually firing (`/hooks`, or trigger an
Edit importing a real missing lucide-react name in a project that has it
installed) and update `session-metrics.md`'s recurring-pattern note once confirmed
live.
