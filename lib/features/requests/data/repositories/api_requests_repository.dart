import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/network/api_client.dart';
import 'package:grabbit/features/requests/data/models/request_summary_model.dart';
import 'package:grabbit/features/requests/data/models/shop_request_model.dart';
import 'package:grabbit/features/requests/data/models/shop_response_model.dart';
import 'package:grabbit/features/requests/domain/entities/create_request_payload.dart';
import 'package:grabbit/features/requests/domain/entities/create_shop_response_payload.dart';
import 'package:grabbit/features/requests/domain/entities/request_responses.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/domain/entities/shop_request.dart';
import 'package:grabbit/features/requests/domain/entities/shop_response.dart';
import 'package:grabbit/features/requests/domain/repositories/requests_repository.dart';

final requestsRepositoryProvider = Provider<RequestsRepository>((ref) {
  return ApiRequestsRepository(ref.watch(apiClientProvider));
});

class ApiRequestsRepository implements RequestsRepository {
  const ApiRequestsRepository(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<RequestSummary>> fetchRequests() async {
    final data = await _apiClient.get('/api/requests/mine');
    final items = data['requests'];
    if (items is! List) {
      return const [];
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map(RequestSummaryModel.fromMap)
        .toList();
  }

  @override
  Future<RequestResponses> fetchRequestResponses(String requestId) async {
    final data = await _apiClient.get('/api/requests/$requestId/responses');
    final requestData = data['request'];
    final responseData = data['responses'];

    return RequestResponses(
      request: requestData is Map<String, dynamic>
          ? RequestSummaryModel.fromMap(requestData)
          : RequestSummaryModel.fromMap(const {}),
      responses: responseData is List
          ? responseData
              .whereType<Map<String, dynamic>>()
              .map(ShopResponseModel.fromMap)
              .toList()
          : const [],
    );
  }

  @override
  Future<RequestSummary> createRequest(CreateRequestPayload payload) async {
    final data = await _apiClient.post('/api/requests', body: payload.toMap());
    final requestData = data['request'];
    if (requestData is Map<String, dynamic>) {
      return RequestSummaryModel.fromMap(requestData);
    }
    return RequestSummaryModel.fromMap(const {});
  }

  @override
  Future<RequestSummary> completeRequestPurchase({
    required String requestId,
    required String shopUserId,
  }) async {
    final data = await _apiClient.put(
      '/api/requests/$requestId/complete',
      body: {'shopUserId': shopUserId},
    );
    final requestData = data['request'];
    if (requestData is Map<String, dynamic>) {
      return RequestSummaryModel.fromMap(requestData);
    }
    return RequestSummaryModel.fromMap(const {});
  }

  @override
  Future<List<ShopRequest>> fetchShopRequests() async {
    final data = await _apiClient.get('/api/shop/requests');
    final items = data['requests'];
    if (items is! List) {
      return const [];
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map(ShopRequestModel.fromMap)
        .toList();
  }

  @override
  Future<ShopResponse> createShopResponse(
    CreateShopResponsePayload payload,
  ) async {
    final data = await _apiClient.post(
      '/api/requests/${payload.requestId}/responses',
      body: payload.toMap(),
    );
    final responseData = data['response'];
    if (responseData is Map<String, dynamic>) {
      return ShopResponseModel.fromMap(responseData);
    }
    return ShopResponseModel.fromMap(const {});
  }

  @override
  Future<ShopResponse> updateShopResponse(
    CreateShopResponsePayload payload,
  ) async {
    final data = await _apiClient.put(
      '/api/requests/${payload.requestId}/responses/me',
      body: payload.toMap(),
    );
    final responseData = data['response'];
    if (responseData is Map<String, dynamic>) {
      return ShopResponseModel.fromMap(responseData);
    }
    return ShopResponseModel.fromMap(const {});
  }
}
