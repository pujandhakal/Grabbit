import 'package:flutter/material.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/features/chat/presentation/widgets/chat_threads_view.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ChatThreadsView(
        title: 'Chats',
        subtitle: 'Follow up on offers and confirm orders quickly.',
        detailRoute: RoutePaths.chatDetail,
        emptyMessage:
            'No conversations yet. Message a shop from a response to start chatting.',
      ),
    );
  }
}
