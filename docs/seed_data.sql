-- AquaTrack 1.6 - 範例測試資料
-- 此檔案用於初始化 test@example.com 帳號與範例資料

-- ==============================================
-- 1. 測試用戶
-- ==============================================
-- 密碼: password123 (實際環境需使用 bcrypt hash)
INSERT INTO Users (user_id, email, password_hash, name, role, created_at, updated_at)
VALUES 
  (1, 'test@example.com', '$2b$10$rH9HqT0MQ9.gN8SqYrz3GuZWWzxYJGjqQnXWFv8.6p0iWXEZLJ5mK', 'Test User', 'swimmer', NOW(), NOW()),
  (2, 'coach@example.com', '$2b$10$rH9HqT0MQ9.gN8SqYrz3GuZWWzxYJGjqQnXWFv8.6p0iWXEZLJ5mK', 'Coach Lee', 'coach', NOW(), NOW()),
  (3, 'swimmer2@example.com', '$2b$10$rH9HqT0MQ9.gN8SqYrz3GuZWWzxYJGjqQnXWFv8.6p0iWXEZLJ5mK', 'Amy Chen', 'swimmer', NOW(), NOW())
ON CONFLICT (email) DO NOTHING;

-- 設定 sequence 起始值
SELECT setval('users_user_id_seq', 100, false);

-- ==============================================
-- 2. 隊伍資料
-- ==============================================
INSERT INTO Teams (team_id, name, description, created_by_user_id, created_at)
VALUES 
  (1, '台北游泳隊', '台北市立游泳訓練隊', 2, NOW()),
  (2, '新竹鯊魚隊', '新竹地區競技游泳隊', 2, NOW())
ON CONFLICT (team_id) DO NOTHING;

SELECT setval('teams_team_id_seq', 100, false);

-- ==============================================
-- 3. 隊伍成員
-- ==============================================
INSERT INTO TeamMembers (team_id, user_id, status, joined_at)
VALUES 
  (1, 1, 'active', NOW()),      -- test@example.com 在台北游泳隊
  (1, 2, 'active', NOW()),      -- 教練在自己的隊伍
  (1, 3, 'active', NOW()),      -- swimmer2 在台北游泳隊
  (2, 3, 'pending', NOW())      -- swimmer2 申請加入新竹鯊魚隊（待審核）
ON CONFLICT (team_id, user_id) DO NOTHING;

-- ==============================================
-- 4. 比賽成績（test@example.com 的成績）
-- ==============================================
INSERT INTO CompetitionResults (user_id, stroke, distance, pool_length, time_ms, meet_name, date, created_at)
VALUES 
  -- 自由式 50m
  (1, 'freestyle', 50, '25m', 28500, '台北市運動會', '2024-10-15', NOW()),
  (1, 'freestyle', 50, '25m', 27800, '新北市公開賽', '2024-11-01', NOW()),
  (1, 'freestyle', 50, '50m', 29200, '全國游泳錦標賽', '2024-09-20', NOW()),
  
  -- 自由式 100m
  (1, 'freestyle', 100, '25m', 62500, '台北市運動會', '2024-10-15', NOW()),
  (1, 'freestyle', 100, '25m', 61200, '新北市公開賽', '2024-11-01', NOW()),
  (1, 'freestyle', 100, '50m', 64800, '全國游泳錦標賽', '2024-09-20', NOW()),
  
  -- 蛙式 50m
  (1, 'breaststroke', 50, '25m', 35200, '台北市運動會', '2024-10-15', NOW()),
  (1, 'breaststroke', 50, '50m', 36500, '全國游泳錦標賽', '2024-09-20', NOW()),
  
  -- 蛙式 100m
  (1, 'breaststroke', 100, '25m', 78000, '新北市公開賽', '2024-11-01', NOW()),
  
  -- 仰式 50m
  (1, 'backstroke', 50, '25m', 32100, '台北市運動會', '2024-10-15', NOW()),
  
  -- 蝶式 50m
  (1, 'butterfly', 50, '25m', 30800, '新北市公開賽', '2024-11-01', NOW()),
  
  -- 其他選手成績
  (3, 'freestyle', 50, '25m', 26800, '新北市公開賽', '2024-11-01', NOW()),
  (3, 'freestyle', 100, '25m', 58900, '新北市公開賽', '2024-11-01', NOW()),
  (3, 'breaststroke', 50, '25m', 33500, '台北市運動會', '2024-10-15', NOW())
