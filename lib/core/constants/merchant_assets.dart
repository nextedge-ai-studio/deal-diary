/// 商家的本地圖標資產
/// 由使用者手動下載並整理於 assets/icons/
class MerchantAssets {
  static const String _path = 'assets/icons/';

  static const Map<String, String> localLogos = {
    // 便利商店
    '7-ELEVEN': '7-eleven.svg',
    '7-11': '7-eleven.svg',
    '全家': '全家.png',
    '萊爾富': '萊爾富.png',
    'OK MART': 'OK_Mart.png',
    'OKMART': 'OK_Mart.png',

    // 速食
    '麥當勞': 'mcdonalds.svg',
    '肯德基': '肯德基.png',
    '漢堡王': '漢堡王.png',

    // 咖啡
    '星巴克': 'starbucks.svg',
    'STARBUCKS': 'starbucks.svg',
    '路易莎': '路易莎.png',

    // 超市
    '全聯': '全聯.png',
    '家樂福': '家樂福.png',
  };

  /// 獲取本地 Asset 路徑
  static String? getAssetPath(String merchantName) {
    if (merchantName.isEmpty) return null;
    final name = merchantName.toUpperCase().trim();

    // 1. 精確匹配
    if (localLogos.containsKey(name)) {
      return '$_path${localLogos[name]}';
    }

    // 2. 模糊匹配 (包含與被包含)
    for (var entry in localLogos.entries) {
      if (name.contains(entry.key) || entry.key.contains(name)) {
        return '$_path${entry.value}';
      }
    }

    return null;
  }
}
