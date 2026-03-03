# AquaTrack / 游跡 App — 版本 1.6（MVP 可執行開發文件）

> 目的：最小可行（MVP）→ 兩條原生（Android Kotlin / iOS Swift）可直接開工，
> 搭配 OpenAPI 與 DB Schema，讓 AI Agent（含 GitHub Copilot）可按「任務卡」執行。

---

## 0. 本版新增（相對 1.4 / 1.5）
- **教練訓練管理**：課表模板 / 週訓練計畫，指派到隊伍或個別學員；學員回報完成度/RPE/備註。
- **可量化目標（Targets）**：以泳姿/距離/池長為維度，設定目標時間（毫秒）與到期日，追蹤進度。
- **代碼/QR 入隊**：教練生成 Join Code 或 QR，學員掃描/輸入後送審；學員可同時屬於多隊/俱樂部。

## 1. MVP 範圍（最小化）
**必做**
- 註冊/登入（Email + 密碼，JWT）。
- 新增比賽成績（CompetitionResult），自動更新 PB（長/短水道）。
- 目標（Targets）建立/查詢/更新，儀表板顯示進度條與差距（毫秒）。
- 教練建隊、產生 Join Code/QR、審核入隊、隊員清單。
- 課表（Plans+PlanSets）建立/指派/學員回饋（完成度%/RPE/備註）。
- 排行榜/官方標竿比對（基礎資料集）。

**延後**
- 穿戴裝置匯入、社交互動、複雜統計圖、進階家長控管、多語系完整化等。

## 2. 角色與權限
- **Swimmer**：讀寫自身資料、提交訓練回饋、申請加入隊伍。
- **Coach**：管理所屬隊伍、審核成員、建立課表與目標、查看/匯出隊員資料。
- **Admin**：官方資料維護、處置違規帳號。

## 3. 主要畫面與流程
- **Dashboard**：個人卡、最近成績、PB、目標進度條。
- **Records**：練習/比賽分頁（MVP 以「比賽」為主），卡片式列表 + 新增。
- **PB**：分池長顯示最佳時間與日期。
- **Targets**：清單（進行/完成/逾期），詳情含進度、差距與到期日。
- **Teams/Coach**：建隊、Join Code/QR、審核、隊員列表、課表/目標指派。
- **Leaderboard/Compare**：我的 PB vs 官方標竿（差距 ms）。

## 4. API 合約
請見同資料夾 `aquatrack_1_6_openapi.yaml`（OpenAPI 3.0）。
> 建議流程：後端先依此檔產生接口（Swagger / FastAPI / NestJS 皆可），
> 客戶端以 OpenAPI Generator 產生 Kotlin / Swift Client Model。

## 5. 驗收標準（節選）
- **QR/代碼入隊**：學員掃碼→/join 成功→教練端待審→核准後學員端即顯示「已加入」。
- **PB 自動更新**：新成績優於既有 PB，`GET /pb` 立即反映（精確到毫秒）。
- **目標進度**：`progress = (baseline_ms - currentPB_ms) / (baseline_ms - target_ms)`；達標即轉「完成」，逾期自動「逾期」。

## 6. 資料庫設計（PostgreSQL）
完整建表與索引請見 `aquatrack_1_6_db.sql`。
核心新增：`Targets / Plans / PlanSets / PlanAssignments / PlanFeedback / TeamJoinCodes`。

## 7. 原生雙平台技術要點
- **Android**：Kotlin + Jetpack Compose、Hilt、ZXing/ML Kit（QR）、EncryptedSharedPreferences（JWT）。
- **iOS**：Swift + SwiftUI、VisionKit（QR）、Keychain（JWT）。
- **共通**：OpenAPI Client、深/淺色、單元/整合測試 ≥60%。

## 8. 雲端建議
- **優先 GCP（MVP 快速上線）**：Firebase Auth + Cloud Run + Cloud SQL + Cloud Storage。
- **AI 擴充（選配）**：獨立微服務串 **AWS Bedrock** 或 **Vertex AI**，避免早期耦合。

## 9. CI/CD 與觀測
- GitHub Actions：Lint/Tests/OpenAPI 檢查 → Staging → Prod。
- 監控：req/sec、p95、error rate；商業事件（加入隊伍、設定目標、上傳成績）。

## 10. 任務卡（交給 AI Agent）
- **Android**：實作 Dashboard / Records / PB / Targets / Team / QR Join；以 OpenAPI 生成 Client；寫 10+ 單測。
- **iOS**：同 Android；JWT 以 Keychain 儲存；VisionKit 掃碼。
- **Backend**：依 SQL 建表、實作 `aquatrack_1_6_openapi.yaml` 端點、部署到 Cloud Run + Cloud SQL。

---

### 可執行性說明（多次自檢結論）
1. **資料模型閉環**：成績→PB→目標進度→課表回饋，均有主鍵/外鍵與索引，具可擴充性。  
2. **API 齊備**：註冊、隊伍、Join Code、課表、目標、PB、官方標竿與比較皆覆蓋 MVP 用例。  
3. **平台落地**：QR 掃碼、JWT 安全存放、OpenAPI 自動化大幅降低人工作業風險。  
4. **彈性演進**：AI 能以此為藍本迭代（新增分析、報表、聊天助教、推薦課表）。

> 建議先以 Staging seed 基礎資料（泳姿/距離/官方標竿），完成 e2e 走查再開放小規模教練測試。
