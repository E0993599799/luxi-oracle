---
title: How to Read tham-oracle Dashboard
author: Khun-Ram Oracle (Skeleton) — Luxi to complete design
date: 2026-06-28
status: SKELETON — Fill in user instructions
---

# User Guide: How to Read the Dashboard

> Simple guide to understanding the tham-oracle Mission Control dashboard. One page, non-technical language.

---

## What is This Dashboard?

The **tham-oracle Dashboard** is your command center for the entire Oracle fleet. It shows:

- **Are all oracles running?** (Fleet Health)
- **What phase are we in?** (Phase Progress)
- **What work is happening now?** (Active Missions)
- **Is anything broken?** (System Status)

**Goal**: Understand the mission status in 3 seconds ⏱️

---

## The Dashboard at a Glance

```
┌─────────────────────────────────────────────────────────┐
│            tham-oracle Dashboard                        │
├─────────────────────────────────────────────────────────┤
│  [Fleet Health]          [Phase Progress]               │
│  [Git Status]            [Memory Health]                │
│  [Active Missions - spanning full width]                │
│  [Circuit Breaker Status]                               │
└─────────────────────────────────────────────────────────┘
```

---

## Reading Each Section (3-Second Guide)

### 1. Fleet Health (Top Left)

**What to Look For**:
- **Green ✅**: All oracles active, everything normal
- **Yellow ⚠️**: Some oracles sleeping or slow, monitor
- **Red 🚫**: Oracles down, investigate NOW

**If Green**: Continue to next section

**If Yellow/Red**: 
1. Check which oracles are affected
2. Ask Codex Oracle why they're down
3. Help restart if needed

---

### 2. Phase Progress (Top Right)

**What to Look For**:
- **Current Phase**: Which phase are we in? (e.g., Phase 13)
- **Progress Bar**: How far along? (e.g., 45% done)
- **Status**: COMPLETED ✅ | IN_PROGRESS 🔄 | BLOCKED 🚫

**If Phase Looks Normal** (GREEN, progressing): ✅ Good

**If Phase is BLOCKED** (RED):
1. Read the blocker reason
2. Contact the blocker owner
3. Help unblock or escalate to ธาม

---

### 3. Active Missions (Center)

