import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabbit/core/config/app_config.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/network/api_client.dart';
import 'package:grabbit/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:grabbit/features/auth/domain/entities/login_payload.dart';
import 'package:grabbit/features/auth/domain/entities/sign_up_payload.dart';
import 'package:grabbit/features/auth/domain/entities/user_role.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('repository maps signup response into entity', () async {
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(apiBaseUrl: 'http://localhost:3000'),
        ),
        httpClientProvider.overrideWithValue(
          MockClient((request) async {
            expect(request.url.toString(), 'http://localhost:3000/api/signup');
            expect(request.body, contains('"type":"shop"'));
            return http.Response(
              '{"user":{"_id":"1","name":"Pujan","email":"pujan@example.com","type":"shop"}}',
              200,
            );
          }),
        ),
      ],
    );
    addTearDown(container.dispose);

    final repository = container.read(authRepositoryProvider);
    final user = await repository.signUp(
      const SignUpPayload(
        name: 'Pujan',
        email: 'pujan@example.com',
        password: '12345678',
        role: UserRole.shop,
      ),
    );

    expect(user.id, '1');
    expect(user.email, 'pujan@example.com');
    expect(user.role, UserRole.shop);
  });

  test('repository maps login response into entity', () async {
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(apiBaseUrl: 'http://localhost:3000'),
        ),
        httpClientProvider.overrideWithValue(
          MockClient((request) async {
            expect(request.url.toString(), 'http://localhost:3000/api/login');
            return http.Response(
              '{"user":{"_id":"1","name":"Pujan","email":"pujan@example.com","type":"customer"}}',
              200,
            );
          }),
        ),
      ],
    );
    addTearDown(container.dispose);

    final repository = container.read(authRepositoryProvider);
    final user = await repository.login(
      const LoginPayload(
        email: 'pujan@example.com',
        password: '12345678',
      ),
    );

    expect(user.id, '1');
    expect(user.role, UserRole.customer);
  });

  test('repository sends delete account request with auth token', () async {
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(apiBaseUrl: 'http://localhost:3000'),
        ),
        apiTokenProvider.overrideWith((ref) => 'token-123'),
        httpClientProvider.overrideWithValue(
          MockClient((request) async {
            expect(request.method, 'DELETE');
            expect(request.url.toString(), 'http://localhost:3000/api/account');
            expect(
              request.headers['Authorization'] ??
                  request.headers['authorization'],
              'Bearer token-123',
            );
            expect(request.body, contains('"password":"secret123"'));
            expect(request.body, contains('"confirmation":"DELETE"'));
            return http.Response('{}', 200);
          }),
        ),
      ],
    );
    addTearDown(container.dispose);

    final repository = container.read(authRepositoryProvider);

    await repository.deleteAccount(
      password: 'secret123',
      confirmation: 'DELETE',
    );
  });

  test('repository surfaces api errors', () async {
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(apiBaseUrl: 'http://localhost:3000'),
        ),
        httpClientProvider.overrideWithValue(
          MockClient(
            (_) async => http.Response(
              '{"msg":"User with same email already exists!"}',
              400,
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final repository = container.read(authRepositoryProvider);

    await expectLater(
      repository.signUp(
        const SignUpPayload(
          name: 'Pujan',
          email: 'pujan@example.com',
          password: '12345678',
          role: UserRole.customer,
        ),
      ),
      throwsA(
        isA<AppException>().having(
          (error) => error.message,
          'message',
          'User with same email already exists!',
        ),
      ),
    );
  });
}
