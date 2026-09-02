# ZITADEL Architecture

## Project Overview

ZITADEL is a large-scale Identity & Access Management (IAM) platform written in Go, with multiple frontend applications (Angular console, Next.js login UI). The codebase implements Event Sourcing and CQRS (Command Query Responsibility Segregation) patterns at its core, with a dual-versioning system in the domain layer.

**Repository**: `github.com/zitadel/zitadel`  
**Primary Language**: Go 1.25.0 (backend); TypeScript/Angular/Next.js (frontend)  
**Key Pattern**: Event Sourcing + CQRS with hexagonal architecture (v3 refactor)

---

## Directory Structure & Organization Philosophy

### Root-Level Layout

```
/
├── cmd/                  # CLI commands (entry point)
├── internal/             # Core business logic (event sourcing, CQRS, domain)
├── backend/v3/           # Hexagonal architecture refactor (new v3 layer)
├── proto/                # Protocol Buffer definitions (gRPC + ConnectRPC APIs)
├── console/              # Angular management UI
├── apps/
│   ├── login/            # Next.js authentication UI
│   ├── api/              # External API test harness
│   ├── docs/             # Documentation site
│   └── login/acceptance/ # Acceptance tests (OIDC, SAML, identity providers)
├── packages/             # Shared library packages
├── deploy/               # Deployment configs (Docker Compose, etc.)
├── tests/                # Integration and functional tests
└── go.mod               # Go module definition (v1.25.0)
```

### Backend Architecture Philosophy

The backend follows **layered separation with event-driven source of truth**:

1. **API Layer** (`/internal/api/`) - HTTP/gRPC handlers, middleware, protocol translation
2. **Domain Layer** (`/internal/domain/`) - Pure business logic entities, no I/O
3. **Command Layer** (`/internal/command/`) - Write side (CQRS) with event emission
4. **Query Layer** (`/internal/query/`) - Read side (CQRS) with read model projections
5. **Eventstore Layer** (`/internal/eventstore/`) - Event persistence and event subscriptions
6. **Repository Layer** (`/internal/repository/`) - Data access abstraction

### Frontend Architecture

#### Console (Angular)
- **Framework**: Angular 21
- **Styling**: Tailwind CSS 4
- **Package Manager**: pnpm
- **Location**: `/console/`
- **Build**: `ng build --configuration production --base-href=/ui/console/`

#### Login UI (Next.js)
- **Framework**: Next.js 16 with React 19
- **Build**: Standalone mode with custom server
- **Package Manager**: pnpm
- **Location**: `/apps/login/`
- **Architecture**: App Router (v16), server components ready
- **Styling**: Tailwind CSS 4 + Headless UI

---

## Entry Points & Initialization

### CLI Entry Points

**Root Entry**: `/main.go`  
Delegates all commands through `cmd.New()`:

```go
// /main.go
func main() {
    args := os.Args[1:]
    rootCmd := cmd.New(os.Stdout, os.Stdin, args, nil)
    ctx := logging.NewCtx(context.Background(), logging.StreamRuntime)
    if err := rootCmd.ExecuteContext(ctx); err != nil {
        os.Exit(1)
    }
}
```

**CLI Command Hub**: `/cmd/zitadel.go`  
Implements Cobra-based CLI with subcommands:

```go
func New(out io.Writer, in io.Reader, args []string, server chan<- *start.Server) *cobra.Command
```

#### Available Commands

- **`start`** - Starts the ZITADEL instance (`/cmd/start/start.go`)
- **`start-from-init`** - Start after initialization (`/cmd/start/start_from_init.go`)
- **`start-from-setup`** - Start after setup (`/cmd/start/start_from_setup.go`)
- **`admin`** - Admin operations (deprecated)
- **`initialise`** - DB initialization
- **`setup`** - Initial setup flow
- **`mirror`** - Event mirroring utilities
- **`key`** - Key management
- **`ready`** - Health check probe

### Server Startup (`/cmd/start/start.go`)

The main server initialization loads:

