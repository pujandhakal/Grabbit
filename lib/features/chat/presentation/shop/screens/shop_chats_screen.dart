import 'package:flutter/material.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/features/chat/presentation/widgets/chat_threads_view.dart';

class ShopChatsScreen extends StatelessWidget {
  const ShopChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatThreadsView(
      title: 'Shop Chats',
      subtitle: 'Customer conversations about requests and offers.',
      detailRoute: RoutePaths.shopChatDetail,
      searchHint: 'Search by customer, request, or message...',
      emptyMessage:
          'No conversations yet. Respond to a request, then customers can message you.',
    );
  }
}
