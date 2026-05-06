class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
    required this.token,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String type;
  final String token;
}
