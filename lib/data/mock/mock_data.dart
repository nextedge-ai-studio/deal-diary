import '../models/deal.dart';

class MockData {
  static List<Deal> getDeals() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return [
      Deal(
        id: '1',
        title: '超值五六日 CITY CAFE 大杯燕麥拿鐵買一送一',
        description: '限時三天！大杯燕麥拿鐵買一送一，趕快來 7-ELEVEN 補貨',
        merchantId: 'm1',
        merchantName: '7-ELEVEN',
        merchantLogo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/7-eleven_logo.svg/1200px-7-eleven_logo.svg.png',
        startDate: today,
        endDate: today.add(const Duration(days: 2)),
        categories: ['超級好康', '咖啡飲料', '買一送一'],
      ),
      Deal(
        id: '2',
        title: '麥當勞會員日｜咔啦雞腿堡買1送1',
        description: '麥當勞會員日限時優惠，咔啦雞腿堡買1送1，特價 95 元',
        merchantId: 'm2',
        merchantName: '麥當勞',
        merchantLogo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/McDonald%27s_Golden_Arches.svg/1200px-McDonald%27s_Golden_Arches.svg.png',
        startDate: today.subtract(const Duration(days: 1)),
        endDate: today.add(const Duration(days: 1)),
        categories: ['速食餐飲', '買一送一'],
      ),
      Deal(
        id: '3',
        title: '星巴克｜好友分享日大杯飲品買一送一',
        description: '全台門市通用（部分門市除外），指定飲品買一送一',
        merchantId: 'm3',
        merchantName: '星巴克',
        merchantLogo: 'https://upload.wikimedia.org/wikipedia/en/thumb/d/d3/Starbucks_Corporation_Logo_2011.svg/1200px-Starbucks_Corporation_Logo_2011.svg.png',
        startDate: today,
        endDate: today.add(const Duration(days: 5)),
        categories: ['超級好康', '咖啡飲料', '買一送一'],
      ),
      Deal(
        id: '4',
        title: '小編推薦｜全能維他命C穀胱甘肽透亮面膜',
        description: '使用過超級好用，已經長期使用半年了，最近剛好有活動可以考慮囤貨買五送五活動三天',
        merchantId: 'm4',
        merchantName: '小編推薦',
        merchantLogo: 'https://api.dicebear.com/7.x/avataaars/png?seed=Felix', // 使用穩定的頭像 API
        startDate: today,
        endDate: today.add(const Duration(days: 10)),
        categories: ['小編推薦', '美妝保養'],
        imageUrl: 'https://images.unsplash.com/photo-1590156221122-c4464d1669a2?q=80&w=800&auto=format&fit=crop', // 使用穩定的 Unsplash 圖片
      ),
    ];
  }
}