ON CONFLICT DO NOTHING;

-- ==============================================
-- 5. 官方標竿（世界紀錄參考）
-- ==============================================
INSERT INTO OfficialRecords (type, country, stroke, distance, pool_length, time_ms, holder, date)
VALUES 
  -- 世界紀錄 (25m 短水道)
  ('WR', NULL, 'freestyle', 50, '25m', 2016, 'Florent Manaudou', '2014-12-06'),
  ('WR', NULL, 'freestyle', 100, '25m', 44984, 'Amaury Leveaux', '2008-12-13'),
  ('WR', NULL, 'breaststroke', 50, '25m', 25250, 'Cameron van der Burgh', '2009-11-14'),
  ('WR', NULL, 'breaststroke', 100, '25m', 55460, 'Cameron van der Burgh', '2009-11-15'),
  ('WR', NULL, 'backstroke', 50, '25m', 22220, 'Florent Manaudou', '2014-11-23'),
  ('WR', NULL, 'butterfly', 50, '25m', 21750, 'Nicholas Santos', '2018-12-21'),
  
  -- 世界紀錄 (50m 長水道)
  ('WR', NULL, 'freestyle', 50, '50m', 20910, 'Cesar Cielo', '2009-12-18'),
  ('WR', NULL, 'freestyle', 100, '50m', 46910, 'Cesar Cielo', '2009-07-30'),
  ('WR', NULL, 'breaststroke', 50, '50m', 25950, 'Adam Peaty', '2017-07-25'),
  ('WR', NULL, 'breaststroke', 100, '50m', 56880, 'Adam Peaty', '2019-07-21'),
  ('WR', NULL, 'backstroke', 50, '50m', 23350, 'Kliment Kolesnikov', '2021-11-13'),
  ('WR', NULL, 'butterfly', 50, '50m', 22270, 'Andrii Govorov', '2018-07-01'),
  
  -- 台灣國家紀錄 (範例)
  ('NR', 'TWN', 'freestyle', 50, '25m', 22100, '王冠閎', '2023-03-15'),
  ('NR', 'TWN', 'freestyle', 100, '25m', 48500, '王冠閎', '2023-03-16'),
  ('NR', 'TWN', 'breaststroke', 50, '25m', 27800, '陳柏瑋', '2022-10-20'),
  ('NR', 'TWN', 'breaststroke', 100, '25m', 60200, '陳柏瑋', '2022-10-21')
ON CONFLICT DO NOTHING;

