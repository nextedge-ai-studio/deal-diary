const axios = require('axios');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const API_KEY = process.env.PERPLEXITY_API_KEY;

// ===== 台灣店家清單 =====
const TAIWAN_MERCHANTS = {
    // 便利商店
    convenience: ['7-ELEVEN', '全家 FamilyMart', '萊爾富 Hi-Life', 'OK超商'],
    // 速食餐廳
    fastFood: ['麥當勞', '肯德基 KFC', '漢堡王', '摩斯漢堡', '頂呱呱', '拿坡里披薩'],
    // 咖啡飲料
    coffee: ['星巴克', '路易莎', 'cama café', '85度C', '50嵐', '清心福全', '可不可熟成紅茶', '迷客夏'],
    // 超市量販
    supermarket: ['全聯', '家樂福', '愛買', 'Costco', '大潤發', '美廉社'],
    // 藥妝美妝
    drugstore: ['屈臣氏', '康是美', '寶雅', '小三美日'],
    // 餐飲連鎖
    restaurant: ['王品集團', '瓦城', '鼎泰豐', '欣葉', '饗食天堂', '爭鮮', '藏壽司', '築間']
};

// ===== 標籤分類定義 =====
const TAG_CATEGORIES = {
    // 店家類型標籤
    storeType: ['便利商店', '速食', '咖啡廳', '手搖飲', '超市', '量販店', '藥妝', '餐廳'],
    // 優惠類型標籤
    dealType: ['買一送一', '第二件半價', '加價購', '滿額折扣', '滿額贈', '會員專屬', '限時特價', '抽獎活動', '集點換購', '免費兌換'],
    // 付款方式標籤
    payment: ['行動支付優惠', '信用卡優惠', '電子票證優惠', 'App專屬'],
    // 時段標籤
    timing: ['早餐優惠', '午餐優惠', '下午茶優惠', '宵夜優惠', '週末限定', '平日限定'],
    // 節日標籤
    festival: ['春節優惠', '情人節', '元宵節', '228連假', '母親節', '端午節', '中秋節', '雙11', '聖誕節']
};

async function fetchDeals(existingDeals = []) {
    if (!API_KEY) {
        console.error('Error: PERPLEXITY_API_KEY is not set in .env');
        return [];
    }

    // 將所有店家展開成列表
    const allMerchants = Object.values(TAIWAN_MERCHANTS).flat().join('、');
    const allTags = [...TAG_CATEGORIES.storeType, ...TAG_CATEGORIES.dealType, ...TAG_CATEGORIES.payment, ...TAG_CATEGORIES.timing, ...TAG_CATEGORIES.festival];

    // 準備已有資料的摘要供 AI 參考
    const existingSummary = existingDeals.length > 0
        ? existingDeals.map(d => `- [${d.merchantName}] ${d.title}: ${d.description.substring(0, 50)}...`).join('\n')
        : '目前資料庫為空';

    console.log('--- 正在搜尋台灣店家優惠資訊 (AI 去重模式) ---');
    if (existingDeals.length > 0) {
        console.log(`已有資料數量: ${existingDeals.length} 筆，將進行比對過濾...`);
    }

    try {
        const response = await axios.post(
            'https://api.perplexity.ai/chat/completions',
            {
                model: 'sonar',
                messages: [
                    {
                        role: 'system',
                        content: `你是台灣專業的優惠情報達人。
你的任務是搜尋台灣各大連鎖店家目前正在進行的優惠活動，並「嚴格過濾」重複內容。

【已存在的優惠（請忽略相似或語義相同的內容）】
${existingSummary}

【去重規則】
1. 如果新搜尋到的優惠與上述「已存在」的內容語義相同（例如標題不同但內容是同一件事），請「不要」回傳。
2. 只有真正全新的、或是已存在優惠的重大更新才回傳。
3. 如果沒有新發現，請只回傳空陣列 []。
4. 只回傳 JSON 陣列，不要有其他解釋文字。`
                    },
                    {
                        role: 'user',
                        content: `請搜尋以下台灣店家目前正在進行的優惠活動（2026年2月）：

【店家清單】
${allMerchants}

【搜尋與輸出規則】
- 聚焦在新的、我名單中沒有的活動。
- 每個優惠必須包含標籤、來源網址、正確日期。
- 格式如下：
[
  {
    "id": "唯一碼",
    "title": "標題",
    "description": "詳情",
    "merchantName": "店家名",
    "merchantType": "類型",
    "startDate": "2026-02-01T00:00:00+08:00",
    "endDate": "2026-02-28T23:59:59+08:00",
    "tags": ["標籤1", "標籤2"],
    "sourceUrl": "網址"
  }
]`
                    }
                ]
            },
            {
                headers: {
                    'Authorization': `Bearer ${API_KEY}`,
                    'Content-Type': 'application/json'
                }
            }
        );

        const content = response.data.choices[0].message.content;

        // 更穩健的 JSON 提取
        const jsonMatch = content.match(/\[[\s\S]*\]/);
        if (!jsonMatch) {
            console.log('AI 未回傳任何新優惠 (或是回應格式不正確)');
            return [];
        }

        let newDeals = JSON.parse(jsonMatch[0]);
        if (!Array.isArray(newDeals)) return [];

        // 整理新優惠
        const processedDeals = newDeals.map((deal, index) => ({
            id: deal.id || `new_deal_${Date.now()}_${index}`,
            title: deal.title || '未命名優惠',
            description: deal.description || '',
            merchantName: deal.merchantName || '未知店家',
            merchantType: deal.merchantType || '其他',
            startDate: deal.startDate || new Date().toISOString(),
            endDate: deal.endDate || new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(),
            tags: Array.isArray(deal.tags) ? deal.tags : [],
            sourceUrl: deal.sourceUrl || '',
            imageUrl: deal.imageUrl || null,
            fetchedAt: new Date().toISOString()
        }));

        // 合併回原本的資料
        const allDeals = [...existingDeals, ...processedDeals];

        // 儲存結果
        const outputPath = path.join(__dirname, 'deals_output.json');
        fs.writeFileSync(outputPath, JSON.stringify(allDeals, null, 2), 'utf8');

        console.log(`✅ 抓取結束。新增: ${processedDeals.length} 筆，總計: ${allDeals.length} 筆`);

        return allDeals;
    } catch (error) {
        console.error('API 錯誤:', error.message);
        return existingDeals; // 出錯時保留原本的
    }
}

// 匯出函式
module.exports = {
    fetchDeals
};

// 如果直接執行此腳本 (node fetch_deals.js)
if (require.main === module) {
    const filePath = path.join(__dirname, 'deals_output.json');
    let existing = [];
    if (fs.existsSync(filePath)) {
        existing = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    }
    fetchDeals(existing);
}

