# ZITADEL Quick Reference

> **Identity Infrastructure for Developers** — An open-source, self-hostable identity and access management (IAM) platform built for multi-tenant architectures and high-scale deployments.

**Repository**: https://github.com/zitadel/zitadel  
**License**: AGPL-3.0 (with Apache 2.0 and MIT exceptions for specific directories)  
**Language**: Go (backend) + Next.js (login UI) + TypeScript  
**Database**: PostgreSQL (≥14)  

---

## What ZITADEL Does

ZITADEL is a comprehensive identity platform designed for teams that need enterprise-grade IAM without vendor lock-in. It provides:

- **Single Sign-On (SSO)** with support for OIDC, SAML 2.0, and custom authentication flows
- **Multi-tenant identity management** at infrastructure level (Instances, Organizations, Projects)
- **Passkeys and WebAuthn** for passwordless authentication
- **Machine-to-machine (M2M) authentication** via JWT, PAT, Client Credentials
- **Full audit trail** via immutable event stream accessible over APIs
- **B2B onboarding** with delegated role management and identity brokering
- **API-first design** with gRPC, Connect-RPC, and HTTP/JSON REST interfaces
- **Zero-downtime updates** and horizontal scalability without external session stores

### Key Differentiators

1. **Relational core, event-driven soul** — Every mutation is immutable event-sourced for comprehensive audit trails
2. **Strict multi-tenant hierarchy** — Identity System → Instances → Organizations → Projects, with isolated data at each level
3. **API-first architecture** — Every resource available via typed APIs (gRPC, Connect-RPC, HTTP/JSON)
4. **SaaS + Self-hosted parity** — Same codebase for Zitadel Cloud and self-hosted deployments

### Comparison to Alternatives

| Feature | ZITADEL | FusionAuth | Keycloak | Auth0 |
|---------|---------|-----------|----------|-------|
| Open-source | ✅ | ❌ | ✅ | ❌ |
| Self-hostable | ✅ | ✅ | ✅ | ❌ |
| Infrastructure-level tenants | ✅ Instances | 🟡 Tenants | 🟡 Realms | ❌ |
| Passkeys (FIDO2) | ✅ | ✅ | ✅ | ✅ |
| Full audit trail (event stream) | ✅ | 🟡 | 🟡 | 🟡 |
| API-first (gRPC + REST) | ✅ | 🟡 | 🟡 | 🟡 |

---

## Installation

### Docker Compose (Quick Start — 3 Minutes)

Fastest way to get a self-hosted instance running locally:

```bash
curl -LO https://raw.githubusercontent.com/zitadel/zitadel/main/deploy/compose/docker-compose.yml \
  && curl -LO https://raw.githubusercontent.com/zitadel/zitadel/main/deploy/compose/.env.example \
  && cp .env.example .env \
  && docker compose up -d --wait
```

**Access**:
- **Admin Console** (Management UI): `http://localhost:8080/ui/v2/` (or your configured domain)
- **Login UI**: `http://localhost:8080/ui/v2/login/`
- **API**: `http://localhost:8080/v2/` (REST) or `:8080` (gRPC)

### Docker Compose Stack Architecture

```
┌─────────────────────────────────────┐
│  Traefik (Reverse Proxy)            │
│  Ports 80/443                       │
└──────────┬──────────────┬───────────┘
           │              │
      ┌────▼─────┐   ┌────▼──────────┐
      │ ZITADEL   │   │ Login UI       │
      │ API       │   │ (Next.js)      │
      │ (Go)      │   │ :3000          │
      │ :8080     │   └────────────────┘
      └────┬──────┘
           │
      ┌────▼────────────┐
      │ PostgreSQL      │
      │ Database        │
      └─────────────────┘

Optional:
- Redis (cache, enabled via --profile cache)
- OTEL Collector (tracing, enabled via --profile observability)
```

### Configuration Files

**Base file**: `docker-compose.yml`  
**Environment config**: `.env.example` (copy to `.env` to customize)  
**TLS overlays**:
- `docker-compose.mode-letsencrypt.yml` — ACME HTTP challenge
- `docker-compose.mode-external-tls.yml` — Upstream LB terminates TLS
- `docker-compose.mode-local-tls.yml` — Self-signed certificates

**Production-like setup**: `docker-compose.prodlike.yml`  
**CI/test**: `docker-compose.test.yml`

### Deployment Methods (Per Documentation)

From README:
- **Docker Compose** — Documented in repo (`deploy/compose/`)
- **Kubernetes** — See https://zitadel.com/docs/self-hosting/deploy/kubernetes
- **Binary** — See https://zitadel.com/docs/self-hosting/deploy/binary

