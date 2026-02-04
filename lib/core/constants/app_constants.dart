/// 優惠日記 App 常數
class AppConstants {
  AppConstants._();

  // App 資訊
  static const String appName = '優惠日記';
  static const String appVersion = '1.0.0';

  // 圓角
  static const double radiusCard = 20.0;
  static const double radiusTag = 8.0;
  static const double radiusButton = 1000.0; // pill shape
  static const double radiusDateButton = 34.0;
  static const double radiusSmall = 10.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 20.0;

  // 間距
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 40.0;

  // 日期選擇器
  static const double dateButtonSize = 42.0;
  static const int calendarDaysToShow = 7;

  // 優惠卡片
  static const double cardPadding = 16.0;
  static const double merchantAvatarSize = 48.0;
  static const double actionButtonSize = 24.0;

  // 通知
  static const int notificationHour = 9; // 早上 9 點
  static const int notificationMinute = 0;
  static const int reminderDaysBefore = 1; // 到期前一天提醒

  // API
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheExpiry = Duration(hours: 6);

  // Hive Box Names
  static const String dealsBox = 'deals';
  static const String favoritesBox = 'favorites';
  static const String settingsBox = 'settings';
  static const String cacheBox = 'cache';
}
