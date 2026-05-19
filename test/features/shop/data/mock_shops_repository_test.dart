import 'package:flutter_test/flutter_test.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/features/marketplace/data/repositories/mock_shops_repository.dart';

void main() {
  test('mock shops repository returns store details by id', () async {
    const repository = MockShopsRepository();

    final details = await repository.fetchShopDetails(defaultShopId);

    expect(details.name, 'Fashion Hub Kathmandu');
    expect(details.reviews, hasLength(3));
    expect(details.activities, hasLength(3));
  });

  test('mock shops repository throws for missing shop id', () async {
    const repository = MockShopsRepository();

    await expectLater(
      repository.fetchShopDetails('missing-shop'),
      throwsA(isA<AppException>()),
    );
  });
}
