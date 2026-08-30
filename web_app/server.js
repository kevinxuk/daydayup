// 家务零花钱打卡 - 云端同步服务器
const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 3000;

// 中间件
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'web_app')));

// 数据存储目录
const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) {
    fs.mkdirSync(DATA_DIR, { recursive: true });
}

// 获取用户数据文件路径
function getUserDataPath(deviceId) {
    return path.join(DATA_DIR, `${deviceId}.json`);
}

// 读取用户数据
function readUserData(deviceId) {
    const filePath = getUserDataPath(deviceId);
    if (fs.existsSync(filePath)) {
        return JSON.parse(fs.readFileSync(filePath, 'utf8'));
    }
    return null;
}

// 保存用户数据
function saveUserData(deviceId, data) {
    const filePath = getUserDataPath(deviceId);
    fs.writeFileSync(filePath, JSON.stringify(data, null, 2));
}

// API: 同步数据
app.post('/api/sync', (req, res) => {
    const { deviceId, data } = req.body;
    
    if (!deviceId) {
        return res.status(400).json({ error: 'deviceId 不能为空' });
    }
    
    saveUserData(deviceId, data);
    res.json({ success: true, message: '数据同步成功' });
});

// API: 获取数据
app.get('/api/sync/:deviceId', (req, res) => {
    const { deviceId } = req.params;
    const data = readUserData(deviceId);
    
    if (!data) {
        return res.status(404).json({ error: '未找到数据' });
    }
    
    res.json(data);
});

// API: 创建新用户
app.post('/api/register', (req, res) => {
    const { deviceId, data } = req.body;
    
    if (!deviceId) {
        return res.status(400).json({ error: 'deviceId 不能为空' });
    }
    
    // 如果已存在，返回现有数据
    const existing = readUserData(deviceId);
    if (existing) {
        return res.json({ success: true, data: existing, isNew: false });
    }
    
    // 创建新用户
    const userData = {
        ...data,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    };
    
    saveUserData(deviceId, userData);
    res.json({ success: true, data: userData, isNew: true });
});

// API: 删除数据（家长端）
app.delete('/api/data/:deviceId', (req, res) => {
    const { deviceId } = req.params;
    const filePath = getUserDataPath(deviceId);
    
    if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
        res.json({ success: true, message: '数据已清除' });
    } else {
        res.status(404).json({ error: '数据不存在' });
    }
});

// 启动服务器
app.listen(PORT, () => {
    console.log(`服务器运行在 http://localhost:${PORT}`);
    console.log(`API 地址: http://localhost:${PORT}/api/sync`);
    console.log(`数据目录: ${DATA_DIR}`);
});
