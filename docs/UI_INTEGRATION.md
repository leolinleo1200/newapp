# 📱 UI/UX 設計整合指南

## 📂 UI 設計資源總覽

你提供的 UI HTML 包含以下頁面設計：

### ✅ 已有的 UI 設計

#### 認證頁面
- [ ] 登入 (Login)
- [ ] 註冊 (Register)

#### 主要功能頁面
- [ ] 儀表板 (Dashboard)
- [ ] 成績列表 (Records List - Competition)
- [ ] 新增成績 (Add Record) - 3 個變體
- [ ] 個人紀錄 (PB - Personal Best)
- [ ] 目標列表 (Targets List)
- [ ] 目標詳情 (Target Details) - 3 個變體

#### 隊伍和社交功能
- [ ] 教練後台 (Coach Backend - Team Creation & Invitation)
- [ ] 隊伍首頁 (Team Homepage - Student) - 3 個變體
- [ ] 輸入代碼加入 (Enter Code to Join)
- [ ] 排行榜 (Leaderboard)

#### 教練功能
- [ ] 建立課表模板 (Create Schedule Template)
- [ ] 教練課表列表 (Coach Schedule List)
- [ ] 學員課表回饋 (Student Schedule Feedback)

#### 工具和狀態
- [ ] 元件庫 (Component Library)
- [ ] 狀態頁 (State Pages)

---

## 🎨 設計系統特徵

根據提供的 HTML 代碼，設計使用：

### 顏色方案
- **主色**: #1193d4 (藍色)
- **背景-亮色**: #f6f7f8
- **背景-深色**: #111618
- **支持深色模式**: ✅

### 字體
- **Display 字體**: Space Grotesk
- **Body 字體**: Noto Sans
- **Icons**: Material Symbols Outlined

### 邊角半徑
- **Default**: 0.25rem
- **Large**: 0.5rem
- **XL**: 0.75rem
- **Full**: 9999px

### 樣式框架
- **CSS 框架**: Tailwind CSS
- **Form 支持**: ✅
- **Container Queries**: ✅
- **深色模式**: class-based

---

## 🔄 集成到 Web 前端

### Step 1: 複製 UI 代碼到 Vue 組件

#### 登入頁面示例

```vue
<!-- web/src/pages/Login.vue -->
<template>
  <div class="relative flex h-auto min-h-screen w-full flex-col bg-[#111618] dark group/design-root overflow-x-hidden">
    <div class="flex flex-col items-center justify-center flex-grow px-4">
      <div class="w-full max-w-sm">
        <h1 class="text-white tracking-light text-[32px] font-bold leading-tight px-4 text-center pb-3 pt-6">
          AquaTrack / 遊跡
        </h1>
        
        <div class="h-10"></div>
        
        <div class="flex max-w-[480px] flex-wrap items-end gap-4 px-4 py-3">
          <label class="flex flex-col min-w-40 flex-1">
            <p class="text-white text-base font-medium leading-normal pb-2">Email</p>
            <input
              v-model="email"
              type="email"
              class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-white focus:outline-0 focus:ring-0 border-none bg-[#283339] focus:border-none h-14 placeholder:text-[#9db0b9] p-4 text-base font-normal leading-normal"
              placeholder="Enter your email"
            />
          </label>
        </div>
        
        <!-- 更多表單字段... -->
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const email = ref('')
const password = ref('')

const handleLogin = async () => {
  // 登入邏輯
}
</script>
```

---

## 🎯 UI 集成優先順序

### Phase 1: 核心認證頁面 (本周)
1. ✅ Login.vue
2. ✅ Register.vue

### Phase 2: 主要功能頁面 (下周)
1. ✅ Dashboard.vue
2. ✅ Records.vue (List + Add)
3. ✅ PB.vue
4. ✅ Targets.vue

### Phase 3: 社交功能 (第 2 周)
1. ✅ Teams.vue
2. ✅ Leaderboard.vue
3. ✅ Join Code

