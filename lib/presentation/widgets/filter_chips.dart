import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import 'tag_chip.dart';

/// 篩選器元件 - 顯示可選擇的篩選標籤
class FilterChipsRow extends StatelessWidget {
  final List<String> filters;
  final String? selectedFilter;
  final ValueChanged<String?> onFilterSelected;
  final bool showAll;

  const FilterChipsRow({
    super.key,
    required this.filters,
    this.selectedFilter,
    required this.onFilterSelected,
    this.showAll = true,
  });

  @override
  Widget build(BuildContext context) {
    final allFilters = showAll ? ['全部', ...filters] : filters;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
      child: Row(
        children: allFilters.map((filter) {
          final isSelected = (filter == '全部' && selectedFilter == null) ||
              filter == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: DealFilterChip(
              label: filter,
              isSelected: isSelected,
              onTap: () {
                if (filter == '全部') {
                  onFilterSelected(null);
                } else {
                  onFilterSelected(filter == selectedFilter ? null : filter);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 類別篩選器
class CategoryFilter extends StatelessWidget {
  final List<String> merchantCategories;
  final List<String> dealCategories;
  final String? selectedMerchantCategory;
  final String? selectedDealCategory;
  final ValueChanged<String?> onMerchantCategorySelected;
  final ValueChanged<String?> onDealCategorySelected;

  const CategoryFilter({
    super.key,
    required this.merchantCategories,
    required this.dealCategories,
    this.selectedMerchantCategory,
    this.selectedDealCategory,
    required this.onMerchantCategorySelected,
    required this.onDealCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 商家類別
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: AppConstants.spacingSm,
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '商家類別',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: merchantCategories.map((category) {
                  return DealFilterChip(
                    label: category,
                    isSelected: category == selectedMerchantCategory,
                    onTap: () {
                      onMerchantCategorySelected(
                        category == selectedMerchantCategory ? null : category,
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 優惠類別
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: AppConstants.spacingSm,
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '優惠類別',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: dealCategories.map((category) {
                  return DealFilterChip(
                    label: category,
                    isSelected: category == selectedDealCategory,
                    onTap: () {
                      onDealCategorySelected(
                        category == selectedDealCategory ? null : category,
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
