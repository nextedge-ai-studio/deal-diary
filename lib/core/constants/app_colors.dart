import 'package:flutter/material.dart';

/// 優惠日記 App 色彩系統
class AppColors {
  AppColors._();

  // 主色
  static const Color primary = Color(0xFFFFCC00);
  static const Color primaryLight = Color(0xFFFFE13C);
  static const Color primaryDark = Color(0xFFE6B800);

  // 背景色
  static const Color background = Color(0xFFF4F1EC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF4F1EC);

  // 文字色
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF989898);
  static const Color textDisabled = Color(0xFFD6D3D3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // 標籤色
  static const Color tagBackground = Color(0xFFF1F1F1);
  static const Color tagHighlight = Color(0x66FFCC00); // 40% opacity
  static const Color tagBorder = Color(0xFFEDEDED);

  // 功能色
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF52A6FF);

  // 邊框與分隔線
  static const Color border = Color(0xFFEDEDED);
  static const Color divider = Color(0xFFF2F2F2);

  // 日期選擇器
  static const Color dateSelected = Color(0xFFFFCC00);
  static const Color dateToday = Color(0xFF000000);
  static const Color dateFuture = Color(0xFF000000);
  static const Color datePast = Color(0xFFD6D3D3);
  static const Color dateHasDeals = Color(0xFFFFCC00);

  // 漸層
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFE13C),
      Color(0xFFF4F1EC),
    ],
    stops: [0.1376, 0.5752],
  );
}
