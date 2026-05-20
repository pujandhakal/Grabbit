import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/application/app_data_refresh.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/network/connectivity_status.dart';
import 'package:grabbit/core/widgets/app_error_state.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/chat/data/repositories/chat_repository.dart';
import 'package:grabbit/features/chat/domain/entities/chat_thread_summary.dart';

class ChatThreadsView extends ConsumerStatefulWidget {
  const ChatThreadsView({
    required this.title,
    required this.subtitle,
    required this.detailRoute,
    this.emptyMessage = 'No conversations yet.',
    this.searchHint = 'Search by shop, request, or message...',
    super.key,
  });

  final String title;
  final String subtitle;
  final String detailRoute;
  final String emptyMessage;
  final String searchHint;

  @override
  ConsumerState<ChatThreadsView> createState() => _ChatThreadsViewState();
}

class _ChatThreadsViewState extends ConsumerState<ChatThreadsView> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final threads = ref.watch(chatThreadsProvider);
    final hasNetwork = ref.watch(networkConnectionProvider).valueOrNull ?? true;

    return AppStickyPage(
      bottomSafeArea: true,
      header: AppScreenHeader(
        title: widget.title,
        subtitle: widget.subtitle,
        bottom: AppSurfaceCard(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _query = value.trim();
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _query = '';
                          });
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                hintText: widget.searchHint,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
        ),
      ),
      child: !hasNetwork
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AppErrorState.offline(
                  onRetry: () => refreshSignedInData(ref),
                ),
              ),
            )
          : threads.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: AppErrorState.fromError(
                    error: error,
                    fallbackTitle: 'Unable to load chats',
                    fallbackMessage: 'Unable to load chats.',
                    onRetry: () => refreshSignedInData(ref),
                  ),
                ),
              ),
              data: (items) {
                final filtered = _filtered(items);
                if (items.isEmpty) {
                  return _EmptyChatState(message: widget.emptyMessage);
                }
                if (filtered.isEmpty) {
                  return _EmptyChatState(
                    message: 'No chats found for "$_query".',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(chatThreadsProvider);
                    await ref.read(chatThreadsProvider.future);
                  },
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
                    children: [
                      AppSectionHeader(
                        title: 'Recent conversations (${filtered.length})',
                      ),
                      const SizedBox(height: 14),
                      for (final thread in filtered) ...[
                        _ChatThreadTile(
                          thread: thread,
                          onTap: () => _openThread(context, thread),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }

  List<ChatThreadSummary> _filtered(List<ChatThreadSummary> items) {
    if (_query.isEmpty) {
      return items;
    }
    final normalizedQuery = _query.toLowerCase();
    return items.where((thread) {
      return thread.peerName.toLowerCase().contains(normalizedQuery) ||
          thread.requestTitle.toLowerCase().contains(normalizedQuery) ||
          thread.lastMessage.toLowerCase().contains(normalizedQuery);
    }).toList(growable: false);
  }

  void _openThread(BuildContext context, ChatThreadSummary thread) {
    context.push(
      '${widget.detailRoute}'
      '?peerUserId=${thread.peerUserId}'
      '&requestId=${thread.requestId}'
      '&peer=${Uri.encodeComponent(thread.peerName)}',
    );
  }
}

class _ChatThreadTile extends StatelessWidget {
  const _ChatThreadTile({
    required this.thread,
    required this.onTap,
  });

  final ChatThreadSummary thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initial =
        thread.peerName.isEmpty ? '?' : thread.peerName.characters.first;

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
                  backgroundColor: thread.isUnread
                      ? AppColors.primary
                      : AppColors.primarySoft,
                  child: Text(
                    initial,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: thread.isUnread
                              ? Colors.white
                              : AppColors.primaryDark,
                        ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              thread.peerName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: thread.isUnread
                                        ? FontWeight.w800
                                        : FontWeight.w700,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            thread.timeLabel,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        thread.requestTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              thread.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: thread.isUnread
                                        ? AppColors.text
                                        : AppColors.textMuted,
                                    fontWeight: thread.isUnread
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                            ),
                          ),
                          if (thread.unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            AppStatusChip(
                              label: thread.unreadCount > 9
                                  ? '9+'
                                  : thread.unreadCount.toString(),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyChatState extends StatelessWidget {
  const _EmptyChatState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
