# 跨平台教練學員追蹤 App 開發計畫 (PLAN.md)

## 1. 專案總覽 (Project Overview)

本專案旨在開發一款跨平台的應用程式，核心功能是讓游泳教練能有效管理學員的訓練進度，並讓學員能清楚地追蹤自己的成長紀錄。應用程式需同時支援 iOS、Android 平台，並提供 Web 版本供測試與管理使用。

**核心價值:**
- **數據化訓練:** 將學員的訓練成績數據化，提供明確的進步指標。
- **提升教練效率:** 教練可輕鬆建立與指派訓練計畫，並即時查看學員回饋。
- **強化團隊凝聚力:** 透過團隊功能，讓學員與教練有更緊密的連結。

## 2. 技術選型 (Technology Stack)

為了達成跨平台與 Web 測試的目標，我們建議採用以下技術棧：

- **前端 (Frontend):**
    - **跨平台框架:** [**Flutter**](https://flutter.dev/) 或 [**React Native**](https://reactnative.dev/) (二選一，Flutter 在 UI 一致性與性能上稍有優勢)。
    - **Web 測試/管理後台:** 使用前端框架內建的 Web build 功能 (Flutter for Web / React Native for Web)。
    - **狀態管理:** Riverpod (Flutter) / Redux (React Native)。
- **後端 (Backend):**
    - **語言/框架:** [**Node.js**](https://nodejs.org/) 搭配 [**NestJS**](https://nestjs.com/) (基於 TypeScript，架構清晰，易於維護)。
    - **API 規格:** OpenAPI 3.0 (如 `aquatrack_1_6_openapi.yaml` 所定義)。
- **資料庫 (Database):**
    - [**PostgreSQL**](https://www.postgresql.org/) (功能強大，且 `aquatrack_1_6_db.sql` 已提供 schema)。
- **雲端服務 (Cloud Services):**
    - **部署:** [**Google Cloud Run**](https://cloud.google.com/run) (Serverless，易於擴展)。
    - **認證:** [**Firebase Authentication**](https://firebase.google.com/docs/auth)。
    - **儲存:** [**Google Cloud Storage**](https://cloud.google.com/storage)。

## 3. 核心功能模組 (Core Feature Modules)

### 3.1 使用者比對記錄 (User Comparison Records)

- **功能描述:** 學員可以記錄每次的比賽或練習成績，系統會自動計算並顯示個人最佳紀錄 (PB)，並能與官方標竿或其他學員進行比對。
- **主要畫面:**
    - 個人儀表板 (Dashboard): 顯示最新的成績與 PB。
    - 成績列表頁: 條列所有成績紀錄。
    - 成績比對頁: 將自己的成績與他人或標竿進行比較。
- **對應 API:**
    - `POST /results`: 新增成績。
    - `GET /results`: 查詢成績列表。
    - `GET /pb`: 取得個人最佳紀錄。
    - `GET /benchmarks`: 取得官方標竿。

### 3.2 教練團隊管理 (Coach Team Management)

- **功能描述:** 教練可以建立自己的隊伍，並透過邀請碼或 QR Code 讓學員加入。教練可以管理隊伍成員，並指派訓練計畫。
- **主要畫面:**
    - 隊伍管理頁: 建立/編輯隊伍資訊。
    - 成員列表頁: 顯示所有隊伍成員。
    - 邀請成員頁: 產生邀請碼/QR Code。
    - 審核成員頁: 教練審核學員的加入申請。
- **對應 API:**
    - `POST /teams`: 建立隊伍。
    - `GET /teams/{teamId}`: 查詢隊伍資訊。
    - `POST /teams/{teamId}/join`: 學員申請加入隊伍。
    - `POST /teams/{teamId}/approve`: 教練核准申請。

### 3.3 教練查看學員記錄 (Coach Viewing Student Records)

- **功能描述:** 教練可以查看隊伍中所有學員的個人資料、成績紀錄、PB 等資訊。
- **主要畫面:**
    - 學員列表頁 (教練視角): 點擊學員可進入學員詳細資料頁。
    - 學員詳細資料頁: 顯示學員的所有相關資訊。
- **對應 API:**
    - `GET /teams/{teamId}/members`: 取得隊伍成員列表。
    - `GET /users/{userId}/results`: 取得特定學員的成績。

## 4. 開發里程碑 (Development Milestones)

- **第一階段 (Sprint 1-2): 環境建置與核心 API 開發**
    - [ ] 雲端環境設定 (GCP Project, Firebase, Cloud SQL)。
    - [ ] 後端專案初始化 (NestJS)。
    - [ ] 根據 `openapi.yaml` 完成使用者認證、團隊管理、成績記錄的核心 API。
    - [ ] 資料庫 schema 部署。
- **第二階段 (Sprint 3-4): 跨平台 App 基礎功能開發**
    - [ ] Flutter / React Native 專案初始化。
    - [ ] 完成使用者註冊、登入、登出流程。
    - [ ] 完成學員新增、查詢、顯示成績與 PB 的功能。
- **第三階段 (Sprint 5-6): 教練功能與 Web 測試**
    - [ ] 完成教練建立團隊、邀請成員、審核成員的功能。
    - [ ] 完成教練查看學員紀錄的功能。
    - [ ] 建置 Web 版本，並部署至測試環境。
- **第四階段 (Sprint 7-8): 優化與測試**
    - [ ] UI/UX 優化。
    - [ ] 整合測試與 Bug 修復。
    - [ ] 準備上架 App Store / Google Play。

## 5. 團隊與技能 (Team & Skills)

為了成功執行此專案，我們需要具備以下技能的團隊成員 (此處技能列表將從 `mesetting` 中複製):

*   **`architect` (建築師):** "從宏觀到微觀，我都能為您的專案擘劃穩固的藍圖。"
*   **`code` (程式設計師):** "精準、高效，我能將您的想法轉化為優雅的程式碼。"
*   **`debug` (除錯專家):** "深入程式的每個角落，我能迅速找出並解決問題的根源。"
*   **`ask` (知識問答):** "有問必答，我能為您提供清晰的解釋與專業的技術建議。"
*   **`orchestrator` (協調者):** "運籌帷幄，我能為複雜專案協調資源、管理流程，確保任務順利達成。"
*   **`brand-guidelines` (品牌指南):** "為您的產出注入官方品牌風格，確保視覺一致性。"
*   **`canvas-design` (畫布設計):** "將設計哲學化為視覺藝術，創造獨一無二的藝術品。"
*   **`doc-coauthoring` (文件協作):** "引導您完成結構化的文件協作流程，從蒐集情境到讀者測試。"
*   **`frontend-design` (前端設計):** "打造具備高度設計質感與獨特風格的產品級前端介面。"
*   **`docx` (Word 文件處理):** "全方位 Word 文件處理：從建立、編輯到紅線修訂。"
*   **`internal-comms` (內部溝通):** "依循公司慣用格式，撰寫各類專業的內部溝通文件。"
*   **`mcp-builder` (MCP 伺服器建構):** "引導您打造高品質的 MCP 伺服器，讓大型語言模型與外部世界互動。"
*   **`pdf` (PDF 文件處理):** "您的全方位 PDF 工具箱：從內容萃取、文件合併到表單填寫。"
*   **`pptx` (PowerPoint 簡報處理):** "專業簡報的自動化生成與編輯，兼顧設計美學與內容結構。"
*   **`skill-creator` (技能創造器):** "引導您打造高效的技能，擴展 Claude 的專業能力。"
*   **`slack-gif-creator` (Slack GIF 產生器):** "為您的 Slack 工作空間，創造符合規範且生動有趣的 GIF 動圖。"
*   **`theme-factory` (主題工廠):** "為您的簡報、文件與網頁，一鍵套用專業設計師級的主題風格。"
