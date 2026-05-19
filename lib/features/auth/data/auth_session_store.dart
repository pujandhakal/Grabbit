import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grabbit/features/auth/data/models/user_model.dart';
import 'package:grabbit/features/auth/domain/entities/user_entity.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final authSessionStoreProvider = Provider<AuthSessionStore>((ref) {
  return AuthSessionStore(ref.watch(secureStorageProvider));
});

class AuthSessionStore {
  const AuthSessionStore(this._storage);

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  final FlutterSecureStorage _storage;

  Future<UserEntity?> restore() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      final userJson = await _storage.read(key: _userKey);
      if (token == null || userJson == null) {
        return null;
      }

      final map = jsonDecode(userJson) as Map<String, dynamic>;
      map['token'] = token;
      return UserModel.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(UserEntity user) async {
    try {
      await _storage.write(key: _tokenKey, value: user.token);
      await _storage.write(
        key: _userKey,
        value: jsonEncode({
          '_id': user.id,
          'name': user.name,
          'email': user.email,
          'phone': user.phone,
          'type': user.type,
        }),
      );
    } catch (_) {
      // Storage can be unavailable in widget tests or unsupported platforms.
    }
  }

  Future<void> clear() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
    } catch (_) {
      // Storage can be unavailable in widget tests or unsupported platforms.
    }
  }
}
