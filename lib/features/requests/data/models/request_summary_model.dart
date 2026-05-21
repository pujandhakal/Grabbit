import 'package:grabbit/core/config/request_categories.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';

class RequestSummaryModel extends RequestSummary {
  const RequestSummaryModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.status,
    required super.time,
    required super.responseText,
    required super.category,
    required super.postedAt,
    super.description,
    super.quantity,
    super.urgency,
    super.locationText,
    super.budgetText,
    super.customerName,
  });

  factory RequestSummaryModel.fromMap(Map<String, dynamic> map) {
    return RequestSummaryModel(
      id: map['id'] as String? ?? map['_id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      status: _statusFromString(map['status'] as String?),
      time: map['time'] as String? ?? '',
      responseText: map['responseText'] as String? ?? '0 shops responded',
      category: RequestCategories.normalize(
        map['category'] as String? ?? RequestCategories.other,
      ),
      postedAt: map['postedAt'] as String? ?? '',
      description: map['description'] as String? ?? '',
      quantity: map['quantity'] as String? ?? '',
      urgency: map['urgency'] as String? ?? 'need_soon',
      locationText: map['locationText'] as String? ?? '',
      budgetText: map['budgetText'] as String? ?? '',
      customerName: map['customerName'] as String? ?? 'Customer',
    );
  }

  static RequestStatus _statusFromString(String? value) {
    return switch (value) {
      'completed' => RequestStatus.completed,
      'pending' => RequestStatus.pending,
      _ => RequestStatus.active,
    };
  }
}
