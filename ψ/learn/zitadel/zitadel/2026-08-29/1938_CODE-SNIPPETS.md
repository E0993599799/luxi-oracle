# ZITADEL: Code Snippets & Core Patterns

**Repository**: zitadel/zitadel  
**Analysis Date**: 2026-08-29  
**Agent**: Code Snippets Collector (Agent 2)

---

## 1. Main Entry Point

### Root main.go

**File**: `/main.go` (22 lines)

```go
package main

import (
	"context"
	"os"

	"github.com/zitadel/zitadel/backend/v3/instrumentation/logging"
	"github.com/zitadel/zitadel/cmd"
)

func main() {
	args := os.Args[1:]
	rootCmd := cmd.New(os.Stdout, os.Stdin, args, nil)
	ctx := logging.NewCtx(context.Background(), logging.StreamRuntime)
	if err := rootCmd.ExecuteContext(ctx); err != nil {
		// error is logged by the command itself
		os.Exit(1)
	}
}
```

**What it wires up:**
- Creates a `cobra.Command` root via `cmd.New()` which registers all CLI subcommands
- Initializes logging context with `StreamRuntime` stream
- Hands off to Cobra's standard execution; errors already logged by command handlers

---

## 2. CLI Command Builder (Cobra Setup)

### cmd/zitadel.go

**File**: `/cmd/zitadel.go` (104 lines)

Key excerpt showing command registration:

```go
func New(out io.Writer, in io.Reader, args []string, server chan<- *start.Server) *cobra.Command {
	cmd := &cobra.Command{
		Use:   "zitadel",
		Short: "The ZITADEL CLI lets you interact with ZITADEL",
		Long:  `The ZITADEL CLI lets you interact with ZITADEL`,
		RunE: func(cmd *cobra.Command, args []string) error {
			return errors.New("no additional command provided")
		},
		Version:      build.Version(),
		SilenceUsage: true,
	}

	viper.AutomaticEnv()
	viper.SetEnvPrefix("ZITADEL")
	viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))
	viper.SetConfigType("yaml")
	err := loadDefaultConfig()
	logging.OnError(context.Background(), err).Fatal("unable to read default config")

	cobra.OnInitialize(initConfig)
	cmd.PersistentFlags().StringArrayVar(&configFiles, "config", nil, "path to config file to overwrite system defaults")

	cmd.AddCommand(
		admin.New(),                    // deprecated
		initialise.New(),
		setup.New(),
		start.New(server),
		start.NewStartFromInit(server),
		start.NewStartFromSetup(server),
		mirror.New(&configFiles),
		key.New(),
		ready.New(),
	)

	cmd.InitDefaultVersionFlag()
	return cmd
}
```

**Key patterns:**
- Embedded YAML config via `//go:embed` (default + FIPS overlay)
- Viper for config management with environment variable support
- Error handling immediately calls `.Fatal()` on logger (pattern: fail-fast at init)

---

## 3. gRPC/Connect API Implementation

### backend/v3/api/session/v2/session.go

**File**: `/backend/v3/api/session/v2/session.go` (60 lines)

Excerpt showing Connect Protocol (gRPC alternative) handler pattern:

