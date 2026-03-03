# 🔧 如何切換 Mock 模式與正式模式

## 快速切換方法

### 只需修改一個檔案！

打開 `lib/core/config/app_mode.dart`

```dart
class AppMode {
  /// 🔧 在這裡切換模式！
  static const bool useMockMode = true;  // ← 改這裡！
}
```

## 🎯 模式說明

### Mock 模式 (開發測試)
```dart
static const bool useMockMode = true;
```

**特點：**
- ✅ 任意帳密都能登入
- ✅ 無需後端 API
- ✅ 適合前端開發與 UI 測試
- ✅ 登入畫面會顯示橘色提示標籤
- ✅ 1 秒模擬網路延遲

**測試帳號：**
```
Email: test@example.com
密碼: 123456
（或任何其他組合）
```

### 正式模式 (連接真實 API)
```dart
static const bool useMockMode = false;
```

**特點：**
- ✅ 連接真實後端 API
- ✅ 需要真實註冊帳號
- ✅ 資料會實際儲存
- ✅ 需要配置 API 端點

**API 配置：**
在 `.env` 檔案中設定：
```env
API_BASE_URL=https://your-api-server.com/v1
```

## 📋 切換步驟

### 方法 1: 修改 app_mode.dart（推薦）

1. 開啟 `lib/core/config/app_mode.dart`
2. 修改 `useMockMode` 的值
   - `true` = Mock 模式
   - `false` = 正式模式
3. 儲存檔案
4. 熱重載應用程式（按 `r`）

### 方法 2: 使用環境變數

```powershell
# Mock 模式
flutter run -d chrome --dart-define=USE_MOCK=true

# 正式模式
flutter run -d chrome --dart-define=USE_MOCK=false
```

## 🔍 如何辨識當前模式

### 視覺指示器

**Mock 模式：**
- 登入畫面頂部會顯示橘色標籤
- 標籤內容：「🧪 Mock 模式 - 任意帳密可登入」

**正式模式：**
- 無標籤顯示
- 需要真實的帳號密碼

### 程式碼檢查

```dart
import 'package:aquatrack/core/config/app_mode.dart';

// 檢查當前模式
if (AppMode.isMock) {
  print('當前為 Mock 模式');
}

if (AppMode.isProduction) {
  print('當前為正式模式');
}

// 顯示模式名稱
print(AppMode.modeName); // "Mock 模式" 或 "正式模式"
```

## 📝 常見使用情境

### 開發階段
```dart
static const bool useMockMode = true;  // ✅ 使用 Mock
```
- 快速測試 UI
- 不需要後端就能開發
- 隨時修改程式碼並測試

### 整合測試階段
```dart
static const bool useMockMode = false;  // ✅ 使用正式模式
```
- 測試真實 API 連接
- 驗證資料流程
- 確認錯誤處理

### 生產環境
```dart
static const bool useMockMode = false;  // ✅ 必須使用正式模式
```
- 連接正式 API
- 真實使用者資料
- 完整功能運作

## 🎨 自訂模式切換 UI

您可以在任何畫面添加模式指示器：

```dart
import 'package:aquatrack/core/config/app_mode.dart';

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('首頁'),
      actions: [
        // 顯示當前模式
        if (AppMode.isMock)
          Chip(
            label: Text('Mock'),
            backgroundColor: Colors.orange,
          ),
      ],
    ),
    // ...
  );
}
```

## ⚙️ 進階配置

### 根據模式使用不同的 API 端點

```dart
class AppConfig {
  static String get apiBaseUrl {
    if (AppMode.isMock) {
      return 'http://localhost:3000/mock';
    } else {
      return const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api.aquatrack.example.com/v1',
      );
    }
  }
}
```

### 根據模式顯示不同的日誌級別

```dart
void log(String message) {
  if (AppMode.isMock) {
    print('[MOCK] $message');
  } else if (AppConfig.isDevelopment) {
    print('[DEV] $message');
  }
  // 生產環境不顯示日誌
}
```

## 🔄 快速切換快捷鍵

在 VS Code 中設置自訂快捷鍵：

1. 按 `Ctrl+Shift+P`
2. 搜尋 "Preferences: Open Keyboard Shortcuts (JSON)"
3. 添加：

```json
{
  "key": "ctrl+alt+m",
  "command": "workbench.action.tasks.runTask",
  "args": "Toggle Mock Mode"
}
```

## ✅ 檢查清單

切換到正式模式前，確認：

- [ ] 後端 API 已部署並運行
- [ ] `.env` 檔案中的 `API_BASE_URL` 已正確設定
- [ ] 已測試 API 連接
- [ ] 已準備真實測試帳號
- [ ] 已移除或註解掉所有 Mock 測試資料

切換到 Mock 模式：

- [x] 設定 `useMockMode = true`
- [x] 儲存檔案
- [x] 熱重載或重新啟動應用程式
- [x] 使用任意帳密測試

## 🎯 最佳實踐

1. **開發時使用 Mock 模式**
   - 快速迭代 UI
   - 不依賴後端進度

2. **整合時切換正式模式**
   - 確保 API 整合正確
   - 測試真實資料流

3. **部署前確認正式模式**
   - 絕不在生產環境使用 Mock

4. **使用版本控制**
   - 提交前檢查 `app_mode.dart`
   - 確保不誤提交 Mock 模式到生產分支

---

**現在您可以輕鬆切換模式了！** 🚀

只需修改 `lib/core/config/app_mode.dart` 中的一個布林值即可！
