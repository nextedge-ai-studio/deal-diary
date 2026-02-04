/// 優惠類型
enum DealCategory {
  buyOneGetOne, // 買一送一
  discount, // 折扣
  freebie, // 贈品
  combo, // 套餐優惠
  limitedTime, // 限時優惠
  memberOnly, // 會員專屬
  delivery, // 外送優惠
  other; // 其他

  /// 取得中文名稱
  String get displayName {
    switch (this) {
      case DealCategory.buyOneGetOne:
        return '買一送一';
      case DealCategory.discount:
        return '折扣';
      case DealCategory.freebie:
        return '贈品';
      case DealCategory.combo:
        return '套餐優惠';
      case DealCategory.limitedTime:
        return '限時優惠';
      case DealCategory.memberOnly:
        return '會員專屬';
      case DealCategory.delivery:
        return '外送優惠';
      case DealCategory.other:
        return '其他';
    }
  }

  /// 取得圖示名稱
  String get iconName {
    switch (this) {
      case DealCategory.buyOneGetOne:
        return 'gift';
      case DealCategory.discount:
        return 'percent';
      case DealCategory.freebie:
        return 'package';
      case DealCategory.combo:
        return 'layers';
      case DealCategory.limitedTime:
        return 'clock';
      case DealCategory.memberOnly:
        return 'crown';
      case DealCategory.delivery:
        return 'truck';
      case DealCategory.other:
        return 'tag';
    }
  }

  /// 從字串轉換
  static DealCategory fromString(String value) {
    return DealCategory.values.firstWhere(
      (e) => e.name == value || e.displayName == value,
      orElse: () => DealCategory.other,
    );
  }
}
