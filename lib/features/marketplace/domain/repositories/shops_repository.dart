import 'package:grabbit/features/marketplace/domain/entities/shop_details.dart';

abstract class ShopsRepository {
  Future<ShopDetails> fetchShopDetails(String shopId);

  Future<void> submitReview({
    required String shopId,
    required String requestId,
    required int rating,
    required String body,
  });
}
