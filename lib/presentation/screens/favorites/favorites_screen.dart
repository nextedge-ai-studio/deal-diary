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

/// 收藏頁面
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final allDeals = ref.watch(dealsProvider);
    final settings = ref.watch(settingsProvider);

    // 篩選出收藏的優惠
    final favoriteDeals = allDeals.where((deal) => favoriteIds.contains(deal.id)).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text('我的收藏', style: AppTextStyles.headline),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: favoriteDeals.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              itemCount: favoriteDeals.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final deal = favoriteDeals[index];
                final notificationEnabled =
                    settings.notificationDealIds.contains(deal.id);

                return DealCard(
                  deal: deal,
                  isFavorite: true,
                  notificationEnabled: notificationEnabled,
                  onTap: () {
                    // TODO: 導航到詳情頁
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
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            '尚無收藏',
            style: AppTextStyles.title.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '點擊優惠卡片的愛心圖示來收藏',
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}
