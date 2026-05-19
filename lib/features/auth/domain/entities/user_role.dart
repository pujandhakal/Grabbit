enum UserRole {
  customer('customer'),
  shop('shop');

  const UserRole(this.wireName);

  final String wireName;

  static UserRole fromWireName(String? value) {
    return switch (value) {
      'shop' => UserRole.shop,
      'customer' || 'user' || '' || null => UserRole.customer,
      _ => UserRole.customer,
    };
  }
}
