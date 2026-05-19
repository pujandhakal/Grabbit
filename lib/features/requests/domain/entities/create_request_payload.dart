class CreateRequestPayload {
  const CreateRequestPayload({
    required this.title,
    required this.description,
    required this.category,
    required this.quantity,
    required this.urgency,
    required this.locationText,
    this.latitude,
    this.longitude,
    this.budgetMin,
    this.budgetMax,
  });

  final String title;
  final String description;
  final String category;
  final String quantity;
  final String urgency;
  final String locationText;
  final double? latitude;
  final double? longitude;
  final int? budgetMin;
  final int? budgetMax;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'quantity': quantity,
      'urgency': urgency,
      'locationText': locationText,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (budgetMin != null) 'budgetMin': budgetMin,
      if (budgetMax != null) 'budgetMax': budgetMax,
    };
  }
}
