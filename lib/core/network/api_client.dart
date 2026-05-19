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

final apiTokenProvider = StateProvider<String?>((ref) => null);

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final client = ref.watch(httpClientProvider);
  final token = ref.watch(apiTokenProvider);
  return ApiClient(
    baseUrl: config.apiBaseUrl,
    client: client,
    token: token,
  );
});

class ApiClient {
  const ApiClient({
    required this.baseUrl,
    required this.client,
    this.token,
  });

  final String baseUrl;
  final http.Client client;
  final String? token;

  Future<Map<String, dynamic>> get(String path) async {
    late http.Response response;

    try {
      response = await client.get(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
      );
    } catch (_) {
      throw const AppException(
        message:
            'Unable to reach the server. Check the API base URL and try again.',
      );
    }

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    late http.Response response;

    try {
      response = await client.post(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
        body: jsonEncode(body),
      );
    } catch (_) {
      throw const AppException(
        message:
            'Unable to reach the server. Check the API base URL and try again.',
      );
    }

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    late http.Response response;

    try {
      response = await client.put(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
        body: jsonEncode(body),
      );
    } catch (_) {
      throw const AppException(
        message:
            'Unable to reach the server. Check the API base URL and try again.',
      );
    }

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    late http.Response response;

    try {
      response = await client.delete(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
        body: jsonEncode(body),
      );
    } catch (_) {
      throw const AppException(
        message:
            'Unable to reach the server. Check the API base URL and try again.',
      );
    }

    return _handleResponse(response);
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null && token!.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
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
