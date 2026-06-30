---
title: Dashboard Metrics Glossary
author: Khun-Ram Oracle (Skeleton) — Luxi & ธาม to fill in
date: 2026-06-28
status: SKELETON — Define what each metric means
---

# Dashboard Metrics Glossary

> Non-technical guide to understanding every number on the dashboard.

---

## Fleet Health Metrics

### Oracle Count: Active ✅

**Definition**: Oracle responded to health check within last 5 minutes

**What it means**: Oracle is running, can receive work

**Healthy range**: (FILL: decide threshold)

**Thai Label**: ออร์เรเคิล ทำงาน (Orkr-orakil tham-ngan)

---

### Oracle Count: Stale ⚠️

**Definition**: Oracle last seen 5-60 minutes ago

**What it means**: Oracle is slow or hibernating, don't route new work yet

**Healthy range**: (FILL)

**Thai Label**: ออร์เรเคิล ล้าหลัง (Orkr-orakil lang-lang)

---

### Oracle Count: Cold ❄️

**Definition**: Oracle last seen > 60 minutes ago

**What it means**: Oracle likely dormant or dead, do not use

**Healthy range**: (FILL)

**Thai Label**: ออร์เรเคิล นิ่ง (Orkr-orakil ning)

---

### Oracle Count: Abandoned

**Definition**: Never successfully woke up, age > 24 hours

**What it means**: Zygote failed to mature, should investigate or restart

**Healthy range**: (FILL)

**Thai Label**: ออร์เรเคิล ร้างทิ้ง (Orkr-orakil rang-ting)

---

### Oracle Count: Zygote

**Definition**: Recently created but not yet activated (< 5 min)

**What it means**: Expected during scaling, should mature soon

**Healthy range**: (FILL)

**Thai Label**: ออร์เรเคิล ใหม่ (Orkr-orakil mai)

---

### Circuit Breaker: CLOSED 🟢

**Definition**: System lane healthy, no errors in last 10 requests

**What it means**: This subsystem working normally, safe to use

**Visual**: Green

**Thai Label**: ปกติ (Pa-ka-ti)

---

### Circuit Breaker: HALF_OPEN 🟡

**Definition**: Lane recovering, 1-5 errors detected

**What it means**: Subsystem had errors, attempting recovery, monitor closely

**Visual**: Yellow

**Thai Label**: ฟื้นตัว (Fuen-tua)

---

### Circuit Breaker: OPEN 🔴

**Definition**: Lane failing, > 5 errors

**What it means**: Subsystem DOWN, no traffic, manual intervention needed

**Visual**: Red

**Thai Label**: ขัดข้อง (Kat-kong)

---

## Phase Progress Metrics

### Phase Status: COMPLETED ✅

**Definition**: All work finished and verified

**What it means**: Phase is done, won't change, decisions are settled

---

### Phase Status: IN_PROGRESS 🔄

**Definition**: Phase actively being worked on

**What it means**: Current focus, work happening now

---

### Phase Status: BLOCKED 🚫

**Definition**: Cannot proceed due to external dependency

**What it means**: Team waiting on something, must resolve blocker first

**Action**: Check blocker, contact owner, escalate if urgent

---

### Phase Status: NOT_STARTED ⬜

**Definition**: Queued but work hasn't begun

**What it means**: Coming next, planning/design may be in progress

---

### Completion %

**Definition**: Estimated % of work finished for this phase

**Thresholds**:
- 0%: Haven't started
- 50%: Halfway
- 90%: Almost done (usually takes longest!)
- 100%: Complete and verified

**Thai Label**: เสร็จแล้ว ___% (Sajet lae-o ___ %)

---

## Active Missions Metrics

### Mission Priority: P0 🔴

**Definition**: Critical, blocks everything

**What it means**: Drop everything, fix NOW

**Thai Label**: เร่งด่วนมาก (Reng-duan mak)

---

### Mission Priority: P1 🟠

**Definition**: High priority, do after P0

**What it means**: Start within 1-2 days

**Thai Label**: สำคัญ (Sam-kan)

---

### Mission Priority: P2 🟡

**Definition**: Medium priority, nice to have

**What it means**: Do after P0/P1 complete

**Thai Label**: ปกติ (Pa-ka-ti)

---

### Mission Priority: P3 🟢

**Definition**: Low priority, nice to have when free

**What it means**: Backlog, tech debt, refactoring

