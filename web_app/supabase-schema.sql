-- 创建数据表
CREATE TABLE IF NOT EXISTS chore_data (
    id INTEGER PRIMARY KEY DEFAULT 1,
    data JSONB NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 设置行级安全
ALTER TABLE chore_data ENABLE ROW LEVEL SECURITY;

-- 允许所有人读取（公开读取）
CREATE POLICY "Allow public read" ON chore_data
    FOR SELECT USING (true);

-- 允许所有人更新（公开写入）
CREATE POLICY "Allow public update" ON chore_data
    FOR ALL USING (true);

-- 插入初始数据（如果不存在）
INSERT INTO chore_data (id, data)
VALUES (1, '{"profile":{"name":"小朋友","class":"","password":"123456"},"checks":{},"approvals":[]}')
ON CONFLICT (id) DO NOTHING;
