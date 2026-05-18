import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabbit/features/shop/data/repositories/mock_shops_repository.dart';
import 'package:grabbit/features/shop/presentation/controllers/shop_providers.dart';

void main() {
  test('shop details provider loads mock store details', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final details = await container.read(
      shopDetailsProvider(defaultShopId).future,
    );

    expect(details.id, defaultShopId);
    expect(details.name, 'Fashion Hub Kathmandu');
  });
}
