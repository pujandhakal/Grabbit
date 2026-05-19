import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';

class ShopChatsScreen extends StatelessWidget {
  const ShopChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStickyPage(
      bottomSafeArea: true,
      header: const AppScreenHeader(
        title: 'Shop Chats',
        subtitle: 'Customer conversations about requests and offers.',
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: const [
          _ShopChatTile(
            customerName: 'Pujan Dhakal',
            message: 'Can I pick up the hoodie this evening?',
          ),
          SizedBox(height: 12),
          _ShopChatTile(
            customerName: 'Aarav Shrestha',
            message: 'Is the keyboard available with warranty?',
          ),
        ],
      ),
    );
  }
}

class _ShopChatTile extends StatelessWidget {
  const _ShopChatTile({
    required this.customerName,
    required this.message,
  });

  final String customerName;
  final String message;

  @override
  Widget build(BuildContext context) {
    final encodedName = Uri.encodeComponent(customerName);

    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => context.push(
          '${RoutePaths.shopChatDetail}?shop=$encodedName',
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(child: Text(customerName.characters.first)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(message,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
