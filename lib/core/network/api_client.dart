import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/config/app_config.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:http/http.dart' as http;

final appConfigProvider = Provider<AppConfig>((ref) {
  return const AppConfig(apiBaseUrl: AppConfig.defaultBaseUrl);
});

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final client = ref.watch(httpClientProvider);
  return ApiClient(
    baseUrl: config.apiBaseUrl,
    client: client,
  );
});

class ApiClient {
  const ApiClient({
    required this.baseUrl,
    required this.client,
  });

  final String baseUrl;
  final http.Client client;

  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    late http.Response response;

    try {
      response = await client.post(
        Uri.parse('$baseUrl$path'),
        headers: const {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
    } catch (_) {
      throw const AppException(
        message: 'Unable to reach the server. Check the API base URL and try again.',
      );
    }

    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw AppException(
      statusCode: response.statusCode,
      message: _extractErrorMessage(decoded),
    );
  }

  String _extractErrorMessage(Map<String, dynamic> payload) {
    return payload['msg'] as String? ??
        payload['error'] as String? ??
        payload['err'] as String? ??
        'Something went wrong. Please try again.';
  }
}
