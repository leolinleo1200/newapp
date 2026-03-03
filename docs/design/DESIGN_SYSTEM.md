# AquaTrack 設計系統 (Design System)

## 目錄
1. [設計原則](#1-設計原則)
2. [色彩系統](#2-色彩系統)
3. [字體系統](#3-字體系統)
4. [間距與佈局](#4-間距與佈局)
5. [圖示系統](#5-圖示系統)
6. [組件庫](#6-組件庫)
7. [動畫與轉場](#7-動畫與轉場)
8. [響應式設計](#8-響應式設計)
9. [無障礙設計](#9-無障礙設計)
10. [設計令牌](#10-設計令牌-design-tokens)

---

## 1. 設計原則

### 1.1 核心價值

**清晰 (Clarity)**
- 資訊層級清楚
- 操作目的明確
- 回饋即時可見

**效率 (Efficiency)**
- 減少操作步驟
- 快速完成任務
- 記憶使用者偏好

**親和力 (Approachability)**
- 友善的視覺語言
- 降低學習門檻
- 鼓勵持續使用

**專業 (Professionalism)**
- 精確的數據呈現
- 可靠的訓練工具
- 教練級的專業感

### 1.2 設計語言

**游泳主題**
- 水波紋理
- 流動曲線
- 清爽配色

**運動科技感**
- 數據視覺化
- 精確度表達
- 進度追蹤

**年輕活力**
- 明亮色彩
- 動態動畫
- 現代介面

---

## 2. 色彩系統

### 2.1 主色調 (Primary Colors)

#### 主要藍色系 (Cyan)
```
主色 Primary
├─ Cyan 700: #0E7490 - 深色模式主色
├─ Cyan 600: #0891B2 - 標準主色 ⭐
├─ Cyan 500: #06B6D4 - 懸停狀態
├─ Cyan 400: #22D3EE - 高亮
└─ Cyan 300: #67E8F9 - 淺色背景

使用場景:
- 主要按鈕
- 選中狀態
- 進度條
- 連結文字
- Tab Bar 選中項
```

#### 次要藍色系 (Blue)
```
次要色 Secondary
├─ Blue 700: #1D4ED8 - 深藍強調
├─ Blue 600: #2563EB - 標準次色
├─ Blue 500: #3B82F6 - 次要按鈕
└─ Blue 400: #60A5FA - 資訊提示

使用場景:
- 次要按鈕
- 資訊標記
- 教練專屬色
- 強調資訊
```

### 2.2 語意色彩 (Semantic Colors)

#### 成功 (Success) - 綠色系
```
├─ Green 700: #15803D - 深綠
├─ Green 600: #16A34A - 標準綠
├─ Green 500: #22C55E - 成功色 ⭐
├─ Green 400: #4ADE80 - 淺綠
└─ Green 100: #DCFCE7 - 背景綠

使用場景:
- 成功訊息
- 完成狀態
- 打破 PB
- 目標達成
- 核准操作
```

#### 警告 (Warning) - 橙色系
```
├─ Amber 700: #B45309 - 深橙
├─ Amber 600: #D97706 - 標準橙
├─ Amber 500: #F59E0B - 警告色 ⭐
├─ Amber 400: #FBBF24 - 淺橙
└─ Amber 100: #FEF3C7 - 背景橙

使用場景:
- 警告訊息
- 待審核狀態
- 目標即將逾期
- 注意事項
```

#### 錯誤 (Error) - 紅色系
```
├─ Red 700: #B91C1C - 深紅
├─ Red 600: #DC2626 - 標準紅
├─ Red 500: #EF4444 - 錯誤色 ⭐
├─ Red 400: #F87171 - 淺紅
└─ Red 100: #FEE2E2 - 背景紅

使用場景:
- 錯誤訊息
- 刪除操作
- 目標逾期
- 拒絕操作
- 驗證失敗
```

#### 資訊 (Info) - 淺藍色系
```
├─ Sky 600: #0284C7 - 標準資訊
├─ Sky 500: #0EA5E9 - 資訊色 ⭐
├─ Sky 400: #38BDF8 - 淺資訊
└─ Sky 100: #E0F2FE - 背景資訊

使用場景:
- 提示訊息
- 幫助文字
- 中性通知
```

### 2.3 中性色彩 (Neutral Colors)

#### 淺色模式 (Light Mode)
```
文字色
├─ Text Primary: #0F172A (Slate 900)
├─ Text Secondary: #475569 (Slate 600)
├─ Text Tertiary: #94A3B8 (Slate 400)
└─ Text Disabled: #CBD5E1 (Slate 300)

背景色
├─ Background Primary: #FFFFFF
├─ Background Secondary: #F8FAFC (Slate 50)
└─ Background Tertiary: #F1F5F9 (Slate 100)

邊框色
├─ Border Primary: #E2E8F0 (Slate 200)
├─ Border Secondary: #CBD5E1 (Slate 300)
└─ Border Focus: #0891B2 (Cyan 600)

覆蓋層
└─ Overlay: rgba(15, 23, 42, 0.5)
```

#### 深色模式 (Dark Mode)
```
文字色
├─ Text Primary: #F8FAFC (Slate 50)
├─ Text Secondary: #CBD5E1 (Slate 300)
├─ Text Tertiary: #64748B (Slate 500)
└─ Text Disabled: #475569 (Slate 600)

背景色
├─ Background Primary: #0F172A (Slate 900)
├─ Background Secondary: #1E293B (Slate 800)
└─ Background Tertiary: #334155 (Slate 700)

邊框色
├─ Border Primary: #334155 (Slate 700)
├─ Border Secondary: #475569 (Slate 600)
└─ Border Focus: #06B6D4 (Cyan 500)

覆蓋層
└─ Overlay: rgba(0, 0, 0, 0.7)
```

### 2.4 泳姿專屬色彩

```
🏊 自由式 (Freestyle): #0891B2 (Cyan 600)
🦋 蝶式 (Butterfly): #A855F7 (Purple 500)
🏊‍♀️ 仰式 (Backstroke): #3B82F6 (Blue 500)
🏊‍♂️ 蛙式 (Breaststroke): #10B981 (Emerald 500)
🌊 混合式 (Medley): #F59E0B (Amber 500)
```

### 2.5 色彩使用規範

#### 對比度要求
```
大文字 (18px+)
├─ WCAG AA: 3:1
└─ WCAG AAA: 4.5:1

小文字 (<18px)
├─ WCAG AA: 4.5:1
└─ WCAG AAA: 7:1

UI 組件
└─ 最低: 3:1
```

#### 色彩搭配範例

**主要按鈕**
```css
background: #0891B2 (Cyan 600)
text: #FFFFFF
hover: #0E7490 (Cyan 700)
active: #155E75 (Cyan 800)
disabled: #CBD5E1 (Slate 300)
```

**成功卡片**
```css
background: #DCFCE7 (Green 100)
border: #22C55E (Green 500)
icon: #16A34A (Green 600)
text: #15803D (Green 700)
```

---

## 3. 字體系統

### 3.1 字體家族

#### 主要字體
```
中文: Noto Sans TC, PingFang TC, Microsoft JhengHei
英文/數字: Inter, SF Pro, Roboto
等寬字體: SF Mono, Consolas, Monaco
```

#### Fallback 順序
```css
font-family:
  'Inter',
  'Noto Sans TC',
  'SF Pro TC',
  'PingFang TC',
  'Microsoft JhengHei',
  -apple-system,
  BlinkMacSystemFont,
  'Segoe UI',
  sans-serif;
```

### 3.2 字體大小

```
Display (展示)
├─ Display 1: 48px / 3rem - 特大標題
├─ Display 2: 40px / 2.5rem - 大標題
└─ Display 3: 32px / 2rem - 頁面標題

Heading (標題)
├─ H1: 28px / 1.75rem - 主標題
├─ H2: 24px / 1.5rem - 次標題
├─ H3: 20px / 1.25rem - 小標題
└─ H4: 18px / 1.125rem - 段落標題

Body (內文)
├─ Body Large: 18px / 1.125rem - 大內文
├─ Body: 16px / 1rem - 標準內文 ⭐
└─ Body Small: 14px / 0.875rem - 小內文

Caption (輔助)
├─ Caption: 12px / 0.75rem - 說明文字
└─ Overline: 10px / 0.625rem - 超小文字

Button (按鈕)
└─ Button: 16px / 1rem - 按鈕文字
```

### 3.3 字重 (Font Weight)

```
├─ Light: 300 - 輔助文字
├─ Regular: 400 - 標準內文 ⭐
├─ Medium: 500 - 強調文字
├─ Semibold: 600 - 小標題
└─ Bold: 700 - 重要標題
```

### 3.4 行高 (Line Height)

```
緊湊 (Tight)
└─ 1.2 - 標題、數字

標準 (Normal)
└─ 1.5 - 內文 ⭐

寬鬆 (Loose)
└─ 1.8 - 長文閱讀
```

### 3.5 字距 (Letter Spacing)

```
├─ Tight: -0.02em - 大標題
├─ Normal: 0 - 標準 ⭐
├─ Wide: 0.02em - 小文字
└─ Wider: 0.05em - 大寫文字
```

### 3.6 字體樣式範例

```css
/* Display 1 - 特大標題 */
.display-1 {
  font-size: 48px;
  font-weight: 700;
  line-height: 1.2;
  letter-spacing: -0.02em;
}

/* H1 - 主標題 */
.h1 {
  font-size: 28px;
  font-weight: 600;
  line-height: 1.3;
}

/* Body - 標準內文 */
.body {
  font-size: 16px;
  font-weight: 400;
  line-height: 1.5;
}

/* Caption - 說明文字 */
.caption {
  font-size: 12px;
  font-weight: 400;
  line-height: 1.4;
  color: var(--text-secondary);
}

/* Time Display - 時間顯示 */
.time-display {
  font-family: 'SF Mono', 'Consolas', monospace;
  font-size: 32px;
  font-weight: 600;
  line-height: 1;
  letter-spacing: 0.02em;
}
```

---

## 4. 間距與佈局

### 4.1 間距系統 (Spacing Scale)

```
基於 4px 的 8 倍數系統

├─ 0: 0px
├─ 1: 4px (0.25rem)
├─ 2: 8px (0.5rem) - 極小間距
├─ 3: 12px (0.75rem)
├─ 4: 16px (1rem) - 標準間距 ⭐
├─ 5: 20px (1.25rem)
├─ 6: 24px (1.5rem) - 中等間距
├─ 7: 28px (1.75rem)
├─ 8: 32px (2rem) - 大間距
├─ 10: 40px (2.5rem)
├─ 12: 48px (3rem) - 超大間距
├─ 16: 64px (4rem)
└─ 20: 80px (5rem)
```

### 4.2 元件內部間距

```
元件 Padding
├─ 緊湊: 8px 12px - 小按鈕、標籤
├─ 標準: 12px 16px - 標準按鈕 ⭐
├─ 舒適: 16px 24px - 大按鈕、卡片
└─ 寬鬆: 24px 32px - 英雄區塊
```

### 4.3 佈局間距

```
區塊間距 (Section Spacing)
├─ 緊湊: 16px - 相關元素
├─ 標準: 24px - 一般間距 ⭐
├─ 舒適: 32px - 區塊分隔
└─ 寬鬆: 48px - 主要區塊

頁面邊距 (Page Margin)
├─ 手機: 16px
├─ 平板: 24px
└─ 桌面: 32px
```

### 4.4 柵格系統 (Grid System)

```
12 欄柵格系統

欄間距 (Gutter)
├─ 手機: 16px
├─ 平板: 24px
└─ 桌面: 32px

最大寬度
├─ 手機: 100%
├─ 平板: 768px
└─ 桌面: 1200px
```

### 4.5 圓角 (Border Radius)

```
├─ None: 0
├─ Small: 4px - 標籤、徽章
├─ Medium: 8px - 按鈕、輸入框 ⭐
├─ Large: 12px - 卡片
├─ XLarge: 16px - 大卡片
└─ Full: 9999px - 圓形頭像、藥丸按鈕
```

### 4.6 陰影 (Shadow)

```css
/* 小陰影 - 懸浮元素 */
--shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);

/* 標準陰影 - 卡片 ⭐ */
--shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1),
          0 1px 2px -1px rgba(0, 0, 0, 0.1);

/* 中等陰影 - 懸停卡片 */
--shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1),
             0 2px 4px -2px rgba(0, 0, 0, 0.1);

/* 大陰影 - Modal */
--shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1),
             0 4px 6px -4px rgba(0, 0, 0, 0.1);

/* 超大陰影 - Drawer */
--shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1),
             0 8px 10px -6px rgba(0, 0, 0, 0.1);
```

---

## 5. 圖示系統

### 5.1 圖示庫選擇

**主要圖示庫：**
- Material Icons (Google)
- SF Symbols (iOS)
- Lucide Icons (開源替代)

### 5.2 圖示大小

```
├─ Extra Small: 16px - 內嵌文字
├─ Small: 20px - 按鈕、標籤
├─ Medium: 24px - 標準圖示 ⭐
├─ Large: 32px - 功能圖示
├─ XLarge: 48px - 空狀態
└─ XXLarge: 64px - 插圖
```

### 5.3 常用圖示對應

#### 導航
```
首頁: home
成績: bar_chart / assessment
目標: flag / target
隊伍: groups / people
個人: person / account_circle
```

#### 操作
```
新增: add / add_circle
編輯: edit / edit_note
刪除: delete / delete_outline
搜尋: search
篩選: filter_list
分享: share / ios_share
設定: settings
```

#### 狀態
```
成功: check_circle
警告: warning / error_outline
錯誤: cancel / error
資訊: info
待審核: schedule / pending
```

#### 泳姿
```
自由式: 🏊 (Emoji)
蝶式: 🦋
仰式: 🏊‍♀️
蛙式: 🏊‍♂️
混合式: 🌊
```

### 5.4 圖示顏色

```
預設: currentColor (繼承文字顏色)
主要: var(--color-primary)
成功: var(--color-success)
警告: var(--color-warning)
錯誤: var(--color-error)
禁用: var(--text-disabled)
```

---

## 6. 組件庫

### 6.1 按鈕 (Button)

#### 變體 (Variants)

**Primary Button (主要按鈕)**
```css
background: var(--color-primary);
color: white;
padding: 12px 24px;
border-radius: 8px;
font-weight: 600;
box-shadow: var(--shadow-sm);

hover {
  background: var(--color-primary-dark);
  box-shadow: var(--shadow-md);
}

active {
  transform: translateY(1px);
}

disabled {
  background: var(--color-disabled);
  cursor: not-allowed;
}
```

**Secondary Button (次要按鈕)**
```css
background: transparent;
color: var(--color-primary);
border: 2px solid var(--color-primary);
padding: 12px 24px;
border-radius: 8px;
```

**Text Button (文字按鈕)**
```css
background: transparent;
color: var(--color-primary);
padding: 8px 16px;
font-weight: 500;
```

**Icon Button (圖示按鈕)**
```css
width: 40px;
height: 40px;
border-radius: 50%;
display: flex;
align-items: center;
justify-content: center;
```

#### 大小 (Sizes)

```
Small: padding: 8px 16px; font-size: 14px;
Medium: padding: 12px 24px; font-size: 16px; ⭐
Large: padding: 16px 32px; font-size: 18px;
```

### 6.2 輸入框 (Input)

```css
.input {
  width: 100%;
  padding: 12px 16px;
  border: 2px solid var(--border-primary);
  border-radius: 8px;
  font-size: 16px;
  transition: all 0.2s;
}

.input:focus {
  outline: none;
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px rgba(8, 145, 178, 0.1);
}

.input:disabled {
  background: var(--bg-tertiary);
  cursor: not-allowed;
}

.input-error {
  border-color: var(--color-error);
}
```

**變體：**
- Text Input (文字輸入)
- Number Input (數字輸入)
- Email Input (電子郵件)
- Password Input (密碼 + 眼睛圖示)
- Textarea (多行文字)
- Search Input (搜尋 + 放大鏡)

### 6.3 選擇器 (Selectors)

**Radio Button (單選按鈕)**
```
大小: 20px × 20px
選中: 實心圓點
顏色: var(--color-primary)
```

**Checkbox (多選框)**
```
大小: 20px × 20px
選中: 勾選標記
顏色: var(--color-primary)
```

**Switch (開關)**
```
寬度: 48px
高度: 28px
圓點: 24px
動畫: 滑動 + 顏色變化
```

**Dropdown (下拉選單)**
```
高度: 44px
箭頭: expand_more 圖示
展開: 向下滑動動畫
```

### 6.4 卡片 (Card)

```css
.card {
  background: var(--bg-primary);
  border-radius: 12px;
  padding: 16px;
  box-shadow: var(--shadow);
  transition: all 0.3s;
}

.card:hover {
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.card-content {
  color: var(--text-secondary);
  line-height: 1.6;
}

.card-footer {
  display: flex;
  gap: 8px;
  margin-top: 16px;
  padding-top: 12px;
  border-top: 1px solid var(--border-primary);
}
```

**變體：**
- Standard Card (標準卡片)
- Elevated Card (浮起卡片)
- Outlined Card (邊框卡片)
- Interactive Card (可點擊卡片)

### 6.5 清單項目 (List Item)

```css
.list-item {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  gap: 12px;
  cursor: pointer;
  transition: background 0.2s;
}

.list-item:hover {
  background: var(--bg-secondary);
}

.list-item-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  flex-shrink: 0;
}

.list-item-content {
  flex: 1;
  min-width: 0;
}

.list-item-title {
  font-weight: 600;
  margin-bottom: 4px;
}

.list-item-subtitle {
  font-size: 14px;
  color: var(--text-secondary);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.list-item-action {
  flex-shrink: 0;
}
```

### 6.6 標籤/徽章 (Badge/Chip)

```css
.badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
  line-height: 1;
}

.badge-primary {
  background: var(--color-primary-light);
  color: var(--color-primary-dark);
}

.badge-success {
  background: var(--color-success-light);
  color: var(--color-success-dark);
}

.badge-warning {
  background: var(--color-warning-light);
  color: var(--color-warning-dark);
}

.badge-error {
  background: var(--color-error-light);
  color: var(--color-error-dark);
}

/* Notification Badge */
.notification-badge {
  position: absolute;
  top: -4px;
  right: -4px;
  min-width: 20px;
  height: 20px;
  background: var(--color-error);
  color: white;
  border-radius: 10px;
  font-size: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 6px;
}
```

### 6.7 進度指示器 (Progress Indicators)

**Linear Progress Bar (線性進度條)**
```css
.progress-bar {
  width: 100%;
  height: 8px;
  background: var(--bg-tertiary);
  border-radius: 4px;
  overflow: hidden;
}

.progress-bar-fill {
  height: 100%;
  background: var(--color-primary);
  transition: width 0.3s ease;
}
```

**Circular Progress (圓形進度)**
```css
.circular-progress {
  width: 48px;
  height: 48px;
  border: 4px solid var(--bg-tertiary);
  border-top-color: var(--color-primary);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
```

**Skeleton Loading (骨架屏)**
```css
.skeleton {
  background: linear-gradient(
    90deg,
    var(--bg-secondary) 25%,
    var(--bg-tertiary) 50%,
    var(--bg-secondary) 75%
  );
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: 4px;
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

### 6.8 通知/提示 (Toast/Snackbar)

```css
.toast {
  position: fixed;
  bottom: 16px;
  left: 16px;
  right: 16px;
  max-width: 400px;
  margin: 0 auto;
  padding: 16px;
  background: var(--bg-primary);
  border-radius: 8px;
  box-shadow: var(--shadow-lg);
  display: flex;
  align-items: center;
  gap: 12px;
  animation: slideUp 0.3s ease;
}

@keyframes slideUp {
  from {
    transform: translateY(100%);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.toast-success {
  border-left: 4px solid var(--color-success);
}

.toast-error {
  border-left: 4px solid var(--color-error);
}

.toast-warning {
  border-left: 4px solid var(--color-warning);
}
```

### 6.9 Modal/Dialog (彈出視窗)

```css
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: fadeIn 0.3s;
}

.modal-content {
  background: var(--bg-primary);
  border-radius: 16px;
  max-width: 500px;
  width: 90%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: var(--shadow-xl);
  animation: scaleIn 0.3s ease;
}

.modal-header {
  padding: 20px 24px;
  border-bottom: 1px solid var(--border-primary);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.modal-body {
  padding: 24px;
}

.modal-footer {
  padding: 16px 24px;
  border-top: 1px solid var(--border-primary);
  display: flex;
  gap: 8px;
  justify-content: flex-end;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes scaleIn {
  from {
    transform: scale(0.9);
    opacity: 0;
  }
  to {
    transform: scale(1);
    opacity: 1;
  }
}
```

### 6.10 Tab 標籤頁

```css
.tabs {
  display: flex;
  border-bottom: 2px solid var(--border-primary);
}

.tab {
  padding: 12px 16px;
  color: var(--text-secondary);
  font-weight: 500;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  margin-bottom: -2px;
  transition: all 0.2s;
}

.tab:hover {
  color: var(--color-primary);
}

.tab-active {
  color: var(--color-primary);
  border-bottom-color: var(--color-primary);
}
```

---

## 7. 動畫與轉場

### 7.1 動畫時長

```
Extra Fast: 100ms - Hover 效果
Fast: 200ms - 狀態切換
Normal: 300ms - 標準動畫 ⭐
Slow: 400ms - Modal/Drawer
Extra Slow: 600ms - 複雜動畫
```

### 7.2 緩動曲線 (Easing)

```css
/* 標準緩動 */
--ease-standard: cubic-bezier(0.4, 0.0, 0.2, 1);

/* 減速 (進入畫面) */
--ease-decelerate: cubic-bezier(0.0, 0.0, 0.2, 1);

/* 加速 (離開畫面) */
--ease-accelerate: cubic-bezier(0.4, 0.0, 1, 1);

/* 彈跳 */
--ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55);
```

### 7.3 常用動畫

#### 淡入淡出
```css
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes fadeOut {
  from { opacity: 1; }
  to { opacity: 0; }
}
```

#### 滑入滑出
```css
@keyframes slideInUp {
  from {
    transform: translateY(20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

@keyframes slideOutDown {
  from {
    transform: translateY(0);
    opacity: 1;
  }
  to {
    transform: translateY(20px);
    opacity: 0;
  }
}
```

#### 放大縮小
```css
@keyframes scaleIn {
  from {
    transform: scale(0.9);
    opacity: 0;
  }
  to {
    transform: scale(1);
    opacity: 1;
  }
}
```

#### 旋轉 (Loading)
```css
@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}
```

#### 彈跳 (Bounce)
```css
@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}
```

#### 慶祝效果 (PB 打破)
```css
@keyframes celebrate {
  0% { transform: scale(1); }
  25% { transform: scale(1.1) rotate(-5deg); }
  50% { transform: scale(1.1) rotate(5deg); }
  75% { transform: scale(1.1) rotate(-5deg); }
  100% { transform: scale(1); }
}
```

---

## 8. 響應式設計

### 8.1 斷點 (Breakpoints)

```
Mobile: 0 - 639px ⭐
Tablet: 640px - 1023px
Desktop: 1024px+
```

### 8.2 佈局調整

```css
/* Mobile First 方法 */

/* 手機 (預設) */
.container {
  padding: 16px;
}

.grid {
  grid-template-columns: 1fr;
  gap: 16px;
}

/* 平板 */
@media (min-width: 640px) {
  .container {
    padding: 24px;
  }

  .grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 24px;
  }
}

/* 桌面 */
@media (min-width: 1024px) {
  .container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 32px;
  }

  .grid {
    grid-template-columns: repeat(3, 1fr);
    gap: 32px;
  }
}
```

---

## 9. 無障礙設計

### 9.1 對比度

- 所有文字與背景對比度 ≥ 4.5:1
- 大文字 (18px+) 對比度 ≥ 3:1
- UI 元件對比度 ≥ 3:1

### 9.2 焦點指示

```css
*:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

button:focus-visible {
  box-shadow: 0 0 0 3px rgba(8, 145, 178, 0.3);
}
```

### 9.3 觸控目標

- 最小觸控區域: 44px × 44px
- 按鈕間距: ≥ 8px

### 9.4 螢幕閱讀器

- 所有圖片有 alt 文字
- 所有互動元素有 aria-label
- 使用語意化 HTML

---

## 10. 設計令牌 (Design Tokens)

### 10.1 CSS 變數定義

```css
:root {
  /* Colors */
  --color-primary: #0891B2;
  --color-primary-dark: #0E7490;
  --color-primary-light: #67E8F9;

  --color-success: #22C55E;
  --color-warning: #F59E0B;
  --color-error: #EF4444;
  --color-info: #0EA5E9;

  /* Text */
  --text-primary: #0F172A;
  --text-secondary: #475569;
  --text-tertiary: #94A3B8;
  --text-disabled: #CBD5E1;

  /* Background */
  --bg-primary: #FFFFFF;
  --bg-secondary: #F8FAFC;
  --bg-tertiary: #F1F5F9;

  /* Border */
  --border-primary: #E2E8F0;
  --border-secondary: #CBD5E1;

  /* Spacing */
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-6: 24px;
  --space-8: 32px;

  /* Border Radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-xl: 16px;
  --radius-full: 9999px;

  /* Shadow */
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1);

  /* Duration */
  --duration-fast: 200ms;
  --duration-normal: 300ms;
  --duration-slow: 400ms;

  /* Easing */
  --ease-standard: cubic-bezier(0.4, 0.0, 0.2, 1);
  --ease-in: cubic-bezier(0.4, 0.0, 1, 1);
  --ease-out: cubic-bezier(0.0, 0.0, 0.2, 1);
}

/* Dark Mode */
[data-theme="dark"] {
  --text-primary: #F8FAFC;
  --text-secondary: #CBD5E1;
  --text-tertiary: #64748B;
  --text-disabled: #475569;

  --bg-primary: #0F172A;
  --bg-secondary: #1E293B;
  --bg-tertiary: #334155;

  --border-primary: #334155;
  --border-secondary: #475569;
}
```

---

## 總結

本設計系統文件定義了 AquaTrack App 的完整視覺規範，包括：

✅ **色彩系統** - 主色、語意色、深淺模式
✅ **字體系統** - 字體家族、大小、行高
✅ **間距佈局** - 間距尺度、柵格系統、圓角陰影
✅ **圖示系統** - 圖示庫、大小、用法
✅ **組件庫** - 按鈕、輸入框、卡片等基礎組件
✅ **動畫效果** - 時長、緩動、常用動畫
✅ **響應式** - 斷點、佈局調整
✅ **無障礙** - 對比度、焦點、觸控
✅ **設計令牌** - CSS 變數定義

請開發團隊嚴格遵循此設計系統，確保 UI 的一致性和品質。
