import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/deal.dart';
import '../data/mock/mock_data.dart';

/// 從 Firebase Firestore 獲取優惠資料的 FutureProvider
final dealsListProvider = FutureProvider<List<Deal>>((ref) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('deals')
        .orderBy('updatedAt', descending: true)
        .get();
    
    if (snapshot.docs.isEmpty) {
      print('Firestore 中目前沒有優惠資料');
      return [];
    }
    
    return snapshot.docs.map((doc) {
      try {
        final data = doc.data();
        // 確保 ID 也有包括在內
        data['id'] = doc.id;
        return Deal.fromJson(data);
      } catch (e) {
        print('解析單筆優惠失敗: $e, Doc ID: ${doc.id}');
        return null;
      }
    }).whereType<Deal>().toList();
    
  } catch (e, stack) {
    print('獲取 Firestore 資料失敗: $e');
    print('錯誤堆疊: $stack');
    // 發生錯誤時先回傳 Mock 資料，讓 UI 不會空白
    return MockData.getDeals();
  }
});

/// 所有優惠資料 Provider (同步獲取最新資料，主要為了簡化 UI 連接)
final dealsProvider = Provider<List<Deal>>((ref) {
  final asyncDeals = ref.watch(dealsListProvider);
  return asyncDeals.maybeWhen(
    data: (deals) => deals,
    orElse: () => MockData.getDeals(), // 載入中或失敗時顯示 Mock 資料
  );
});

/// 選擇的日期 Provider
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

/// 指定日期的優惠 Provider
final dealsForDateProvider = Provider<List<Deal>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  final allDeals = ref.watch(dealsProvider);
  
  return allDeals.where((deal) => deal.isValidOn(selectedDate)).toList();
});

/// 篩選後的優惠 Provider
final filteredDealsProvider = Provider<List<Deal>>((ref) {
  final deals = ref.watch(dealsForDateProvider);
  final filter = ref.watch(selectedFilterProvider);
  
  if (filter == null) {
    return deals;
  }
  
  return deals.where((deal) {
    return deal.categories.contains(filter) ||
           deal.merchantName.contains(filter);
  }).toList();
});

/// 選擇的篩選條件 Provider
final selectedFilterProvider = StateProvider<String?>((ref) {
  return null;
});

/// 有優惠的日期集合 Provider
final datesWithDealsProvider = Provider<Set<DateTime>>((ref) {
  final allDeals = ref.watch(dealsProvider);
  final dates = <DateTime>{};
  
  for (final deal in allDeals) {
    var date = deal.startDate;
    // 限制處理範圍，避免無限循環或過多計算
    final endDate = deal.endDate;
    while (!date.isAfter(endDate)) {
      dates.add(DateTime(date.year, date.month, date.day));
      date = date.add(const Duration(days: 1));
      // 安全機制：如果優惠超過 100 天則停止，防止異常數據
      if (date.difference(deal.startDate).inDays > 100) break;
    }
  }
  
  return dates;
});
