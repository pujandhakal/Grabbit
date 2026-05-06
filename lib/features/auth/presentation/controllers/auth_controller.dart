import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:grabbit/features/auth/domain/entities/sign_up_payload.dart';
import 'package:grabbit/features/auth/domain/entities/user_entity.dart';
import 'package:grabbit/features/auth/domain/repositories/auth_repository.dart';

final authControllerProvider =
    AutoDisposeAsyncNotifierProvider<AuthController, UserEntity?>(
  AuthController.new,
);

class AuthController extends AutoDisposeAsyncNotifier<UserEntity?> {
  late final AuthRepository _repository;

  @override
  Future<UserEntity?> build() async {
    _repository = ref.read(authRepositoryProvider);
    return null;
  }

  Future<UserEntity> signUp(SignUpPayload payload) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => _repository.signUp(payload));
    state = result;

    return result.when(
      data: (user) => user,
      error: (error, stackTrace) => throw error,
      loading: () => throw StateError('Signup is still loading.'),
    );
  }
}
