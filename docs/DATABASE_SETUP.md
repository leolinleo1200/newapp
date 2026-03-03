# AquaTrack 資料庫設定指南

## 資料庫選擇：PostgreSQL

### 為什麼選擇 PostgreSQL？

1. **開源且成熟**：穩定可靠，社群支援完善
2. **強大的資料類型**：支援 JSON、Array、時間戳等複雜類型
3. **ACID 合規**：確保資料一致性
4. **優秀的效能**：適合中大型應用
5. **雲端支援**：GCP Cloud SQL、AWS RDS、Azure Database 都支援
6. **擴充性**：可透過 pg_partman 做資料分區、pgBouncer 做連線池

## 快速開始

### 選項 1: 本地開發環境 (Docker)

```bash
# 1. 啟動 PostgreSQL 容器
docker run --name aquatrack-db \
  -e POSTGRES_DB=aquatrack \
  -e POSTGRES_USER=aquatrack_user \
  -e POSTGRES_PASSWORD=your_password_here \
  -p 5432:5432 \
  -d postgres:15

# 2. 等待容器啟動 (約 5 秒)
sleep 5

# 3. 初始化資料庫結構
docker exec -i aquatrack-db psql -U aquatrack_user -d aquatrack < docs/aquatrack_1_6_db.sql

# 4. 載入範例資料
docker exec -i aquatrack-db psql -U aquatrack_user -d aquatrack < docs/seed_data.sql

# 5. 驗證資料
docker exec -it aquatrack-db psql -U aquatrack_user -d aquatrack -c "SELECT COUNT(*) FROM Users;"
```

### 選項 2: Windows 本機安裝

```powershell
# 1. 下載並安裝 PostgreSQL
# https://www.postgresql.org/download/windows/
# 建議安裝版本: PostgreSQL 15 或更新

# 2. 安裝後，使用 psql 連線
psql -U postgres

# 3. 在 psql 中執行：
CREATE DATABASE aquatrack;
CREATE USER aquatrack_user WITH PASSWORD 'your_password_here';
GRANT ALL PRIVILEGES ON DATABASE aquatrack TO aquatrack_user;
\q

# 4. 初始化資料庫
psql -U aquatrack_user -d aquatrack -f docs\aquatrack_1_6_db.sql

# 5. 載入範例資料
psql -U aquatrack_user -d aquatrack -f docs\seed_data.sql
```

### 選項 3: GCP Cloud SQL (推薦用於正式環境)

```bash
# 1. 建立 Cloud SQL 實例
gcloud sql instances create aquatrack-prod \
  --database-version=POSTGRES_15 \
  --tier=db-f1-micro \
  --region=asia-east1 \
  --root-password=secure_root_password

# 2. 建立資料庫
gcloud sql databases create aquatrack --instance=aquatrack-prod

# 3. 建立使用者
gcloud sql users create aquatrack_user \
  --instance=aquatrack-prod \
  --password=secure_user_password

# 4. 連線並初始化
gcloud sql connect aquatrack-prod --user=aquatrack_user --database=aquatrack
# 然後貼上 aquatrack_1_6_db.sql 和 seed_data.sql 的內容
```

## 資料庫結構說明

### 核心資料表

| 資料表 | 用途 | 關鍵欄位 |
|--------|------|----------|
| `Users` | 使用者帳號 | user_id, email, role (swimmer/coach/admin) |
| `Teams` | 隊伍/俱樂部 | team_id, name, created_by_user_id |
| `TeamMembers` | 隊伍成員關係 | team_id, user_id, status (pending/active/rejected) |
| `CompetitionResults` | 比賽成績 | user_id, stroke, distance, pool_length, time_ms |
| `OfficialRecords` | 官方標竿 | type (WR/OR/NR), stroke, distance, time_ms |
| `Targets` | 訓練目標 | athlete_user_id, target_ms, baseline_ms, status |
| `Plans` | 課表 | plan_id, team_id, is_template |
| `PlanSets` | 課表組合 | plan_id, stroke, distance, repetitions |
| `PlanAssignments` | 課表指派 | plan_id, team_id, athlete_user_id |
| `PlanFeedback` | 訓練回饋 | assignment_id, completion_percent, rpe |
| `TeamJoinCodes` | 入隊代碼 | team_id, code, qr_svg |

