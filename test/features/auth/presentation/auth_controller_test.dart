import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:grabbit/features/auth/domain/entities/login_payload.dart';
import 'package:grabbit/features/auth/domain/entities/sign_up_payload.dart';
import 'package:grabbit/features/auth/domain/entities/user_entity.dart';
import 'package:grabbit/features/auth/domain/entities/user_role.dart';
import 'package:grabbit/features/auth/domain/repositories/auth_repository.dart';
import 'package:grabbit/features/auth/presentation/controllers/auth_controller.dart';

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
}

class _FakeAuthRepository implements AuthRepository {
  const _FakeAuthRepository({
    this.result,
    this.error,
  });

  final UserEntity? result;
  final AppException? error;

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
}
