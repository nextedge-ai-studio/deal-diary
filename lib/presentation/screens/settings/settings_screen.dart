import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/settings_provider.dart';

/// 設定頁面 - 優惠設定
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          '優惠設定',
          style: AppTextStyles.headline.copyWith(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 系統通知
            _buildNotificationToggle(ref, settings),
            const SizedBox(height: 32),
            // 商家類型
            _buildMerchantCategories(ref, settings),
            const SizedBox(height: 32),
            // 優惠類型
            _buildDealCategories(ref, settings),
            const SizedBox(height: 48),
            // 版權資訊
            _buildCopyright(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(WidgetRef ref, AppSettings settings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '系統通知',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        // 自定義 Switch 以符合 Figma 樣式
        GestureDetector(
          onTap: () {
            ref.read(settingsProvider.notifier).setNotificationsEnabled(!settings.notificationsEnabled);
          },
          child: Container(
            width: 50,
            height: 28,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: settings.notificationsEnabled ? AppColors.textPrimary : Colors.black.withAlpha(50),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: settings.notificationsEnabled ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMerchantCategories(WidgetRef ref, AppSettings settings) {
    final categories = [
      '便利商店',
      '咖啡飲料',
      '連鎖餐廳',
      '超市賣場',
      '外送平台',
      '電商平台',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '商家類型',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: categories.map((category) {
            final isSelected = settings.selectedMerchantCategories.contains(category);
            return _SettingsChip(
              label: category,
              isSelected: isSelected,
              onTap: () {
                ref.read(settingsProvider.notifier).toggleMerchantCategory(category);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDealCategories(WidgetRef ref, AppSettings settings) {
    final categories = [
      '買一送一',
      '買二送二',
      '第二件折扣',
      '限定促銷',
      '小編推薦',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '優惠類型',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: categories.map((category) {
            final isSelected = settings.selectedDealCategories.contains(category);
            return _SettingsChip(
              label: category,
              isSelected: isSelected,
              onTap: () {
                ref.read(settingsProvider.notifier).toggleDealCategory(category);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCopyright() {
    return const Center(
      child: Text(
        '© Copyright 2025. All Rights Reserved Snag',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _SettingsChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SettingsChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(1000),
          border: Border.all(
            color: AppColors.textPrimary,
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
