const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const cron = require('node-cron');
const { fetchDeals } = require('./fetch_deals');
const { initializeFirebase, syncDealsToFirestore } = require('./firebase_service');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// 初始化 Firebase
initializeFirebase();

const STATUS_FILE = path.join(__dirname, 'last_run_status.json');

// 儲存執行狀態
function updateStatus(result) {
    const status = {
        lastRun: new Date().toLocaleString("zh-TW", { timeZone: "Asia/Taipei" }),
        ...result
    };
    fs.writeFileSync(STATUS_FILE, JSON.stringify(status, null, 2));
}

// 封裝一個通用的抓取與同步函式
async function performFetchAndSync() {
    try {
        const filePath = path.join(__dirname, 'deals_output.json');
        let existingDeals = [];
        if (fs.existsSync(filePath)) {
            const data = fs.readFileSync(filePath, 'utf8');
            existingDeals = JSON.parse(data);
        }

        console.log(`[Task] Starting fetch with ${existingDeals.length} existing deals as context...`);
        const allDeals = await fetchDeals(existingDeals);

        // 只同步最後抓到的完整清單
        const count = await syncDealsToFirestore(allDeals);
        return { fetchCount: allDeals.length, syncCount: count };
    } catch (error) {
        console.error('[Task] Error:', error.message);
        throw error;
    }
}

// 設定排程：每天早上 08:00 執行抓取與同步
// Cron 格式: 分 時 日 月 週
cron.schedule('0 8 * * *', async () => {
    console.log(`[Scheduled Task] Triggered at ${new Date().toLocaleString()}`);
    try {
        const result = await performFetchAndSync();
        updateStatus({ success: true, ...result });
        console.log(`[Scheduled Task] Success: ${JSON.stringify(result)}`);
    } catch (error) {
        updateStatus({ success: false, error: error.message });
        console.error('[Scheduled Task] Error:', error.message);
    }
}, {
    timezone: "Asia/Taipei"
});

console.log('⏰ Scheduled task initialized: Daily at 08:00 AM (Asia/Taipei)');

// API: 查看最後執行狀態
app.get('/api/status', (req, res) => {
    if (fs.existsSync(STATUS_FILE)) {
        res.json(JSON.parse(fs.readFileSync(STATUS_FILE, 'utf8')));
    } else {
        res.json({ message: 'No tasks have run yet.' });
    }
});

// API: 獲取本地 JSON 數據
app.get('/api/deals', (req, res) => {
    const filePath = path.join(__dirname, 'deals_output.json');
    if (fs.existsSync(filePath)) {
        const data = fs.readFileSync(filePath, 'utf8');
        res.json(JSON.parse(data));
    } else {
        res.status(404).json({ error: 'No deals found. Run /api/fetch first.' });
    }
});

// API: 觸發 Perplexity 抓取
app.get('/api/fetch', async (req, res) => {
    try {
        const filePath = path.join(__dirname, 'deals_output.json');
        let existingDeals = [];
        if (fs.existsSync(filePath)) {
            existingDeals = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        }
        const deals = await fetchDeals(existingDeals);
        res.json({ message: 'Fetch completed', count: deals.length });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// API: 同步本地 JSON 到 Firebase
app.get('/api/sync', async (req, res) => {
    try {
        const filePath = path.join(__dirname, 'deals_output.json');
        if (!fs.existsSync(filePath)) {
            return res.status(404).json({ error: 'Local deals file not found. Run fetch first.' });
        }
        const deals = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        const count = await syncDealsToFirestore(deals);
        res.json({ message: 'Sync completed', count });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// API: 抓取並直接同步到 Firebase (One-stop)
app.get('/api/fetch-and-sync', async (req, res) => {
    try {
        const result = await performFetchAndSync();
        res.json({
            message: 'Fetch and Sync completed (AI Deduplication applied)',
            ...result
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.listen(PORT, () => {
    console.log('\n' + '='.repeat(40));
    console.log(`🚀 優惠抓取後端已啟動！`);
    console.log(`📡 運行網址: http://localhost:${PORT}`);
    console.log(`⏰ 定時任務: 每天早上 08:00 (台北時間)`);
    console.log(`📊 狀態查看: http://localhost:${PORT}/api/status`);
    console.log('='.repeat(40) + '\n');
});

