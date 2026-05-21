import 'package:grabbit/features/auth/data/models/user_model.dart';
import 'package:grabbit/features/auth/domain/entities/user_entity.dart';
import 'package:grabbit/core/config/request_categories.dart';

class CustomerProfile {
  const CustomerProfile({
    required this.user,
    required this.memberSince,
    required this.stats,
    required this.addresses,
    required this.notificationSettings,
    required this.preferences,
    required this.enabledNotificationCount,
  });

  final UserEntity user;
  final String memberSince;
  final CustomerProfileStats stats;
  final List<CustomerAddress> addresses;
  final CustomerNotificationSettings notificationSettings;
  final CustomerPreferences preferences;
  final int enabledNotificationCount;

  factory CustomerProfile.fromMap(Map<String, dynamic> map) {
    return CustomerProfile(
      user: UserModel.fromMap(
        Map<String, dynamic>.from(map['user'] as Map? ?? const {}),
      ),
      memberSince: map['memberSince'] as String? ?? '',
      stats: CustomerProfileStats.fromMap(
        Map<String, dynamic>.from(map['stats'] as Map? ?? const {}),
      ),
      addresses: (map['addresses'] as List? ?? const [])
          .whereType<Map>()
          .map((item) =>
              CustomerAddress.fromMap(Map<String, dynamic>.from(item)))
          .toList(),
      notificationSettings: CustomerNotificationSettings.fromMap(
        Map<String, dynamic>.from(
          map['notificationSettings'] as Map? ?? const {},
        ),
      ),
      preferences: CustomerPreferences.fromMap(
        Map<String, dynamic>.from(map['preferences'] as Map? ?? const {}),
      ),
      enabledNotificationCount:
          (map['enabledNotificationCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class CustomerProfileStats {
  const CustomerProfileStats({
    required this.totalRequests,
    required this.completedRequests,
    required this.reviewCount,
  });

  final int totalRequests;
  final int completedRequests;
  final int reviewCount;

  factory CustomerProfileStats.fromMap(Map<String, dynamic> map) {
    return CustomerProfileStats(
      totalRequests: (map['totalRequests'] as num?)?.toInt() ?? 0,
      completedRequests: (map['completedRequests'] as num?)?.toInt() ?? 0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class CustomerAddress {
  const CustomerAddress({
    required this.id,
    required this.label,
    required this.addressText,
    required this.city,
    required this.landmark,
    required this.phone,
    required this.isDefault,
  });

  final String id;
  final String label;
  final String addressText;
  final String city;
  final String landmark;
  final String phone;
  final bool isDefault;

  factory CustomerAddress.fromMap(Map<String, dynamic> map) {
    return CustomerAddress(
      id: map['id'] as String? ?? map['_id'] as String? ?? '',
      label: map['label'] as String? ?? 'Home',
      addressText: map['addressText'] as String? ?? '',
      city: map['city'] as String? ?? 'Kathmandu',
      landmark: map['landmark'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'addressText': addressText,
      'city': city,
      'landmark': landmark,
      'phone': phone,
      'isDefault': isDefault,
    };
  }
}

class CustomerNotificationSettings {
  const CustomerNotificationSettings({
    required this.requestResponses,
    required this.chatMessages,
    required this.purchaseUpdates,
    required this.promotions,
  });

  final bool requestResponses;
  final bool chatMessages;
  final bool purchaseUpdates;
  final bool promotions;

  factory CustomerNotificationSettings.fromMap(Map<String, dynamic> map) {
    return CustomerNotificationSettings(
      requestResponses: map['requestResponses'] as bool? ?? true,
      chatMessages: map['chatMessages'] as bool? ?? true,
      purchaseUpdates: map['purchaseUpdates'] as bool? ?? true,
      promotions: map['promotions'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestResponses': requestResponses,
      'chatMessages': chatMessages,
      'purchaseUpdates': purchaseUpdates,
      'promotions': promotions,
    };
  }
}

class CustomerPreferences {
  const CustomerPreferences({
    required this.categories,
    required this.budgetMin,
    required this.budgetMax,
    required this.searchRadiusKm,
  });

  final List<String> categories;
  final int? budgetMin;
  final int? budgetMax;
  final int searchRadiusKm;

  factory CustomerPreferences.fromMap(Map<String, dynamic> map) {
    return CustomerPreferences(
      categories: RequestCategories.normalizeList(
        (map['categories'] as List? ?? const []).whereType<String>(),
      ),
      budgetMin: (map['budgetMin'] as num?)?.toInt(),
      budgetMax: (map['budgetMax'] as num?)?.toInt(),
      searchRadiusKm: (map['searchRadiusKm'] as num?)?.toInt() ?? 5,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categories': categories,
      'budgetMin': budgetMin,
      'budgetMax': budgetMax,
      'searchRadiusKm': searchRadiusKm,
    };
  }
}

class CustomerReview {
  const CustomerReview({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.shopInitials,
    required this.requestId,
    required this.requestTitle,
    required this.rating,
    required this.body,
    required this.timeAgo,
  });

  final String id;
  final String shopId;
  final String shopName;
  final String shopInitials;
  final String requestId;
  final String requestTitle;
  final int rating;
  final String body;
  final String timeAgo;

  factory CustomerReview.fromMap(Map<String, dynamic> map) {
    return CustomerReview(
      id: map['id'] as String? ?? '',
      shopId: map['shopId'] as String? ?? '',
      shopName: map['shopName'] as String? ?? 'Shop',
      shopInitials: map['shopInitials'] as String? ?? 'SH',
      requestId: map['requestId'] as String? ?? '',
      requestTitle: map['requestTitle'] as String? ?? 'Purchase',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      body: map['body'] as String? ?? '',
      timeAgo: map['timeAgo'] as String? ?? '',
    );
  }
}
