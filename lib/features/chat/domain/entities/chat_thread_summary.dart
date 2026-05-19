class ChatThreadSummary {
  const ChatThreadSummary({
    required this.threadId,
    required this.peerUserId,
    required this.peerName,
    required this.requestId,
    required this.requestTitle,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.timeLabel,
    required this.unreadCount,
    required this.isUnread,
  });

  final String threadId;
  final String peerUserId;
  final String peerName;
  final String requestId;
  final String requestTitle;
  final String lastMessage;
  final DateTime lastMessageAt;
  final String timeLabel;
  final int unreadCount;
  final bool isUnread;

  factory ChatThreadSummary.fromMap(Map<String, dynamic> map) {
    final rawDate = map['lastMessageAt'] as String?;
    final parsedDate = rawDate == null ? null : DateTime.tryParse(rawDate);
    return ChatThreadSummary(
      threadId: map['threadId'] as String? ?? '',
      peerUserId: map['peerUserId'] as String? ?? '',
      peerName: map['peerName'] as String? ?? 'Conversation',
      requestId: map['requestId'] as String? ?? '',
      requestTitle: map['requestTitle'] as String? ?? 'Request',
      lastMessage: map['lastMessage'] as String? ?? '',
      lastMessageAt: parsedDate ?? DateTime.now(),
      timeLabel: map['timeLabel'] as String? ?? '',
      unreadCount: map['unreadCount'] as int? ?? 0,
      isUnread: map['isUnread'] as bool? ?? false,
    );
  }
}