1. **Configuration** - YAML defaults + environment overrides via Viper
2. **Database** - PostgreSQL connection (required, no in-memory fallback)
3. **Event Store** - Both v1 (legacy SQL) and v3 (new schema)
4. **Cache Layer** - Redis or in-memory connectors
5. **API Layers** - gRPC, HTTP, ConnectRPC servers
6. **Authentication** - OIDC, SAML, WebAuthn providers
7. **Notification** - Email, SMS, push via configurable senders
8. **Service Mesh** - CORS, middleware, observability hooks

Key startup sequence:
- Load defaults from embedded `defaults.yaml` and `defaults_fips.yaml`
- Merge config files from `--config` flags
- Initialize database connection (required PostgreSQL)
- Start event store subscriptions
- Launch gRPC server on `:50051` (default)
- Launch HTTP server on `:8080` (default, HTTP/2 via h2c)
- Set up graceful shutdown on SIGINT/SIGTERM

---

## Core Abstractions & Relationships

### 1. Event Sourcing Pattern

**Central Store**: `/internal/eventstore/`

All state changes are immutable events, persisted to PostgreSQL. Events are the single source of truth.

```
Domain Event → Command Handler → Eventstore.Push() → Event Persisted
                    ↓
              Projection Updates Read Model
                    ↓
              Query Layer Serves Current State
```

**Key Types**:
- `Aggregate` (`/internal/eventstore/aggregate.go`) - Event-sourced entity root
- `Event` (`/internal/eventstore/event.go`) - Immutable fact
- `EventStore` (`/internal/eventstore/eventstore.go`) - Central event log and subscriptions
- `SearchQuery` (`/internal/eventstore/search_query.go`) - Event filtering

**Versioning**:
- **v1 (Legacy)** - Old event schema, still reads from same table
- **v3 (New)** - Hexagonal refactor, new schema in `backend/v3/`

### 2. CQRS (Command Query Responsibility Segregation)

#### Write Side: Command Layer
**Location**: `/internal/command/command.go`

Central handler for all state mutations:

```go
type Commands struct {
    eventstore *eventstore.Eventstore
    idGenerator id.Generator
    crypto *crypto.Hasher
    // ... 100+ specialized command methods
}
```

**Responsibilities**:
- Validate user intent (auth checks, business rules)
- Load aggregate state from event history
- Apply command to aggregate
- Emit new events
- Persist to eventstore
- Update caches/projections

**Example Patterns**: All domain operations are methods on `Commands`:
- `UserCreate()`, `UserUpdate()`, `UserDelete()`
- `ProjectCreate()`, `ApplicationCreate()`
- `OrgCreate()`, `OrgUpdate()`
- `SessionCreate()`, `SessionUpdate()`
- `IdentityProviderCreate()`, etc.

#### Read Side: Query Layer
**Location**: `/internal/query/`

Queries against read model projections (separate database tables):

```go
type Queries struct {
    eventstore *eventstore.Eventstore
    // ... read-model materialization
}
```

**Key Methods**:
- `User()` - Fetch user by ID
- `UserByLoginName()` - Find user by email/username
- `Project()` - Fetch project by ID
- `App()` - Fetch application
- `Session()` - Query session state
- `OrgByDomain()` - Lookup org by domain
- Hundreds of specialized read-only queries

**Read Model Tables**: Typically mirror domain entities (users, projects, apps, sessions, etc.) with denormalized data optimized for queries.

### 3. Domain Layer

**Location**: `/internal/domain/`

Pure business logic entities, no I/O. Defines:

- **User** (`human.go`) - Human identity with profile, email, phone, address
- **Application** (`application.go`) - OAuth/OIDC/SAML app registration
- **Project** - Logical grouping of applications
- **Organization** - Tenant/workspace
- **AuthRequest** (`auth_request.go`) - Authentication session state
- **Session** (`browser_info.go`) - Browser session lifetime
- **IdentityProvider** - External auth federation (Google, GitHub, custom OIDC)
- **Policy** - Password, MFA, branding, security policies
- **Action** - Custom business logic triggers (event hooks)
- **Group** - User groupings for authorization
- **Asset** - Logos, logos, branding assets
- **WebAuthn** - Passkey/passwordless authentication
- **Feature** - Feature flag gates

All entities are defined as interfaces with stateful behavior. State is loaded from events, not persisted directly.

