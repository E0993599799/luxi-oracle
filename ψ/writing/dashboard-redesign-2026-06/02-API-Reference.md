---
title: Dashboard API Endpoint Reference
author: Khun-Ram Oracle (Skeleton) — Build team to complete
date: 2026-06-28
status: SKELETON — Fill in endpoints as implemented
---

# API Endpoint Reference — tham-oracle Dashboard

> Contract definition for all dashboard data sources. Build team: implement these endpoints and update response examples.

## Base URL

```
http://localhost:3000/api   (development)
https://tham-oracle.pages.dev/api  (production — FILL: actual domain)
```

## Authentication

- FILL: Do these endpoints require authentication? JWT? Session cookie?
- FILL: Rate limiting strategy?

---

## 1. Fleet Status

**Endpoint**: `GET /api/fleet-status`

**Purpose**: Current state of all oracles in the fleet

**Query Parameters**:
- `cache=true|false` — (FILL: bypass cache?) Default: false

**Response Schema**:
```json
{
  "timestamp": "2026-06-28T14:30:00Z",
  "success": true,
  "data": {
    "oracles": {
      "total": 25,
      "active": 22,
      "stale": 2,
      "cold": 1,
      "abandoned": 0,
      "zygote": 0
    },
    "last_updated": "2026-06-28T14:30:00Z"
  },
  "error": null
}
```

**Status Definitions** (FILL: confirm meanings):
- **active**: Oracle responded in last 5 minutes
- **stale**: Oracle last seen 5-60 minutes ago
- **cold**: Oracle last seen > 60 minutes ago
- **abandoned**: Oracle never woke up (age > 24h)
- **zygote**: Oracle created but not yet activated

**Response Time**: < 500ms (SLA)
**Polling Interval**: 30 seconds (per brief)
**Cache TTL**: (FILL: server-side cache duration?)

**Error Cases**:
- 500 — Unable to read oracle registry
- 503 — System in maintenance mode
- FILL: Other error cases?

**Example cURL**:
```bash
curl -X GET http://localhost:3000/api/fleet-status
```

---

## 2. Phase Progress

**Endpoint**: `GET /api/phase-progress`

**Purpose**: Which phase are we in? How much is done?

**Query Parameters**:
- (None currently — FILL: add filtering if needed)

**Response Schema**:
```json
{
  "timestamp": "2026-06-28T14:30:00Z",
  "success": true,
  "data": {
    "current_phase": 13,
    "phases": [
      {
        "phase_number": 1,
        "name": "FILL: Phase 1 name",
        "status": "COMPLETED",
        "completion_percent": 100,
        "started_at": "2026-01-01T00:00:00Z",
        "completed_at": "2026-01-15T00:00:00Z",
        "description": "FILL: What did phase 1 accomplish?"
      },
      {
        "phase_number": 13,
        "name": "FILL: Phase 13 name",
        "status": "IN_PROGRESS",
        "completion_percent": 45,
        "started_at": "2026-06-01T00:00:00Z",
        "completed_at": null,
        "description": "FILL: What is phase 13 trying to do?"
      }
    ]
  },
  "error": null
}
```

**Phase Status Values**:
- `COMPLETED` — ✅ All tasks done
- `IN_PROGRESS` — 🔄 Currently active
- `BLOCKED` — 🚫 Waiting on external dependency
- `NOT_STARTED` — ⬜ Queued but not started

**Response Time**: < 500ms
**Polling Interval**: (FILL: 30s? or less frequent for slow-changing data?)
**Cache TTL**: (FILL: in-memory? database?)

**Error Cases**:
- 404 — No phase data found
- 500 — Unable to read phase-state.json
- FILL: Others?

**Example cURL**:
```bash
curl -X GET http://localhost:3000/api/phase-progress
```

---

## 3. Active Missions

**Endpoint**: `GET /api/active-missions`

**Purpose**: Kanban board — what work is in flight?

**Query Parameters**:
- `status=IN_PROGRESS|BLOCKED|NOT_STARTED` — Filter by status (optional)
- `priority=P0|P1|P2` — Filter by priority (optional)

**Response Schema**:
```json
{
  "timestamp": "2026-06-28T14:30:00Z",
  "success": true,
  "data": {
    "missions": [
      {
        "id": "mission-2026-06-28-001",
        "title": "Dashboard redesign",
        "description": "Rebuild tham-oracle dashboard with new UX",
        "status": "IN_PROGRESS",
        "priority": "P1",
        "assigned_to": "Luxi Oracle",
        "created_at": "2026-05-30T00:00:00Z",
        "due_at": "2026-07-15T00:00:00Z",
        "started_at": "2026-06-28T00:00:00Z",
        "completed_at": null,
        "progress_percent": 15
      }
    ],
    "summary": {
      "total": 12,
      "not_started": 5,
      "in_progress": 4,
      "blocked": 2,
      "completed": 1
    }
  },
  "error": null
}
```

