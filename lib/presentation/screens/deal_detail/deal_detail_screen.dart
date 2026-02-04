import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/deal.dart';
import '../../../providers/favorites_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../core/constants/merchant_assets.dart';
import '../../widgets/widgets.dart';

/// 優惠詳情頁面
class DealDetailScreen extends ConsumerWidget {
  final Deal deal;

  const DealDetailScreen({super.key, required this.deal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(deal.id));
    final notificationEnabled = ref.watch(isDealNotificationEnabledProvider(deal.id));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          // 頂部圖片 AppBar
          _buildSliverAppBar(context, isFavorite, ref),
          
          // 內容
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 標題與標籤
                  _buildHeader(),
                  const SizedBox(height: 24),
                  
                  // 優惠描述
                  _buildDescriptionSection(),
                  const SizedBox(height: 24),
                  
                  // 商家資訊
                  _buildMerchantSection(),
                  const SizedBox(height: 32),
                  
                  // 分享與通知設定
                  _buildActionButtons(ref, isFavorite, notificationEnabled),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isFavorite, WidgetRef ref) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: FavoriteButton(
              isFavorite: isFavorite,
              onTap: () => ref.read(favoritesProvider.notifier).toggleFavorite(deal.id),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: deal.imageUrl != null
            ? Image.network(
                deal.imageUrl!.startsWith('http')
                    ? 'https://images.weserv.nl/?url=${deal.imageUrl!.replaceFirst('https://', '').replaceFirst('http://', '')}&w=800'
                    : deal.imageUrl!,
                fit: BoxFit.cover,
              )
            : Container(
                color: AppColors.primaryLight,
                child: Center(
                  child: Icon(
                    Icons.local_offer,
                    size: 64,
                    color: AppColors.textPrimary.withAlpha(50),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: deal.categories.map((cat) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TagChip(label: cat, isHighlighted: cat == '買一送一'),
          )).toList(),
        ),
        const SizedBox(height: 16),
        Text(
          deal.title,
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              '優惠期間：${DateFormat('yyyy/MM/dd').format(deal.startDate)} - ${DateFormat('yyyy/MM/dd').format(deal.endDate)}',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('優惠詳情', style: AppTextStyles.titleMedium),
        const SizedBox(height: 8),
        Text(
          deal.description ?? '暫無詳細說明',
          style: AppTextStyles.body.copyWith(height: 1.6),
        ),
      ],
    );
  }

  Widget _buildMerchantSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
      ),
      child: Row(
        children: [
          MerchantAvatar(
            logoUrl: deal.merchantLogo,
            merchantName: deal.merchantName,
            size: 56,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deal.merchantName, style: AppTextStyles.titleMedium),
                const SizedBox(height: 4),
                Text('查看更多該商家優惠', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildActionButtons(WidgetRef ref, bool isFavorite, bool notificationEnabled) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Share.share('${deal.title}\n來自優惠日記 App');
            },
            icon: const Icon(Icons.share, size: 20),
            label: const Text('分享給朋友'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ref.read(settingsProvider.notifier).toggleDealNotification(deal.id);
            },
            icon: Icon(
              notificationEnabled ? Icons.notifications_off : Icons.notifications_active,
              size: 20,
            ),
            label: Text(notificationEnabled ? '取消預約' : '預約優惠'),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    if (deal.sourceUrl == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () async {
            final url = Uri.parse(deal.sourceUrl!);
            try {
              if (await canLaunchUrl(url)) {
                await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              } else {
                debugPrint('無法開啟網址: ${deal.sourceUrl}');
              }
            } catch (e) {
              debugPrint('開啟網頁出錯: $e');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            minimumSize: const Size(double.infinity, 56),
          ),
          child: const Text('前往官方網站 / 領取優惠', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}
