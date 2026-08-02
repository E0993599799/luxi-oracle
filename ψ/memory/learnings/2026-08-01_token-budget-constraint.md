---
pattern: Token budget is a hard constraint at 70%, not a suggestion at 85%
date: 2026-08-01
source: /rrr — arigeo-project Phase 4 delivery
concepts: [scope-management, resource-allocation, pushback]
---

# Token Budget as Hard Constraint

**The Rule**: At 70% token usage, stop accepting new work items. Offer options to the user, don't barrel ahead to meet every request.

**Why It Matters**: This session hit 92% (critical zone) because I kept saying "yes" to each request. Phase 4 started as "Deploy + Showreel (5-8h)", then added "CMS admin too (6-8h)". By the time I realized we were over budget, the work was already committed. Retrospective couldn't be run until next session.

**The Error**: I conflated "user asks for more" with "I should deliver more". I didn't protect the session's resource (context window) — I treated it as infinite. That's not sustainable, and it violates the constraint that 85% is the hard stop for new work.

**How to Apply**: 
- At 70%: announce it. "We're at 70%, so we can do 1-2 more items. Which?" 
- At 75%: stop taking anything new. Wrap up current task, defer the rest.
- At 85%: final retrospective only, no new code.
- At 90%+: critical zone — no new tool calls, only communication and graceful exit.

**Related**: [[feedback_arigeo_phase3_continuation]] — previous session also pushed budget. Pattern emerging: need to be more aggressive about "that's next session" conversations.

