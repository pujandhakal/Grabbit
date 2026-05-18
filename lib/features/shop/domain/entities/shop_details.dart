class ShopDetails {
  const ShopDetails({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.openStatus,
    required this.closingTime,
    required this.description,
    required this.specialties,
    required this.reviews,
    required this.activities,
    required this.typicalResponseTime,
    required this.address,
    required this.landmark,
  });

  final String id;
  final String name;
  final String rating;
  final String reviewCount;
  final String distance;
  final String openStatus;
  final String closingTime;
  final String description;
  final List<String> specialties;
  final List<StoreReview> reviews;
  final List<StoreActivity> activities;
  final String typicalResponseTime;
  final String address;
  final String landmark;
}

class StoreReview {
  const StoreReview({
    required this.initials,
    required this.name,
    required this.timeAgo,
    required this.body,
  });

  final String initials;
  final String name;
  final String timeAgo;
  final String body;
}

class StoreActivity {
  const StoreActivity({
    required this.product,
    required this.timeAgo,
  });

  final String product;
  final String timeAgo;
}
