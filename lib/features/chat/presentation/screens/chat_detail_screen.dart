import 'package:flutter/material.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_soft_background.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({
    required this.shopName,
    super.key,
  });

  final String shopName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppSoftBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: AppSurfaceCard(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.chevron_left_rounded),
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primarySoft,
                        child: Text(
                          shopName.characters.first,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.primaryDark,
                                  ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(shopName,
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(
                              'Delivery is given on time',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.more_horiz_rounded),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  children: const [
                    _MessageBubble(
                      alignRight: false,
                      message:
                          'We can arrange same-day pickup if you confirm before 6 PM.',
                    ),
                    SizedBox(height: 12),
                    _MessageBubble(
                      alignRight: true,
                      message: 'That works. Can you share the final price?',
                    ),
                    SizedBox(height: 12),
                    _MessageBubble(
                      alignRight: false,
                      message:
                          'Final price is NPR 5,200 with the charger included.',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: AppSurfaceCard(
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: null,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Icon(Icons.send_outlined),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.alignRight,
    required this.message,
  });

  final bool alignRight;
  final String message;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = alignRight ? AppColors.primary : Colors.white;
    final textColor = alignRight ? Colors.white : AppColors.text;

    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: alignRight
              ? null
              : [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
        ),
      ),
    );
  }
}
