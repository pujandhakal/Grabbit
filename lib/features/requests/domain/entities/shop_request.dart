import 'package:grabbit/features/requests/domain/entities/request_summary.dart';

class ShopRequest {
  const ShopRequest({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.budget,
    required this.age,
    required this.distance,
    required this.customerName,
    required this.isNew,
    required this.isUrgent,
    required this.hasResponded,
    required this.responsePrice,
    required this.responseMessage,
    required this.respondedAgo,
    this.status = RequestStatus.active,
    this.customerId = '',
  });

  final String id;
  final String customerId;
  final String title;
  final String subtitle;
  final String description;
  final String category;
  final String budget;
  final String age;
  final String distance;
  final String customerName;
  final bool isNew;
  final bool isUrgent;
  final bool hasResponded;
  final String responsePrice;
  final String responseMessage;
  final String respondedAgo;
  final RequestStatus status;
}