### 索引優化

系統已預設建立以下關鍵索引：

```sql
-- 成績查詢優化
idx_results_user: CompetitionResults(user_id)
idx_results_dims: CompetitionResults(user_id, stroke, distance, pool_length, time_ms)

-- 目標查詢優化
idx_targets_user: Targets(athlete_user_id, status, due_date)

-- 課表查詢優化
idx_plansets_plan: PlanSets(plan_id)
idx_planassign_team: PlanAssignments(team_id)
idx_planassign_user: PlanAssignments(athlete_user_id)
```

## 測試帳號資訊

初始化後可使用以下測試帳號：

### 選手帳號
- **Email**: `test@example.com`
- **密碼**: `password123`
- **角色**: Swimmer
- **資料**:
  - 11 筆比賽成績（涵蓋 4 種泳姿）
  - 3 個進行中目標、1 個已完成目標
  - 加入台北游泳隊（active）
  - 2 筆訓練回饋

### 教練帳號
- **Email**: `coach@example.com`
- **密碼**: `password123`
- **角色**: Coach
- **資料**:
  - 管理 2 個隊伍
  - 建立 3 份課表
  - 設定隊員目標

### 其他選手
- **Email**: `swimmer2@example.com`
- **密碼**: `password123`
- **角色**: Swimmer

## 環境變數設定

在 `.env` 檔案中設定資料庫連線：

```env
# 本地開發
DATABASE_URL=postgresql://aquatrack_user:your_password_here@localhost:5432/aquatrack

# GCP Cloud SQL (使用 Cloud SQL Proxy)
DATABASE_URL=postgresql://aquatrack_user:secure_user_password@/aquatrack?host=/cloudsql/project-id:region:instance-name

# 連線池設定
DB_POOL_MIN=2
DB_POOL_MAX=10
```

## 後端實作建議

### 技術棧選項

#### 選項 1: Node.js + TypeScript (推薦快速開發)

```bash
# 安裝套件
npm install express typeorm pg bcrypt jsonwebtoken
npm install -D @types/express @types/bcrypt @types/jsonwebtoken

# TypeORM 設定
import { DataSource } from "typeorm"

export const AppDataSource = new DataSource({
  type: "postgres",
  url: process.env.DATABASE_URL,
  entities: ["src/entity/**/*.ts"],
  migrations: ["src/migration/**/*.ts"],
  synchronize: false, // 正式環境必須設為 false
  logging: true,
})
```

#### 選項 2: Python + FastAPI (推薦 AI/ML 擴充)

```bash
# 安裝套件
pip install fastapi uvicorn sqlalchemy psycopg2-binary python-jose[cryptography] passlib[bcrypt]

# SQLAlchemy 設定
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL = os.getenv("DATABASE_URL")
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
```

#### 選項 3: Go + Gin (推薦高效能)

```bash
# 安裝套件
go get github.com/gin-gonic/gin
go get gorm.io/gorm
go get gorm.io/driver/postgres
go get github.com/golang-jwt/jwt/v5

# GORM 設定
import (
  "gorm.io/driver/postgres"
  "gorm.io/gorm"
)

dsn := os.Getenv("DATABASE_URL")
db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
```

### API 實作清單

根據 `docs/API_REFERENCE.md`，需要實作以下端點：

**認證模組** (5 個端點)
- `POST /auth/signup` - 註冊
- `POST /auth/login` - 登入
- `POST /auth/refresh` - 刷新 Token
- `GET /me` - 取得當前用戶
- `PATCH /me` - 更新用戶資料

