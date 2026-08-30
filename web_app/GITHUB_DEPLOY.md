# 家务零花钱打卡 - GitHub Pages 版

## 在线访问
部署后可直接访问，支持多设备同步

## 部署到 GitHub Pages

### 步骤 1: 创建 GitHub 仓库
```bash
# 1. 在 GitHub 创建新仓库（如：chore-reward-app）
# 2. 将 web_app 目录内容推送到仓库
```

### 步骤 2: 启用 GitHub Pages
```
仓库设置 → Pages → Source: main branch → Save
```

### 步骤 3: 访问应用
```
https://你的用户名.github.io/仓库名/
```

---

## 功能特性

### 👦 孩子端
- ✅ 每日任务打卡（24项任务）
- ✅ 自动统计今日收入
- ✅ 显示本月累计收入
- ✅ 周末任务自动标记
- ✅ 点击任务勾选/取消

### 👨 家长端
- ✅ 密码保护登录
- ✅ 查看孩子信息
- ✅ 审核今日打卡记录
- ✅ 查看本月统计数据
- ✅ 历史记录表格视图
- ✅ 导出数据功能
- ✅ 修改密码设置

### ☁️ 数据同步（Firebase）
- ✅ 多设备数据同步
- ✅ 支持手机、平板、PC 访问
- ✅ 数据安全存储

---

## 配置 Firebase

1. 访问 https://firebase.google.com
2. 创建项目
3. 添加 Web 应用
4. 复制配置到 `index.html` 第 15-25 行
5. 启用 Firestore 数据库
6. 设置规则为公开读取（测试用）

---

## 文件说明

| 文件 | 说明 |
|-----|------|
| `index.html` | 主应用文件（单文件部署） |
| `firebase-config.js` | Firebase 配置 |
| `README.md` | 使用说明 |

---

## 使用说明

1. 复制 `index.html` 到 GitHub 仓库
2. 启用 GitHub Pages
3. 访问链接即可使用
4. 家长密码默认：123456
