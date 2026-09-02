---
pattern: "Learned zitadel/zitadel: event-sourced CQRS IAM platform, Go backend + dual frontends (Angular console, Next.js login UI), generic type-parameterized repository layer"
date: 2026-08-29
source: "learn: zitadel/zitadel"
concepts: ["learn", "codebase", "identity", "iam", "event-sourcing", "cqrs", "go", "oidc", "saml"]
---

# Learned zitadel/zitadel

- Event-sourced IAM/identity platform: an immutable event log (`internal/eventstore/`) is the
  single source of truth, with CQRS splitting writes (`internal/command/`) from read-side
  materialized projections (`internal/query/`). A newer `backend/v3/` hexagonal-DDD refactor is
  underway alongside the original layout.
- Two separate frontends sit on one Go backend: Console (Angular 21 + Tailwind, admin/management
  UI) and a Next.js 16 + React 19 Login UI (auth flows) — the backend itself speaks gRPC,
  ConnectRPC, and HTTP/REST simultaneously via `buf.gen.yaml`-driven codegen (9 plugins,
  including a custom Zitadel plugin).
- Defensive-by-default Go idioms run throughout: a generic type-parameterized repository layer
  (Go 1.18+ generics), automatic `ZitadelError` wrapping with unique error IDs, no-op logger
  chains on nil — "safety over convenience" shows up as a consistent code pattern, not just a
  README claim.

Full docs: `ψ/learn/zitadel/zitadel/zitadel.md` (hub) → Architecture, Code Snippets, Quick
Reference (2026-08-29 1938 run, 3 Haiku agents, zero contamination on check).
