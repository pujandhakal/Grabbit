import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/network/api_client.dart';
import 'package:grabbit/features/auth/data/auth_session_store.dart';
import 'package:grabbit/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:grabbit/features/auth/domain/entities/login_payload.dart';
import 'package:grabbit/features/auth/domain/entities/sign_up_payload.dart';
import 'package:grabbit/features/auth/domain/entities/user_entity.dart';
import 'package:grabbit/features/auth/domain/repositories/auth_repository.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserEntity?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<UserEntity?> {
  late final AuthRepository _repository;
  late final AuthSessionStore _sessionStore;

  @override
  Future<UserEntity?> build() async {
    _repository = ref.read(authRepositoryProvider);
    _sessionStore = ref.read(authSessionStoreProvider);
    final restoredUser = await _sessionStore.restore();
    ref.read(apiTokenProvider.notifier).state = restoredUser?.token;
    return restoredUser;
  }

  Future<UserEntity> signUp(SignUpPayload payload) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => _repository.signUp(payload));
    state = result;

    return result.when(
      data: (user) async {
        ref.read(apiTokenProvider.notifier).state = user.token;
        await _sessionStore.save(user);
        return user;
      },
      error: (error, stackTrace) => throw error,
      loading: () => throw StateError('Signup is still loading.'),
    );
  }

  Future<UserEntity> login(LoginPayload payload) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => _repository.login(payload));
    state = result;

    return result.when(
      data: (user) async {
        ref.read(apiTokenProvider.notifier).state = user.token;
        await _sessionStore.save(user);
        return user;
      },
      error: (error, stackTrace) => throw error,
      loading: () => throw StateError('Login is still loading.'),
    );
  }

  Future<void> logout() async {
    ref.read(apiTokenProvider.notifier).state = null;
    await _sessionStore.clear();
    state = const AsyncData(null);
  }

  Future<void> updateCurrentUser(UserEntity nextUser) async {
    final currentUser = state.valueOrNull;
    final user = UserEntity(
      id: nextUser.id,
      name: nextUser.name,
      email: nextUser.email,
      phone: nextUser.phone,
      role: nextUser.role,
      token: currentUser?.token ?? nextUser.token,
    );
    ref.read(apiTokenProvider.notifier).state = user.token;
    await _sessionStore.save(user);
    state = AsyncData(user);
  }

  Future<void> deleteAccount({
    required String password,
    required String confirmation,
  }) async {
    final currentUser = state.valueOrNull;
    state = const AsyncLoading();

    try {
      await _repository.deleteAccount(
        password: password,
        confirmation: confirmation,
      );
      ref.read(apiTokenProvider.notifier).state = null;
      await _sessionStore.clear();
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      if (currentUser != null) {
        state = AsyncData(currentUser);
      }
      rethrow;
    }
  }
}
