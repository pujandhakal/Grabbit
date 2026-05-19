import 'package:grabbit/features/marketplace/domain/entities/shop_details.dart';

class ShopDetailsModel extends ShopDetails {
  const ShopDetailsModel({
    required super.id,
    required super.name,
    required super.rating,
    required super.reviewCount,
    required super.distance,
    required super.openStatus,
    required super.closingTime,
    required super.description,
    required super.specialties,
    required super.reviews,
    required super.activities,
    required super.typicalResponseTime,
    required super.address,
    required super.landmark,
    super.phone,
    super.isVerified,
    super.latitude,
    super.longitude,
  });

  factory ShopDetailsModel.fromMap(Map<String, dynamic> map) {
    return ShopDetailsModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'Store',
      rating: map['rating'] as String? ?? 'No ratings yet',
      reviewCount: map['reviewCount'] as String? ?? '0 reviews',
      distance: map['distance'] as String? ?? 'Nearby',
      openStatus: map['openStatus'] as String? ?? 'Hours unavailable',
      closingTime: map['closingTime'] as String? ?? '',
      description: map['description'] as String? ?? '',
      specialties: (map['specialties'] as List? ?? const [])
          .whereType<String>()
          .toList(),
      reviews: (map['reviews'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(
            (item) => StoreReview(
              initials: item['initials'] as String? ?? '',
              name: item['name'] as String? ?? '',
              rating: (item['rating'] as num?)?.toInt() ?? 0,
              timeAgo: item['timeAgo'] as String? ?? '',
              body: item['body'] as String? ?? '',
            ),
          )
          .toList(),
      activities: (map['activities'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(
            (item) => StoreActivity(
              product: item['product'] as String? ?? '',
              timeAgo: item['timeAgo'] as String? ?? '',
            ),
          )
          .toList(),
      typicalResponseTime: map['typicalResponseTime'] as String? ?? '',
      address: map['address'] as String? ?? '',
      landmark: map['landmark'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      isVerified: map['isVerified'] as bool? ?? false,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }
}
