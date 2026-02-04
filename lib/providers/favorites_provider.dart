import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';

/// 收藏的優惠 ID 集合 Provider
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({}) {
    _loadFavorites();
  }

  Box<String>? _box;

  Future<void> _loadFavorites() async {
    _box = await Hive.openBox<String>(AppConstants.favoritesBox);
    state = _box!.values.toSet();
  }

  Future<void> toggleFavorite(String dealId) async {
    if (state.contains(dealId)) {
      await removeFavorite(dealId);
    } else {
      await addFavorite(dealId);
    }
  }

  Future<void> addFavorite(String dealId) async {
    state = {...state, dealId};
    await _box?.put(dealId, dealId);
  }

  Future<void> removeFavorite(String dealId) async {
    state = state.where((id) => id != dealId).toSet();
    await _box?.delete(dealId);
  }

  bool isFavorite(String dealId) {
    return state.contains(dealId);
  }
}

/// 檢查是否為收藏 Provider
final isFavoriteProvider = Provider.family<bool, String>((ref, dealId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.contains(dealId);
});