### Cloud (SaaS)

**Zitadel Cloud** available at https://zitadel.com — Free tier available, US · EU · AU · CH regions, pay-as-you-go pricing.

---

## Configuration

### Environment Variables (Key Settings)

**Domain & External URL** (Critical — must match public URL):
```bash
ZITADEL_DOMAIN=localhost
ZITADEL_EXTERNALPORT=8080
ZITADEL_EXTERNALSECURE=false      # Set to true for HTTPS
ZITADEL_PUBLIC_SCHEME=http        # http or https
```

**Security & Bootstrap**:
```bash
ZITADEL_MASTERKEY=MasterkeyNeedsToHave32Characters  # Must be exactly 32 chars
LOGIN_CLIENT_PAT_EXPIRATION=2099-01-01T00:00:00Z    # Login PAT expiration
```

**Database** (PostgreSQL):
```bash
POSTGRES_DB=zitadel
POSTGRES_ADMIN_USER=postgres
POSTGRES_ADMIN_PASSWORD=postgres
ZITADEL_DATABASE_POSTGRES_DSN=postgresql://postgres:postgres@postgres:5432/zitadel?sslmode=disable
```

**Images & Versions**:
```bash
ZITADEL_VERSION=v4.16.0
TRAEFIK_IMAGE=traefik:v3.7.7
POSTGRES_IMAGE=postgres:17.10-alpine
REDIS_IMAGE=redis:7.4.9-alpine
OTEL_COLLECTOR_IMAGE=otel/opentelemetry-collector-contrib:0.156.0
```

**Proxy & TLS**:
```bash
TRAEFIK_DASHBOARD_ENABLED=false
TRAEFIK_LOG_LEVEL=INFO
TRAEFIK_ACCESSLOG_ENABLED=true
TRAEFIK_TRUSTED_IPS=10.0.0.0/8,172.16.0.0/12,192.168.0.0/16  # External TLS mode
```

**Cache (Optional — enable with `--profile cache`)**:
```bash
ZITADEL_CACHES_CONNECTORS_REDIS_ENABLED=false
ZITADEL_CACHES_CONNECTORS_REDIS_URL=redis://redis:6379/0
ZITADEL_CACHES_INSTANCE_CONNECTOR=
ZITADEL_CACHES_MILESTONES_CONNECTOR=
ZITADEL_CACHES_ORGANIZATION_CONNECTOR=
```

**Observability (Optional — enable with `--profile observability`)**:
```bash
ZITADEL_INSTRUMENTATION_TRACE_EXPORTER_TYPE=none  # or otlp
ZITADEL_INSTRUMENTATION_TRACE_EXPORTER_ENDPOINT=otel-collector:4317
ZITADEL_INSTRUMENTATION_SERVICENAME=zitadel-api
```

**Access Logs**:
```bash
ZITADEL_ACCESS_LOG_STDOUT_ENABLED=true
```

### Critical Deployment Note

> **⚠️ External URL Invariant**: `ZITADEL_EXTERNALDOMAIN`, `ZITADEL_EXTERNALPORT`, and `ZITADEL_EXTERNALSECURE` **must match the public URL** that users see. If they don't, ZITADEL returns "Instance not found" errors. This is the single most common deployment issue.

---

## Key Features & Examples

### Authentication Methods

**Interactive flows** (Login UI):
- Username & Password
- Passkeys (FIDO2 / WebAuthn)
- MFA: TOTP (authenticator app), U2F, OTP Email, OTP SMS
- LDAP integration
- Enterprise IdPs (Google, Azure AD, Okta, etc.)
- Social logins

**Protocol support**:
- OpenID Connect (OIDC) — OpenID certified
- SAML 2.0
- Device authorization (OAuth 2.0 Device Flow)
- Hosted Login V2 (fully customizable)

**Machine-to-machine (M2M)**:
- JWT Profile
- Personal Access Token (PAT)
- Client Credentials
- Service Accounts (non-interactive)

**Advanced**:
- Token exchange & impersonation
- Custom sessions for flows beyond OIDC/SAML

### Example: Create User via REST API V2

```bash
curl -X POST https://$ZITADEL_DOMAIN/v2/users/human \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "alice@example.com",
    "profile": {
      "givenName": "Alice",
      "familyName": "Smith"
    },
    "email": {
      "email": "alice@example.com",
      "sendCode": {}
    }
  }'
```

### Multi-Tenancy & B2B

- **Identity brokering** with pre-built IdP templates
- **Customizable B2B onboarding** with self-service for customers
- **Delegated role management** to third parties
- **Domain discovery** for automatic organization routing

### Integration & Extensibility

