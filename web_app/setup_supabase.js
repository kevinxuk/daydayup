const { createClient } = require('@supabase/supabase-js');

// 生成随机密码
function generatePassword(length = 20) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*';
    let password = '';
    for (let i = 0; i < length; i++) {
        password += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return password;
}

async function createSupabaseProject() {
    console.log('正在创建 Supabase 项目...');
    
    // 注意：Supabase 没有公开 API 创建项目，需要通过控制台手动创建
    // 这里我们创建一个配置文件，用户需要手动填入
    
    const config = {
        projectRef: 'your-project-ref',
        password: generatePassword()
    };
    
    console.log('\n========================================');
    console.log('Supabase 项目配置');
    console.log('========================================');
    console.log('\n⚠️  请按照以下步骤创建 Supabase 项目：\n');
    console.log('1. 访问 https://supabase.com/dashboard');
    console.log('2. 点击 "New Project"\n');
    console.log('3. 设置项目信息：');
    console.log('   - 名称：chore-reward');
    console.log('   - 数据库密码：' + config.password);
    console.log('   - 区域：Southeast Asia (Singapore)\n');
    console.log('4. 等待项目创建完成（约 2 分钟）\n');
    console.log('5. 获取 API 配置：');
    console.log('   - 进入 Settings → API');
    console.log('   - 复制 Project URL 和 anon/public key\n');
    console.log('========================================\n');
    
    return config;
}

async function setupDatabase(supabaseUrl, supabaseKey) {
    console.log('正在配置数据库...');
    
    const supabase = createClient(supabaseUrl, supabaseKey);
    
    // 创建表
    const { error } = await supabase.rpc('create_chore_data_table');
    
    if (error) {
        console.log('\n请手动执行以下 SQL 创建表：\n');
        console.log(`
-- 在 Supabase SQL Editor 中执行：

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
        `);
    } else {
        console.log('数据库配置完成！');
    }
}

async function main() {
    const config = await createSupabaseProject();
    
    console.log('\n配置文件已生成：supabase-config.json');
    console.log('请按照提示完成 Supabase 项目创建，然后填写配置信息。\n');
    
    // 保存配置到文件
    const fs = require('fs');
    fs.writeFileSync('supabase-config.json', JSON.stringify(config, null, 2));
}

main().catch(console.error);
