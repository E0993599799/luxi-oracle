---
title: tham-oracle Dashboard Architecture
author: Khun-Ram Oracle (Skeleton) — Luxi to complete
date: 2026-06-28
status: SKELETON — Fill in data flow details
---

# Dashboard Architecture — tham-oracle Mission Control

> Codex Oracle's documentation template. Luxi team: fill in actual implementation details as you build.

## Overview

**Purpose**: Single-pane Mission Control dashboard showing fleet health, phase progress, active missions, and system state.

**Tech Stack**:
- Framework: Next.js (React 18+)
- Language: TypeScript
- Styling: Tailwind CSS
- State: (CLIENT vs SERVER state — to be determined by build team)
- Icons: Lucide React
- Data: Real-time polling from `/api/*` endpoints

## System Architecture Diagram

```
┌────────────────────────────────────────────────────────────────┐
│                    Browser (Client)                             │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  NextJS Page (app/page.tsx)                              │  │
│  │  - Polling interval management (30s)                     │  │
│  │  - Error boundary & fallback UI                          │  │
│  └──────────────────┬───────────────────────────────────────┘  │
│                     │                                            │
│  ┌──────────────────▼───────────────────────────────────────┐  │
│  │  Component Tree (app/components/)                        │  │
│  │  - FleetHealthCard (FILL: oracle stats)                 │  │
│  │  - PhaseProgressTracker (FILL: phase data)              │  │
│  │  - ActiveMissionsBoard (FILL: kanban layout)            │  │
│  │  - [OTHER CARDS AS DESIGNED BY LUXI]                    │  │
│  └──────────────────┬───────────────────────────────────────┘  │
│                     │                                            │
│                     │ HTTP Requests (30s poll)                  │
│                     │                                            │
└────────────────────┼────────────────────────────────────────────┘
                     │
                     ▼
┌────────────────────────────────────────────────────────────────┐
│              Next.js API Routes (Backend)                       │
│  app/api/                                                       │
│  ├── /fleet-status        → oracle counts, states             │
│  ├── /phase-progress       → phase tracker data               │
│  ├── /active-missions      → mission queue                    │
│  ├── /memory-health        → ψ folder metrics                 │
│  ├── /git-state            → git branch, commits, dirty files │
│  └── [OTHER ENDPOINTS AS NEEDED]                              │
└────────────────────┬───────────────────────────────────────────┘
                     │
                     ▼
        [DATA SOURCES — TO BE DEFINED]
        - tham-oracle/ψ/ filesystem
        - orchestrator/phase-state.json
        - Git repository state
        - Circuit breaker state
        - [OTHER SOURCES]
```

## Data Flow

### Request → Response Cycle

**Step 1: Client Initialization**
- [ ] On mount, determine polling strategy (FILL: immediate vs delayed first poll)
- [ ] Initialize error boundary
- [ ] FILL: Any authentication/session checks?

**Step 2: Polling Loop (30s interval)**
- [ ] Fetch all endpoints in parallel or sequential? (FILL: choice)
- [ ] Handle partial failures (one endpoint down, others OK?) (FILL: strategy)
- [ ] Update component state
- [ ] FILL: Retry logic? Exponential backoff?

**Step 3: Component Rendering**
- [ ] Each card consumes specific endpoint data (FILL: data → component mapping)
- [ ] FILL: Thai text handling? (Noto Sans Thai, line-height, diacritics)
- [ ] Dark mode applied (FILL: Tailwind config)

**Step 4: Error Handling**
- [ ] FILL: What happens if `/fleet-status` times out?
- [ ] FILL: What if API returns stale data?
- [ ] FILL: Show loading state? Spinner, skeleton, cached data?

## API Contracts

### Endpoint: `/api/fleet-status`

**Purpose**: Oracle fleet health at a glance

**Response Schema** (FILL):
```json
{
  "timestamp": "ISO 8601",
  "oracles": {
    "total": 0,
    "active": 0,
    "stale": 0,
    "cold": 0,
    "abandoned": 0,
    "zygote": 0
  },
  "circuit_breaker": {
    "state": "OPEN | HALF_OPEN | CLOSED",
    "description": "human readable"
  }
}
```

**Polling Interval**: (FILL: 30s per brief?)
**Cache TTL**: (FILL: client-side vs server-side?)
**Error Response**: (FILL: what status codes? what fallback data?)

### Endpoint: `/api/phase-progress`

**Purpose**: Phase tracker — what phase are we in, what % complete?

**Response Schema** (FILL):
```json
{
  "current_phase": 0,
  "phases": [
    {
      "phase_number": 1,
      "status": "COMPLETED | IN_PROGRESS | BLOCKED | NOT_STARTED",
      "description": "",
      "completion_percent": 0
    }
  ]
}
```

**Polling Interval**: (FILL)
**Cache TTL**: (FILL)
**Error Response**: (FILL)

### Endpoint: `/api/active-missions`

**Purpose**: Kanban board — what work is in progress, blocked, waiting?

**Response Schema** (FILL):
```json
{
  "timestamp": "ISO 8601",
  "missions": [
    {
      "id": "unique-id",
      "title": "mission name",
      "status": "NOT_STARTED | IN_PROGRESS | BLOCKED | COMPLETED",
      "priority": "P0 | P1 | P2 | P3",
      "assigned_to": "oracle name or human",
      "description": "brief description"
    }
  ]
}
```

**Polling Interval**: (FILL)
**Cache TTL**: (FILL)
**Error Response**: (FILL)

### Endpoint: `/api/memory-health`

**Purpose**: ψ folder metrics — how healthy is our documentation brain?

**Response Schema** (FILL):
```json
{
  "timestamp": "ISO 8601",
  "memory": {
    "total_files": 0,
    "by_category": {
      "inbox": 0,
      "memory": 0,
      "writing": 0,
      "learn": 0,
      "archive": 0,
      "outbox": 0
    },
    "health_score": 0.0
  }
}
```

**Polling Interval**: (FILL)
**Cache TTL**: (FILL)
**Error Response**: (FILL)

---

## State Management

**Client-Side State**:
- FILL: What state is needed? (loading, error, lastUpdate, data)
- FILL: React hooks (useState, useEffect, useReducer?) or external library (Zustand, Jotai)?

**Server-Side Caching**:
- FILL: Is API caching needed? TTL per endpoint?
- FILL: Database queries or in-memory cache?

**Stale Data Handling**:
- FILL: How to show "data is 5 minutes old"?
- FILL: Should dashboard auto-retry on stale data?

---

## Dark Mode & Thai Support

**Dark Mode**:
- FILL: Tailwind dark mode config
- FILL: Card backgrounds, text contrast
- FILL: Icon colors in dark mode

**Thai Text**:
- FILL: Font: Noto Sans Thai (already in project?)
- FILL: Line-height adjustment for Thai diacritics
- FILL: Test rendering with mixed Thai/English text

---

## Performance Targets

- Page load time: < 3 seconds (brief requirement)
- Poll response time: < 1 second per endpoint
- FILL: Memory usage? (client-side state bloat)
- FILL: Network bandwidth? (poll payload size)

---

## Future Extensions

- FILL: Real-time updates (WebSocket instead of polling)?
- FILL: Drill-down into mission details?
- FILL: Historical trends (past week/month)?

---

**[MARCUZ:Khun-Ram]** — Skeleton prepared for Luxi team.
*Luxi: Fill in design decisions. Build team: Fill in implementation details.*
