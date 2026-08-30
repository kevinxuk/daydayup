# 家务零花钱打卡 - Flutter 项目

## 项目说明
这是一个专为小学生设计的家务零花钱打卡管理应用，包含每日打卡、数据统计、任务管理等功能。

## 功能特性

### 📋 每日打卡
- 自动显示当天日期
- 24个任务（晨间4 + 家务6 + 学习7 + 运动7）
- 点击方框打勾/取消，有动效反馈
- 周末任务自动标记 🌙
- 实时显示当日收入

### 📊 数据统计
- 本月累计收入
- 最高单日收入
- 打卡天数统计
- 分组任务完成图表（使用 FL Chart）

### ✏️ 任务管理
- 新增任务（选择分组、设置金额、图标）
- 修改现有任务
- 删除任务
- 启用/禁用任务
- 设置周末/平日

### 🔒 家长管理
- 密码保护
- 修改孩子姓名、班级
- 重置所有数据
- 第一使用时设置密码

## 技术栈
- **Flutter 3.16+** - 跨平台 UI 框架
- **Dart** - 编程语言
- **Hive** - 本地 NoSQL 存储
- **Provider** - 状态管理
- **FL Chart** - 数据可视化
- **intl** - 日期格式化

## 项目结构
```
flutter_chore_app/
├── lib/
│   ├── main.dart                    # 应用入口
│   ├── models/
│   │   ├── task.dart                # 数据模型 (Task, CheckRecord等)
│   │   └── task_data.dart           # 任务配置 + 数据库助手 + Hive适配器
│   ├── providers/
│   │   └── chore_provider.dart      # 状态管理
│   └── screens/
│       ├── daily_screen.dart        # 每日打卡界面
│       ├── statistics_screen.dart   # 统计图表界面
│       ├── task_manager_screen.dart # 任务管理界面
│       └── parent_panel_screen.dart # 家长管理界面
├── pubspec.yaml                     # 项目配置和依赖
├── buildozer.spec                   # Android APK 构建配置
└── README.md                        # 项目说明
```

## 任务数据（与 Excel 完全一致）

### 🌅 晨间 (4项)
| 任务 | 金额 | 周末 |
|------|------|------|
| 按时起床、叠好被子 | +1元 | ✗ |
| 整理床铺 | +0.5元 | ✗ |
| 吃早餐（不催促） | +0.5元 | ✗ |
| 准备当天上学用品 | +0.5元 | ✗ |

### 🏠 家务 (6项)
| 任务 | 金额 | 周末 |
|------|------|------|
| 摆碗筷、收拾餐桌 | +1元 | ✗ |
| 扫地/拖地（自己房间） | +1元 | ✗ |
| 倒垃圾（分类） | +0.5元 | ✗ |
| 擦桌子 | +0.5元 | ✗ |
| 整理玩具/书籍 | +0.5元 | ✗ |
| 周末：洗菜/择菜/洗袜子等 | +2元 | ✓ |

### 📚 学习 (7项)
| 任务 | 金额 | 周末 |
|------|------|------|
| 按时完成作业（无催促） | +2元 | ✗ |
| 主动复习/预习 | +1元 | ✗ |
| 课外阅读30分钟 | +1元 | ✗ |
| 练字/书法练习 | +1元 | ✗ |
| 完成额外练习题 | +1元 | ✗ |
| 整理书包/学习资料 | +0.5元 | ✗ |
| 背单词/古诗词（10个） | +0.5元 | ✗ |

### 🏃 运动 (7项)
| 任务 | 金额 | 周末 |
|------|------|------|
| 跳绳100下 | +1元 | ✗ |
| 跑步/慢跑800米 | +1.5元 | ✗ |
| 仰卧起坐30个 | +1元 | ✗ |
| 坐位体前屈练习 | +0.5元 | ✗ |
| 立定跳远练习 | +0.5元 | ✗ |
| 开合跳/高抬腿（5分钟） | +1元 | ✗ |
| 球类运动（篮球/足球/乒乓球等） | +1.5元 | ✗ |

**总计：每日最多 18.5 元**

## 环境准备

### 安装 Flutter
```bash
# Windows - 下载安装包
# https://docs.flutter.dev/get-started/install/windows

# 验证安装
flutter --version
flutter doctor
```

### 安装 Android Studio (可选，用于模拟器)
```
- Android Studio 2022.3+
- Android SDK 33
- Android SDK Build-Tools 33.0.0
- Java 17 JDK
```

## 运行项目

### 方法1：运行到设备/模拟器
```bash
cd outputs/flutter_chore_app
flutter pub get
flutter run
```

### 方法2：使用 Android Studio / VS Code
1. 打开 Flutter_chore_app 目录
2. 等待依赖安装完成
3. 选择设备后运行

## 构建 APK

### 方法1：直接构建
```bash
cd outputs/flutter_chore_app
flutter build apk --release
# 输出: build/app/outputs/flutter-apk/app-release.apk
```

### 方法2：使用 buildozer (需要 WSL 环境)
```bash
# 在 WSL 中
pip install buildozer cython
buildozer android debug
# 输出: bin/chore_reward_app-1.0.0-arm64-v8a-debug.apk
```

## 安装 APK
```bash
# 通过 USB 安装
adb install build/app/outputs/flutter-apk/app-release.apk

# 或直接在手机上打开文件管理器安装
```

## 开发说明

### 添加新任务
编辑 `lib/models/task_data.dart` 中的 `TaskConfig.defaultTasks`：
```dart
{
  "group": "🌅 晨间",
  "name": "新任务名称",
  "amount": 1.0,
  "icon": "📌",
  "weekendOnly": false
}
```

### 修改金额
在同一个文件中修改 `amount` 字段即可。

### 修改密码
首次打开"管理"页面，设置家长密码。密码存储在本地设备中。

## 数据存储
所有数据使用 Hive 本地存储，包括：
- 任务列表（支持增删改）
- 打卡记录
- 用户配置
- 统计数据

数据不会上传到云端，仅保存在本地设备中。

## 常见问题

### Q: 运行时报错 "Hive initialization failed"
```bash
flutter clean
flutter pub get
```

### Q: 构建 APK 失败
检查 `flutter doctor` 输出，确保 Android SDK 和 Java 环境正确配置。

### Q: 应用数据丢失
Hive 数据存储在应用沙盒中，卸载应用会清除数据。如需保留，可导出数据库文件。

## 许可证
MIT License - 可用于个人教育用途

## 版本
v1.0.0 - 2026年
