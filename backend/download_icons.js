const axios = require('axios');
const fs = require('fs');
const path = require('path');

const iconsDir = path.join(__dirname, '../assets/icons');

const merchants = [
    { name: '7-eleven', domain: '7-11.com.tw' },
    { name: 'familymart', domain: 'family.com.tw' },
    { name: 'hilife', domain: 'hilife.com.tw' },
    { name: 'okmart', domain: 'okmart.com.tw' },
    { name: 'mcdonalds', domain: 'mcdonalds.com.tw' },
    { name: 'kfc', domain: 'kfcclub.com.tw' },
    { name: 'burgerking', domain: 'burgerking.com.tw' },
    { name: 'starbucks', domain: 'starbucks.com.tw' },
    { name: 'pxmart', domain: 'pxmart.com.tw' },
    { name: 'carrefour', domain: 'carrefour.com.tw' }
];

async function downloadIcons() {
    if (!fs.existsSync(iconsDir)) {
        fs.mkdirSync(iconsDir, { recursive: true });
    }

    for (const m of merchants) {
        const filePath = path.join(iconsDir, `${m.name}.png`);
        const url = `https://logo.clearbit.com/${m.domain}`;
        console.log(`Downloading ${m.name} logo from ${url}...`);
        try {
            const response = await axios({
                url: url,
                method: 'GET',
                responseType: 'stream'
            });
            const writer = fs.createWriteStream(filePath);
            response.data.pipe(writer);
            await new Promise((resolve, reject) => {
                writer.on('finish', resolve);
                writer.on('error', reject);
            });
            console.log(`Saved ${m.name}.png`);
        } catch (error) {
            console.error(`Failed ${m.name}: ${error.message}`);
        }
    }
}

downloadIcons();
