/// 優惠資料模型
class Deal {
  final String id;
  final String title;
  final String? description;
  final String merchantId;
  final String merchantName;
  final String? merchantLogo;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> categories;
  final String? sourceUrl;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Deal({
    required this.id,
    required this.title,
    this.description,
    required this.merchantId,
    required this.merchantName,
    this.merchantLogo,
    required this.startDate,
    required this.endDate,
    required this.categories,
    this.sourceUrl,
    this.imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// 檢查優惠是否在指定日期有效
  bool isValidOn(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final startOnly = DateTime(startDate.year, startDate.month, startDate.day);
    final endOnly = DateTime(endDate.year, endDate.month, endDate.day);
    return !dateOnly.isBefore(startOnly) && !dateOnly.isAfter(endOnly);
  }

  /// 檢查優惠是否已過期
  bool get isExpired {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endOnly = DateTime(endDate.year, endDate.month, endDate.day);
    return today.isAfter(endOnly);
  }

  /// 檢查優惠是否即將到期（剩餘天數）
  int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endOnly = DateTime(endDate.year, endDate.month, endDate.day);
    return endOnly.difference(today).inDays;
  }

  /// 從 JSON 或 Firestore Map 建立 (支援 String 和 Timestamp 類型)
  factory Deal.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value, DateTime defaultValue) {
      if (value == null) return defaultValue;
      if (value is String) return DateTime.tryParse(value) ?? defaultValue;
      // 處理 Firestore 的 Timestamp 類型
      try {
        if (value.runtimeType.toString() == 'Timestamp') {
          return (value as dynamic).toDate();
        }
      } catch (_) {}
      return defaultValue;
    }

    return Deal(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '無標題').toString(),
      description: json['description']?.toString(),
      merchantId: (json['merchantId'] ?? json['merchantName'] ?? 'unknown').toString(),
      merchantName: (json['merchantName'] ?? '未知商家').toString(),
      merchantLogo: json['merchantLogo']?.toString(),
      startDate: parseDate(json['startDate'], DateTime.now()),
      endDate: parseDate(json['endDate'], DateTime.now().add(const Duration(days: 7))),
      categories: json['categories'] != null 
          ? List<String>.from((json['categories'] as List).map((e) => e.toString()))
          : [],
      sourceUrl: json['sourceUrl']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      createdAt: json['createdAt'] != null
          ? parseDate(json['createdAt'], DateTime.now())
          : null,
      updatedAt: json['updatedAt'] != null
          ? parseDate(json['updatedAt'], DateTime.now())
          : null,
    );
  }

  /// 轉換為 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'merchantId': merchantId,
      'merchantName': merchantName,
      'merchantLogo': merchantLogo,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'categories': categories,
      'sourceUrl': sourceUrl,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// 複製並修改
  Deal copyWith({
    String? id,
    String? title,
    String? description,
    String? merchantId,
    String? merchantName,
    String? merchantLogo,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? categories,
    String? sourceUrl,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Deal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      merchantId: merchantId ?? this.merchantId,
      merchantName: merchantName ?? this.merchantName,
      merchantLogo: merchantLogo ?? this.merchantLogo,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categories: categories ?? this.categories,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Deal(id: $id, title: $title, merchant: $merchantName)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Deal && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
