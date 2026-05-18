import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/features/shop/domain/entities/shop_details.dart';
import 'package:grabbit/features/shop/domain/repositories/shops_repository.dart';

const defaultShopId = 'fashion-hub-kathmandu';

final shopsRepositoryProvider = Provider<ShopsRepository>((ref) {
  return const MockShopsRepository();
});

class MockShopsRepository implements ShopsRepository {
  const MockShopsRepository();

  @override
  Future<ShopDetails> fetchShopDetails(String shopId) async {
    final details = _shops[shopId];

    if (details == null) {
      throw const AppException(message: 'Store not found.');
    }

    return details;
  }
}

const _shops = {
  defaultShopId: ShopDetails(
    id: defaultShopId,
    name: 'Fashion Hub Kathmandu',
    rating: '4.8',
    reviewCount: '234 reviews',
    distance: '850m away',
    openStatus: 'Open Now',
    closingTime: 'Closes 9:00 PM',
    description:
        'Premium fashion store offering latest trends in clothing, accessories, and footwear. We pride ourselves on quality products and excellent customer service. Visit us for the best deals in Kathmandu!',
    specialties: [
      'Clothing',
      'Fashion',
      'Accessories',
      'Footwear',
    ],
    reviews: [
      StoreReview(
        initials: 'PS',
        name: 'Priya Sharma',
        timeAgo: '2 days ago',
        body:
            'Excellent service! Found exactly what I was looking for. The staff was very helpful and friendly.',
      ),
      StoreReview(
        initials: 'AK',
        name: 'Amit Kumar',
        timeAgo: '5 days ago',
        body:
            'Good collection and reasonable prices. Quick response to my request.',
      ),
      StoreReview(
        initials: 'ST',
        name: 'Sneha Thapa',
        timeAgo: '1 week ago',
        body:
            'Amazing quality products! Will definitely shop here again. Highly recommended!',
      ),
    ],
    activities: [
      StoreActivity(product: 'Laptop Charger', timeAgo: '30 minutes ago'),
      StoreActivity(product: 'Winter Jacket', timeAgo: '2 hours ago'),
      StoreActivity(product: 'Running Shoes', timeAgo: '5 hours ago'),
    ],
    typicalResponseTime: '15 minutes',
    address: 'Thamel, Kathmandu 44600',
    landmark: 'Near Kathmandu Guest House, opposite to Himalayan Java Coffee',
  ),
};
