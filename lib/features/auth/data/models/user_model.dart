import 'package:grabbit/features/auth/domain/entities/user_entity.dart';
import 'package:grabbit/features/auth/domain/entities/user_role.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
    required super.token,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      role: UserRole.fromWireName(map['type'] as String?),
      token: map['token'] as String? ?? '',
    );
  }
}
