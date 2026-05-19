import 'package:grabbit/features/auth/domain/entities/login_payload.dart';
import 'package:grabbit/features/auth/domain/entities/sign_up_payload.dart';
import 'package:grabbit/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signUp(SignUpPayload payload);

  Future<UserEntity> login(LoginPayload payload);

  Future<void> deleteAccount({
    required String password,
    required String confirmation,
  });
}
