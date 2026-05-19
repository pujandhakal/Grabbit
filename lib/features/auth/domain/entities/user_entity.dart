import 'package:grabbit/features/auth/domain/entities/user_role.dart';

class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.token,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String token;

  String get type => role.wireName;
}
