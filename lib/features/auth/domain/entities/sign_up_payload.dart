import 'package:grabbit/features/auth/domain/entities/user_role.dart';

class SignUpPayload {
  const SignUpPayload({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  final String name;
  final String email;
  final String password;
  final UserRole role;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'type': role.wireName,
    };
  }
}