```go
package v2

import (
	"context"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	"github.com/zitadel/zitadel/backend/v3/api/session/v2/convert"
	"github.com/zitadel/zitadel/backend/v3/domain"
	"github.com/zitadel/zitadel/backend/v3/storage/database/repository"
	object "github.com/zitadel/zitadel/pkg/grpc/object/v2"
	session "github.com/zitadel/zitadel/pkg/grpc/session/v2"
)

// Handler: ListSessions
func ListSessions(ctx context.Context, request *connect.Request[session.ListSessionsRequest]) (*connect.Response[session.ListSessionsResponse], error) {
	// 1. Convert gRPC request to domain model
	req, err := convert.ListSessionsRequestGRPCToDomain(ctx, request.Msg)
	if err != nil {
		return nil, err
	}

	// 2. Create domain query
	q := domain.NewListSessionsQuery(req)
	
	// 3. Invoke with injected repository
	err = domain.Invoke(ctx, q, domain.WithSessionRepo(repository.SessionRepository()))
	if err != nil {
		return nil, err
	}

	// 4. Convert domain response back to gRPC
	sessions := convert.DomainSessionListToGRPCResponse(q.Result())
	return connect.NewResponse(&session.ListSessionsResponse{
		Sessions: sessions,
		Details: &object.ListDetails{
			TotalResult: uint64(len(sessions)),
			Timestamp:   timestamppb.Now(),
		},
	}), nil
}

// Handler: DeleteSession
func DeleteSession(ctx context.Context, request *connect.Request[session.DeleteSessionRequest]) (*connect.Response[session.DeleteSessionResponse], error) {
	sessionDeleteCmd := domain.NewDeleteSessionCommand(request.Msg.GetSessionId(), request.Msg.GetSessionToken(), true)

	err := domain.Invoke(ctx, sessionDeleteCmd,
		domain.WithSessionRepo(repository.SessionRepository()),
	)

	if err != nil {
		return nil, err
	}

	details := &object.Details{}
	if !sessionDeleteCmd.DeletedAt.IsZero() {
		details.ChangeDate = timestamppb.New(sessionDeleteCmd.DeletedAt)
	}

	return connect.NewResponse(&session.DeleteSessionResponse{
		Details: details,
	}), nil
}
```

**Architectural pattern:**
- **Three-layer flow**: gRPC Request → Domain Query/Command → Repository
- **Connect Protocol** (not standard gRPC) for HTTP/1.1 + HTTP/2 compatibility
- **Dependency injection** via `domain.Invoke(ctx, q, domain.WithSessionRepo(...))`
- **Domain-driven design**: Query/Command objects encapsulate business logic
- **Type-safe conversion layer**: Separate `convert/` package handles protobuf ↔ domain translation

---

## 4. Structured Logging with Error Handling

### backend/v3/instrumentation/logging/logging.go

**File**: `/backend/v3/instrumentation/logging/logging.go` (222 lines)

Key patterns:

```go
// OnError is the central error-handling pattern
func OnError(ctx context.Context, err error) *ErrorContextLogger {
	if err == nil {
		return &ErrorContextLogger{ctx, noop, false}  // no-op logger if no error
	}
	var target *zerrors.ZitadelError
	if !errors.As(err, &target) {
		// Wrap unknown errors in ZitadelError with custom error ID
		target = zerrors.CreateZitadelError(zerrors.KindUnknown, err, "LOG-ii6Pi", "an unknown error occurred", 1)
	}
	return &ErrorContextLogger{
		ctx:          ctx,
		logger:       slogctx.FromCtx(ctx).With(slogctx.Err(target)),
		canTerminate: true,
	}
}

// ErrorContextLogger provides chainable logging methods
type ErrorContextLogger struct {
	ctx    context.Context
	logger *slog.Logger
	canTerminate bool
}

// Panic logs and panics (only if error was non-nil during creation)
func (l *ErrorContextLogger) Panic(msg string, args ...any) {
	log(l.ctx, l.logger, sloggcp.LevelAlert, msg, 1, args...)
	if l.canTerminate {
		panic(msg)
	}
}

// Fatal logs and exits with code 1
func (l *ErrorContextLogger) Fatal(msg string, args ...any) {
	log(l.ctx, l.logger, sloggcp.LevelEmergency, msg, 1, args...)
	if l.canTerminate {
		exit(1)
	}
}

// Stream-based logging initialization
func New(stream Stream, args ...any) *slog.Logger {
	if !instrumentation.IsStreamEnabled(stream) {
		return noop
	}
	args = append(args,
		slog.String("stream", stream.String()),
		slog.String("version", build.Version()),
	)
	return slog.Default().With(args...)
}

// Context-aware logging
func NewCtx(ctx context.Context, stream Stream, args ...any) context.Context {
	logger := New(stream, args...)
	return ToCtx(ctx, logger)
}
```

**Patterns:**
- **Error wrapping**: Automatically wraps unknown errors in structured `ZitadelError` with unique error IDs (e.g., "LOG-ii6Pi")
- **No-op logger on nil error**: `.OnError(ctx, nil).Warn(...)` silently succeeds
- **Structured context**: Uses `slog-context` for logger propagation through call stacks
- **Stream-based filtering**: Different streams (Runtime, Request, EventPusher, etc.) can be enabled/disabled independently
- **Terminable logger**: `.Fatal()` and `.Panic()` are no-ops on error-free paths (defensive design)

