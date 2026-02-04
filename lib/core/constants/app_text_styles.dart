import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// 優惠日記 App 文字樣式系統
class AppTextStyles {
  AppTextStyles._();

  // 標題樣式
  static TextStyle get headline => GoogleFonts.inter(
        fontWeight: FontWeight.w800,
        fontSize: 24,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => GoogleFonts.inter(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: AppColors.textPrimary,
      );

  // 標題
  static TextStyle get title => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 17,
        letterSpacing: -0.43,
        height: 1.29,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: -0.31,
        height: 1.31,
        color: AppColors.textPrimary,
      );

  // 內文
  static TextStyle get body => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 11,
        letterSpacing: 0.06,
        height: 1.18,
        color: AppColors.textSecondary,
      );

  // 標籤
  static TextStyle get caption => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 11,
        letterSpacing: 0.06,
        height: 1.18,
        color: AppColors.textPrimary,
      );

  static TextStyle get captionLight => const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 11,
        letterSpacing: 0.06,
        height: 1.18,
        color: AppColors.textSecondary,
      );

  // 按鈕
  static TextStyle get button => const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: -0.43,
        height: 1.57,
        color: AppColors.textOnPrimary,
      );

  static TextStyle get buttonOutlined => const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: -0.43,
        height: 1.57,
        color: AppColors.textPrimary,
      );

  // 日期
  static TextStyle get dateNumber => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: AppColors.textPrimary,
      );

  static TextStyle get dateLabel => GoogleFonts.inter(
        fontWeight: FontWeight.w800,
        fontSize: 16,
        color: AppColors.textPrimary,
      );

  // 價格
  static TextStyle get price => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 17,
        letterSpacing: -0.43,
        height: 1.29,
        color: Color(0xFFC4A383),
      );

  // 連結
  static TextStyle get link => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColors.info,
      );
}