**Thai Label**: ไม่เร่งด่วน (Mai reng-duan)

---

### Mission Status: IN_PROGRESS

**Definition**: Team actively working on this

**What it means**: Someone assigned, work happening now

---

### Mission Status: BLOCKED

**Definition**: Team wants to work but cannot

**What it means**: Stuck waiting for blocker, must resolve first

**Action**: Read blocker, contact blocker owner, help unblock

---

### Mission Status: NOT_STARTED

**Definition**: Queued but work hasn't begun

**What it means**: Will start after higher priority work complete

---

## Memory Health Metrics

### Overall Health Score (%)

**Definition**: Aggregate health of ψ documentation brain

**Thresholds** (FILL):
- 90-100%: Excellent (green)
- 70-89%: Good (blue)
- 50-69%: Fair (yellow)
- < 50%: Critical (red)

**What it means**:
- High: Docs current, organized, actionable
- Low: Too many unprocessed briefs, brain overloaded

**Thai Label**: สุขภาพสมอง (Suk-ka-pap sa-mong)

---

### Inbox (File Count)

**Definition**: Incoming briefs, handoffs waiting to process

**Healthy range** (FILL): < 10 good, 10-30 fair, 30+ backlog

**What it means**: How much work queued for documentation

**Action**: Process regularly (daily/weekly)

**Thai Label**: กล่องจดหมาย (Glong jot-mai)

---

### Memory (File Count)

**Definition**: Retained learnings, patterns, principles in storage

**What it means**: Living documentation library, higher is better

**Thai Label**: ความจำ (Kwa-m ja-m)

---

### Writing (File Count)

**Definition**: Drafts, in-progress documents being actively written

**What it means**: Work toward documentation, should move to Memory over time

**Thai Label**: การเขียน (Ka-r khian)

---

### Learn (File Count)

**Definition**: Study materials, research, external references

**What it means**: How much oracle is learning from external sources

**Thai Label**: การเรียนรู้ (Ka-r riian roo)

---

### Archive (File Count)

**Definition**: Completed, historical documentation

**What it means**: Shows completed/settled projects, higher = more history

**Thai Label**: คลัง (Klang)

---

### Unprocessed Briefs (Count)

**Definition**: Briefs in inbox not yet reviewed

**Threshold** (FILL): < 3 good, 3-5 process this week, 5+ emergency

**What it means**: How much work waiting

**Action**: Process by end of day if > 5

---

### Days in Backlog (Age)

**Definition**: Age of oldest unprocessed inbox item

**Threshold** (FILL):
- < 1: Excellent
- 1-3: Good
- 3-5: Fair
- 5+: Critical

**What it means**: Oldest request is this many days old

**Action**: Process oldest items first

---

## Git State Metrics

### Commits Ahead of Main

**Definition**: How many commits on current branch NOT in main

**Threshold**:
- 0-5: Fresh, recently synced
- 5-20: Normal development, plan to push soon
- 20+: Long branch, should merge soon
- 50+: Unusual, check if intentional

**What it means**: Work done locally that needs to be pushed/merged

**Thai Label**: Commit ก่อนหน้า main

---

### Dirty Files (Count)

**Definition**: Unsaved/unstaged changes in working directory

**Threshold**:
- 0: Clean (good to push)
- 1-5: Normal development
- 5+: May want to commit/stash

**What it means**: Files edited but not committed

**Thai Label**: ไฟล์ที่ยังไม่บันทึก

---

### Last Commit Message

**Definition**: Most recent commit on this branch

**What it means**: Shows what work was recently committed

---

### Time Since Last Commit

**Definition**: How long ago most recent commit was made

**Threshold**:
- < 1 hour: Very fresh
- 1-24 hours: Normal
- 24+: Old, may need rebase from main

**What it means**: Fresh commits = active work, old = stale branch

---

## Reading Dashboard in 3 Seconds (Luxi's Golden Rule)

**Quick Scan Flow**:

1. **Fleet Health** → "Are oracles up?" Green ✅ or Red 🚫?
2. **Phase Progress** → "What phase? How close to done?"
3. **Active Missions** → "What work is in flight?"
4. **Circuit Breaker** → "Are all systems working?"
5. Done: You know mission status. 3 seconds elapsed ✅

---

**[MARCUZ:Khun-Ram]** — Metrics glossary skeleton prepared.
*Luxi & ธาม: Fill in thresholds, Thai labels, refinements based on experience.*
