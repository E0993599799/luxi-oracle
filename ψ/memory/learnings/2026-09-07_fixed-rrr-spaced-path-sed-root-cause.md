---
pattern: When a recurring-pattern note names a specific fix and the friction shows up again, apply the fix — don't write a 5th occurrence row
date: 2026-09-07
source: rrr: luxi-oracle
concepts: [retrospective, path-encoding, root-cause-fix, self-evaluation-loop]
---

# Fixed the /rrr skill's spaced-path sed bug at the source instead of logging a 4th occurrence

The `/rrr` skill's `ENCODED_PWD` derivation (`sed 's|^/|-|; s|[/.]|-|g'`) never stripped
spaces, so on this repo's WSL mount path (`/mnt/d/01 Main Work/Boots/Agentic AI/...`) it
silently produced an empty `PROJECT_BASE`. This had already recurred 3 times
(2026-08-19, 2026-09-03, 2026-09-05) and crossed the session-metrics.md ≥3 escalation
threshold, with a concrete suggested fix (`s|[/. ]|-|g`, i.e. add a space to the
character class) already written down — but never applied. It recurred a 4th time on
2026-09-07.

**Why it matters**: the parent CLAUDE.md "Self-Evaluation Loop" rule says same friction
3 sessions → fix root cause, not another workaround. The rule was followed for
*noticing* (three separate memory entries flagged it) but not for *acting* — each
session applied the documented workaround (`ls -d ~/.claude/projects/*<repo>*`) and
moved on, which satisfies the immediate task but leaves the next session to hit the
same bug again.

**How to apply**: `~/.claude/skills/rrr/SKILL.md` was edited directly (4 sites: lines
75, 95, 314, 412) to change the sed pattern to `s|[/. ]|-|g`. Verified before applying
by comparing sed output against the actual directory under
`~/.claude/projects/-mnt-d-01-Main-Work-Boots-Agentic-AI-...` — confirmed exact match.
Generalizable rule: when a recurring-pattern note in `session-metrics.md` names a
specific, mechanical fix (not just "be more careful"), and the same friction shows up
in a later session, treat that as a signal to open and edit the named file — a global
skill file counts, even though it sits outside the current repo's git tree and won't
show up in `git status` here.