---

## 5. Protocol Buffers Schema

### proto/zitadel/session/v2/session.proto

**File**: `/proto/zitadel/session/v2/session.proto` (100+ lines)

Excerpt showing message structure and validation:

```protobuf
syntax = "proto3";

package zitadel.session.v2;

import "zitadel/object.proto";
import "google/protobuf/timestamp.proto";
import "protoc-gen-openapiv2/options/annotations.proto";
import "validate/validate.proto";

option go_package = "github.com/zitadel/zitadel/pkg/grpc/session/v2;session";

message Session {
  string id = 1;
  google.protobuf.Timestamp creation_date = 2;
  google.protobuf.Timestamp change_date = 3;
  uint64 sequence = 4;
  Factors factors = 5;
  map<string, bytes> metadata = 6;
  UserAgent user_agent = 7;
  optional google.protobuf.Timestamp expiration_date = 8;
}

message Factors {
  UserFactor user = 1;
  PasswordFactor password = 2;
  WebAuthNFactor web_auth_n = 3;
  IntentFactor intent = 4;
  TOTPFactor totp = 5;
  OTPFactor otp_sms = 6;
  OTPFactor otp_email = 7;
  RecoveryCodeFactor recovery_code = 8;
}

message UserFactor {
  reserved 5;
  reserved "organisation_id";  // Backward compatibility marker

  google.protobuf.Timestamp verified_at = 1;
  string id = 2;
  string login_name = 3;
  string display_name = 4;
  string organization_id = 6;
}
```

**Patterns:**
- **Versioned services**: v2, v2beta in separate proto packages (no breaking changes to v2)
- **Embedded validation**: `validate/validate.proto` imports enable proto-level validation
- **Backwards compatibility**: `reserved` fields mark deprecated fields (e.g., `organisation_id` removed but reserved)
- **Metadata flexibility**: `map<string, bytes>` for extensibility without schema changes
- **OpenAPI codegen**: `protoc-gen-openapiv2` generates REST documentation alongside gRPC

---

## 6. Protobuf Codegen Configuration

### buf.gen.yaml

**File**: `/buf.gen.yaml` (24 lines)

```yaml
version: v1
plugins:
  - plugin: go
    out: .artifacts/grpc
  - plugin: go-grpc
    out: .artifacts/grpc
  - plugin: grpc-gateway
    out: .artifacts/grpc
    opt: 
    - allow_delete_body=true
  - plugin: openapiv2
    out: .artifacts/grpc
    opt: 
    - allow_delete_body=true
  - plugin: validate
    out: .artifacts/grpc
    opt: lang=go
  - plugin: authoption
    out: .artifacts/grpc
  - plugin: zitadel
    out: .artifacts/grpc
  - plugin: connect-go
    out: .artifacts/grpc
```

**Codegen strategy:**
- **Go stubs** + **Go gRPC** (standard Google-generated code)
- **gRPC Gateway** (REST/HTTP/1.1 proxy for gRPC endpoints)
- **OpenAPI v2** (Swagger docs auto-generated from proto)
- **Validation** (proto-level validation code in Go)
- **Connect-Go** (Connectrpc/Connect Protocol alternative to gRPC, HTTP/1.1 compatible)
- **Custom authoption** (Zitadel-specific auth metadata codegen)
- Custom **zitadel** plugin (likely for internal code generation)

All outputs to `.artifacts/grpc/` (likely git-ignored and generated at build time).

---

## 7. Database Repository Pattern

### backend/v3/storage/database/repository/repository.go

**File**: `/backend/v3/storage/database/repository/repository.go` (100+ lines)

Generic query/update/delete abstractions:

```go
package repository

import (
	"context"
	"github.com/zitadel/zitadel/backend/v3/domain"
	"github.com/zitadel/zitadel/backend/v3/storage/database"
)

// writeCondition appends a WHERE clause to the SQL builder
func writeCondition(
	builder *database.StatementBuilder,
	condition database.Condition,
) {
	if condition == nil {
		return
	}
	builder.WriteString(" WHERE ")
	condition.Write(builder)
}

// checkRestrictingColumns ensures condition restricts all required columns
func checkRestrictingColumns(
	condition database.Condition,
	requiredColumns ...database.Column,
) error {
	for _, col := range requiredColumns {
		if !condition.IsRestrictingColumn(col) {
			return database.NewMissingConditionError(col)
		}
	}
	return nil
}

// checkPKCondition ensures only a single row is affected by updates/deletes
func checkPKCondition(
	repo domain.Repository,
	condition database.Condition,
) error {
	return checkRestrictingColumns(
		condition,
		repo.PrimaryKeyColumns()...,
	)
}

// Generic getOne with type parameter
func getOne[Target any](ctx context.Context, querier database.Querier, builder *database.StatementBuilder) (*Target, error) {
	rows, err := querier.Query(ctx, builder.String(), builder.Args()...)
	if err != nil {
		return nil, err
	}
	var target Target
	if err := rows.(database.CollectableRows).CollectExactlyOneRow(&target); err != nil {
		return nil, err
	}
	return &target, nil
}

// Generic getMany with type parameter
func getMany[Target any](ctx context.Context, querier database.Querier, builder *database.StatementBuilder) ([]*Target, error) {
	rows, err := querier.Query(ctx, builder.String(), builder.Args()...)
	if err != nil {
		return nil, err
	}
	var targets []*Target
	if err := rows.(database.CollectableRows).Collect(&targets); err != nil {
		return nil, err
	}
	return targets, nil
}

// updateOne with automatic UpdatedAt tracking
func updateOne[Target updatable](ctx context.Context, client database.QueryExecutor, target Target, condition database.Condition, changes ...database.Change) (int64, error) {
	if len(changes) == 0 {
		return 0, database.ErrNoChanges
	}
	if err := checkPKCondition(target, condition); err != nil {
		return 0, err
	}
	// Auto-add UpdatedAt if not already present in changes
	if !database.Changes(changes).IsOnColumn(target.UpdatedAtColumn()) {
		changes = append(changes, database.NewChange(target.UpdatedAtColumn(), database.NullInstruction))
	}
	builder := database.NewStatementBuilder("UPDATE ")
	builder.WriteString(target.qualifiedTableName())
	builder.WriteString(" SET ")
	if err := database.Changes(changes).Write(builder); err != nil {
		return 0, err
	}
	writeCondition(builder, condition)
	return client.Exec(ctx, builder.String(), builder.Args()...)
}
```

**Database patterns:**
- **Type parameters (Go 1.18+)**: `getOne[Target]`, `getMany[Target]` for type-safe queries
- **Builder pattern**: `StatementBuilder` accumulates SQL fragments and arguments separately
- **Condition interface**: Composable WHERE clauses with column validation
- **Safety checks**: Primary key conditions required on UPDATE/DELETE (prevents accidental full-table mutations)
- **Automatic UpdatedAt**: `updateOne` silently adds UpdatedAt timestamp if missing
- **Typed change sets**: `database.Changes` validates which columns are being modified

---

## 8. Server Startup & Wiring

### cmd/start/start.go (excerpt)

**File**: `/cmd/start/start.go` (lines 1–150)

Demonstrates complete dependency injection:

```go
package start

import (
	"context"
	"crypto/tls"
	_ "embed"
	"errors"
	"fmt"
	"math"
	"net/http"
	"os"
	"os/signal"
	"slices"
	"syscall"
	"time"

	clockpkg "github.com/benbjohnson/clock"
	"github.com/common-nighthawk/go-figure"
	"github.com/fatih/color"
	"github.com/gorilla/mux"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"github.com/zitadel/oidc/v3/pkg/op"
	"github.com/zitadel/saml/pkg/provider"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"golang.org/x/text/language"

	new_domain "github.com/zitadel/zitadel/backend/v3/domain"
	"github.com/zitadel/zitadel/backend/v3/instrumentation/logging"
	v3_postgres "github.com/zitadel/zitadel/backend/v3/storage/database/dialect/postgres"
	"github.com/zitadel/zitadel/cmd/build"
	"github.com/zitadel/zitadel/cmd/encryption"
	"github.com/zitadel/zitadel/cmd/key"
	cmd_tls "github.com/zitadel/zitadel/cmd/tls"
	"github.com/zitadel/zitadel/internal/actions"
	// ... 90+ more imports ...
)

func New(server chan<- *Server) *cobra.Command {
	start := &cobra.Command{
		Use:   "start",
		Short: "starts ZITADEL instance",
		Long: `starts ZITADEL.