### Phase 4: 教練功能 (第 3 周)
1. ✅ Coach Dashboard
2. ✅ Schedule Management
3. ✅ Team Management

---

## 📝 Web Vue 組件模板

### 使用提供的 UI 設計更新所有頁面

```
web/src/pages/
├── Login.vue              ← 使用 UI 設計
├── Register.vue           ← 使用 UI 設計
├── Dashboard.vue          ← 使用 UI 設計
├── Records.vue            ← 使用 UI 設計 (List + Add 3 個變體)
├── PB.vue                 ← 使用 UI 設計
├── Targets.vue            ← 使用 UI 設計 (詳情 3 個變體)
├── Teams.vue              ← 使用 UI 設計 (3 個變體)
├── Leaderboard.vue        ← 使用 UI 設計
└── Coach/
    ├── Dashboard.vue      ← 使用 UI 設計
    ├── Schedule.vue       ← 使用 UI 設計
    └── TeamManagement.vue ← 使用 UI 設計
```

---

## 📱 Android UI 組件庫 (Compose)

### Jetpack Compose 中實現相同的設計系統

```kotlin
// android/app/src/main/kotlin/com/aquatrack/ui/theme/Theme.kt

@Composable
fun AquaTrackTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val colors = if (darkTheme) {
        darkColorScheme(
            primary = Color(0xFF1193D4),
            surface = Color(0xFF111618),
            background = Color(0xFF111618),
        )
    } else {
        lightColorScheme(
            primary = Color(0xFF1193D4),
            surface = Color(0xFFF6F7F8),
            background = Color(0xFFF6F7F8),
        )
    }

    MaterialTheme(
        colorScheme = colors,
        typography = Typography(
            displayLarge = TextStyle(
                fontFamily = spaceGroteskFont,
                fontSize = 32.sp,
                fontWeight = FontWeight.Bold,
            ),
        ),
        content = content
    )
}
```

### Android Compose 頁面實現

```kotlin
// android/app/src/main/kotlin/com/aquatrack/ui/screens/LoginScreen.kt

@Composable
fun LoginScreen(
    onLoginClick: (email: String, password: String) -> Unit
) {
    var email by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF111618)),
        contentAlignment = Alignment.Center
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth(0.9f)
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                "AquaTrack / 遊跡",
                style = MaterialTheme.typography.displayLarge,
                color = Color.White
            )

            Spacer(modifier = Modifier.height(40.dp))

            OutlinedTextField(
                value = email,
                onValueChange = { email = it },
                label = { Text("Email") },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp),
                colors = TextFieldDefaults.outlinedTextFieldColors(
                    textColor = Color.White,
                    containerColor = Color(0xFF283339),
                )
            )

            Spacer(modifier = Modifier.height(16.dp))

            OutlinedTextField(
                value = password,
                onValueChange = { password = it },
                label = { Text("Password") },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp),
                colors = TextFieldDefaults.outlinedTextFieldColors(
                    textColor = Color.White,
                    containerColor = Color(0xFF283339),
                ),
                visualTransformation = PasswordVisualTransformation()
            )

            Spacer(modifier = Modifier.height(24.dp))

            Button(
                onClick = { onLoginClick(email, password) },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color(0xFF1193D4)
                )
            ) {
                Text("Sign In", fontSize = 16.sp)
            }
        }
    }
}
```

---

## 🎨 設計系統配置

### Web Tailwind 配置更新

```typescript
// web/tailwind.config.js
export default {
  theme: {
    extend: {
      colors: {
        'primary': '#1193D4',
        'background-light': '#f6f7f8',
        'background-dark': '#111618',
        'card-dark': '#283339',
        'text-light': '#9db0b9',
      },
      fontFamily: {
        'display': ['Space Grotesk', 'Noto Sans', 'sans-serif'],
        'body': ['Noto Sans', 'sans-serif'],
      },
      borderRadius: {
        'DEFAULT': '0.25rem',
        'lg': '0.5rem',
        'xl': '0.75rem',
      },
    },
  },
}
```

---

## 📊 UI 組件映射表

