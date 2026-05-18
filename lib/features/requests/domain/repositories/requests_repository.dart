import 'package:grabbit/features/requests/domain/entities/request_responses.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';

abstract class RequestsRepository {
  Future<List<RequestSummary>> fetchRequests();

  Future<RequestResponses> fetchRequestResponses(String requestId);
}
