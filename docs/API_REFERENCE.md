# 📡 AquaTrack API 文件

> 最後更新: 2025-11-09
> API 版本: 1.6.0  
> Base URL: `https://api.aquatrack.example.com/v1`

## 📋 目錄

- [認證 API](#認證-api)
- [比賽成績 API](#比賽成績-api)
- [隊伍管理 API](#隊伍管理-api)
- [資料模型](#資料模型)
- [錯誤處理](#錯誤處理)
- [認證方式](#認證方式)

---

## 認證 API

**檔案位置**: `lib/features/auth/data/auth_api.dart`

### 1. 註冊新帳號

```http
POST /auth/signup
```

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "securePassword123",
  "displayName": "使用者名稱",
  "birthdate": "1990-01-01",  // 選填
  "gender": "M"                // 選填: M, F, Other
}
```

**Response** (201 Created):
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIs...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
  "expiresIn": 3600
}
```

**錯誤**:
- `400` - Email 格式錯誤或密碼太短
- `409` - Email 已被使用

---

### 2. 登入

```http
POST /auth/login
```

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**Response** (200 OK):
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIs...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
  "expiresIn": 3600
}
```

**錯誤**:
- `400` - 缺少必要欄位
- `401` - Email 或密碼錯誤

---

### 3. 刷新 Token

```http
POST /auth/refresh
```

**Request Body**:
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
}
```

**Response** (200 OK):
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIs...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
  "expiresIn": 3600
}
```

**錯誤**:
- `401` - Refresh token 無效或過期

---

### 4. 取得當前使用者資料

```http
GET /me
```

**Headers**:
```
Authorization: Bearer {accessToken}
```

**Response** (200 OK):
```json
{
  "id": "user-uuid-123",
  "email": "user@example.com",
  "displayName": "使用者名稱",
  "birthdate": "1990-01-01",
  "gender": "M",
  "clubId": "club-uuid-456",
  "role": "swimmer",
  "createdAt": "2025-01-01T00:00:00Z"
}
```

**錯誤**:
- `401` - Token 無效或過期

---

### 5. 更新使用者資料

```http
PATCH /me
```

**Headers**:
```
Authorization: Bearer {accessToken}
```

**Request Body** (部分更新):
```json
{
  "displayName": "新名稱",
  "birthdate": "1990-01-01",
  "gender": "F"
}
```

**Response** (200 OK):
```json
{
  "id": "user-uuid-123",
  "email": "user@example.com",
  "displayName": "新名稱",
  "birthdate": "1990-01-01",
  "gender": "F",
  "clubId": "club-uuid-456",
  "role": "swimmer",
  "createdAt": "2025-01-01T00:00:00Z"
}
```

---

## 比賽成績 API

**檔案位置**: `lib/features/competitions/data/competition_api.dart`

### 6. 取得成績列表

```http
GET /competitions/results?limit=50&offset=0
```

**Headers**:
```
Authorization: Bearer {accessToken}
```

**Query Parameters**:
- `limit` (int, 選填): 回傳筆數，預設 50
- `offset` (int, 選填): 分頁偏移，預設 0

**Response** (200 OK):
```json
[
  {
    "id": "result-uuid-123",
    "userId": "user-uuid-123",
    "competitionName": "全國游泳錦標賽",
    "eventName": "男子 100M 自由式",
    "stroke": "Freestyle",
    "distanceMeters": 100,
    "poolLength": "SCM",
    "timeMs": 54320,
    "eventDate": "2025-10-15T00:00:00Z",
    "location": "台北體育館",
    "rank": 3,
    "notes": "個人最佳成績",
    "createdAt": "2025-10-16T12:00:00Z"
  }
]
```

**錯誤**:
- `401` - Token 無效

---

### 7. 新增成績

```http
POST /competitions/results
```

**Headers**:
```
Authorization: Bearer {accessToken}
```

**Request Body**:
```json
{
  "competitionName": "全國游泳錦標賽",
  "eventName": "男子 100M 自由式",
  "stroke": "Freestyle",
  "distanceMeters": 100,
  "poolLength": "SCM",
  "timeMs": 54320,
  "eventDate": "2025-10-15T00:00:00Z",
  "location": "台北體育館",
  "rank": 3,
  "notes": "個人最佳成績"
}
```

**泳姿選項** (`stroke`):
- `Freestyle` - 自由式
- `Backstroke` - 仰式
- `Breaststroke` - 蛙式
- `Butterfly` - 蝶式
- `IM` - 混合式

**池長選項** (`poolLength`):
- `SCM` - 短水道 (25m)
- `LCM` - 長水道 (50m)

**Response** (201 Created):
```json
{
  "id": "result-uuid-123",
  "userId": "user-uuid-123",
  "competitionName": "全國游泳錦標賽",
  "eventName": "男子 100M 自由式",
  "stroke": "Freestyle",
  "distanceMeters": 100,
  "poolLength": "SCM",
  "timeMs": 54320,
  "eventDate": "2025-10-15T00:00:00Z",
  "location": "台北體育館",
  "rank": 3,
  "notes": "個人最佳成績",
  "createdAt": "2025-10-16T12:00:00Z"
}
```

**錯誤**:
- `400` - 必填欄位缺失或格式錯誤
- `401` - Token 無效

---

### 8. 取得個人最佳成績 (PB)

```http
GET /pb?poolLength=SCM
```

**Headers**:
```
Authorization: Bearer {accessToken}
```

**Query Parameters**:
- `poolLength` (string, 選填): `SCM` 或 `LCM`，不指定則回傳全部

**Response** (200 OK):
```json
[
  {
    "stroke": "Freestyle",
    "distanceMeters": 100,
    "poolLength": "SCM",
    "bestTimeMs": 54320,
    "achievedDate": "2025-10-15T00:00:00Z",
    "competitionName": "全國游泳錦標賽"
  },
  {
    "stroke": "Butterfly",
    "distanceMeters": 50,
    "poolLength": "SCM",
    "bestTimeMs": 27890,
    "achievedDate": "2025-09-20T00:00:00Z",
    "competitionName": "區域運動會"
  }
]
```

---

### 9. 取得特定項目 PB

```http
GET /pb/{stroke}/{distance}?poolLength=SCM
```

**Path Parameters**:
- `stroke` (string): 泳姿 (Freestyle, Backstroke, Breaststroke, Butterfly, IM)
- `distance` (int): 距離 (米)

**Query Parameters**:
- `poolLength` (string, 選填): `SCM` 或 `LCM`

**範例**:
```http
GET /pb/Freestyle/100?poolLength=SCM
```

**Response** (200 OK):
```json
{
  "stroke": "Freestyle",
  "distanceMeters": 100,
  "poolLength": "SCM",
  "bestTimeMs": 54320,
  "achievedDate": "2025-10-15T00:00:00Z",
  "competitionName": "全國游泳錦標賽"
}
```

**錯誤**:
- `404` - 無此項目的成績

---

## 隊伍管理 API

**檔案位置**: `lib/features/teams/data/team_api.dart`

### 10. 取得我的隊伍列表

```http
GET /teams/my
```

**Headers**:
```
Authorization: Bearer {accessToken}
```

**Response** (200 OK):
```json
[
  {
    "id": "team-uuid-123",
    "name": "台北游泳隊",
    "clubId": "club-uuid-456",
    "coachId": "coach-uuid-789",
    "description": "競技游泳訓練隊",
    "createdAt": "2025-01-01T00:00:00Z"
  }
]
```

---

### 11. 建立新隊伍

```http
POST /teams
```

**Headers**:
```
Authorization: Bearer {accessToken}
```

**Request Body**:
```json
{
  "name": "台北游泳隊",
  "clubId": "club-uuid-456",
  "description": "競技游泳訓練隊"
}
```

**Response** (201 Created):
```json
{
  "id": "team-uuid-123",
  "name": "台北游泳隊",
  "clubId": "club-uuid-456",
  "coachId": "coach-uuid-789",
  "description": "競技游泳訓練隊",
  "createdAt": "2025-01-01T00:00:00Z"
}
```

**錯誤**:
- `400` - 必填欄位缺失
- `403` - 非教練角色無法建立隊伍

---

### 12. 取得隊伍詳情

```http
GET /teams/{teamId}
```

**Headers**:
```
Authorization: Bearer {accessToken}
```

**Response** (200 OK):
```json
{
  "id": "team-uuid-123",
  "name": "台北游泳隊",
  "clubId": "club-uuid-456",
  "coachId": "coach-uuid-789",
  "description": "競技游泳訓練隊",
  "createdAt": "2025-01-01T00:00:00Z"
}
```

**錯誤**:
- `404` - 隊伍不存在
- `403` - 無權限查看

---

### 13. 取得隊伍成員

```http
GET /teams/{teamId}/members
```

**Headers**:
```
Authorization: Bearer {accessToken}
```

**Response** (200 OK):
```json
[
  {
    "id": "member-uuid-123",
    "userId": "user-uuid-456",
    "teamId": "team-uuid-123",
    "displayName": "選手姓名",
    "email": "swimmer@example.com",
    "status": "approved",
    "joinedAt": "2025-01-05T00:00:00Z"
  }
]
```

**狀態值** (`status`):
- `pending` - 待審核
- `approved` - 已核准
- `rejected` - 已拒絕

---

### 14. 產生加入代碼

```http
POST /teams/{teamId}/join-code
```

**Headers**:
```
Authorization: Bearer {accessToken}
```

**Request Body**:
```json
{
  "expiresInDays": 7
}
```

**Response** (200 OK):
```json
{
  "code": "SWIM-ABC123",
  "qrCodeUrl": "https://api.example.com/qr/SWIM-ABC123.png",
  "expiresAt": "2025-11-16T00:00:00Z"
}
```

**錯誤**:
- `403` - 非教練無法產生代碼

---

### 15. 加入隊伍

```http
POST /join
```

**Headers**:
```
Authorization: Bearer {accessToken}
```

**Request Body**:
```json
{
  "code": "SWIM-ABC123"
}
```

**Response** (200 OK):
```json
{
  "code": "SWIM-ABC123"
}
```

**錯誤**:
- `400` - 代碼無效或已過期
- `409` - 已在此隊伍中

---

### 16. 更新成員狀態

```http
PUT /teams/{teamId}/members/{userId}
```

**Headers**:
```
Authorization: Bearer {accessToken}
```

**Request Body**:
```json
{
  "status": "approved"
}
```

**Response** (204 No Content)

**錯誤**:
- `403` - 非教練無法更新狀態
- `404` - 成員不存在

---

## 資料模型

### User (使用者)

```typescript
{
  id: string              // UUID
  email: string           // Email (唯一)
  displayName: string     // 顯示名稱
  birthdate?: string      // 生日 (ISO 8601)
  gender?: string         // 性別: M, F, Other
  clubId?: string         // 俱樂部 ID
  role: string            // 角色: swimmer, coach, admin
  createdAt: string       // 建立時間 (ISO 8601)
}
```

### CompetitionResult (比賽成績)

```typescript
{
  id?: string             // UUID
  userId: string          // 使用者 ID
  competitionName: string // 比賽名稱
  eventName: string       // 項目名稱
  stroke: string          // 泳姿
  distanceMeters: number  // 距離 (米)
  poolLength: string      // 池長: SCM, LCM
  timeMs: number          // 時間 (毫秒)
  eventDate: string       // 比賽日期 (ISO 8601)
  location?: string       // 地點
  rank?: number           // 名次
  notes?: string          // 備註
  createdAt?: string      // 建立時間
}
```

### PersonalBest (個人最佳)

```typescript
{
  stroke: string          // 泳姿
  distanceMeters: number  // 距離
  poolLength: string      // 池長
  bestTimeMs: number      // 最佳時間 (毫秒)
  achievedDate: string    // 達成日期
  competitionName?: string // 比賽名稱
}
```

### Team (隊伍)

```typescript
{
  id: string              // UUID
  name: string            // 隊伍名稱
  clubId?: string         // 俱樂部 ID
  coachId: string         // 教練 ID
  description?: string    // 描述
  createdAt: string       // 建立時間
}
```

### TeamMember (隊伍成員)

```typescript
{
  id: string              // UUID
  userId: string          // 使用者 ID
  teamId: string          // 隊伍 ID
  displayName: string     // 顯示名稱
  email?: string          // Email
  status: string          // 狀態: pending, approved, rejected
  joinedAt: string        // 加入時間
}
```

---

## 錯誤處理

### 標準錯誤回應格式

```json
{
  "error": {
    "code": "INVALID_EMAIL",
    "message": "Email 格式不正確",
    "details": {
      "field": "email",
      "value": "invalid-email"
    }
  }
}
```

### HTTP 狀態碼

| 狀態碼 | 說明 | 常見原因 |
|--------|------|----------|
| 200 | OK | 請求成功 |
| 201 | Created | 資源建立成功 |
| 204 | No Content | 操作成功但無回應內容 |
| 400 | Bad Request | 請求參數錯誤 |
| 401 | Unauthorized | 未認證或 Token 無效 |
| 403 | Forbidden | 無權限執行此操作 |
| 404 | Not Found | 資源不存在 |
| 409 | Conflict | 資源衝突 (如重複註冊) |
| 500 | Internal Server Error | 伺服器錯誤 |

---

## 認證方式

### JWT Bearer Token

所有需要認證的 API 都需要在 Header 中帶入 Access Token：

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Token 生命週期

1. **Access Token**: 有效期 1 小時
2. **Refresh Token**: 有效期 30 天
3. Token 過期時使用 `/auth/refresh` 刷新

### 自動刷新機制

Flutter 應用程式已實作自動 Token 刷新：
- 當 API 回傳 `401` 時自動嘗試刷新
- 刷新成功後重試原請求
- 刷新失敗則清除 Token 並導向登入頁

---

## 測試環境

### Mock 模式

開發時使用 Mock 模式，無需真實後端：

```dart
// lib/core/config/app_mode.dart
static const bool useMockMode = true;
```

### API Base URL 配置

在 `.env` 檔案中設定：

```env
# 開發環境
API_BASE_URL=http://localhost:3000/v1

# 測試環境
API_BASE_URL=https://staging-api.aquatrack.example.com/v1

# 正式環境
API_BASE_URL=https://api.aquatrack.example.com/v1
```

---

## 相關文件

- **OpenAPI 規格**: [aquatrack_1_6_openapi.yaml](aquatrack_1_6_openapi.yaml)
- **資料庫設計**: [aquatrack_1_6_db.sql](aquatrack_1_6_db.sql)
- **完整規格書**: [AquaTrack_1.6_MVP_Spec.md](AquaTrack_1.6_MVP_Spec.md)
- **模式切換指南**: [MODE_SWITCHING.md](MODE_SWITCHING.md)

---

## 更新日誌

### v1.6.0 (2025-11-09)
- ✅ 初始版本
- ✅ 認證 API (5 支)
- ✅ 比賽成績 API (4 支)
- ✅ 隊伍管理 API (8 支)
- ✅ JWT 認證機制
- ✅ 自動 Token 刷新

---

**總計**: 17 支 API | 3 個模組 | JWT 認證