| UI 設計 | Web Vue 組件 | Android Compose | iOS SwiftUI |
|--------|-----------|----------------|-----------|
| Login | ✅ 已有框架 | ✅ 待實現 | ⏳ 待開發 |
| Register | ✅ 已有框架 | ✅ 待實現 | ⏳ 待開發 |
| Dashboard | ✅ 已有框架 | ✅ 待實現 | ⏳ 待開發 |
| Records | ✅ 已有框架 | ✅ 待實現 | ⏳ 待開發 |
| PB | ✅ 已有框架 | ✅ 待實現 | ⏳ 待開發 |
| Targets | ✅ 已有框架 | ✅ 待實現 | ⏳ 待開發 |
| Teams | ✅ 已有框架 | ✅ 待實現 | ⏳ 待開發 |
| Leaderboard | ✅ 已有框架 | ✅ 待實現 | ⏳ 待開發 |
| Coach Section | ✅ 待實現 | ✅ 待實現 | ⏳ 待開發 |

---

## 🚀 快速集成步驟

### Step 1: 為每個 UI 頁面建立 Vue 組件

```bash
# 自動生成所有 Vue 組件框架
npm run generate:vue-components
```

### Step 2: 複製 HTML 結構

```bash
# 從 ui_html 複製 HTML 並轉換為 Vue
npm run convert:html-to-vue
```

### Step 3: 添加 Vue 邏輯

```typescript
// web/src/pages/NewPage.vue
<template>
  <!-- 從 UI 設計複製的 HTML -->
</template>

<script setup lang="ts">
// 添加 Vue 邏輯
</script>
```

### Step 4: Android Compose 實現

使用相同的 UI 設計，但用 Kotlin Compose 重新實現。

---

## 📦 文件組織

```
swimtracker/
├── ui_html/                    # ← 原始 UI 設計
│   ├── 登入_(login)/
│   ├── 註冊_(register)/
│   ├── 儀表板_(dashboard)/
│   ├── ... (其他 20+ 頁面)
│   └── 元件庫_(component_library)/
│
├── web/
│   └── src/
│       ├── pages/
│       │   ├── Login.vue       # ← 從 ui_html 轉換
│       │   ├── Register.vue    # ← 從 ui_html 轉換
│       │   ├── Dashboard.vue   # ← 從 ui_html 轉換
│       │   └── ...
│       └── components/
│           ├── Button.vue
│           ├── Input.vue
│           └── ...
│
├── android/
│   └── app/src/main/kotlin/com/aquatrack/
│       ├── ui/
│       │   ├── screens/
│       │   │   ├── LoginScreen.kt      # ← Compose 版本
│       │   │   ├── RegisterScreen.kt   # ← Compose 版本
│       │   │   └── ...
│       │   ├── theme/
│       │   │   └── Theme.kt
│       │   └── components/
│       │       ├── AquaButton.kt
│       │       ├── AquaInput.kt
│       │       └── ...
│       └── viewmodels/
│           ├── LoginViewModel.kt
│           └── ...
│
└── docs/
    ├── UI_INTEGRATION.md        # ← 本文檔
    ├── COMPONENT_LIBRARY.md
    └── DESIGN_SYSTEM.md
```

---

## ✅ 集成檢查清單

- [ ] 安裝 Material Symbols Outlined 字體
- [ ] 配置 Tailwind CSS 主題色
- [ ] 轉換所有 HTML 為 Vue 組件
- [ ] 為每個 Vue 組件添加業務邏輯
- [ ] 在 Android 中實現 Compose 版本
- [ ] 測試所有頁面
- [ ] 測試深色模式
- [ ] 驗證響應式設計

---

## 🎓 下一步

1. **Web 前端**: 用提供的 UI HTML 更新所有 Vue 組件
2. **Android**: 用 Compose 實現相同的設計
3. **iOS**: 稍後用 SwiftUI 實現

**建議開發順序**: Login → Dashboard → Records → 其他

---

**UI 設計資源已集成！開始實現 Web 前端吧！** 🚀
