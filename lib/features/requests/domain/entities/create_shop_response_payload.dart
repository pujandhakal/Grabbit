class CreateShopResponsePayload {
  const CreateShopResponsePayload({
    required this.requestId,
    required this.price,
    required this.message,
  });

  final String requestId;
  final String price;
  final String message;

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'message': message,
    };
  }
}
