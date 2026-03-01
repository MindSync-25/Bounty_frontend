# Bounty Ghost — API Specification (OpenAPI 3 Placeholder)

> **Base URL:** `https://api.bountyghost.com/api/v1`  
> **Auth:** Bearer JWT in `Authorization` header (all endpoints except `/auth/**`)  
> **Format:** JSON. All timestamps in ISO 8601 (UTC). Monetary values in **USD cents** (integers).

---

## Authentication

### `POST /api/v1/auth/register`
Register a new user account.

**Request Body:**
```json
{
  "name": "Ghost User",
  "email": "ghost@example.com",
  "password": "SecurePass123!"
}
```

**Response `201 Created`:**
```json
{
  "user": {
    "id": "uuid",
    "name": "Ghost User",
    "email": "ghost@example.com",
    "isVerified": false,
    "rating": 0.0,
    "createdAt": "2026-02-28T10:00:00Z"
  },
  "tokens": {
    "accessToken": "eyJ...",
    "refreshToken": "eyJ...",
    "expiresIn": 3600
  }
}
```

**Errors:** `409 Conflict` — email already registered.

---

### `POST /api/v1/auth/login`
Authenticate and receive JWT tokens.

**Request Body:**
```json
{
  "email": "ghost@example.com",
  "password": "SecurePass123!"
}
```

**Response `200 OK`:** Same structure as `/register`.

**Errors:** `401 Unauthorized` — invalid credentials.

---

### `POST /api/v1/auth/refresh`
Exchange a refresh token for a new access token.

**Request Body:**
```json
{ "refreshToken": "eyJ..." }
```

**Response `200 OK`:**
```json
{ "accessToken": "eyJ...", "expiresIn": 3600 }
```

---

### `POST /api/v1/auth/logout`
Invalidate current tokens (adds to Redis denylist).

**Response `204 No Content`**

---

## Bounties

### `GET /api/v1/bounties/nearby`
Fetch open bounties within radius of a coordinate.

**Query Parameters:**

| Param | Type | Required | Description |
|---|---|---|---|
| `lat` | `number` | ✅ | Latitude |
| `lng` | `number` | ✅ | Longitude |
| `radiusKm` | `number` | ❌ | Search radius in km (default: 5.0, max: 50.0) |
| `category` | `string` | ❌ | Filter by category (delivery, errand, tech, ...) |
| `minReward` | `integer` | ❌ | Minimum reward in cents |
| `urgent` | `boolean` | ❌ | Filter urgent only |
| `page` | `integer` | ❌ | Page number (default: 0) |
| `size` | `integer` | ❌ | Page size (default: 20, max: 100) |

**Response `200 OK`:**
```json
{
  "content": [
    {
      "id": "uuid",
      "title": "Pick up dry cleaning",
      "description": "...",
      "rewardCents": 1200,
      "category": "ERRAND",
      "status": "OPEN",
      "isUrgent": false,
      "distanceKm": 0.3,
      "location": { "lat": 37.7751, "lng": -122.4194 },
      "poster": {
        "id": "uuid",
        "name": "Alex K.",
        "rating": 4.9,
        "avatarUrl": "https://..."
      },
      "postedAt": "2026-02-28T09:48:00Z",
      "expiresAt": "2026-02-28T11:48:00Z"
    }
  ],
  "totalElements": 6,
  "totalPages": 1,
  "page": 0,
  "size": 20
}
```

**Spring Boot Implementation Note:**
```java
// BountyRepository.java
@Query(value = """
    SELECT *, ST_Distance(location::geography, ST_MakePoint(:lng, :lat)::geography) / 1000 AS distance_km
    FROM bounties
    WHERE status = 'OPEN'
      AND ST_DWithin(location::geography, ST_MakePoint(:lng, :lat)::geography, :radiusMeters)
      AND expires_at > NOW()
    ORDER BY distance_km ASC
    LIMIT :size OFFSET :offset
    """, nativeQuery = true)
List<BountyProjection> findNearby(
    @Param("lat") double lat,
    @Param("lng") double lng,
    @Param("radiusMeters") double radiusMeters,
    @Param("size") int size,
    @Param("offset") int offset
);
```

---

### `POST /api/v1/bounties`
Post a new bounty (requires auth).

