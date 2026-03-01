# Bounty Ghost — Phase 2 Backend Architecture

> **Status:** Planned. Phase 1 runs entirely on Flutter mock services.  
> Phase 2 begins when `AppConfig.useMock` is flipped to `false`.

---

## System Overview

```
┌───────────────────────────────────────────────────────────────────┐
│                         CLIENT TIER                               │
│   Flutter App (iOS / Android)                                     │
│   ├── REST calls  →  Dio  →  Spring Boot REST API                │
│   └── Realtime    →  stomp_dart_client  →  Spring STOMP/WS       │
└───────────────────────────────────────────────────────────────────┘
                              │  HTTPS / WSS
┌───────────────────────────────────────────────────────────────────┐
│                         API GATEWAY (PLANNED)                     │
│   Kong / AWS API Gateway  —  Rate limiting, TLS termination       │
└───────────────────────────────────────────────────────────────────┘
                              │
┌───────────────────────────────────────────────────────────────────┐
│                    MICROSERVICES TIER (Spring Boot)               │
│                                                                   │
│  ┌─────────────────┐  ┌──────────────────┐  ┌────────────────┐  │
│  │  Auth Service   │  │  Bounty Service  │  │ Wallet Service │  │
│  │  :8081          │  │  :8082           │  │ :8083          │  │
│  │  Spring Security│  │  PostGIS queries │  │ Escrow / Txns  │  │
│  │  JWT / OAuth2   │  │  WebSocket push  │  │ (Stripe Phase3)│  │
│  └─────────────────┘  └──────────────────┘  └────────────────┘  │
│                                                                   │
│  ┌─────────────────┐  ┌──────────────────┐                       │
│  │ Location Service│  │ Notification Svc │                       │
│  │  :8084          │  │  :8085           │                       │
│  │  STOMP / WS     │  │  FCM / APNs push │                       │
│  └─────────────────┘  └──────────────────┘                       │
└───────────────────────────────────────────────────────────────────┘
                              │
┌───────────────────────────────────────────────────────────────────┐
│                       DATA TIER                                   │
│   PostgreSQL 16 + PostGIS extension  (primary relational store)  │
│   Redis 7                            (session cache / pub-sub)   │
│   (Phase 3) Apache Kafka             (event streaming)           │
└───────────────────────────────────────────────────────────────────┘
```

---

## Technology Stack

| Layer | Technology | Purpose |
|---|---|---|
| Language | Java 21 (LTS) | Spring Boot 3.x |
| Framework | Spring Boot 3.3 | REST + WebSocket microservices |
| Security | Spring Security 6 + JWT | Stateless auth with RS256 tokens |
| Database | PostgreSQL 16 + PostGIS | Relational + geospatial queries |
| ORM | Spring Data JPA + Hibernate Spatial | Entity mapping + geo queries |
| Cache | Redis 7 | JWT denylist, session, pub-sub |
| Realtime | Spring WebSocket + STOMP | Live location & bounty updates |
| Migration | Flyway | Versioned DB schema management |
| Docs | SpringDoc OpenAPI 3 (Swagger UI) | Auto-generated API docs |
| Containerization | Docker + Docker Compose | Local development |
| Orchestration | Kubernetes (K8s) | Production deployment |
| CI/CD | GitHub Actions | Build → Test → Deploy pipeline |
| Monitoring | Prometheus + Grafana | Metrics & dashboards |
| Tracing | OpenTelemetry + Jaeger | Distributed tracing |

---

## Microservice Breakdown

### 1. Auth Service (`:8081`)
- **Endpoints:** `POST /api/v1/auth/register`, `POST /api/v1/auth/login`, `POST /api/v1/auth/refresh`, `POST /api/v1/auth/logout`
- **Tech:** Spring Security + JWT (RS256 asymmetric keys). Tokens stored in Redis for denylist on logout.
- **Flutter integration:** `IUserService` → `RemoteUserService` → Dio with `AuthInterceptor` injecting `Bearer <token>`.

