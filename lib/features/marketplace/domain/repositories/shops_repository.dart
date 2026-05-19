import 'package:grabbit/features/marketplace/domain/entities/shop_details.dart';

abstract class ShopsRepository {
  Future<ShopDetails> fetchShopDetails(String shopId);
}
