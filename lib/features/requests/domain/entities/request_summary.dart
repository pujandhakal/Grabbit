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
  });

  final String id;
  final String title;
  final String subtitle;
  final RequestStatus status;
  final String time;
  final String responseText;
  final String category;
  final String postedAt;
}
