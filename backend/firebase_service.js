const admin = require('firebase-admin');
const crypto = require('crypto');
require('dotenv').config();

let db;

function initializeFirebase() {
    if (admin.apps.length > 0) {
        db = admin.firestore();
        return db;
    }

    const projectId = process.env.FIREBASE_PROJECT_ID;
    const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
    const privateKey = process.env.FIREBASE_PRIVATE_KEY;

    if (!projectId || projectId === 'your_project_id' || !clientEmail || !privateKey) {
        console.warn('Firebase credentials missing in .env. Skip initialization.');
        return null;
    }

    try {
        admin.initializeApp({
            credential: admin.credential.cert({
                projectId: projectId,
                clientEmail: clientEmail,
                privateKey: privateKey.replace(/\\n/g, '\n'),
            }),
        });
        db = admin.firestore();
        console.log('✅ Firebase initialized successfully');
        return db;
    } catch (error) {
        console.error('❌ Firebase initialization failed:', error.message);
        return null;
    }
}

/**
 * 產生確定性的 Hash ID 作為 Firestore 文件 ID
 * 避免重複抓取時產生重複文件
 */
function generateDeterministicId(deal) {
    if (deal.id && !deal.id.startsWith('deal_')) {
        return deal.id; // 如果已經有穩定的 ID 則沿用
    }
    const seed = `${deal.merchantName}_${deal.title}`;
    return crypto.createHash('md5').update(seed).digest('hex');
}

async function syncDealsToFirestore(deals) {
    if (!db) db = initializeFirebase();
    if (!db) throw new Error('Firebase not initialized');

    const collectionName = process.env.FIRESTORE_COLLECTION || 'deals';
    console.log(`--- Syncing ${deals.length} deals to Firestore [${collectionName}] ---`);

    const batch = db.batch();
    const timestamp = admin.firestore.FieldValue.serverTimestamp();

    deals.forEach((deal) => {
        // 使用確定性 Hash ID 以達去重效果
        const stableId = generateDeterministicId(deal);
        const docRef = db.collection(collectionName).doc(stableId);

        batch.set(docRef, {
            ...deal,
            id: stableId, // 更新 deal 物件內的 id 為穩定 ID
            updatedAt: timestamp,
        }, { merge: true });
    });

    await batch.commit();
    console.log('✅ Sync completed successfully (Deduplication enabled)');
    return deals.length;
}

module.exports = {
    initializeFirebase,
    syncDealsToFirestore,
    generateDeterministicId,
    getDb: () => db
};