### 4. Repository Pattern

**Location**: `/internal/repository/`

Abstraction over data access. Each major entity has:

```
Repository Interface (defines contract)
    ↓
Event Store Implementation (reads from events)
```

Key repositories:
- `UserRepository` - User aggregate access
- `ProjectRepository` - Project aggregate access
- `ApplicationRepository` - App aggregate access
- `InstanceRepository` - Instance/tenant aggregate access

### 5. API Layers

#### gRPC API (Primary)
**Location**: `/internal/api/grpc/`

Services implemented using gRPC with multiple API versions:

- **v2** - Current stable version
- **v2beta** - Next-generation APIs in development
- **v3alpha** - Experimental new APIs

Example services:
- `auth.proto` - User authentication (login, session, MFA)
- `management.proto` - App/project/user CRUD
- `admin.proto` - System-level admin operations
- `user/v3alpha` - Next-gen user service
- `session/v2` - Session management
- `oidc/v2` - OIDC configuration and discovery

**Implementations**: Auto-generated from protocol buffers in `/proto/zitadel/`

#### HTTP API
**Location**: `/internal/api/http/`

RESTful handlers for:
- OIDC provider endpoints (`/oidc/...`)
- SAML provider endpoints (`/saml/...`)
- SCIM provisioning (`/scim/v2/...`)
- Well-known metadata (`/.well-known/...`)
- Health checks (`/ready`, `/health`)
- WebAuthn registration/authentication

**Middleware Stack** (`/internal/api/http/middleware/`):
- CORS
- CSRF protection
- Rate limiting
- Access logging
- Authorization interceptors

#### ConnectRPC API
Modern RPC framework with HTTP/2 semantics:
- `connect.proto` - ConnectRPC service definitions
- Works alongside gRPC for web and native clients
- Uses `/internal/api/grpc/server/connect_middleware/` for interceptors

### 6. Authentication & Authorization

#### AuthZ Package
**Location**: `/internal/api/authz/`

**Token-based flow**:
1. Client calls API with JWT or session token
2. `APITokenVerifier` validates token signature
3. Extracts claims (user ID, roles, org ID)
4. `PermissionCheck` verifies authorization
5. Request is routed with context containing principals

**Supported Credentials**:
- API tokens (JWT, service-to-service)
- Session tokens (browser sessions via cookies)
- OIDC/OAuth2 tokens (federated login)

#### OIDC Provider
**Location**: `/internal/api/oidc/`

ZITADEL acts as OAuth2/OIDC provider:
- `/oidc/.well-known/openid-configuration` - OIDC discovery
- `/oidc/authorize` - AuthZ endpoint
- `/oidc/token` - Token endpoint
- `/oidc/userinfo` - UserInfo endpoint
- `/oidc/revocation` - Token revocation
- `/oidc/introspection` - Token introspection

Uses `github.com/zitadel/oidc/v3` library.

#### SAML Provider
**Location**: `/internal/api/saml/`

ZITADEL acts as SAML IdP:
- Metadata endpoint
- Single Sign-On (SSO) endpoint
- Assertion Consumer Service (ACS)
- Single Logout (SLO)

Uses `github.com/crewjam/saml` library.

#### Identity Provider (IDP) Federation
**Location**: `/internal/api/idp/`

External auth source integration:
- Google OAuth2
- GitHub OAuth2
- Custom OIDC providers
- SAML IdP links
- LDAP directory

User is linked to external identity via identity provider registration.

### 7. WebAuthn/Passkeys

**Location**: `/internal/webauthn/`

Passwordless authentication via:
- FIDO2/WebAuthn hardware keys
- Platform authenticators (Windows Hello, Touch ID, Face ID)
- CTAP2 protocol

Uses `github.com/go-webauthn/webauthn` and custom ZITADEL wrapper.

### 8. Notification System

**Location**: `/internal/notification/`

Multi-channel outbound messaging:
- **Email** - Via SMTP, configured in system settings
- **SMS** - Via Twilio integration
- **Push** - Via Firebase Cloud Messaging

**Emitters**:
- Password reset links
- Email verification codes
- Login alerts
- MFA challenges

Uses template rendering (`/internal/renderer/`) with i18n support.

