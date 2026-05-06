import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_soft_background.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppSoftBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 130),
            children: [
              const Text(
                'Chats',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Follow up on offers and confirm orders quickly.',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 18),
              AppSurfaceCard(
                padding: EdgeInsets.zero,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search chats...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const AppSectionHeader(
                title: 'Recent conversations',
                actionLabel: 'View all',
              ),
              const SizedBox(height: 14),
              _ChatListTile(
                shopName: 'Tech Haven',
                message: 'We have your requested laptop in stock.',
                timeStamp: '10:45 AM',
                unreadLabel: 'New',
                onTap: () =>
                    context.push('${RoutePaths.chats}/detail?shop=Tech%20Haven'),
              ),
              const SizedBox(height: 12),
              const _ChatListTile(
                shopName: 'StyleHub Boutique',
                message: 'Your pickup is ready for collection.',
                timeStamp: 'Yesterday',
                unreadLabel: 'Ready',
              ),
              const SizedBox(height: 12),
              const _ChatListTile(
                shopName: 'Book Nook',
                message: 'We found the book you were looking for.',
                timeStamp: 'Yesterday',
                unreadLabel: 'Offer',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatListTile extends StatelessWidget {
  const _ChatListTile({
    required this.shopName,
    required this.message,
    required this.timeStamp,
    required this.unreadLabel,
    this.onTap,
  });

  final String shopName;
  final String message;
  final String timeStamp;
  final String unreadLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primarySoft,
                  child: Text(
                    shopName.characters.first,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primaryDark,
                        ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shopName, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeStamp,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    AppStatusChip(label: unreadLabel, tone: AppStatusTone.primary),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