-- ==============================================
-- 6. 目標設定（test@example.com 的訓練目標）
-- ==============================================
INSERT INTO Targets (athlete_user_id, created_by_user_id, pool_length, stroke, distance, target_ms, baseline_ms, due_date, status, note, created_at, updated_at)
VALUES 
  -- 自由式 50m 目標：突破 27 秒（當前 PB: 27.8 秒）
  (1, 2, '25m', 'freestyle', 50, 27000, 27800, '2025-03-31', 'active', '春季賽前達標', NOW(), NOW()),
  
  -- 自由式 100m 目標：突破 60 秒（當前 PB: 61.2 秒）
  (1, 2, '25m', 'freestyle', 100, 60000, 61200, '2025-03-31', 'active', '春季賽主力項目', NOW(), NOW()),
  
  -- 蛙式 50m 目標：突破 34 秒（當前 PB: 35.2 秒）
  (1, 2, '25m', 'breaststroke', 50, 34000, 35200, '2025-06-30', 'active', '技術改善後目標', NOW(), NOW()),
  
  -- 已達成目標（範例）
  (1, 2, '25m', 'freestyle', 50, 29000, 29500, '2024-10-31', 'completed', '已在新北市公開賽達成', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- ==============================================
-- 7. 課表（Plans）
-- ==============================================
INSERT INTO Plans (plan_id, team_id, created_by_user_id, title, is_template, week_start, description, created_at, updated_at)
VALUES 
  (1, 1, 2, '短距離衝刺週課表', false, '2024-11-04', '專注 50m 衝刺與爆發力訓練', NOW(), NOW()),
  (2, 1, 2, '耐力基礎週課表', false, '2024-11-11', '中長距離有氧訓練', NOW(), NOW()),
  (3, NULL, 2, '標準熱身模板', true, NULL, '可重複使用的熱身菜單', NOW(), NOW())
ON CONFLICT (plan_id) DO NOTHING;

SELECT setval('plans_plan_id_seq', 100, false);

-- ==============================================
-- 8. 課表組合（PlanSets）
-- ==============================================
INSERT INTO PlanSets (plan_id, order_no, stroke, distance, repetitions, target_pace_ms, notes)
VALUES 
  -- 短距離衝刺週課表
  (1, 1, 'freestyle', 50, '10 x 50m', 32000, '每組休息 30 秒'),
  (1, 2, 'freestyle', 25, '20 x 25m', 15000, '全力衝刺，休息 15 秒'),
  (1, 3, 'freestyle', 100, '5 x 100m', 68000, '保持高速，休息 60 秒'),
  
  -- 耐力基礎週課表
  (2, 1, 'freestyle', 400, '3 x 400m', NULL, '有氧配速，休息 45 秒'),
  (2, 2, 'freestyle', 200, '6 x 200m', NULL, '門檻配速，休息 30 秒'),
  (2, 3, 'mixed', 100, '4 x 100m IM', NULL, '混合泳，休息 60 秒'),
  
  -- 標準熱身模板
  (3, 1, 'freestyle', 400, '1 x 400m', NULL, '輕鬆游'),
  (3, 2, 'mixed', 200, '4 x 50m', NULL, '每種泳姿 50m'),
  (3, 3, 'freestyle', 50, '4 x 50m', NULL, '逐漸加速')
ON CONFLICT DO NOTHING;

-- ==============================================
-- 9. 課表指派（PlanAssignments）
-- ==============================================
INSERT INTO PlanAssignments (plan_id, team_id, athlete_user_id, assigned_at, due_date)
VALUES 
  -- 整個隊伍的指派
  (1, 1, NULL, NOW(), '2024-11-10'),
  (2, 1, NULL, NOW(), '2024-11-17'),
  
  -- 個人指派
  (1, NULL, 1, NOW(), '2024-11-10')
ON CONFLICT DO NOTHING;

-- ==============================================
-- 10. 訓練回饋（PlanFeedback）
-- ==============================================
INSERT INTO PlanFeedback (assignment_id, athlete_user_id, completion_percent, rpe, comment, created_at)
VALUES 
  -- test@example.com 的訓練回饋
  (1, 1, 100, 8, '完成所有組數，最後幾組有點吃力', NOW()),
  (3, 1, 90, 7, '50m 衝刺感覺不錯，100m 後段掉速', NOW())
ON CONFLICT DO NOTHING;

-- ==============================================
-- 11. Join Code / QR Code
-- ==============================================
INSERT INTO TeamJoinCodes (team_id, code, qr_svg, expires_at, max_uses, used_count, created_by_user_id, created_at)
VALUES 
  (1, 'TAIPEI2024', NULL, '2025-12-31', 50, 2, 2, NOW()),
  (2, 'SHARK2024', NULL, '2025-12-31', 30, 0, 2, NOW())
ON CONFLICT (code) DO NOTHING;

-- ==============================================
-- 完成提示
-- ==============================================
-- 測試帳號資訊:
-- Email: test@example.com
-- Password: password123
-- 
-- 教練帳號:
-- Email: coach@example.com
-- Password: password123
--
-- 範例資料包含:
-- ✅ 3 個用戶（1 教練 + 2 選手）
-- ✅ 2 個隊伍
-- ✅ 14 筆比賽成績（test@example.com 有 11 筆）
-- ✅ 16 筆官方標竿（世界紀錄 + 台灣紀錄）
-- ✅ 4 個訓練目標（3 進行中 + 1 已達成）
-- ✅ 3 份課表（2 週課表 + 1 模板）
-- ✅ 10 個課表組合
-- ✅ 3 個課表指派
-- ✅ 2 筆訓練回饋
-- ✅ 2 個 Join Code