### 9. Actions/Automation

**Location**: `/internal/actions/`

JavaScript-based event hooks:
- Pre/post authentication
- User lifecycle events
- Custom validation

Runs inside JavaScript VM (Goja engine) with sandboxed context access.

### 10. Database Layer

**Location**: `/internal/database/`

PostgreSQL-only (no other database support):
- Connection pooling via `jackc/pgx/v5`
- Migration management via `jackc/tern`
- Query builder: `Masterminds/squirrel`
- Row scanning: `georgysavva/scany`

**Schema**:
- Single event log table (all events appended)
- Multiple read model tables (projections)
- Versioning strategy: v1 (legacy) shares table with v3 (new)

### 11. Instrumentation & Observability

**Location**: `/backend/v3/instrumentation/`

- **Logging** - Structured logging via `zitadel/logging` package
- **Tracing** - OpenTelemetry distributed tracing
- **Metrics** - Prometheus metrics via `prometheus/client_golang`
- **Profiling** - Google Cloud Profiler integration

### 12. v3 Hexagonal Architecture (In Progress)

**Location**: `/backend/v3/`

New package structure for improved separation of concerns:

```
backend/v3/
├── api/              # API handlers (adapters)
├── domain/           # Domain entities & logic
├── storage/          # Repository implementations
└── instrumentation/  # Logging, tracing, metrics
```

**Philosophy**:
- Domain defines dependencies as interfaces
- Adapters (API, storage) implement interfaces
- No business logic in adapters
- Event Store as dependency injection

This refactor runs parallel to legacy `/internal/` packages, gradually replacing them.

---

## Dependencies

### Key Backend Dependencies (from `go.mod`)

**gRPC & RPC**:
- `connectrpc.com/connect` v1.19.2 - ConnectRPC framework
- `connectrpc.com/grpcreflect` v1.3.0 - gRPC reflection
- `google.golang.org/grpc` - gRPC server
- `github.com/grpc-ecosystem/grpc-gateway/v2` - gRPC gateway

**Database**:
- `github.com/jackc/pgx/v5` v5.9.2 - PostgreSQL driver
- `github.com/jackc/tern/v2` v2.3.6 - DB migrations
- `github.com/Masterminds/squirrel` v1.5.4 - Query builder

**Authentication & Crypto**:
- `github.com/go-jose/go-jose/v4` v4.1.4 - JWT/JWE/JWS
- `github.com/go-webauthn/webauthn` v0.10.2 - WebAuthn
- `github.com/crewjam/saml` v0.5.1 - SAML
- `github.com/zitadel/oidc/v3` - Custom OIDC provider
- `github.com/zitadel/saml` - Custom SAML provider

**LDAP & External Auth**:
- `github.com/go-ldap/ldap/v3` v3.4.13 - LDAP client

**Queuing & Events**:
- `github.com/riverqueue/river` v0.35.0 - Job queue (PostgreSQL-backed)
- `github.com/redis/go-redis/v9` v9.18.0 - Redis cache

**HTTP & Web**:
- `github.com/gorilla/mux` v1.8.1 - HTTP routing
- `github.com/gorilla/websocket` v1.5.3 - WebSocket
- `github.com/rs/cors` v1.11.1 - CORS middleware

**JavaScript VM**:
- `github.com/dop251/goja` v0.0.0-20260311135729-065cd970411c - JavaScript execution
- `github.com/dop251/goja_nodejs` - Node.js compat

**Utilities**:
- `github.com/spf13/cobra` v1.10.2 - CLI framework
- `github.com/spf13/viper` v1.21.0 - Config management
- `github.com/stretchr/testify` v1.11.1 - Test assertions

### Frontend Dependencies

#### Console (Angular)
- `@angular/*` v21.x - Full Angular framework
- `@angular/material` v21.x - Material Design components
- `@connectrpc/connect-web` v2.1.1 - ConnectRPC web client
- `@tanstack/angular-query-experimental` v5.x - Data fetching
- `tailwindcss` v4 - Utility CSS

