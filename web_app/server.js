const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// 中间件
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'web_app')));

// 数据存储文件
const DATA_FILE = path.join(__dirname, 'data', 'chore_data.json');

// 确保数据目录存在
const dataDir = path.join(__dirname, 'data');
if (!fs.existsSync(dataDir)) {
    fs.mkdirSync(dataDir, { recursive: true });
}

// 读取数据
function loadData() {
    try {
        if (fs.existsSync(DATA_FILE)) {
            const data = fs.readFileSync(DATA_FILE, 'utf8');
            return JSON.parse(data);
        }
    } catch (error) {
        console.error('读取数据失败:', error);
    }
    return {
        profile: { name: '小朋友', class: '', password: '123456' },
        checks: {},
        approvals: []
    };
}

// 保存数据
function saveData(data) {
    try {
        fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2));
        return true;
    } catch (error) {
        console.error('保存数据失败:', error);
        return false;
    }
}

// API 路由

// 获取数据
app.get('/api/data', (req, res) => {
    const data = loadData();
    res.json(data);
});

// 保存数据
app.post('/api/data', (req, res) => {
    const success = saveData(req.body);
    if (success) {
        res.json({ success: true, message: '数据已保存' });
    } else {
        res.status(500).json({ success: false, message: '保存失败' });
    }
});

// 服务器已启动
console.log(`🚀 服务器运行在 http://localhost:${PORT}`);
console.log(`📁 数据文件: ${DATA_FILE}`);

app.listen(PORT, () => {
    console.log(`✅ 服务已启动!`);
});
