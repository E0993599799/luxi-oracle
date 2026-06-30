---
title: Dashboard Redesign Documentation Index
author: Khun-Ram Oracle (Fleet Documentation Authority)
date: 2026-06-28
status: SKELETON — 7 templates prepared for team to fill in
---

# Dashboard Redesign Documentation Index

> All 7 documentation skeletons for the tham-oracle Dashboard Redesign project are ready. Each has clear placeholders for the team to fill in during development.

---

## The 7 Documents

### 1. **Architecture Document** (01-Architecture.md)

**Owner**: Build team (with Luxi input on design decisions)

**Purpose**: System design — how data flows from APIs to UI

**Sections**:
- Overview & tech stack
- System architecture diagram
- Data flow (request → response cycle)
- API contracts (fleet-status, phase-progress, active-missions, memory-health)
- State management strategy
- Performance targets
- Future extensions

**Placeholders**: (FILL: polling strategy, caching, error handling, Thai text support)

**Status**: Ready for build team to complete

---

### 2. **API Reference** (02-API-Reference.md)

**Owner**: Build team (backend developer)

**Purpose**: Endpoint specification — exactly what each API returns

**Sections**:
- Base URLs (staging & production)
- Authentication & rate limiting
- Endpoint schemas for all 5 APIs:
  - `/api/fleet-status`
  - `/api/phase-progress`
  - `/api/active-missions`
  - `/api/memory-health`
  - `/api/git-state`
- Error response format
- Polling strategy
- Testing instructions

**Placeholders**: (FILL: actual response formats, error cases, testing URLs)

**Status**: Ready for backend developer to implement & fill in

---

### 3. **Component Library** (03-Component-Library.md)

**Owner**: Luxi Oracle (design & specification)

**Purpose**: UI specification — what each component looks like and behaves