#### Login UI (Next.js)
- `next` v16.2.11 - React framework
- `react` v19.2.6 + `react-dom` v19.2.6 - UI library
- `@connectrpc/connect-node` v2.1.1 - Server-side RPC
- `next-intl` v4.11.2 - i18n routing
- `lucide-react` v0.577.0 - Icon library
- `tailwindcss` v4 - Utility CSS

---

## Communication Patterns

### Internal Service Communication

**gRPC** (primary):
- Command → Eventstore (via gRPC gateway internally)
- Query → Cache/Database (SQL queries)
- Services → OIDC/SAML libraries

**Event Subscriptions**:
- External services subscribe to event stream
- Webhook delivery for third-party integrations

### External API Communication

**Frontend → Backend**:
- **Console** (Angular): gRPC via `grpc-web` transpiler
- **Login UI** (Next.js): ConnectRPC (`connect-web` client)
- Both use same protobuf service definitions

**Client → ZITADEL**:
- **OIDC** - Standard OAuth2/OIDC endpoints
- **SAML** - Standard SAML binding
- **gRPC** - Service-to-service with API tokens
- **REST** - HTTP endpoints for specific use cases

---

## Data Flow Example: User Login

```
1. User browses /login (Next.js Login UI)
2. User enters credentials
3. Login UI calls `auth.v2.AuthService.ListAuthMethods()` (gRPC)
   → Determines available auth factors
4. User selects password auth
5. Login UI calls `auth.v2.AuthService.StartPasswordAuth()`
   → Command.AuthRequestAdd() emits AuthRequestStarted event
   → Eventstore persists event
   → Query layer updates read model
6. Login UI calls `auth.v2.AuthService.CheckPasswordAuth()`
   → Command.AuthRequestCheckPassword()
   → Validates password against stored hash
   → Emits HumanPasswordCheckSucceeded event
7. If MFA required:
   → Login UI calls `auth.v2.AuthService.StartTOTPAuth()` or similar
   → User provides TOTP/WebAuthn
8. Login UI calls `auth.v2.AuthService.CreateSession()`
   → Command.SessionCreate()
   → Eventstore persists SessionCreated event
   → Session token issued
9. Browser sets secure HTTP-only cookie with session token
10. Subsequent API calls include session token in Authorization header
11. Middleware verifies session token via Query.Session()
    → Loads from read model cache
12. Request proceeds with user context
```

---

## Deployment & Configuration

### Configuration Sources (in precedence order)

1. Environment variables with `ZITADEL_` prefix
2. YAML config files passed via `--config` flag
3. Embedded defaults (`cmd/defaults.yaml`)
4. FIPS-mode overlay (`cmd/defaults_fips.yaml`)

### Database Initialization

Command sequence:
1. `zitadel initialise` - Schema setup
2. `zitadel setup` - Initial instance & admin user
3. `zitadel start` - Continuous operation

### Build Artifacts

**Backend**:
- Single binary: `zitadel` (Go executable)
- Contains all code, embedded assets (HTML, CSS, JS)
- Docker image at `ghcr.io/zitadel/zitadel:latest`

**Frontend**:
- Console built as SPAs (deployed to `/ui/console/`)
- Login UI built as Next.js standalone (deployed to `/ui/`)
- Both served from same HTTP server

---

## Testing Strategy

**Unit Tests**: `*_test.go` files throughout codebase  
**Integration Tests**: `/tests/` directory  
**Acceptance Tests**: `/apps/login/acceptance/` with Playwright  
**Load Testing**: `/benchmark/` package

Test database: Embedded PostgreSQL via `fergusstrange/embedded-postgres`

---

## Summary

ZITADEL is a sophisticated IAM platform built on:

- **Event Sourcing** as the source of truth (all state in immutable event log)
- **CQRS** separation (Commands for writes, Queries for reads)
- **Hexagonal Architecture** (v3 refactor in progress)
- **Protocol Buffers** for polyglot API contracts
- **PostgreSQL** as single persistent store
- **Multiple Frontend UIs** (Angular console, Next.js login)
- **Standard Protocols** (OIDC, SAML, LDAP, WebAuthn)
- **Multi-tenant** with organization/instance isolation

The architecture prioritizes correctness (event log cannot be lost), auditability (every action is an event), and extensibility (actions, webhooks, custom auth flows).
