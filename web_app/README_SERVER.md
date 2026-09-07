# 家务零花钱打卡 - 本地服务器版

## 🚀 启动服务器

### 方式一：一键启动
双击运行 `start_server.py`

### 方式二：命令行启动
```bash
cd C:\Users\Administrator\Documents\1mycode\daydayup\web_app
npm install
npm start
```

### 方式三：手动启动
```bash
npm install
node server.js
```

---

## 📱 访问地址

启动后访问：http://localhost:3000

---

## ☁️ 云端同步（可选）

如需云端同步，请配置 Supabase：

1. 访问 https://supabase.com 创建项目
2. 在控制台执行 SQL：
```sql
CREATE TABLE IF NOT EXISTS chore_data (
    id INTEGER PRIMARY KEY DEFAULT 1,
    data JSONB NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE chore_data ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read" ON chore_data
    FOR SELECT USING (true);

CREATE POLICY "Allow public update" ON chore_data
    FOR ALL USING (true);

INSERT INTO chore_data (id, data)
VALUES (1, '{"profile":{"name":"小朋友","class":"","password":"123456"},"checks":{},"approvals":[]}')
ON CONFLICT (id) DO NOTHING;
```

3. 在代码中配置 Supabase 连接

---

## 📋 功能说明

### 孩子端
- ✅ 每日任务打卡（24项）
- ✅ 自动统计金额
- ✅ 一键同步到云端

### 家长端
- ✅ 密码保护登录
- ✅ 审核打卡记录
- ✅ 查看历史记录
- ✅ 导出数据

---

## 🔒 默认密码
家长密码：`123456`
