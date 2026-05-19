enum RequestStatus {
  active,
  pending,
  completed,
}

class RequestSummary {
  const RequestSummary({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.time,
    required this.responseText,
    required this.category,
    required this.postedAt,
    this.description = '',
    this.quantity = '',
    this.urgency = 'need_soon',
    this.locationText = '',
    this.budgetText = '',
    this.customerName = 'Customer',
  });

  final String id;
  final String title;
  final String subtitle;
  final RequestStatus status;
  final String time;
  final String responseText;
  final String category;
  final String postedAt;
  final String description;
  final String quantity;
  final String urgency;
  final String locationText;
  final String budgetText;
  final String customerName;
}
