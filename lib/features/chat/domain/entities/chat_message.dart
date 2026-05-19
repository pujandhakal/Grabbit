class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.threadId,
    required this.requestId,
    required this.senderId,
    required this.content,
    required this.sentAt,
  });

  final String id;
  final String threadId;
  final String requestId;
  final String senderId;
  final String content;
  final DateTime sentAt;

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final raw = map['sentAt'] as String?;
    final parsed = raw == null ? null : DateTime.tryParse(raw);
    return ChatMessage(
      id: map['id'] as String? ?? '',
      threadId: map['threadId'] as String? ?? '',
      requestId: map['requestId'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      content: map['content'] as String? ?? '',
      sentAt: parsed ?? DateTime.now(),
    );
  }
}
