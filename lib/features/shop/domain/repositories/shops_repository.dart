import 'package:grabbit/features/shop/domain/entities/shop_details.dart';

abstract class ShopsRepository {
  Future<ShopDetails> fetchShopDetails(String shopId);
}
