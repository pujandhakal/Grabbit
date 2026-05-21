import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grabbit/core/config/app_config.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/network/api_client.dart';
import 'package:grabbit/features/auth/data/auth_session_store.dart';
import 'package:grabbit/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:grabbit/features/auth/domain/entities/login_payload.dart';
import 'package:grabbit/features/auth/domain/entities/sign_up_payload.dart';
import 'package:grabbit/features/auth/domain/entities/user_entity.dart';
import 'package:grabbit/features/auth/domain/entities/user_role.dart';
import 'package:grabbit/features/auth/domain/repositories/auth_repository.dart';
import 'package:grabbit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('auth controller stores signed-up user on success', () async {
    final repository = _FakeAuthRepository(
      result: const UserEntity(
        id: '1',
        name: 'Pujan',
        email: 'pujan@example.com',
        phone: '',
        role: UserRole.customer,
        token: '',
      ),
    );

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(authControllerProvider.notifier);
    final user = await notifier.signUp(
      const SignUpPayload(
        name: 'Pujan',
        email: 'pujan@example.com',
        password: '12345678',
        role: UserRole.customer,
      ),
    );

    expect(user.email, 'pujan@example.com');
    expect(container.read(authControllerProvider).requireValue?.name, 'Pujan');
  });

  test('auth controller exposes signup errors', () async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          _FakeAuthRepository(
            error: const AppException(message: 'Email already exists.'),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(authControllerProvider.notifier);

    await expectLater(
      notifier.signUp(
        const SignUpPayload(
          name: 'Pujan',
          email: 'pujan@example.com',
          password: '12345678',
          role: UserRole.customer,
        ),
      ),
      throwsA(isA<AppException>()),
    );

    expect(container.read(authControllerProvider).hasError, isTrue);
  });

  test('auth controller clears session after deleting account', () async {
    final repository = _FakeAuthRepository(
      result: const UserEntity(
        id: '1',
        name: 'Pujan',
        email: 'pujan@example.com',
        phone: '',
        role: UserRole.customer,
        token: 'token',
      ),
    );

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(authControllerProvider.notifier);
    await notifier.login(
      const LoginPayload(
        email: 'pujan@example.com',
        password: '12345678',
      ),
    );

    await notifier.deleteAccount(
      password: '12345678',
      confirmation: 'DELETE',
    );

    expect(repository.deleted, isTrue);
    expect(container.read(authControllerProvider).requireValue, isNull);
  });

  test('delete account sends the token captured at login', () async {
    // Drives the real provider chain (no authRepositoryProvider override) so it
    // catches the regression where the controller cached a token-less ApiClient
    // built before login and deleteAccount went out unauthenticated.
    String? deleteAuthHeader;

    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(apiBaseUrl: 'http://localhost:3000'),
        ),
        authSessionStoreProvider.overrideWithValue(_NoopSessionStore()),
        httpClientProvider.overrideWithValue(
          MockClient((request) async {
            if (request.url.path == '/api/login') {
              return http.Response(
                '{"user":{"_id":"1","name":"Pujan","email":"pujan@example.com",'
                '"type":"customer"},"token":"jwt-xyz"}',
                200,
              );
            }
            if (request.method == 'DELETE' &&
                request.url.path == '/api/account') {
              deleteAuthHeader = request.headers['Authorization'] ??
                  request.headers['authorization'];
              return http.Response('{}', 200);
            }
            return http.Response('{}', 404);
          }),
        ),
      ],
    );
    addTearDown(container.dispose);

    // Ensure the async build (session restore) finishes before we act.
    await container.read(authControllerProvider.future);

    final notifier = container.read(authControllerProvider.notifier);
    await notifier.login(
      const LoginPayload(
        email: 'pujan@example.com',
        password: '12345678',
      ),
    );

    await notifier.deleteAccount(
      password: '12345678',
      confirmation: 'DELETE',
    );

    expect(deleteAuthHeader, 'Bearer jwt-xyz');
    expect(container.read(authControllerProvider).requireValue, isNull);
  });
}

class _NoopSessionStore extends AuthSessionStore {
  _NoopSessionStore() : super(const FlutterSecureStorage());

  @override
  Future<UserEntity?> restore() async => null;

  @override
  Future<void> save(UserEntity user) async {}

  @override
  Future<void> clear() async {}
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    this.result,
    this.error,
  });

  final UserEntity? result;
  final AppException? error;
  bool deleted = false;

  @override
  Future<UserEntity> signUp(SignUpPayload payload) async {
    if (error != null) {
      throw error!;
    }

    return result!;
  }

  @override
  Future<UserEntity> login(LoginPayload payload) async {
    if (error != null) {
      throw error!;
    }

    return result!;
  }

  @override
  Future<void> deleteAccount({
    required String password,
    required String confirmation,
  }) async {
    if (error != null) {
      throw error!;
    }

    deleted = true;
  }
}
