import 'package:grabbit/features/requests/domain/entities/shop_request.dart';

class ShopRequestModel extends ShopRequest {
  const ShopRequestModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.description,
    required super.category,
    required super.budget,
    required super.age,
    required super.distance,
    required super.customerName,
    required super.isNew,
    required super.isUrgent,
    required super.hasResponded,
    required super.responsePrice,
    required super.responseMessage,
    required super.respondedAgo,
  });

  factory ShopRequestModel.fromMap(Map<String, dynamic> map) {
    return ShopRequestModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? 'Other',
      budget: map['budget'] as String? ?? 'Budget open',
      age: map['age'] as String? ?? '',
      distance: map['distance'] as String? ?? 'Nearby',
      customerName: map['customerName'] as String? ?? 'Customer',
      isNew: map['isNew'] as bool? ?? false,
      isUrgent: map['isUrgent'] as bool? ?? false,
      hasResponded: map['hasResponded'] as bool? ?? false,
      responsePrice: map['responsePrice'] as String? ?? '',
      responseMessage: map['responseMessage'] as String? ?? '',
      respondedAgo: map['respondedAgo'] as String? ?? '',
    );
  }
}
