import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/features/requests/data/repositories/mock_requests_repository.dart';
import 'package:grabbit/features/requests/domain/entities/request_responses.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';

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
