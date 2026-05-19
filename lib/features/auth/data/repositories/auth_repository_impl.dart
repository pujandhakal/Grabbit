import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/network/api_client.dart';
import 'package:grabbit/features/auth/data/models/user_model.dart';
import 'package:grabbit/features/auth/domain/entities/login_payload.dart';
import 'package:grabbit/features/auth/domain/entities/sign_up_payload.dart';
import 'package:grabbit/features/auth/domain/entities/user_entity.dart';
import 'package:grabbit/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepositoryImpl(apiClient);
});

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<UserEntity> signUp(SignUpPayload payload) async {
    final data = await _apiClient.post('/api/signup', body: payload.toMap());
    final userData = data['user'];

    if (userData is! Map<String, dynamic>) {
      throw const AppException(message: 'Unexpected signup response.');
    }

    return UserModel.fromMap({
      ...userData,
      'token': data['token'] as String? ?? '',
    });
  }

  @override
  Future<UserEntity> login(LoginPayload payload) async {
    final data = await _apiClient.post('/api/login', body: payload.toMap());
    final userData = data['user'];

    if (userData is! Map<String, dynamic>) {
      throw const AppException(message: 'Unexpected login response.');
    }

    return UserModel.fromMap({
      ...userData,
      'token': data['token'] as String? ?? '',
    });
  }
}