- **Actions** (webhooks, custom code, token enrichment) via Actions v2
- **SCIM 2.0 Server** for user provisioning
- **RBAC** (Role-based access control)
- **SDKs** for all major languages/frameworks
- **Audit log export** and SOC/SIEM integration via event stream

### Self-Service & Admin

- **Self-registration** with email/phone verification
- **Administration Console** (Management Console) for orgs and projects
- **Custom branding** per organization
- **Email & SMS notifications** (configurable)

---

## Core Concepts (Canonical Terminology)

| Term | Definition |
|------|-----------|
| **Instance** | Private, isolated top-level ZITADEL environment (replaces "IAM" or "System") |
| **Organization** | Group of users within an instance |
| **Project** | Container for applications sharing a role context |
| **Application** | Software/service secured using ZITADEL |
| **Service Account** | User with non-interactive auth flows (replaces "Machine User" or "Machine Account") |
| **User (Human)** | User with interactive authentication flows |
| **Role Assignment** | What a user is allowed to do (roles + org + user combination) |
| **Administrator** | Role granting administrative privileges |
| **Project Grant** | Delegation of project access to another organization |
| **Passkey** | Passwordless auth using device-bound credentials (WebAuthn/FIDO2) |
| **TOTP** | Time-based one-time password via authenticator app |
| **OTP Email** | One-time password delivered via email |
| **OTP SMS** | One-time password delivered via SMS |
| **Policies** | Enforcement rules governing checks and constraints (scoped: Instance or Organization) |
| **Settings** | Resource-specific configuration values (scoped: Instance or Organization) |
| **Custom Domain** | Domain identifying a ZITADEL instance (globally unique) |
| **Metadata** | Key-value custom data attached to resources |

For full terminology reference, see `TERMINOLOGY.md` in the repository.

---

## API Interfaces

ZITADEL exposes three transports:

### 1. **gRPC** (Primary — typed, efficient)
- Port `:8080` (default)
- Protocol: HTTP/2
- Supports gRPC and gRPC-web

### 2. **Connect-RPC** (gRPC for web/JavaScript)
- Same as gRPC but works in browsers
- Available at same port with h2c (HTTP/2 without TLS)

### 3. **HTTP/JSON REST** (V2 API via gRPC-gateway)
- Base path: `/v2/`
- Example: `GET /v2/users`, `POST /v2/users/human`
- Full REST parity with gRPC API

### API Documentation

- Full reference: https://zitadel.com/docs/apis/introduction
- SDK examples: https://zitadel.com/docs/sdk-examples/introduction
- Supported languages: Go, Python, Node.js, Java, C#, Rust, TypeScript, Swift, Kotlin, and more

### Example API Calls

**Authenticate (get access token)**:
```bash
# Machine-to-machine (client credentials)
curl -X POST https://$ZITADEL_DOMAIN/oauth/v2/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials&client_id=...&client_secret=..."
```

**List users** (requires admin token):
```bash
curl https://$ZITADEL_DOMAIN/v2/users \
  -H "Authorization: Bearer $TOKEN"
```

**Check OIDC configuration**:
```bash
curl https://$ZITADEL_DOMAIN/.well-known/openid-configuration
```

---

## Real-World Users (Adopters)

Organizations using ZITADEL in production:

- **Zitadel Cloud** — Zitadel itself (of course)
- **Rawkode Academy** — Platform & Zulip SSO
- **XPeditionist** — All-in-one travel solution
- **devOS: Sanity Edition** — Internal/external infrastructure SSO
- **CNAP.tech** — Cloud-native application auth
- **Minekube** — Gaming infrastructure auth
- **Dribdat** — Hackathon identity education
- **Micromate** — Digital learning platform auth
- **Smat.io** — B2B portfolio management + auth
- **hirschengraben** — B2B dispatch app (bike messengers)
- **OpenAIP**, **roclub GmbH**, **CEEX AG**, **D1V.AI** — Various SaaS/cloud products

See full list in `ADOPTERS.md`.

---

## Technology Stack

**Backend**:
- **Language**: Go 1.25.0
- **API**: gRPC, Connect-RPC, gRPC-gateway (REST)
- **Database**: PostgreSQL (5.9.2 driver via pgx)
- **Queue**: River (job queue in PostgreSQL)
- **Cache**: Redis (optional, via go-redis/v9)
- **Auth libraries**: go-jose, go-webauthn, crewjam/saml, go-ldap
- **Observability**: OpenTelemetry, Prometheus metrics

**Frontend** (Login UI):
- **Framework**: Next.js
- **Language**: TypeScript
- **Port**: `:3000` (behind Traefik at `/ui/v2/login/`)

