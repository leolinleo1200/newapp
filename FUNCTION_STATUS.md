# AquaTrack 功能完整清單（2026-03-04）

> 依目前程式碼實作狀態整理。APK 流程暫停處理。

## 一、後端 API

### A. Auth
- [x] `POST /auth/register` 註冊
- [x] `POST /auth/login` 登入
- [x] `GET /auth/me` 取得當前使用者
- [x] JWT 驗證
- [x] bcrypt 密碼雜湊
- [x] 全域 ValidationPipe
- [x] CORS

### B. Teams
- [x] `POST /teams` 建立隊伍（coach/admin）
- [x] `GET /teams/:teamId` 取得隊伍資訊
- [x] `POST /teams/:teamId/join` 申請加入
- [x] `POST /teams/:teamId/approve/:userId` 核准加入（coach/admin）
- [x] `GET /teams/:teamId/members` 隊員列表（coach/admin）
- [x] 建隊者自動加入 active

### C. Results
- [x] `POST /results` 新增成績
- [x] `GET /results` 取得自己的成績列表
- [x] DTO 欄位驗證

### D. PB / Benchmarks
- [x] `GET /pb` 依泳姿/距離/池長聚合 PB
- [x] `GET /benchmarks` 取得官方標竿

### E. Users（教練視角）
- [x] `GET /users/:userId/results` 查特定學員成績（coach/admin）

### F. 權限
- [x] Roles decorator
- [x] Roles guard
- [x] 教練專屬端點加上 role 限制

---

## 二、前端 Flutter

### A. Auth 與 Session
- [x] 登入頁
- [x] 註冊頁
- [x] 自動登入（讀 token + `/auth/me`）
- [x] 登出
- [x] 錯誤訊息處理

### B. 主畫面架構
- [x] Bottom Navigation（首頁/成績/PB/團隊）

### C. 成績頁
- [x] 新增成績表單（泳姿、距離、池長、timeMs）
- [x] 成績列表
- [x] 下拉刷新

### D. PB 頁
- [x] PB 列表
- [x] 官方標竿列表

### E. 團隊頁
- [x] 教練建立隊伍
- [x] 查詢隊伍
- [x] 申請加入隊伍
- [x] 教練可查看隊員列表

---

## 三、待補強（下一階段）

### 後端
- [ ] approve/reject 分離 API（目前只有 approve）
- [ ] 更細緻的權限規則（同隊教練才可看指定學員）
- [ ] seed script（官方標竿初始化）
- [ ] e2e tests（auth/teams/results/pb/users）

### 前端
- [ ] 團隊審核 pending 成員 UI
- [ ] 教練查看特定學員歷史成績 UI
- [ ] 輸入格式優化（timeMs 轉 mm:ss.xx）
- [ ] 空狀態/錯誤狀態視覺優化

### DevOps
- [ ] CI 把 frontend analyze 恢復為 blocking（目前暫時 non-blocking）
- [ ] DB migration + seed pipeline

---

## 四、目前可用的 MVP 流程
1. 使用者註冊/登入
2. 學員新增成績、查自己的歷史成績
3. 學員查看 PB
4. 教練建立隊伍
5. 學員申請加入隊伍
6. 教練查看隊員
7. 教練查特定學員成績
