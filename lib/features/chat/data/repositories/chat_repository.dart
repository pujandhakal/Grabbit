import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/network/api_client.dart';
import 'package:grabbit/features/chat/domain/entities/chat_message.dart';
import 'package:grabbit/features/chat/domain/entities/chat_thread_summary.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(apiClientProvider));
});

class ChatRepository {
  const ChatRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ChatThreadSummary>> fetchThreads() async {
    final data = await _apiClient.get('/api/chat/threads');
    final items = data['threads'];
    if (items is! List) {
      return const [];
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map(ChatThreadSummary.fromMap)
        .toList();
  }

  Future<List<ChatMessage>> fetchMessages({
    required String peerUserId,
    required String requestId,
  }) async {
    final data = await _apiClient.get(
      '/api/chat/messages?peerUserId=$peerUserId&requestId=$requestId',
    );
    final items = data['messages'];
    if (items is! List) {
      return const [];
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map(ChatMessage.fromMap)
        .toList();
  }

  Future<ChatMessage> sendMessage({
    required String peerUserId,
    required String requestId,
    required String content,
  }) async {
    final data = await _apiClient.post(
      '/api/chat/messages',
      body: {
        'peerUserId': peerUserId,
        'requestId': requestId,
        'content': content,
      },
    );
    final message = data['message'];
    if (message is! Map<String, dynamic>) {
      throw const AppException(message: 'Unexpected response from server.');
    }
    return ChatMessage.fromMap(message);
  }

  Future<void> markThreadRead({
    required String peerUserId,
    required String requestId,
  }) async {
    await _apiClient.put(
      '/api/chat/read',
      body: {
        'peerUserId': peerUserId,
        'requestId': requestId,
      },
    );
  }
}

final chatThreadsProvider = FutureProvider.autoDispose<List<ChatThreadSummary>>(
  (ref) {
    return ref.watch(chatRepositoryProvider).fetchThreads();
  },
);
