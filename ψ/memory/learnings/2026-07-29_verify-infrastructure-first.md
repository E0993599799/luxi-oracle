---
pattern: Verify infrastructure exists before proposing to build it
date: 2026-07-29
source: rrr: luxi-oracle
concepts: ["Rule 5", "architecture", "verification", "duplication-risk"]
---

# Verify Infrastructure First — Don't Duplicate the Bridge

**Pattern:** I proposed building a new webhook endpoint without checking if one already existed. This violated Rule 5 (Verify capability before committing to it) and risked creating duplicate infrastructure.

**The Mistake:**

1. Asked user: "Should I build a webhook receiver for incoming LINE messages?"
2. Generated detailed Option B plan with new `/api/webhooks/line` endpoint
3. User corrected me: "We already have `controlfleet.vercel.app/api/line/webhook` in production"

Result: Would have created a second webhook, split state between two services, and added unnecessary complexity.

**The Right Protocol:**

Before suggesting to build infrastructure X:

1. **Search git history (24h)** — did someone set up X recently?
2. **Check related projects** — does X exist in a sibling service?
3. **Read config files** — is X already wired up?
4. **Ask the team** — where does X currently live?
5. **THEN propose** — extend it, don't rebuild it

**Time investment:** 5 minutes of verification saves 5 hours of debugging two parallel systems.

**Why This Matters:**

- **Duplication splits state** — Messages stored in two places are doubly lost
- **Maintenance multiplies** — Updates to one webhook might miss the other
- **Debugging nightmare** — Is the message in webhook A or webhook B?
- **Signals fragmentation** — No single source of truth

**How to Apply:**

When about to commit to "I'll build X system":
- Grep for X in git log (last 72 hours)
- Check control_fleet, mission-control, and any other shared services
- Read `.env`, `config/`, and recent PRs
- Ask user: "Is there already a [webhook/queue/API] for this?"

If yes → extend it.  
If no → build it.  
If unsure → ask first.

**Related:** HARD-RULE 5, Line Bridge Architecture pattern

---

*Caught by user correction, saved as learning. Prevents pattern repetition.*
