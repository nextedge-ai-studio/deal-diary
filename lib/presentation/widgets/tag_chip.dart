import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';

/// 標籤 Chip 元件
class TagChip extends StatelessWidget {
  final String label;
  final bool isHighlighted;
  final bool isSelected;
  final VoidCallback? onTap;

  const TagChip({
    super.key,
    required this.label,
    this.isHighlighted = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(AppConstants.radiusTag),
          border: isSelected
              ? Border.all(color: AppColors.textPrimary, width: 1)
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: _getTextColor(),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isHighlighted) {
      return AppColors.tagHighlight;
    }
    return AppColors.tagBackground;
  }

  Color _getTextColor() {
    return AppColors.textPrimary;
  }
}

/// 可選擇的篩選標籤
class DealFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const DealFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusButton),
          border: isSelected
              ? null
              : Border.all(color: AppColors.textPrimary, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            letterSpacing: -0.43,
            color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
