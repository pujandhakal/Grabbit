import 'package:flutter_test/flutter_test.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/features/requests/data/repositories/mock_requests_repository.dart';

void main() {
  test('mock requests repository returns posted requests', () async {
    const repository = MockRequestsRepository();

    final requests = await repository.fetchRequests();

    expect(requests.first.id, defaultRequestId);
    expect(requests.first.title, 'Red Hoodie, Size L');
  });

  test('mock requests repository returns responses for request id', () async {
    const repository = MockRequestsRepository();

    final bundle = await repository.fetchRequestResponses(defaultRequestId);

    expect(bundle.request.title, 'Red Hoodie, Size L');
    expect(bundle.responses, hasLength(8));
    expect(bundle.responses.first.shopId, 'fashion-hub-kathmandu');
  });

  test('mock requests repository throws for missing request id', () async {
    const repository = MockRequestsRepository();

    await expectLater(
      repository.fetchRequestResponses('missing-request'),
      throwsA(isA<AppException>()),
    );
  });
}
