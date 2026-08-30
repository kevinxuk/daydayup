# 家务零花钱打卡 - 云端同步版

## 🌐 在线访问
https://kevinxuk.github.io/daydayup/

## ☁️ 云端同步功能

### 功能特点
- ✅ 多设备数据同步
- ✅ 数据实时保存到云端
- ✅ 支持手机、平板、PC 访问
- ✅ 历史记录表格视图
- ✅ 导出 CSV 功能

### 数据同步方式
使用 Supabase 作为后端数据库，免费额度充足（500MB）

## 📝 部署 Supabase

### 步骤 1: 创建 Supabase 项目
1. 访问 https://supabase.com
2. 注册/登录账号
3. 点击 "New Project"
4. 选择免费套餐（Free）
5. 设置项目名称和密码
6. 选择服务器位置（建议选东南亚）

### 步骤 2: 创建数据表
1. 进入项目 Dashboard
2. 点击 "SQL Editor"
3. 复制 `supabase-schema.sql` 内容
4. 点击 "Run" 执行

### 步骤 3: 获取配置信息
1. 进入项目设置（Settings）
2. 点击 "API"
3. 复制以下信息：
   - Project URL（例如：`https://xxxxx.supabase.co`）
   - Anon/Public Key

### 步骤 4: 更新代码
打开 `web_app/cloud_index.html`，替换第 15-16 行：
```javascript
const SUPABASE_URL = 'https://your-project.supabase.co';
const SUPABASE_ANON_KEY = 'your-anon-key';
```

### 步骤 5: 部署到 GitHub Pages
1. 将 `cloud_index.html` 重命名为 `index.html`
2. 推送到 GitHub
3. GitHub Pages 会自动更新

## 📱 使用方法

### 孩子端
1. 打开网页
2. 点击任务打勾/取消
3. 数据自动同步到云端

### 家长端
1. 点击「家长端」
2. 输入密码（默认：`123456`）
3. 审核打卡记录
4. 查看历史记录表格
5. 导出 CSV 数据

## 🔒 数据说明

- 所有数据保存在 Supabase 云端
- 多设备数据实时同步
- 清除浏览器缓存不会影响数据
- 数据加密存储，安全可靠

## 📋 任务列表

| 分组 | 任务数 | 每日最高 |
|-----|-------|---------|
| 🌅 晨间 | 4 项 | 2.5 元 |
| 🏠 家务 | 6 项 | 5.0 元 |
| 📚 学习 | 7 项 | 7.0 元 |
| 🏃 运动 | 7 项 | 6.0 元 |
| **合计** | **24 项** | **20.5 元** |

## 🛠️ 技术栈

- 前端：纯 HTML/CSS/JavaScript
- 后端：Supabase（PostgreSQL）
- 部署：GitHub Pages
- 数据库：PostgreSQL（Supabase 托管）
