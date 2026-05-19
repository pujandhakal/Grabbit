import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/realtime/realtime_connection.dart';
import 'package:grabbit/features/chat/data/repositories/chat_repository.dart';
import 'package:grabbit/features/chat/domain/entities/chat_message.dart';

typedef ChatThreadKey = ({String peerUserId, String requestId});

final chatThreadProvider = AsyncNotifierProvider.family<ChatThreadController,
    List<ChatMessage>, ChatThreadKey>(
  ChatThreadController.new,
);

class ChatThreadController
    extends FamilyAsyncNotifier<List<ChatMessage>, ChatThreadKey> {
  @override
  Future<List<ChatMessage>> build(ChatThreadKey key) async {
    ref.listen<ChatMessage?>(incomingMessageProvider, (_, message) {
      if (message != null) {
        _maybeAppend(message);
      }
    });
    final repo = ref.read(chatRepositoryProvider);
    final messages = await repo.fetchMessages(
      peerUserId: key.peerUserId,
      requestId: key.requestId,
    );
    unawaited(
      repo.markThreadRead(
        peerUserId: key.peerUserId,
        requestId: key.requestId,
      ),
    );
    ref.invalidate(chatThreadsProvider);
    return messages;
  }

  void _maybeAppend(ChatMessage msg) {
    // Only append incoming messages from the peer; our own outgoing sends are
    // appended directly by [send] after the POST returns.
    if (msg.requestId != arg.requestId) return;
    if (msg.senderId != arg.peerUserId) return;
    final current = state.valueOrNull ?? const <ChatMessage>[];
    if (current.any((m) => m.id == msg.id)) return;
    state = AsyncData([...current, msg]);
    unawaited(
      ref.read(chatRepositoryProvider).markThreadRead(
            peerUserId: arg.peerUserId,
            requestId: arg.requestId,
          ),
    );
    ref.invalidate(chatThreadsProvider);
  }

  Future<void> send(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    final repo = ref.read(chatRepositoryProvider);
    final sent = await repo.sendMessage(
      peerUserId: arg.peerUserId,
      requestId: arg.requestId,
      content: trimmed,
    );
    final current = state.valueOrNull ?? const <ChatMessage>[];
    if (current.any((m) => m.id == sent.id)) return;
    state = AsyncData([...current, sent]);
    ref.invalidate(chatThreadsProvider);
  }
}
