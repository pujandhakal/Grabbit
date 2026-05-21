import 'package:grabbit/core/config/request_categories.dart';

class ShopProfile {
  const ShopProfile({
    required this.businessName,
    required this.initials,
    required this.categories,
    required this.addressText,
    required this.phone,
    required this.description,
    required this.specialties,
    required this.openStatus,
    required this.closingTime,
    required this.typicalResponseTime,
    required this.landmark,
    required this.isVerified,
    required this.rating,
    required this.reviewCount,
    this.latitude,
    this.longitude,
    this.showAllRequests = true,
  });

  final String businessName;
  final String initials;
  final List<String> categories;
  final String addressText;
  final String phone;
  final String description;
  final List<String> specialties;
  final String openStatus;
  final String closingTime;
  final String typicalResponseTime;
  final String landmark;
  final bool isVerified;
  final double rating;
  final int reviewCount;
  final double? latitude;
  final double? longitude;
  final bool showAllRequests;

  factory ShopProfile.fromMap(Map<String, dynamic> map) {
    return ShopProfile(
      businessName: map['businessName'] as String? ?? 'My Shop',
      initials: map['initials'] as String? ?? 'MS',
      categories: RequestCategories.normalizeList(
        (map['categories'] as List? ?? const []).whereType<String>(),
      ),
      addressText: map['addressText'] as String? ?? 'Kathmandu',
      phone: map['phone'] as String? ?? '',
      description: map['description'] as String? ?? '',
      specialties: (map['specialties'] as List? ?? const [])
          .whereType<String>()
          .toList(),
      openStatus: map['openStatus'] as String? ?? '',
      closingTime: map['closingTime'] as String? ?? '',
      typicalResponseTime: map['typicalResponseTime'] as String? ?? '',
      landmark: map['landmark'] as String? ?? '',
      isVerified: map['isVerified'] as bool? ?? false,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      showAllRequests: map['showAllRequests'] as bool? ?? true,
    );
  }
}
