import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/deals_provider.dart';
import '../../../providers/favorites_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/widgets.dart';
import '../settings/settings_screen.dart';
import '../favorites/favorites_screen.dart';
import '../deal_detail/deal_detail_screen.dart';

/// 首頁 - 優惠日記主頁面 (符合 Figma 設計)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 頂部黃色區域
          Container(
            height: 200,
            color: AppColors.primary,
          ),
          SafeArea(
            child: Column(
              children: [
                // 頂部標題與圖示
                _buildHeader(context),
                
                // 內容區域
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMd,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // 日曆選擇器卡片
                        _buildCalendar(ref),
                        const SizedBox(height: 24),
                        // 優惠列表
                        _buildDealsList(ref),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '優惠日記',
            style: AppTextStyles.headline.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, size: 28),
                onPressed: () {
                  // 暫時導向收藏頁面作為通知功能的替代展示
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, size: 28),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final datesWithDeals = ref.watch(datesWithDealsProvider);

    return CalendarStrip(
      selectedDate: selectedDate,
      datesWithDeals: datesWithDeals,
      onDateSelected: (date) {
        ref.read(selectedDateProvider.notifier).state = date;
      },
    );
  }

  Widget _buildDealsList(WidgetRef ref) {
    final deals = ref.watch(dealsForDateProvider); // 不使用過濾器以符合展示
    final favorites = ref.watch(favoritesProvider);
    final settings = ref.watch(settingsProvider);

    if (deals.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: deals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final deal = deals[index];
        final isFavorite = favorites.contains(deal.id);
        final notificationEnabled = settings.notificationDealIds.contains(deal.id);

        return DealCard(
          deal: deal,
          isFavorite: isFavorite,
          notificationEnabled: notificationEnabled,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DealDetailScreen(deal: deal),
              ),
            );
          },
          onFavoriteTap: () {
            ref.read(favoritesProvider.notifier).toggleFavorite(deal.id);
          },
          onShareTap: () {
            Share.share(
              '${deal.title}\n${deal.description ?? ""}\n來自優惠日記 App',
              subject: deal.title,
            );
          },
          onNotificationTap: () {
            ref.read(settingsProvider.notifier).toggleDealNotification(deal.id);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            const Icon(Icons.local_offer_outlined, size: 64, color: AppColors.textDisabled),
            const SizedBox(height: 16),
            Text('當天暫無優惠', style: AppTextStyles.title.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