Requirements:
- postgreSQL`,
		RunE: func(cmd *cobra.Command, args []string) (err error) {
			defer func() {
				logging.OnError(cmd.Context(), err).Error("zitadel start command failed")
			}()

			// 1. Load TLS configuration
			err = cmd_tls.ModeFromFlag(cmd)
			if err != nil {
				return err
			}
			
			// 2. Load config from flags/env/files
			config, shutdown, err := NewConfig(cmd, viper.GetViper())
			if err != nil {
				return err
			}
			defer func() {
				err = errors.Join(err, shutdown(cmd.Context()))
			}()

			// 3. Decrypt master key
			masterKey, err := key.MasterKey(cmd)
			if err != nil {
				// ... continues with database connection, middleware setup, etc.
			}
		},
	}
	return start
}
```

**Startup patterns:**
- **Deferred shutdown**: `defer shutdown()` ensures resources are cleaned even on error
- **Error accumulation**: `errors.Join(err, shutdown(...))` chains multiple errors
- **Flag + Viper**: Cobra flags parsed into Viper config
- **TLS mode setup**: Loaded early (affects all downstream connections)
- **Master key decryption**: Happens after config loads, before database connection
- **Rich import set**: 90+ imports indicate extensive subsystem integration (OIDC, SAML, SCIM, queues, caching, etc.)

---

## 9. Key Idioms & Naming Conventions

### Codebase-Specific Patterns

1. **Command & Query Objects** (Domain-Driven Design)
   - `domain.NewListSessionsQuery(req)` — Query objects encapsulate read logic
   - `domain.NewDeleteSessionCommand(...)` — Command objects encapsulate write logic
   - `domain.Invoke(ctx, q, opts...)` — Execute with dependency injection

2. **Three-Layer Architecture**
   - **API Layer** (gRPC/Connect handlers): Request validation, conversion
   - **Domain Layer**: Business logic, query/command execution
   - **Repository/Storage Layer**: Database queries, caching

3. **Error Handling Idiom**
   ```go
   logging.OnError(ctx, err).Error("message", "arg", value)      // Log only if err != nil
   logging.OnError(ctx, err).Fatal("critical error")              // Exit if err != nil
   logging.OnError(ctx, err).Warn("message")                      // No-op if err == nil
   ```
   - Zero-cost on nil error (returns noop logger)
   - Automatic error wrapping in ZitadelError with unique ID

4. **Conversion Layer Naming**
   - `convert.ListSessionsRequestGRPCToDomain(ctx, msg)` — gRPC → domain
   - `convert.DomainSessionListToGRPCResponse(result)` — domain → gRPC
   - Bidirectional naming makes flow explicit

5. **Versioning Strategy**
   - Proto packages: `zitadel.session.v2`, `zitadel.session.v2beta`
   - Go paths: `github.com/zitadel/zitadel/internal/api/grpc/session/v2`
   - No breaking changes within version; new version gets new package

6. **Dependency Injection via Options**
   - `domain.Invoke(ctx, cmd, domain.WithSessionRepo(repo), domain.WithLogger(logger))`
   - Functional options pattern for flexible dependency binding

7. **Embedded Config Files**
   - `//go:embed defaults.yaml` — Binary-embedded defaults
   - `//go:embed defaults_fips.yaml` — FIPS overlay config
   - Merged at runtime based on crypto mode

---

## Summary

**ZITADEL is a gRPC/HTTP identity and access management platform** with:

- **gRPC-first API** via Connect Protocol (HTTP/1.1 compatible)
- **Domain-driven design** with Command/Query pattern
- **Type-safe generic repository** layer (Go 1.18+)
- **Structured logging** with stream-based filtering and automatic error wrapping
- **Protocol Buffers** with code generation (Connect, gRPC-Gateway, OpenAPI, validation)
- **Multi-layer startup** with cascading dependency injection
- **Defensive coding**: no-op loggers, validated SQL conditions, automatic timestamps
- **Comprehensive error handling**: Unique error IDs, type-safe ZitadelError wrapping
- **Versioning discipline**: API versions in package paths, backwards-compatible reserved fields

The codebase emphasizes **type safety, composability, and fail-safety** over convenience.
