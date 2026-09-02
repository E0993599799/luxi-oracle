# zitadel Learning Index

## Source
- **Origin**: ./origin/
- **GitHub**: https://github.com/zitadel/zitadel

## Explorations

### 2026-08-29 1938 (default, 3 agents)
- [[2026-08-29/1938_ARCHITECTURE|Architecture]]
- [[2026-08-29/1938_CODE-SNIPPETS|Code Snippets]]
- [[2026-08-29/1938_QUICK-REFERENCE|Quick Reference]]

**Key insights**:
- Event-sourced IAM/identity platform: immutable event log (`internal/eventstore/`) is the single source of truth, with CQRS separating writes (`internal/command/`) from read-side materialized projections (`internal/query/`) — plus a newer `backend/v3/` hexagonal-DDD refactor in progress alongside the original layout.
- Two separate frontends against the same Go backend: Console (Angular 21 + Tailwind, management UI) and a Next.js 16 + React 19 Login UI for auth flows — backend speaks gRPC, ConnectRPC, and HTTP/REST simultaneously via `buf.gen.yaml`-driven codegen (9 plugins including a custom Zitadel plugin).
- Defensive-by-default Go idioms throughout: generic type-parameterized repository layer (Go 1.18+), automatic `ZitadelError` wrapping with unique error IDs, no-op logger chains on nil — safety over convenience is a consistent theme across the codebase, not just a README claim.