**Infrastructure**:
- **Reverse Proxy**: Traefik (v3.x)
- **Container**: Docker
- **Orchestration**: Docker Compose (for self-hosting) or Kubernetes (via Helm)

**Security**:
- **Password hashing**: Argon2 (OWASP standard)
- **Session management**: Secure cookies
- **TLS**: Support for ACME (Let's Encrypt), external TLS termination, or self-signed
- **CSRF protection**: Gorilla CSRF middleware

---

## Common Deployment Scenarios

### Local Development

```bash
docker compose up -d --wait
# Admin Console: http://localhost:8080/ui/v2/
# Credentials: Set during first login
```

### Homelab / Self-Hosted (Internal Network)

```bash
# Edit .env:
# - ZITADEL_DOMAIN=auth.internal
# - ZITADEL_EXTERNALPORT=443
# - ZITADEL_EXTERNALSECURE=true
# - Use docker-compose.mode-local-tls.yml overlay for self-signed certs

docker compose -f docker-compose.yml -f docker-compose.mode-local-tls.yml up -d
```

### Production (Internet-Facing)

```bash
# Prerequisites:
# 1. Update .env with production values
# 2. Use docker-compose.mode-letsencrypt.yml for Let's Encrypt
# 3. Set unique ZITADEL_MASTERKEY (32 chars)
# 4. Use strong POSTGRES passwords
# 5. Enable cache (--profile cache) and observability (--profile observability) as needed

docker compose \
  -f docker-compose.yml \
  -f docker-compose.mode-letsencrypt.yml \
  --profile cache \
  --profile observability \
  up -d --wait
```

### Kubernetes

- Use Helm charts (documented at https://zitadel.com/docs/self-hosting/deploy/kubernetes)
- Same environment variables, mounted via ConfigMaps/Secrets

---

## Updating ZITADEL

To upgrade to a new version:

```bash
# 1. Update .env
ZITADEL_VERSION=v4.17.0

# 2. Pull new images
docker compose --env-file .env pull

# 3. Restart services (zero-downtime via event-driven design)
docker compose --env-file .env up -d --wait
```

---

## Scaling Considerations

### Horizontal Scalability

- **Stateless API**: Run multiple `zitadel-api` instances behind Traefik/load balancer
- **No session store** required — sessions are self-contained tokens (JWT)
- **Event-driven**: All state changes persisted to PostgreSQL

### Performance Tuning

- **Redis cache** (optional) — Cache organization, instance, and milestone data
- **Database optimization** — PostgreSQL query optimization, connection pooling
- **Traefik load balancing** — HTTP/2 with h2c for gRPC efficiency

### High-Availability Deployment

```bash
# Run zitadel-api replicas via Docker Swarm or Kubernetes
# Keep single PostgreSQL (or use Postgres HA with streaming replication)
# Cache via Redis cluster (optional)
```

---

## Security Notes

From `SECURITY.md`:
- Responsible vulnerability disclosure: See https://zitadel.com/docs/legal/policies/vulnerability-disclosure-policy
- Technical advisories published for major issues
- Security policy available in repository

### Insecure Defaults (Development Only)

The `.env.example` file includes development defaults:
- Weak masterkey: `MasterkeyNeedsToHave32Characters`
- Weak database password: `postgres`

**Before deploying to production**:
1. Generate a new 32-character random masterkey
2. Use strong, random passwords for `POSTGRES_ADMIN_PASSWORD`
3. Set `ZITADEL_EXTERNALSECURE=true` and use TLS overlay
4. Restrict database access to ZITADEL services only

---

## Testing the Stack

NX targets in `deploy/compose/project.json`:

```bash
nx test-config          # Validate Docker Compose configs
nx test-run             # Build & start stack
nx test-e2e             # Playwright browser tests
nx test-full            # Full pipeline (config → run → E2E → teardown)
nx stop                 # Tear down and remove volumes
```

---

## Useful Links

- **Docs**: https://zitadel.com/docs/
- **Quick Start**: https://zitadel.com/docs/guides/start/quickstart
- **API Reference**: https://zitadel.com/docs/apis/introduction
- **Roadmap**: https://zitadel.com/roadmap
- **Changelog**: https://zitadel.com/changelog
- **Discord Community**: https://discord.gg/YgjEuJzZ3x
- **GitHub Issues**: https://github.com/zitadel/zitadel/issues
- **Contributing**: See `CONTRIBUTING.md` in repository

---

**Document source**: ZITADEL GitHub repository (`zitadel/zitadel`)  
**Built from**: README.md, TERMINOLOGY.md, ADOPTERS.md, deploy/ configs, docker-compose.yml, .env.example, go.mod  
**Generated**: 2026-08-29
