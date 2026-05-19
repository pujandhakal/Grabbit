class ShopResponse {
  const ShopResponse({
    required this.shopId,
    required this.name,
    required this.distance,
    required this.respondedAgo,
    required this.rating,
    required this.reviews,
    required this.message,
    required this.price,
    this.shopUserId = '',
  });

  final String shopId;
  final String shopUserId;
  final String name;
  final String distance;
  final String respondedAgo;
  final String rating;
  final String reviews;
  final String message;
  final String price;
}
