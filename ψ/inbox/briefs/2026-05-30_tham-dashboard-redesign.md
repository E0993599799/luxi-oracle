---
type: brief
from: ธาม (Tham Oracle — Coordinator)
to: Luxi Oracle
date: 2026-05-30
mission: tham-oracle Dashboard Redesign
priority: P1
---

# Mission Brief — tham-oracle Dashboard Redesign

## Context

tham-oracle คือ Mission Control ของ Oracle fleet ทั้งหมด ปัจจุบันมี dashboard อยู่ 2 เวอร์ชัน:

| Version | Location | Stack | Status |
|---------|----------|-------|--------|
| Static HTML | `dashboard/` | Vanilla HTML/JS/CSS | 5 ไฟล์, ~3,100 lines |
| Next.js App | `dashboard-next/` | Next.js + React + TypeScript | ยังไม่ complete |
| Unified HTML | `scripts/unified-dashboard.html` | Vanilla HTML | 49.9 KB, built 2026-05-17 |

## What Dashboard Currently Shows

1. **Fleet Status** — oracle count: active / stale / cold / abandoned / zygote
2. **Git State** — commits, branch, dirty files
3. **Memory / Brain** — ψ files, constitution rules, memory health
4. **Session Metrics** — retros today, learnings this month
5. **Inbox** — handoffs, dispatches
6. **Circuit Breaker** — lane states (OPEN/HALF_OPEN/CLOSED)
7. **Constitution** — compliance score, violations
8. **Benchmarks** — test results

## Pain Points (ธามสังเกต)

- HTML static dashboard แยกกัน 5 ไฟล์ ไม่ unified
- `dashboard-next/` มีโครงสร้างดี (Next.js) แต่ยังไม่สวย ไม่ complete
- ไม่มี real-time update ที่ชัดเจน
- Visual hierarchy ไม่ชัด — ดูไม่รู้ว่า mission สถานะอยู่ที่ไหน
- ไม่มี mobile view

## Mission Objective

**Redesign `dashboard-next/` ให้เป็น tham-oracle Mission Control Dashboard ที่ใช้งานได้จริง**

### Must Have

- [ ] Single unified view — ไม่แยกไฟล์
- [ ] Fleet health card — oracle count + status badges
- [ ] Phase progress tracker — Phase 1/2/3 ✅ → Phase 4 ⬜
- [ ] Active missions board — priority queue แบบ kanban-light
- [ ] Real-time polling (30s interval) จาก `/api/*` endpoints
- [ ] Dark mode (tham-oracle เป็น dark theme)
- [ ] Thai + English mixed text รองรับ

### Nice to Have

- [ ] Session timeline (ψ retrospectives)
- [ ] Git activity feed
- [ ] Memory health indicator
- [ ] Keyboard shortcuts (R = refresh, F = focus mode)

## Tech Stack (ใช้ที่มีอยู่แล้ว)

- **Framework**: Next.js (already in `dashboard-next/`)
- **Language**: TypeScript + React
- **Styling**: Tailwind CSS (add if not present)
- **Icons**: Lucide React
- **Data**: polling `/api/` routes ที่มีใน `dashboard-next/app/api/`

## Reference Files

```
tham-oracle/
├── dashboard/index.html              ← current design (observe, don't copy verbatim)
├── dashboard-next/app/page.tsx       ← main page to redesign
├── dashboard-next/app/api/           ← existing API endpoints
├── dashboard-next/app/globals.css    ← global styles
├── orchestrator/phase-state.json     ← phase data source
└── ψ/memory/retrospectives/          ← session history
```

## Deliverables

1. **Redesigned `dashboard-next/app/page.tsx`** — new layout
2. **Component files** in `dashboard-next/app/components/` (extract cards/widgets)
3. **Screenshot or description** of the new layout for ธาม to review

## Constraints

- ห้าม break existing API routes
- ห้าม commit secrets / .env
- Test ด้วย `npm run dev` ใน `dashboard-next/`
- ถ้าเพิ่ม dependency ให้ใช้ `npm` เท่านั้น (ไม่ใช่ pnpm/bun)

## Definition of Done

- [ ] `npm run build` ผ่านไม่มี error
- [ ] Dashboard โหลด < 3 วินาที
- [ ] ดูแล้วรู้ mission status ภายใน 3 วินาที (Luxi's golden rule)
- [ ] ธาม approve design ก่อน merge

---

> "สูง มองไกล — ออกแบบเส้นทางที่ผู้ใช้ตามหาง่าย สุดสั้น สุดสวย"

**From**: ธาม (Coordinator)
**To**: Luxi — The Golden Path 🛤️
**Ready when you are.**
