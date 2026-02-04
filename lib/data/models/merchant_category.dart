/// 商家類型
enum MerchantCategory {
  convenienceStore, // 便利商店
  fastFood, // 速食
  cafe, // 咖啡
  restaurant, // 餐廳
  supermarket, // 超市
  delivery, // 外送平台
  other; // 其他

  /// 取得中文名稱
  String get displayName {
    switch (this) {
      case MerchantCategory.convenienceStore:
        return '便利商店';
      case MerchantCategory.fastFood:
        return '速食';
      case MerchantCategory.cafe:
        return '咖啡';
      case MerchantCategory.restaurant:
        return '餐廳';
      case MerchantCategory.supermarket:
        return '超市';
      case MerchantCategory.delivery:
        return '外送平台';
      case MerchantCategory.other:
        return '其他';
    }
  }

  /// 取得圖示名稱
  String get iconName {
    switch (this) {
      case MerchantCategory.convenienceStore:
        return 'store';
      case MerchantCategory.fastFood:
        return 'utensils';
      case MerchantCategory.cafe:
        return 'coffee';
      case MerchantCategory.restaurant:
        return 'chef-hat';
      case MerchantCategory.supermarket:
        return 'shopping-cart';
      case MerchantCategory.delivery:
        return 'bike';
      case MerchantCategory.other:
        return 'tag';
    }
  }

  /// 從字串轉換
  static MerchantCategory fromString(String value) {
    return MerchantCategory.values.firstWhere(
      (e) => e.name == value || e.displayName == value,
      orElse: () => MerchantCategory.other,
    );
  }
}