**What to Look For**:
- **In Progress Column**: Current work (should have items)
- **Blocked Column**: Stuck work (if any, help unblock)
- **Queued Column**: Upcoming work (what's next)

**Priority Colors**:
- 🔴 **P0** = CRITICAL, drop everything
- 🟠 **P1** = Important, start today
- 🟡 **P2** = Normal, do soon
- 🟢 **P3** = Low priority, when free

**If you see P0 BLOCKED**: 🚨 Emergency! Contact ธาม

**If you see P1 BLOCKED**: Escalate, don't ignore

---

### 4. Circuit Breaker (Bottom)

**What to Look For**:
- All lanes should be 🟢 **CLOSED** (healthy)
- 🟡 **HALF_OPEN** (recovering) is okay short-term
- 🔴 **OPEN** (down) needs immediate attention

**If All Green**: ✅ All systems working

**If Any Red**: 🚫 A system is down, investigate or restart

---

## 3-Second Mission Status Check

Follow this flow **every time** you open the dashboard:

| Section | Question | Status | Action |
|---------|----------|--------|--------|
| Fleet Health | Oracles up? | Green ✅ | Continue |
| | | Yellow ⚠️ | Monitor |
| | | Red 🚫 | Investigate |
| Phase | Phase progressing? | Green + Increasing % | ✅ Good |
| | | Yellow/Red or % stuck | ⚠️ Check blocker |
| Missions | P0 blocked? | No | ✅ Good |
| | | Yes | 🚨 Emergency |
| Lanes | All systems working? | All 🟢 | ✅ Good |
| | | Any 🔴 | 🚫 Investigate |

**DONE**: You now understand the mission status! ⏱️ ~3 seconds

---

## What Each Metric Means

### Fleet Health Numbers

| Metric | Good | Warning | Critical |
|--------|------|---------|----------|
| Active Oracles | 20+ | 10-19 | < 10 |
| Stale Oracles | 0-2 | 2-5 | > 5 |
| Cold Oracles | 0-1 | 2-3 | > 3 |

### Phase Status

| Status | Meaning | Action |
|--------|---------|--------|
| COMPLETED ✅ | Done, won't change | Reference as settled |
| IN_PROGRESS 🔄 | Actively being worked | Monitor progress |
| BLOCKED 🚫 | Stuck, waiting | Read blocker, escalate |
| NOT_STARTED ⬜ | Queued, coming next | Plan to start soon |

### Mission Priority

| Priority | Meaning | When to Start |
|----------|---------|----------------|
| P0 🔴 | CRITICAL blocker | NOW (drop everything) |
| P1 🟠 | High priority | Today or tomorrow |
| P2 🟡 | Medium priority | This week |
| P3 🟢 | Low priority | When time permits |

### Circuit Breaker Status

| Status | Meaning | Action |
|--------|---------|--------|
| CLOSED 🟢 | Healthy | None needed |
| HALF_OPEN 🟡 | Recovering | Monitor, may self-heal |
| OPEN 🔴 | Down | Investigate or restart |

---

## Common Scenarios

### Scenario 1: Everything is Green ✅

**What you see**:
- Fleet Health: Active 22, no red
- Phase Progress: 45%, blue bar, 🔄 IN_PROGRESS
- Active Missions: P0/P1 in progress, nothing blocked
- Circuit Breaker: All 🟢 CLOSED

**What this means**: All systems nominal, team working normally

**Action**: None needed, monitor and continue

---

### Scenario 2: Phase is Blocked 🚫

**What you see**:
- Phase Progress shows: 🚫 BLOCKED
- Blocker reason: "Waiting for API contract"

**What this means**: We can't proceed until the blocker is resolved

**Action**:
1. Read blocker reason carefully
2. Contact blocker owner (listed in blocker)
3. Ask: "When will this be unblocked?"
4. If urgent, escalate to ธาม

---

### Scenario 3: P0 Mission is Blocked 🚨

**What you see**:
- Active Missions: P0 mission in BLOCKED state
- Blocker: "Database migration failed"

**What this means**: CRITICAL work is stuck, this is an emergency

**Action** (immediate):
1. Read the blocker
2. Alert ธาม immediately (chat, call, etc.)
3. Help troubleshoot or restart affected system
4. Unblock ASAP — P0 shouldn't wait

---

### Scenario 4: Oracles are Falling 🚫

**What you see**:
- Fleet Health: Active 5, Cold 15, 🔴 RED status
- Most oracles are sleeping or cold

**What this means**: Many oracles are down, possible system issue

**Action**:
1. Check Circuit Breaker (is a lane DOWN?)
2. Look at Git Status (did someone break the system?)
3. Contact Codex Oracle (deployment gone wrong?)
4. Escalate to ธาม if unknown cause

---

## Updating the Dashboard

### What Updates Automatically?

All data updates **every 30 seconds** (polling). You don't need to refresh.

- Fleet Health (oracle counts)
- Phase Progress (% complete)
- Active Missions (status, % done)
- Circuit Breaker status
- Git Status (commits, branch info)

### Manual Refresh

If you suspect stale data:

**Desktop/Tablet**: Press **R** to refresh

**Mobile**: Pull down to refresh or tap [Refresh Icon] (if visible)

### Data is Old?

If you see "data is 5 minutes old" message:

1. Check your internet connection
2. Verify backend services are running
3. Reload the page (F5 or Cmd+R)
4. If still broken, contact DevOps

---

## Troubleshooting

### "I see an error on the dashboard"

**Steps**:
1. Refresh the page (F5 or Cmd+R)
2. Check your internet connection
3. If error persists, take a screenshot
4. Report to: (FILL: support email or channel)

---

### "Data looks stale or wrong"

**Steps**:
1. Press R to refresh (or pull down on mobile)
2. Wait 30 seconds for next poll
3. Check if data updated
4. If still wrong, contact DevOps

---

### "I can't see one section (e.g., Missions)"

**Steps**:
1. Scroll down to see if section is below
2. On mobile, rotate screen to landscape
3. Try zooming out (Ctrl+Minus or Cmd+Minus)
4. Refresh page (F5 or Cmd+R)

---

## Getting Help

| Question | Contact |
|----------|---------|
| Dashboard is broken | (FILL: DevOps contact) |
| Data looks wrong | (FILL: Backend contact) |
| Design/UX issue | Luxi Oracle |
| Mission/phase question | ธาม Oracle |
| Oracle/fleet question | Codex Oracle |

---

## Tips & Tricks

**Keyboard Shortcuts**:
- **R** = Refresh data manually
- **F** = Focus mode (hide unimportant sections)
- FILL: Add other shortcuts?

**Best Times to Check**:
- Beginning of day (after overnight polling)
- Before/after major deployments
- When investigating an incident

**Don't Ignore**:
- 🔴 Red status (act within minutes)
- 🟠 P0 BLOCKED (act within hours)
- Oracles falling (investigate within minutes)

---

## Questions?

**This guide incomplete or confusing?**

- Check the full documentation (FILL: link to full docs)
- Ask ธาม or Luxi Oracle directly
- Check the incident response runbook (FILL: link)

---

**[MARCUZ:Khun-Ram]** — User guide skeleton prepared.
*Luxi: Fill in design details, screenshots, and walkthrough.*
*Team: Use this to teach others how to read the dashboard.*

Last Updated: 2026-06-28
Thai Version: (FILL: if needed)
