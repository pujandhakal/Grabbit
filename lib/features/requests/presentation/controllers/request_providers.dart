import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/features/requests/data/repositories/api_requests_repository.dart';
import 'package:grabbit/features/requests/domain/entities/request_responses.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/domain/entities/shop_request.dart';

final requestsProvider =
    FutureProvider.autoDispose<List<RequestSummary>>((ref) {
  final repository = ref.watch(requestsRepositoryProvider);
  return repository.fetchRequests();
});

final requestResponsesProvider = FutureProvider.autoDispose
    .family<RequestResponses, String>((ref, requestId) {
  final repository = ref.watch(requestsRepositoryProvider);
  return repository.fetchRequestResponses(requestId);
});

final shopRequestsProvider =
    FutureProvider.autoDispose<List<ShopRequest>>((ref) {
  final repository = ref.watch(requestsRepositoryProvider);
  return repository.fetchShopRequests();
});

final shopRequestDetailProvider = FutureProvider.autoDispose
    .family<ShopRequest, String>((ref, requestId) async {
  final requests = await ref.watch(shopRequestsProvider.future);
  return requests.firstWhere((request) => request.id == requestId);
});