**Sections**:
- Design principles (Luxi's golden rules)
- Fleet Health Card spec
- Phase Progress Tracker spec
- Active Missions Board (kanban-light) spec
- Memory Health Indicator spec
- Git State Badge spec
- Circuit Breaker Status spec
- Layout (desktop/tablet/mobile)
- Dark mode color palette
- Thai language support
- Accessibility requirements

**Placeholders**: (FILL: visual mockups, color codes, hover states, responsive breakpoints)

**Status**: Ready for Luxi to fill in visual design details

---

### 4. **Metrics Glossary** (04-Metrics-Glossary.md)

**Owner**: ธาม Oracle (with Luxi input)

**Purpose**: Non-technical guide to what every number means

**Sections**:
- Fleet health metrics (active, stale, cold, abandoned, zygote)
- Circuit breaker states (CLOSED, HALF_OPEN, OPEN)
- Phase status meanings (COMPLETED, IN_PROGRESS, BLOCKED, NOT_STARTED)
- Mission priority definitions (P0, P1, P2, P3)
- Memory health interpretation
- Git state metrics
- 3-second reading flow (Luxi's golden rule)

**Placeholders**: (FILL: thresholds, Thai labels, refinements based on team experience)

**Status**: Ready for ธาม & team to define meanings

---

### 5. **QA & Testing Checklist** (05-QA-Checklist.md)

**Owner**: QA team

**Purpose**: Complete test suite before merge to main

**Sections**:
- Build & deployment checks
- Performance targets (< 3 seconds)
- Visual & design verification (Luxi sign-off)
- Thai language support testing
- Dark mode accessibility
- WCAG AA compliance
- API integration testing
- Polling & real-time updates
- Error handling scenarios
- Browser compatibility
- Mobile-specific testing
- Security checks
- Edge case testing
- Regression testing
- Documentation verification

**Placeholders**: (FILL: specific test cases, browser list, device list)

**Status**: Ready for QA team to execute before merge

---

### 6. **Deployment Runbook** (06-Deployment-Runbook.md)

**Owner**: DevOps / Platform team

**Purpose**: Step-by-step procedures for deploying to staging & production

**Sections**:
- Pre-deployment checklist
- Deployment to staging (build → deploy → smoke test → sign-off)
- Deployment to production (final checks → deploy → verify → monitor)
- Rollback procedures (if something breaks)
- Monitoring & alerting setup
- Troubleshooting guide (common errors & fixes)
- Deployment log template

**Placeholders**: (FILL: deployment commands, monitoring tools, rollback strategies)

**Status**: Ready for DevOps to complete with actual deployment procedures

---

### 7. **User Guide** (07-User-Guide.md)

**Owner**: Luxi Oracle (with Khun-Ram support)

**Purpose**: How users/team reads the dashboard in 3 seconds

**Sections**:
- What is the dashboard?
- Dashboard at a glance (visual)
- 3-second reading flow (each section explained)
- What each metric means (fleet health, phase, missions, lanes)
- Common scenarios (green status, blocked phase, P0 blocked, oracles down)
- Updating & refreshing data
- Troubleshooting
- Getting help contacts
- Keyboard shortcuts & tips

**Placeholders**: (FILL: screenshots, support email, full documentation link)

**Status**: Ready for Luxi to add design screenshots & polish language

---

## How to Use These Documents

### For Luxi Oracle (Design Lead)

1. Start with **Component Library** (03) — define all visual specs
2. Review **Metrics Glossary** (04) — ensure terminology is clear
3. Complete **User Guide** (07) — add screenshots, visual walkthrough

### For Build Team (Frontend + Backend)

1. Read **Architecture** (01) — understand the system
2. Implement endpoints in **API Reference** (02)
3. Build components per **Component Library** (03)
4. Verify everything works per **QA Checklist** (05)

### For ธาม Oracle (Coordinator)

1. Review **Metrics Glossary** (04) — confirm definitions make sense
2. Approve **Architecture** (01) — sign off on design
3. Review **Deployment Runbook** (06) before deployment

### For DevOps / Platform Team

1. Read **Deployment Runbook** (06)
2. Set up monitoring & alerting (Deployment Runbook section)
3. Prepare staging & production environments
4. Execute deployment steps

### For QA Team

1. Review **QA Checklist** (05)
2. Execute all test cases before merge
3. Sign off when all items pass

### For Users / Team Members

1. Read **User Guide** (07)
2. Bookmark the dashboard
3. Use 3-second reading flow daily

---

## Document Ownership & Sign-Off

| Document | Owner | Status | Signed Off? |
|----------|-------|--------|------------|
| 01-Architecture | Build team | Skeleton | ☐ |
| 02-API-Reference | Backend dev | Skeleton | ☐ |
| 03-Component-Library | Luxi Oracle | Skeleton | ☐ |
| 04-Metrics-Glossary | ธาม Oracle | Skeleton | ☐ |
| 05-QA-Checklist | QA Team | Skeleton | ☐ |
| 06-Deployment-Runbook | DevOps | Skeleton | ☐ |
| 07-User-Guide | Luxi Oracle | Skeleton | ☐ |

---

## Timeline Recommendation

**Phase 1** (Days 1-2):
- [ ] Luxi completes Component Library (03)
- [ ] ธาม finalizes Metrics Glossary (04)
- [ ] Build team completes Architecture (01)

**Phase 2** (Days 3-5):
- [ ] Backend dev implements API endpoints & fills in API Reference (02)
- [ ] Frontend dev builds components & fills in Architecture
- [ ] DevOps prepares environments & completes Deployment Runbook (06)

**Phase 3** (Days 6-7):
- [ ] QA executes full test suite per QA Checklist (05)
- [ ] Luxi completes User Guide (07)
- [ ] ธาม reviews all documents

**Phase 4** (Day 8):
- [ ] Deploy to staging → sign-off
- [ ] Deploy to production → sign-off
- [ ] Team uses dashboard with User Guide

---

## How to Contribute

Each document has **(FILL: ...)** placeholders. As you work:

1. Remove the placeholder once filled
2. Update the status in the table above
3. Add your name to the sign-off line in the document
4. Commit changes with clear messages: `docs: Add [specific detail]`

Example:
```markdown
OLD:
**Polling Interval**: (FILL: 30s per brief?)

NEW:
**Polling Interval**: 30 seconds (confirmed in brief)
```

---

## Key Principles

All 7 documents follow these principles:

1. **Nothing is Deleted** — All drafts, decisions, edge cases preserved in history
2. **Patterns Over Intentions** — Docs reflect what actually works, not what was planned
3. **External Brain, Not Command** — Docs clarify; humans decide
4. **Curiosity Creates Existence** — Questions are encouraged, answered in docs
5. **Form and Formless** — Docs balance structure (templates) with meaning (content)
6. **Transparency** — AI work signed with [MARCUZ:Khun-Ram], humans have final say

---

## Quick Reference

**Skeleton Created**: 2026-06-28
**Prepared By**: [MARCUZ:Khun-Ram] — Khun-Ram Oracle, Royal Scribe

**Status**: All 7 documents ready for team to fill in and develop

**Next Steps**: 
1. Share these docs with team
2. Assign each document to an owner
3. Begin filling in FILL: placeholders
4. Track progress in document sign-off table above

---

**[MARCUZ:Khun-Ram]** — Fleet Documentation Authority 📜

*"เขียนแผนที่ให้ผู้เดินทางเห็นชัด"*  
*(Write the map so travelers see clearly)*

---

## File Listing

```
dashboard-redesign-2026-06/
├── README.md                          ← You are here
├── 01-Architecture.md                 ← System design
├── 02-API-Reference.md                ← API endpoints
├── 03-Component-Library.md            ← UI components
├── 04-Metrics-Glossary.md            ← What metrics mean
├── 05-QA-Checklist.md                ← Testing checklist
├── 06-Deployment-Runbook.md          ← How to deploy
└── 07-User-Guide.md                  ← How to read dashboard
```

---

**All 7 skeleton templates prepared and ready to go.**

*Luxi, build team, QA, DevOps: your blueprints await. Fill them in as you work.*

*[MARCUZ:Khun-Ram]* — Ready to document this journey 📜
