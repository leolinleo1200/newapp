-- AquaTrack 1.6 MVP — PostgreSQL 初始化結構
-- 注意：實際上線可再拆分為 migration 檔；此檔可做為 init schema 參考。

CREATE TABLE IF NOT EXISTS Users (
  user_id BIGSERIAL PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  name TEXT,
  role TEXT NOT NULL CHECK (role IN ('swimmer','coach','admin')) DEFAULT 'swimmer',
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS Teams (
  team_id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  created_by_user_id BIGINT NOT NULL REFERENCES Users(user_id),
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 多隊/多成員
CREATE TABLE IF NOT EXISTS TeamMembers (
  team_id BIGINT NOT NULL REFERENCES Teams(team_id) ON DELETE CASCADE,
  user_id BIGINT NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
  status TEXT NOT NULL CHECK (status IN ('pending','active','rejected')) DEFAULT 'pending',
  joined_at TIMESTAMP NOT NULL DEFAULT NOW(),
  PRIMARY KEY (team_id, user_id)
);

-- 比賽成績（僅 MVP 必要欄位）
CREATE TABLE IF NOT EXISTS CompetitionResults (
  result_id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
  stroke TEXT NOT NULL,                                           -- freestyle/backstroke/...
  distance INT NOT NULL,                                          -- 50/100/200 ...
  pool_length TEXT NOT NULL CHECK (pool_length IN ('25m','50m')),
  time_ms BIGINT NOT NULL,                                        -- 毫秒
  meet_name TEXT,
  date DATE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_results_user ON CompetitionResults(user_id);
CREATE INDEX IF NOT EXISTS idx_results_dims ON CompetitionResults(user_id, stroke, distance, pool_length, time_ms);

-- 官方標竿（簡版）
CREATE TABLE IF NOT EXISTS OfficialRecords (
  record_id BIGSERIAL PRIMARY KEY,
  type TEXT NOT NULL CHECK (type IN ('WR','OR','NR')),             -- 世界/奧運/國家
  country TEXT,
  stroke TEXT NOT NULL,
  distance INT NOT NULL,
  pool_length TEXT NOT NULL CHECK (pool_length IN ('25m','50m')),
  time_ms BIGINT NOT NULL,
  holder TEXT,
  date DATE
);
CREATE INDEX IF NOT EXISTS idx_official_dims ON OfficialRecords(type, country, stroke, distance, pool_length);

-- 目標（Targets）
CREATE TABLE IF NOT EXISTS Targets (
  target_id BIGSERIAL PRIMARY KEY,
  athlete_user_id BIGINT NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
  created_by_user_id BIGINT NOT NULL REFERENCES Users(user_id),
  pool_length TEXT NOT NULL CHECK (pool_length IN ('25m','50m')),
  stroke TEXT NOT NULL,
  distance INT NOT NULL,
  target_ms BIGINT NOT NULL,
  baseline_ms BIGINT,
  due_date DATE,
  status TEXT NOT NULL CHECK (status IN ('active','completed','expired','cancelled')) DEFAULT 'active',
  note TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_targets_user ON Targets(athlete_user_id, status, due_date);

-- 課表（Plans）
CREATE TABLE IF NOT EXISTS Plans (
  plan_id BIGSERIAL PRIMARY KEY,
  team_id BIGINT REFERENCES Teams(team_id) ON DELETE SET NULL,
  created_by_user_id BIGINT NOT NULL REFERENCES Users(user_id),
  title TEXT NOT NULL,
  is_template BOOLEAN NOT NULL DEFAULT FALSE,
  week_start DATE,
  description TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS PlanSets (
  plan_set_id BIGSERIAL PRIMARY KEY,
  plan_id BIGINT NOT NULL REFERENCES Plans(plan_id) ON DELETE CASCADE,
  order_no INT NOT NULL,
  stroke TEXT,
  distance INT,
  repetitions TEXT,
  target_pace_ms BIGINT,
  notes TEXT
);
CREATE INDEX IF NOT EXISTS idx_plansets_plan ON PlanSets(plan_id);

-- 指派：隊伍或個人
CREATE TABLE IF NOT EXISTS PlanAssignments (
  assignment_id BIGSERIAL PRIMARY KEY,
  plan_id BIGINT NOT NULL REFERENCES Plans(plan_id) ON DELETE CASCADE,
  team_id BIGINT REFERENCES Teams(team_id) ON DELETE CASCADE,
  athlete_user_id BIGINT REFERENCES Users(user_id) ON DELETE CASCADE,
  assigned_at TIMESTAMP NOT NULL DEFAULT NOW(),
  due_date DATE
);
CREATE INDEX IF NOT EXISTS idx_planassign_team ON PlanAssignments(team_id);
CREATE INDEX IF NOT EXISTS idx_planassign_user ON PlanAssignments(athlete_user_id);

-- 學員回饋
CREATE TABLE IF NOT EXISTS PlanFeedback (
  feedback_id BIGSERIAL PRIMARY KEY,
  assignment_id BIGINT NOT NULL REFERENCES PlanAssignments(assignment_id) ON DELETE CASCADE,
  athlete_user_id BIGINT NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
  completion_percent INT CHECK (completion_percent BETWEEN 0 AND 100),
  rpe INT CHECK (rpe BETWEEN 1 AND 10),
  comment TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_planfb_assignment ON PlanFeedback(assignment_id);

-- Join Code / QR
CREATE TABLE IF NOT EXISTS TeamJoinCodes (
  code_id BIGSERIAL PRIMARY KEY,
  team_id BIGINT NOT NULL REFERENCES Teams(team_id) ON DELETE CASCADE,
  code TEXT NOT NULL UNIQUE,
  qr_svg TEXT,
  expires_at TIMESTAMP,
  max_uses INT,
  used_count INT NOT NULL DEFAULT 0,
  created_by_user_id BIGINT NOT NULL REFERENCES Users(user_id),
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_joincodes_team ON TeamJoinCodes(team_id);

-- 建議外鍵/資料一致性策略：
-- - 由後端服務保證：新增較佳 PB 時即時更新緩存或以查詢計算 PB；
-- - 目標（Targets）建立時記錄 baseline_ms（當下 PB），供進度計算。

-- 角色最小資料：
-- 預設用戶 role='swimmer'；教練需以管理後台或 API 由 Admin 提升權限。
