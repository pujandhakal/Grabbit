import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabbit/features/requests/data/repositories/mock_requests_repository.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';

void main() {
  test('request responses provider loads mock responses', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final bundle = await container.read(
      requestResponsesProvider(defaultRequestId).future,
    );

    expect(bundle.request.id, defaultRequestId);
    expect(bundle.responses.first.name, 'Fashion Hub Kathmandu');
  });
}
