import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/deals_provider.dart';
import '../../../providers/favorites_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../data/models/deal.dart';
import '../../widgets/widgets.dart';

/// 搜尋頁面
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allDeals = ref.watch(dealsProvider);
    final favorites = ref.watch(favoritesProvider);
    final settings = ref.watch(settingsProvider);

    // 過濾搜尋結果
    final filteredDeals = _searchQuery.isEmpty
        ? <Deal>[]
        : allDeals.where((deal) {
            final query = _searchQuery.toLowerCase();
            return deal.title.toLowerCase().contains(query) ||
                deal.merchantName.toLowerCase().contains(query) ||
                (deal.description?.toLowerCase().contains(query) ?? false) ||
                deal.categories.any((c) => c.toLowerCase().contains(query));
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _buildSearchField(),
        titleSpacing: 0,
      ),
      body: _searchQuery.isEmpty
          ? _buildInitialState()
          : filteredDeals.isEmpty
              ? _buildEmptyState()
              : _buildSearchResults(filteredDeals, favorites, settings),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(right: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: '搜尋優惠、商家...',
          hintStyle: AppTextStyles.body,
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            '搜尋優惠',
            style: AppTextStyles.title.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '輸入關鍵字搜尋優惠或商家',
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            '找不到結果',
            style: AppTextStyles.title.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '試試其他關鍵字',
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(
    List<Deal> deals,
    Set<String> favorites,
    AppSettings settings,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
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
    );
  }
}