### 2. Bounty Service (`:8082`)
- **Endpoints:** See `api_spec.md`
- **Tech:** PostGIS `ST_DWithin` for geospatial radius queries. Spring WebSocket + STOMP for real-time bounty marker updates broadcast to nearby clients.
- **Key table:** `bounties (id UUID, location GEOGRAPHY(POINT,4326), reward_cents INT, status ENUM, expires_at TIMESTAMPTZ, ...)`
- **Flutter integration:** `IBountyService` → `RemoteBountyService` → Dio (REST) + `stomp_dart_client` (live markers).

### 3. Wallet Service (`:8083`)
- **Tech:** Pessimistic locking on `wallet` rows for concurrent credit/debit safety. Escrow table for in-flight bounties.
- **Phase 3:** Stripe integration for real fiat on-ramp/off-ramp.
- **Flutter integration:** `IWalletService` → `RemoteWalletService` → Dio.

### 4. Location Service (`:8084`)
- **Tech:** Spring WebSocket + STOMP. Hunters publish location every 3s. Posters subscribe to their active bounty's hunter topic.
- **Flutter integration:** `stomp_dart_client` subscribes to `/topic/bounty/{id}/location`.

### 5. Notification Service (`:8085`)
- **Tech:** Firebase Cloud Messaging (FCM) for Android, APNs for iOS. Triggered by Bounty Service events (new nearby bounty, bounty accepted, completed).

---

## Database Schema (Key Tables)

```sql
-- PostGIS extension
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE users (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(255) UNIQUE NOT NULL,
    password    VARCHAR(255) NOT NULL, -- bcrypt
    rating      DECIMAL(3,2) DEFAULT 0,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE bounties (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title        VARCHAR(200) NOT NULL,
    description  TEXT,
    reward_cents INT NOT NULL CHECK (reward_cents > 0),
    location     GEOGRAPHY(POINT, 4326) NOT NULL, -- (lng, lat)
    status       VARCHAR(20) DEFAULT 'OPEN',
    category     VARCHAR(50),
    is_urgent    BOOLEAN DEFAULT FALSE,
    poster_id    UUID REFERENCES users(id),
    hunter_id    UUID REFERENCES users(id),
    posted_at    TIMESTAMPTZ DEFAULT NOW(),
    expires_at   TIMESTAMPTZ NOT NULL,
    CONSTRAINT status_check CHECK (status IN ('OPEN','ACCEPTED','IN_PROGRESS','COMPLETED','CANCELLED','EXPIRED'))
);

-- Geospatial index for ST_DWithin queries
CREATE INDEX idx_bounties_location ON bounties USING GIST(location);

CREATE TABLE wallets (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID UNIQUE REFERENCES users(id),
    balance_cents INT DEFAULT 0 CHECK (balance_cents >= 0),
    escrow_cents  INT DEFAULT 0 CHECK (escrow_cents >= 0)
);

CREATE TABLE transactions (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_id   UUID REFERENCES wallets(id),
    type        VARCHAR(20) NOT NULL,
    amount_cents INT NOT NULL,
    description TEXT,
    bounty_id   UUID REFERENCES bounties(id),
    created_at  TIMESTAMPTZ DEFAULT NOW()
);
```

---

## Deployment (Kubernetes)

```
k8s/
├── namespace.yaml
├── auth-service/
│   ├── deployment.yaml
│   └── service.yaml
├── bounty-service/
│   ├── deployment.yaml
│   └── service.yaml
├── wallet-service/
│   ├── deployment.yaml
│   └── service.yaml
├── postgres/
│   ├── statefulset.yaml
│   └── pvc.yaml
├── redis/
│   └── deployment.yaml
└── ingress.yaml          # NGINX ingress with TLS
```

---

## Security Considerations
- All inter-service communication uses mTLS in production.
- JWT secrets use RS256 (asymmetric) — public key distributed to all services.
- Rate limiting at API Gateway: 100 req/min per IP for auth endpoints.
- PostGIS queries are parameterized — no raw string concatenation.
- Wallet operations use `SELECT ... FOR UPDATE` (pessimistic locking).
- Sensitive config (DB passwords, JWT keys) via Kubernetes Secrets, not ConfigMaps.
