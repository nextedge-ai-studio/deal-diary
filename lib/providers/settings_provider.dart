import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';

/// 應用設定 Provider
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

class AppSettings {
  final bool notificationsEnabled;
  final int notificationHour;
  final int notificationMinute;
  final Set<String> notificationDealIds;
  final Set<String> selectedMerchantCategories;
  final Set<String> selectedDealCategories;

  const AppSettings({
    this.notificationsEnabled = true,
    this.notificationHour = 9,
    this.notificationMinute = 0,
    this.notificationDealIds = const {},
    this.selectedMerchantCategories = const {},
    this.selectedDealCategories = const {},
  });

  AppSettings copyWith({
    bool? notificationsEnabled,
    int? notificationHour,
    int? notificationMinute,
    Set<String>? notificationDealIds,
    Set<String>? selectedMerchantCategories,
    Set<String>? selectedDealCategories,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
      notificationDealIds: notificationDealIds ?? this.notificationDealIds,
      selectedMerchantCategories:
          selectedMerchantCategories ?? this.selectedMerchantCategories,
      selectedDealCategories:
          selectedDealCategories ?? this.selectedDealCategories,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  Box? _box;

  Future<void> _loadSettings() async {
    _box = await Hive.openBox(AppConstants.settingsBox);
    
    final notificationsEnabled = _box?.get('notificationsEnabled', defaultValue: true) as bool;
    final notificationHour = _box?.get('notificationHour', defaultValue: 9) as int;
    final notificationMinute = _box?.get('notificationMinute', defaultValue: 0) as int;
    final notificationDealIds = (_box?.get('notificationDealIds', defaultValue: <String>[]) as List)
        .cast<String>()
        .toSet();
    final selectedMerchantCategories = (_box?.get('selectedMerchantCategories', defaultValue: <String>[]) as List)
        .cast<String>()
        .toSet();
    final selectedDealCategories = (_box?.get('selectedDealCategories', defaultValue: <String>[]) as List)
        .cast<String>()
        .toSet();
    
    state = AppSettings(
      notificationsEnabled: notificationsEnabled,
      notificationHour: notificationHour,
      notificationMinute: notificationMinute,
      notificationDealIds: notificationDealIds,
      selectedMerchantCategories: selectedMerchantCategories,
      selectedDealCategories: selectedDealCategories,
    );
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _box?.put('notificationsEnabled', enabled);
  }

  Future<void> setNotificationTime(int hour, int minute) async {
    state = state.copyWith(
      notificationHour: hour,
      notificationMinute: minute,
    );
    await _box?.put('notificationHour', hour);
    await _box?.put('notificationMinute', minute);
  }

  Future<void> toggleDealNotification(String dealId) async {
    final newIds = {...state.notificationDealIds};
    if (newIds.contains(dealId)) {
      newIds.remove(dealId);
    } else {
      newIds.add(dealId);
    }
    state = state.copyWith(notificationDealIds: newIds);
    await _box?.put('notificationDealIds', newIds.toList());
  }

  Future<void> toggleMerchantCategory(String category) async {
    final newCategories = {...state.selectedMerchantCategories};
    if (newCategories.contains(category)) {
      newCategories.remove(category);
    } else {
      newCategories.add(category);
    }
    state = state.copyWith(selectedMerchantCategories: newCategories);
    await _box?.put('selectedMerchantCategories', newCategories.toList());
  }

  Future<void> toggleDealCategory(String category) async {
    final newCategories = {...state.selectedDealCategories};
    if (newCategories.contains(category)) {
      newCategories.remove(category);
    } else {
      newCategories.add(category);
    }
    state = state.copyWith(selectedDealCategories: newCategories);
    await _box?.put('selectedDealCategories', newCategories.toList());
  }

  bool isDealNotificationEnabled(String dealId) {
    return state.notificationDealIds.contains(dealId);
  }
}

/// 檢查是否開啟特定優惠通知 Provider
final isDealNotificationEnabledProvider = Provider.family<bool, String>((ref, dealId) {
  final settings = ref.watch(settingsProvider);
  return settings.notificationDealIds.contains(dealId);
});
