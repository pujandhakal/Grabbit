import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/domain/entities/shop_response.dart';

class RequestResponses {
  const RequestResponses({
    required this.request,
    required this.responses,
  });

  final RequestSummary request;
  final List<ShopResponse> responses;
}
