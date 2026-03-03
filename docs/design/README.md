# AquaTrack 設計文件總覽

> **游泳訓練追蹤 App 完整設計規範**
> 版本: 1.0
> 最後更新: 2026-02-06

---

## 📚 文件目錄

本設計資料夾包含 AquaTrack App 的完整設計規範，建議按照以下順序閱讀：

### 1. [使用者流程圖 (USER_FLOWS.md)](./USER_FLOWS.md)
**必讀** - 理解使用者如何使用 App

**包含內容:**
- ✅ 9 個主要使用者流程的 Mermaid 流程圖
- ✅ 學員註冊、登入、新增成績、設定目標
- ✅ 學員加入隊伍（QR Code / 邀請碼）
- ✅ 教練建立隊伍、審核學員、建立課表
- ✅ 訓練執行與回饋流程
- ✅ 排行榜與標竿比對

**適用對象:**
- 產品經理
- UI/UX 設計師
- 前端開發者
- QA 測試人員

---

### 2. [介面線框圖 (WIREFRAMES.md)](./WIREFRAMES.md)
**必讀** - 查看每個畫面的詳細設計

**包含內容:**
- ✅ 50+ 個畫面的詳細線框圖（ASCII art 格式）
- ✅ 完整的設計規範（色彩、字體、間距）
- ✅ 歡迎與認證畫面
- ✅ Dashboard 儀表板（學員 & 教練）
- ✅ 成績記錄、個人最佳 PB
- ✅ 目標追蹤介面
- ✅ 隊伍管理（學員 & 教練視角）
- ✅ 訓練計畫管理
- ✅ 排行榜與個人資料
- ✅ 通用組件設計（按鈕、卡片、輸入框等）

**適用對象:**
- UI/UX 設計師
- 前端開發者
- 視覺設計師

---

### 3. [導航架構 (NAVIGATION.md)](./NAVIGATION.md)
**必讀** - 理解 App 的資訊架構和導航邏輯

**包含內容:**
- ✅ 完整的資訊架構圖（Mermaid）
- ✅ 學員端 Tab Bar 導航結構
- ✅ 教練端 Tab Bar 導航結構
- ✅ Modal、Stack、Drawer 等導航模式
- ✅ 深層連結規範（Deep Link Schema）
- ✅ 推送通知導航
- ✅ 轉場動畫規範
- ✅ 無障礙導航支援

**適用對象:**
- 前端開發者
- 產品經理
- 架構師

---

### 4. [設計系統 (DESIGN_SYSTEM.md)](./DESIGN_SYSTEM.md)
**必讀** - 實作時的視覺規範手冊

**包含內容:**
- ✅ 設計原則與核心價值
- ✅ 完整的色彩系統（主色、語意色、深淺模式）
- ✅ 字體系統（字體家族、大小、行高、字重）
- ✅ 間距與佈局系統（4px 基準、柵格系統）
- ✅ 圖示系統規範
- ✅ 組件庫（10+ 種基礎組件的 CSS 範例）
- ✅ 動畫與轉場效果
- ✅ 響應式設計斷點
- ✅ 無障礙設計規範
- ✅ 設計令牌（Design Tokens）CSS 變數

**適用對象:**
- 前端開發者
- UI/UX 設計師
- 視覺設計師

---

## 🎯 快速導覽

### 我是產品經理
建議閱讀順序：
1. USER_FLOWS.md - 理解使用者旅程
2. WIREFRAMES.md - 查看畫面設計
3. NAVIGATION.md - 理解功能結構

### 我是 UI/UX 設計師
建議閱讀順序：
1. DESIGN_SYSTEM.md - 掌握視覺規範
2. WIREFRAMES.md - 查看介面設計
3. USER_FLOWS.md - 理解互動流程
4. NAVIGATION.md - 理解導航邏輯

### 我是前端開發者
建議閱讀順序：
1. NAVIGATION.md - 理解 App 架構
2. DESIGN_SYSTEM.md - 實作視覺規範
3. WIREFRAMES.md - 實作畫面
4. USER_FLOWS.md - 實作互動邏輯