**比賽成績模組** (4 個端點)
- `GET /competitions/results` - 查詢成績
- `POST /competitions/results` - 新增成績
- `GET /pb` - 取得個人最佳
- `GET /pb/compare` - 比較官方標竿

**隊伍模組** (8 個端點)
- `POST /teams` - 建立隊伍
- `GET /teams` - 查詢隊伍列表
- `GET /teams/{teamId}` - 取得隊伍詳情
- `POST /teams/{teamId}/join-codes` - 生成 Join Code
- `POST /teams/join` - 加入隊伍
- `GET /teams/{teamId}/members` - 取得隊員列表
- `PATCH /teams/{teamId}/members/{userId}` - 審核成員
- `DELETE /teams/{teamId}/members/{userId}` - 移除成員

## 資料備份策略

### 自動備份 (推薦)

```bash
# Cron job 設定（每日凌晨 2 點備份）
0 2 * * * pg_dump -U aquatrack_user aquatrack | gzip > /backups/aquatrack_$(date +\%Y\%m\%d).sql.gz

# 保留最近 30 天的備份
find /backups -name "aquatrack_*.sql.gz" -mtime +30 -delete
```

### 手動備份

```bash
# 完整備份
pg_dump -U aquatrack_user -d aquatrack -F c -f aquatrack_backup.dump

# 僅備份資料（不含結構）
pg_dump -U aquatrack_user -d aquatrack -a -F c -f aquatrack_data.dump

# 還原
pg_restore -U aquatrack_user -d aquatrack aquatrack_backup.dump
```

## 效能監控

### 查詢慢查詢

```sql
-- 啟用慢查詢日誌
ALTER DATABASE aquatrack SET log_min_duration_statement = 1000; -- 1 秒

-- 查看最耗時的查詢
SELECT 
  query,
  calls,
  total_time,
  mean_time,
  max_time
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 10;
```

### 資料表大小監控

```sql
-- 查看各資料表大小
SELECT
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

## 遷移管理

建議使用 migration 工具管理資料庫版本：

- **TypeORM**: `typeorm migration:create`
- **Alembic** (Python): `alembic revision --autogenerate`
- **golang-migrate**: `migrate create -ext sql -dir migrations`

## 安全建議

1. **密碼加密**: 使用 bcrypt，cost factor ≥ 10
2. **SQL 注入防護**: 使用 ORM 或 prepared statements
3. **連線加密**: 正式環境啟用 SSL/TLS
4. **最小權限**: 應用程式帳號不應有 DROP/ALTER 權限
5. **定期更新**: 保持 PostgreSQL 版本更新

## 疑難排解

### 連線失敗
```bash
# 檢查 PostgreSQL 是否啟動
pg_isready -h localhost -p 5432

# 檢查防火牆
netstat -an | findstr 5432  # Windows
netstat -tuln | grep 5432   # Linux/Mac
```

### 權限問題
```sql
-- 授予完整權限
GRANT ALL PRIVILEGES ON DATABASE aquatrack TO aquatrack_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO aquatrack_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO aquatrack_user;
```

### 清空資料重新開始
```sql
-- ⚠️ 危險：刪除所有資料
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
-- 然後重新執行 aquatrack_1_6_db.sql 和 seed_data.sql
```

## 下一步

1. ✅ 選擇並安裝 PostgreSQL
2. ✅ 執行初始化腳本
3. ✅ 載入範例資料
4. ⏭️ 選擇後端技術棧並實作 API
5. ⏭️ 在 Flutter app 中設定 API_BASE_URL
6. ⏭️ 測試完整流程

## 相關文件

- [API 參考文件](./API_REFERENCE.md)
- [資料庫結構](./aquatrack_1_6_db.sql)
- [範例資料](./seed_data.sql)
- [MVP 規格](./AquaTrack_1.6_MVP_Spec.md)
- [OpenAPI 規格](./aquatrack_1_6_openapi.yaml)
