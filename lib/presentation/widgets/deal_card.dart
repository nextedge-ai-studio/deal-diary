import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/merchant_assets.dart';
import '../../data/models/deal.dart';
import 'merchant_avatar.dart';
import 'tag_chip.dart';

/// 優惠卡片元件 (符合 Figma 設計)
class DealCard extends StatelessWidget {
  final Deal deal;
  final bool isFavorite;
  final bool notificationEnabled;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onNotificationTap;

  const DealCard({
    super.key,
    required this.deal,
    this.isFavorite = false,
    this.notificationEnabled = false,
    this.onTap,
    this.onFavoriteTap,
    this.onShareTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppConstants.radiusCard * 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 頂部標籤
            Wrap(
              spacing: 6,
              children: deal.categories.map((cat) => _buildMiniTag(cat)).toList(),
            ),
            const SizedBox(height: 12),
            
            // 中間內容：圓形 Logo + 文字
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MerchantAvatar(
                  logoUrl: deal.merchantLogo,
                  merchantName: deal.merchantName,
                  size: 48,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${deal.merchantName}｜${deal.title}',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            _formatDateRange(),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      if (deal.imageUrl != null) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: deal.imageUrl!.startsWith('http') 
                                ? 'https://images.weserv.nl/?url=${deal.imageUrl!.replaceFirst('https://', '').replaceFirst('http://', '')}&w=800'
                                : deal.imageUrl!,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 180,
                              color: AppColors.tagBackground,
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 180,
                              color: AppColors.tagBackground,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_not_supported_outlined, color: AppColors.textSecondary.withAlpha(100), size: 40),
                                  const SizedBox(height: 8),
                                  Text('圖片載入失敗', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            
            // 底部按鈕
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : AppColors.textPrimary,
                    size: 20,
                  ),
                  onPressed: onFavoriteTap,
                ),
                IconButton(
                  icon: const Icon(Icons.ios_share, size: 20),
                  onPressed: onShareTap,
                ),
                IconButton(
                  icon: Icon(
                    deal.imageUrl != null 
                      ? Icons.chat_bubble_outline 
                      : (notificationEnabled ? Icons.notifications : Icons.notifications_none),
                    color: (deal.imageUrl == null && notificationEnabled) ? AppColors.primary : AppColors.textPrimary,
                    size: 20,
                  ),
                  onPressed: onNotificationTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniTag(String label) {
    bool isHighlight = label == '超級好康' || label == '買一送一';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isHighlight ? AppColors.primary.withAlpha(40) : Colors.grey.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary.withAlpha(200),
        ),
      ),
    );
  }

  String _formatDateRange() {
    return '${deal.startDate.month}/${deal.startDate.day}-${deal.endDate.month}/${deal.endDate.day}';
  }
}