**Request Body:**
```json
{
  "title": "Pick up dry cleaning",
  "description": "My order is ready at FreshPress on Main St.",
  "rewardCents": 1200,
  "category": "ERRAND",
  "isUrgent": false,
  "location": { "lat": 37.7751, "lng": -122.4194 },
  "expiresInHours": 4
}
```

**Response `201 Created`:** Full bounty object (same schema as nearby response item).

**Errors:**
- `400 Bad Request` — validation failure (missing fields, reward ≤ 0)
- `402 Payment Required` — insufficient wallet balance for escrow
- `401 Unauthorized`

---

### `GET /api/v1/bounties/{id}`
Get a single bounty by ID.

**Response `200 OK`:** Full bounty object.  
**Errors:** `404 Not Found`

---

### `POST /api/v1/bounties/{id}/accept`
Accept an open bounty as a hunter.

**Response `200 OK`:** Updated bounty with `status: "ACCEPTED"` and `hunterId`.

**Errors:**
- `409 Conflict` — bounty already accepted or expired
- `403 Forbidden` — poster cannot accept own bounty

---

### `POST /api/v1/bounties/{id}/complete`
Poster marks bounty as completed (releases escrow to hunter).

**Response `200 OK`:** Updated bounty with `status: "COMPLETED"`.

---

### `DELETE /api/v1/bounties/{id}`
Cancel a bounty (poster only, while status = `OPEN`).

**Response `204 No Content`**

**Errors:** `409 Conflict` — cannot cancel an accepted bounty

---

### `GET /api/v1/bounties/my/posted`
Get all bounties posted by authenticated user.

**Response `200 OK`:** Paginated list of bounty objects.

---

### `GET /api/v1/bounties/my/hunting`
Get all bounties accepted/hunted by authenticated user.

**Response `200 OK`:** Paginated list.

---

## Wallet

### `GET /api/v1/wallet`
Get authenticated user's wallet.

**Response `200 OK`:**
```json
{
  "userId": "uuid",
  "balanceCents": 12750,
  "escrowCents": 5000,
  "totalCents": 17750
}
```

---

### `POST /api/v1/wallet/deposit`
Add funds to wallet.

**Request Body:** `{ "amountCents": 5000 }`

**Response `200 OK`:** Updated wallet object.

---

### `POST /api/v1/wallet/withdraw`
Withdraw available balance.

**Request Body:** `{ "amountCents": 2000 }`

**Errors:** `422 Unprocessable Entity` — insufficient balance.

---

### `GET /api/v1/wallet/transactions`
Paginated transaction history.

**Query Params:** `page`, `size`

**Response `200 OK`:**
```json
{
  "content": [
    {
      "id": "uuid",
      "type": "CREDIT",
      "amountCents": 3500,
      "description": "Bounty completed: WiFi setup",
      "bountyId": "uuid",
      "createdAt": "2026-02-28T08:00:00Z"
    }
  ],
  "totalElements": 5
}
```

---

## WebSocket / STOMP (Real-time)

**Connection:** `wss://api.bountyghost.com/ws`  
**Protocol:** STOMP over WebSocket  
**Auth:** Pass JWT via `Authorization` header on CONNECT frame.

### Topics

| Topic | Direction | Description |
|---|---|---|
| `/topic/bounties/zone/{geohash}` | Server → Client | New bounty posted in zone |
| `/topic/bounty/{id}/location` | Server → Client | Hunter's live location update |
| `/app/location/update` | Client → Server | Hunter publishes their location |
| `/topic/bounty/{id}/status` | Server → Client | Bounty status changed |

**Location message payload:**
```json
{
  "bountyId": "uuid",
  "lat": 37.7751,
  "lng": -122.4194,
  "accuracy": 5.0,
  "timestamp": "2026-02-28T10:15:00Z"
}
```

---

## Error Response Schema

All errors follow this structure:
```json
{
  "status": 400,
  "error": "BAD_REQUEST",
  "message": "Human-readable error message",
  "code": "VALIDATION_ERROR",
  "timestamp": "2026-02-28T10:00:00Z",
  "path": "/api/v1/bounties"
}
```

---

## OpenAPI Swagger UI
Available at: `https://api.bountyghost.com/swagger-ui.html`  
JSON spec: `https://api.bountyghost.com/v3/api-docs`

Spring Boot dependency to enable:
```xml
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.5.0</version>
</dependency>
```
