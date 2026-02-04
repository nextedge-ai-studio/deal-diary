const axios = require('axios');
require('dotenv').config();

const API_KEY = process.env.PERPLEXITY_API_KEY;

async function testDeduplication() {
    if (!API_KEY) {
        console.error('API_KEY missing');
        return;
    }

    const fs = require('fs');
    const path = require('path');
    const filePath = path.join(__dirname, 'deals_output.json');
    let existingDeals = [];
    if (fs.existsSync(filePath)) {
        existingDeals = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    }

    console.log(`--- 真實資料去重測試 (現有 ${existingDeals.length} 筆) ---`);

    try {
        const response = await axios.post(
            'https://api.perplexity.ai/chat/completions',
            {
                model: 'sonar',
                messages: [
                    {
                        role: 'system',
                        content: `你是一個專業的台灣零售優惠去重助手。
請搜尋台灣店家 2026/02 的新優惠，但必須排除與以下內容語義重複的活動：
${existingDeals.map(d => `- [${d.merchantName}] ${d.title}`).join('\n')}

回傳規則：
1. 絕不回傳與上述清單相似的活動。
2. 即使標題寫法略有不同（例如「買一送一」變「買 1 送 1」）也要排除。
3. 只回傳「全新」的活動。
4. 只回傳 JSON 陣列。`
                    },
                    {
                        role: 'user',
                        content: "請搜尋新的台灣店家優惠，包含餐飲、速食、美妝等名單外內容。"
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
        console.log('\n--- AI 發現的新優惠 (已排除舊資料) ---');
        console.log(content);

        const deals = JSON.parse(content.match(/\[[\s\S]*\]/)?.[0] || '[]');
        console.log(`\n結果數量: ${deals.length}`);
        deals.forEach(d => console.log(`- [${d.merchantName}] ${d.title}`));

    } catch (error) {
        console.error('測試失敗:', error.message);
    }
}

testDeduplication();