### 我是後端開發者
建議閱讀：
- USER_FLOWS.md - 理解 API 呼叫時機
- 參考 `/docs/aquatrack_1_6_openapi.yaml` 進行 API 實作

### 我是 QA 測試人員
建議閱讀順序：
1. USER_FLOWS.md - 製作測試案例
2. WIREFRAMES.md - 驗證 UI 實作
3. NAVIGATION.md - 測試導航流程

---

## 📊 設計規範總覽

### 色彩
- **主色**: Cyan 600 (#0891B2) - 水藍色
- **次色**: Blue 600 (#2563EB) - 深藍色
- **成功**: Green 500 (#22C55E)
- **警告**: Amber 500 (#F59E0B)
- **錯誤**: Red 500 (#EF4444)

### 字體
- **中文**: Noto Sans TC, PingFang TC
- **英文**: Inter, SF Pro, Roboto
- **基準大小**: 16px (1rem)

### 間距
- **基準**: 4px 的 8 倍數系統
- **標準間距**: 16px (1rem)

### 圓角
- **小**: 4px - 標籤
- **中**: 8px - 按鈕、輸入框 ⭐
- **大**: 12px - 卡片
- **超大**: 16px - 大卡片

### 響應式斷點
- **手機**: 0 - 639px
- **平板**: 640px - 1023px
- **桌面**: 1024px+

---

## 🎨 品牌識別

### Logo 使用規範
- 最小尺寸: 24px × 24px
- 安全空間: Logo 尺寸的 25%
- 背景: 淺色背景使用彩色版，深色背景使用白色版

### 品牌色彩
```
主要品牌色: #0891B2 (Cyan 600)
次要品牌色: #0E7490 (Cyan 700)
強調色: #06B6D4 (Cyan 500)
```

### 品牌語調
- **專業但親切** - 不過於正式，但保持專業
- **激勵性** - 鼓勵使用者持續進步
- **數據導向** - 強調精確和量化

---

## 🔧 技術實作建議

### 前端框架
- **跨平台**: Flutter (已選用)
- **狀態管理**: Riverpod
- **路由**: GoRouter / Auto Route
- **主題**: flutter_riverpod + 自定義主題

### 組件庫
建議使用以下套件作為基礎：
```yaml
dependencies:
  flutter_riverpod: ^2.x
  go_router: ^13.x
  material_design_icons_flutter: ^7.x
  qr_code_scanner: ^1.x
  fl_chart: ^0.x # 圖表
  cached_network_image: ^3.x
  shimmer: ^3.x # 骨架屏
```

### 設計令牌實作

**方式 1: Flutter Theme**
```dart
// lib/theme/app_theme.dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF0891B2),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF0891B2),
      secondary: Color(0xFF2563EB),
      error: Color(0xFFEF4444),
      // ...
    ),
    // ...
  );
}
```

**方式 2: 設計令牌類別**
```dart
// lib/theme/design_tokens.dart
class DesignTokens {
  // Colors
  static const colorPrimary = Color(0xFF0891B2);
  static const colorSuccess = Color(0xFF22C55E);

  // Spacing
  static const space1 = 4.0;
  static const space2 = 8.0;
  static const space4 = 16.0;

  // Radius
  static const radiusMd = 8.0;
  static const radiusLg = 12.0;
}
```

### CSS 變數（Web 版本）
如果使用 Flutter Web，可在 `web/index.html` 加入：
```html
<style>
:root {
  --color-primary: #0891B2;
  --color-success: #22C55E;
  --space-4: 16px;
  --radius-md: 8px;
}
</style>
```

---

## ✅ 設計檢查清單

實作畫面時，請確認以下項目：

### 視覺規範
- [ ] 使用正確的品牌色彩
- [ ] 字體大小符合規範
- [ ] 間距使用 4px 倍數
- [ ] 圓角大小一致
- [ ] 陰影效果正確

### 互動設計
- [ ] 所有按鈕有 hover 和 active 狀態
- [ ] 載入狀態有骨架屏或 spinner
- [ ] 錯誤狀態有明確提示
- [ ] 成功操作有確認回饋

### 響應式設計
- [ ] 手機、平板、桌面佈局正確
- [ ] 觸控目標 ≥ 44px × 44px
- [ ] 橫向和直向模式都可正常使用

### 無障礙性
- [ ] 對比度符合 WCAG AA 標準
- [ ] 所有圖片有替代文字
- [ ] 焦點指示清楚可見
- [ ] 支援螢幕閱讀器

### 效能
- [ ] 圖片使用適當格式和大小
- [ ] 動畫流暢 (60fps)
- [ ] 首次載入時間 < 3 秒

---

## 📝 設計決策記錄

### 為什麼選擇水藍色作為主色？
- 符合游泳/水的主題
- 傳達清新、專業的感覺
- 在深淺色模式下都有良好的可讀性
- 與其他運動 App 有明顯區隔

### 為什麼使用 Tab Bar 而非 Drawer？
- 主要功能需要快速切換
- Tab Bar 符合現代 App 慣例
- 減少操作步驟（不需要開啟選單）
- 適合手機單手操作

### 為什麼學員和教練使用不同的 Tab 結構？
- 兩種角色的核心任務不同
- 學員專注於個人進步（成績、目標）
- 教練專注於團隊管理（隊伍、課表、數據）
- 避免功能過度擁擠

### 為什麼使用 Mermaid 流程圖？
- 可版本控制（純文字）
- 易於維護和更新
- 可以在 Markdown 中直接渲染
- 團隊協作友善

---

## 🔄 設計更新流程

### 提議新設計
1. 在 GitHub Issues 中開啟設計提議
2. 說明設計變更的原因和預期效果
3. 附上視覺範例或線框圖
4. 等待設計團隊審核

### 更新設計文件
1. Fork 專案並建立新分支
2. 更新相關的 Markdown 文件
3. 確保範例程式碼可執行
4. 提交 Pull Request
5. 通過審核後合併

### 設計審核標準
- [ ] 符合既有設計語言
- [ ] 不影響無障礙性
- [ ] 考慮深淺色模式
- [ ] 提供手機、平板、桌面版本
- [ ] 文件清楚易懂

---

## 📚 參考資源

### 設計靈感
- [Material Design 3](https://m3.material.io/)
- [Human Interface Guidelines (Apple)](https://developer.apple.com/design/human-interface-guidelines/)
- [Nike Training Club App](https://www.nike.com/ntc-app)
- [Strava](https://www.strava.com/)

### 設計工具
- **Figma** - UI 設計和原型
- **Mermaid** - 流程圖
- **Coolors.co** - 配色方案
- **Type Scale** - 字體比例計算

### 學習資源
- [Refactoring UI](https://www.refactoringui.com/) - UI 設計最佳實踐
- [Laws of UX](https://lawsofux.com/) - UX 設計原則
- [Inclusive Components](https://inclusive-components.design/) - 無障礙組件

---

## 👥 設計團隊

### 角色與職責

**產品設計師**
- 定義使用者流程
- 設計資訊架構
- 製作原型和互動設計

**視覺設計師**
- 建立設計系統
- 設計視覺元素
- 製作品牌素材

**前端開發者**
- 實作設計規範
- 建立可重用組件
- 確保響應式和無障礙性

---

## 📞 聯絡方式

如有設計相關問題，請聯絡：

**設計團隊 Email**: design@aquatrack.com
**GitHub Issues**: [專案 Issues 頁面](https://github.com/yourusername/aquatrack/issues)
**設計討論**: 在 Discussions 中發起討論

---

## 📄 授權

本設計文件採用 [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) 授權。

---

## 🎉 開始實作

現在你已經瞭解了完整的設計規範，可以開始實作了！

建議的實作順序：
1. ✅ 建立設計令牌和主題系統
2. ✅ 實作基礎組件庫（按鈕、輸入框、卡片等）
3. ✅ 實作導航結構（Tab Bar、Stack、Modal）
4. ✅ 實作認證流程（Welcome、Login、Register）
5. ✅ 實作 Dashboard（學員版）
6. ✅ 實作核心功能（Records、Targets、Teams）
7. ✅ 實作教練功能
8. ✅ 優化與測試

**祝開發順利！** 🏊‍♂️💙
