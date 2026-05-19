import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/network/api_client.dart';
import 'package:grabbit/features/marketplace/data/models/shop_details_model.dart';
import 'package:grabbit/features/marketplace/domain/entities/shop_details.dart';
import 'package:grabbit/features/marketplace/domain/repositories/shops_repository.dart';

final shopsRepositoryProvider = Provider<ShopsRepository>((ref) {
  return ApiShopsRepository(ref.watch(apiClientProvider));
});

class ApiShopsRepository implements ShopsRepository {
  const ApiShopsRepository(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ShopDetails> fetchShopDetails(String shopId) async {
    final data = await _apiClient.get('/api/shops/$shopId');
    final shop = data['shop'];
    if (shop is Map<String, dynamic>) {
      return ShopDetailsModel.fromMap(shop);
    }
    throw const AppException(message: 'Store details are not available yet.');
  }

  @override
  Future<void> submitReview({
    required String shopId,
    required String requestId,
    required int rating,
    required String body,
  }) async {
    await _apiClient.post(
      '/api/shops/$shopId/reviews',
      body: {
        'requestId': requestId,
        'rating': rating,
        'body': body,
      },
    );
  }
}
