import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';

/// 日曆橫列元件 (符合 Figma 設計)
class CalendarStrip extends StatelessWidget {
  final DateTime selectedDate;
  final Set<DateTime> datesWithDeals;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarStrip({
    super.key,
    required this.selectedDate,
    required this.datesWithDeals,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    // 取得當前週的日期
    final List<DateTime> weekDates = _getWeekDates(selectedDate);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 頂部日期與導航
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('yyyy/MM/dd').format(selectedDate),
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20),
                    onPressed: () => onDateSelected(selectedDate.subtract(const Duration(days: 7))),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20),
                    onPressed: () => onDateSelected(selectedDate.add(const Duration(days: 7))),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 日期橫列
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDates.map((date) => _buildDateItem(date)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(DateTime date) {
    final isSelected = _isSameDay(date, selectedDate);
    final hasDeals = datesWithDeals.any((d) => _isSameDay(d, date));

    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppColors.textPrimary
                    : (hasDeals || _isToday(date))
                        ? AppColors.primary
                        : AppColors.textPrimary.withAlpha(50),
              ),
            ),
          ),
          if (hasDeals && !isSelected) ...[
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<DateTime> _getWeekDates(DateTime date) {
    // 假設一週從週日開始 (符合常見日曆)
    final dayOfWeek = date.weekday % 7;
    final sunday = date.subtract(Duration(days: dayOfWeek));
    return List.generate(7, (index) => sunday.add(Duration(days: index)));
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }
}
