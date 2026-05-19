import 'package:grabbit/features/requests/domain/entities/create_request_payload.dart';
import 'package:grabbit/features/requests/domain/entities/create_shop_response_payload.dart';
import 'package:grabbit/features/requests/domain/entities/request_responses.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/domain/entities/shop_request.dart';
import 'package:grabbit/features/requests/domain/entities/shop_response.dart';

abstract class RequestsRepository {
  Future<List<RequestSummary>> fetchRequests();

  Future<RequestResponses> fetchRequestResponses(String requestId);

  Future<RequestSummary> createRequest(CreateRequestPayload payload);

  Future<RequestSummary> completeRequestPurchase({
    required String requestId,
    required String shopUserId,
  });

  Future<List<ShopRequest>> fetchShopRequests();

  Future<ShopResponse> createShopResponse(CreateShopResponsePayload payload);

  Future<ShopResponse> updateShopResponse(CreateShopResponsePayload payload);
}
