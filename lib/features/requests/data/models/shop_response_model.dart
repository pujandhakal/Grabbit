import 'package:grabbit/features/requests/domain/entities/shop_response.dart';

class ShopResponseModel extends ShopResponse {
  const ShopResponseModel({
    required super.shopId,
    required super.name,
    required super.distance,
    required super.respondedAgo,
    required super.rating,
    required super.reviews,
    required super.message,
    required super.price,
    super.shopUserId,
  });

  factory ShopResponseModel.fromMap(Map<String, dynamic> map) {
    return ShopResponseModel(
      shopId: map['shopId'] as String? ?? '',
      shopUserId: map['shopUserId'] as String? ?? '',
      name: map['name'] as String? ?? 'Shop',
      distance: map['distance'] as String? ?? 'Nearby',
      respondedAgo: map['respondedAgo'] as String? ?? '',
      rating: map['rating'] as String? ?? '4.8',
      reviews: map['reviews'] as String? ?? '(0 reviews)',
      message: map['message'] as String? ?? '',
      price: map['price'] as String? ?? '',
    );
  }
}
