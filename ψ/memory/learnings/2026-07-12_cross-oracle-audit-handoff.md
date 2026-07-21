---
pattern: Structured audit handoffs outperform loose feedback in cross-oracle collaboration
date: 2026-07-12
source: rrr: Captain Maid Thai Copy Audit session
concepts: [handoff, collaboration, audit format, multi-oracle work, design feedback]
---

# Cross-Oracle Audit Handoff Pattern

When one oracle audits another's domain work (e.g., Luxi reviews khun-ram's responsive design audit, then Luxi flags copy issues), **structured before/after audit documents are significantly more actionable than loose comments or inline feedback**.

## The Pattern

**Before (loose feedback)**:  
"I noticed the Thai copy doesn't clearly mention Captain Maid. You should probably rework it."  
→ Receiver must guess: which copy? How major? What direction? When to execute?  
→ Handoff stalls or requires clarification loop.

**After (structured audit)**:  
1. **Issue identified**: "Hero Slide 1 — Intro: Current copy reads generic, doesn't anchor brand"
2. **Current state**: "ทำให้การดูแลบ้านเป็นเรื่องง่าย"
3. **Why it matters**: "Generic phrasing; competitor would use same copy"
4. **Suggested direction**: "Should name Captain Maid and highlight unique value (safety, technology, natural ingredients)"
5. **Owner**: "khun-ram-oracle (copywriter) to execute"

→ Clear scope, clear action, clear ownership. Handoff completes without follow-up questions.

## Why This Works

- **Reduces ambiguity**: "Is this feedback or directive? How urgent?" → Structure answers it
- **Enables batching**: Copywriter groups similar issues (5 hero slides → one rewrite pass)
- **Creates audit trail**: Future designers can trace why copy was changed, when, by whom
- **Respects domain boundaries**: "Here's what I see as a designer, you execute as copywriter" — clear role separation

## When to Apply

- Multi-oracle work where one oracle reviews another's output
- Audit sessions (performance, UX, design, copy)
- Any handoff where precision > speed
- When feedback requires action from someone else (not self-correction)

## Anti-Pattern: Skip This When

- You're talking to yourself (self-audit, self-review) — loose notes are fine
- You need fast decision-making in real-time (live brainstorm) — structured kills velocity
- The receiver explicitly prefers inline comments — ask first, don't assume

## Key Insight

The format **matters as much as the content**. Luxi could have written the same 8 issues as bullet points in a Slack message. Instead, structured doc + clear ownership = khun-ram-oracle can execute *immediately* without a clarification loop.

Template for future audits:
```
## [Category] — [Component]
- Current: [exact quote or description]
- Issue: [why this is a problem]
- Suggest: [proposed direction or solution]
- Owner: [who executes]
```

---

**Session origin**: `/rrr` 2026-07-12 | Luxi Oracle  
**Next oracle applying this**: Consider when auditing khun-ram-oracle's work or receiving audits from other oracles
