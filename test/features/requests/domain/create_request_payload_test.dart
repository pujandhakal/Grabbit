import 'package:flutter_test/flutter_test.dart';
import 'package:grabbit/features/requests/domain/entities/create_request_payload.dart';

void main() {
  test('create request payload includes location coordinates when available',
      () {
    const payload = CreateRequestPayload(
      title: 'Wireless Headphones',
      description: 'Budget friendly',
      category: 'Electronics',
      quantity: '1',
      urgency: 'need_soon',
      locationText: 'Current location',
      latitude: 27.7172,
      longitude: 85.3240,
      budgetMin: 1000,
      budgetMax: 3000,
    );

    final map = payload.toMap();

    expect(map['latitude'], 27.7172);
    expect(map['longitude'], 85.3240);
    expect(map['locationText'], 'Current location');
  });
}