**Priority Levels** (FILL: confirm):
- `P0` — Critical blocker
- `P1` — High priority
- `P2` — Medium priority
- `P3` — Low priority / Nice to have

**Response Time**: < 500ms
**Polling Interval**: 30 seconds
**Cache TTL**: (FILL)

**Error Cases**:
- 404 — No missions found
- 500 — Unable to read mission queue
- FILL: Others?

**Example cURL**:
```bash
curl -X GET "http://localhost:3000/api/active-missions?status=IN_PROGRESS&priority=P0,P1"
```

---

## 4. Memory Health

**Endpoint**: `GET /api/memory-health`

**Purpose**: ψ folder metrics — documentation brain health

**Query Parameters**:
- (None currently)

**Response Schema**:
```json
{
  "timestamp": "2026-06-28T14:30:00Z",
  "success": true,
  "data": {
    "brain": {
      "total_files": 247,
      "total_size_mb": 12.4,
      "by_category": {
        "inbox": { "files": 31, "size_mb": 1.2 },
        "memory": { "files": 89, "size_mb": 5.3 },
        "writing": { "files": 45, "size_mb": 2.1 },
        "learn": { "files": 52, "size_mb": 2.8 },
        "archive": { "files": 25, "size_mb": 0.8 },
        "outbox": { "files": 5, "size_mb": 0.2 }
      },
      "health_indicators": {
        "inbox_backlog_days": 3,
        "unprocessed_briefs": 2,
        "archived_this_month": 15,
        "learning_score": 0.82
      }
    }
  },
  "error": null
}
```

**Health Score Interpretation** (FILL):
- 0.9–1.0 → Excellent
- 0.7–0.9 → Good
- 0.5–0.7 → Fair (attention needed)
- < 0.5 → Critical (brain overload)

**Response Time**: < 1 second (may need to scan filesystem)
**Polling Interval**: (FILL: 30s? or slower since this is I/O heavy?)
**Cache TTL**: (FILL: cache for 5 min? 1 min?)

**Error Cases**:
- 404 — ψ folder not found
- 500 — Unable to scan memory directory
- FILL: Others?

**Example cURL**:
```bash
curl -X GET http://localhost:3000/api/memory-health
```

---

## 5. Git State

**Endpoint**: `GET /api/git-state`

**Purpose**: Repository health — commits, branches, dirty files

**Query Parameters**:
- (None currently)

**Response Schema** (FILL: adjust to actual git metrics):
```json
{
  "timestamp": "2026-06-28T14:30:00Z",
  "success": true,
  "data": {
    "git": {
      "current_branch": "master",
      "commits_ahead_of_main": 12,
      "dirty_files": 0,
      "staged_changes": 0,
      "last_commit": {
        "hash": "abc123def",
        "message": "docs: Add D: drive reorganization summary",
        "author": "E0993599799",
        "timestamp": "2026-06-28T12:00:00Z"
      }
    }
  },
  "error": null
}
```

**Response Time**: < 500ms
**Polling Interval**: (FILL: 1 min? git commands can be slow)
**Cache TTL**: (FILL: cache for 2 min?)

**Error Cases**:
- 500 — Unable to run git commands
- FILL: Others?

**Example cURL**:
```bash
curl -X GET http://localhost:3000/api/git-state
```

---

## Error Response Format

All endpoints use this error format:

```json
{
  "timestamp": "2026-06-28T14:30:00Z",
  "success": false,
  "data": null,
  "error": {
    "code": "FLEET_STATUS_READ_FAILURE",
    "message": "Unable to read oracle registry: ENOENT /path/to/registry.json",
    "details": "FILL: stack trace or additional context?"
  }
}
```

---

## Polling Strategy

**Recommended Client Logic**:

```pseudocode
POLL_INTERVAL = 30 seconds

setup() {
  initial_fetch()  // fetch all endpoints immediately
  setInterval(poll_all, POLL_INTERVAL)
}

poll_all() {
  results = await Promise.all([
    fetch('/api/fleet-status'),
    fetch('/api/phase-progress'),
    fetch('/api/active-missions'),
    fetch('/api/memory-health'),
    fetch('/api/git-state')
  ])
  
  // Handle partial failures
  // Update UI only for successful endpoints
  // Show error state for failed endpoints
}
```

---

**[MARCUZ:Khun-Ram]** — API skeleton prepared.
*Build team: Implement these endpoints. Update response examples as you go.*
