import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/features/shop/data/repositories/mock_shops_repository.dart';
import 'package:grabbit/features/shop/domain/entities/shop_details.dart';

final shopDetailsProvider =
    FutureProvider.autoDispose.family<ShopDetails, String>((ref, shopId) {
  final repository = ref.watch(shopsRepositoryProvider);
  return repository.fetchShopDetails(shopId);
});
