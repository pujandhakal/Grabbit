import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/widgets/app_soft_background.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:grabbit/features/chat/domain/entities/chat_message.dart';
import 'package:grabbit/features/chat/presentation/controllers/chat_thread_controller.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  const ChatDetailScreen({
    required this.peerName,
    this.peerUserId,
    this.requestId,
    super.key,
  });

  final String peerName;
  final String? peerUserId;
  final String? requestId;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _sending = false;
  int _renderedCount = 0;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _sending) return;
    final peerUserId = widget.peerUserId;
    final requestId = widget.requestId;
    if (peerUserId == null || requestId == null) return;

    setState(() {
      _sending = true;
    });
    try {
      await ref
          .read(chatThreadProvider(
            (peerUserId: peerUserId, requestId: requestId),
          ).notifier)
          .send(text);
      _inputController.clear();
    } catch (error) {
      if (!mounted) return;
      final message =
          error is AppException ? error.message : 'Could not send message.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final peerUserId = widget.peerUserId;
    final requestId = widget.requestId;
    final currentUser = ref.watch(authControllerProvider).valueOrNull;
    final isMissingContext = peerUserId == null ||
        peerUserId.isEmpty ||
        requestId == null ||
        requestId.isEmpty;

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
                          widget.peerName.isEmpty
                              ? '?'
                              : widget.peerName.characters.first,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.primaryDark,
                                  ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.peerName.isEmpty
                              ? 'Conversation'
                              : widget.peerName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: isMissingContext
                    ? _EmptyState(
                        message:
                            'No conversation selected. Open chat from a response.',
                      )
                    : _buildThread(
                        peerUserId: peerUserId,
                        requestId: requestId,
                        currentUserId: currentUser?.id ?? '',
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: AppSurfaceCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          enabled: !isMissingContext,
                          minLines: 1,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            filled: false,
                          ),
                          onSubmitted: (_) => _send(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: isMissingContext || _sending ? null : _send,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _sending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send_outlined),
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

  Widget _buildThread({
    required String peerUserId,
    required String requestId,
    required String currentUserId,
  }) {
    final threadAsync = ref.watch(
      chatThreadProvider((peerUserId: peerUserId, requestId: requestId)),
    );

    return threadAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _EmptyState(
        message: 'Could not load messages.\n${error.toString()}',
      ),
      data: (messages) {
        if (messages.length != _renderedCount) {
          _renderedCount = messages.length;
          _scrollToBottom();
        }
        if (messages.isEmpty) {
          return _EmptyState(
            message: 'No messages yet. Say hi to ${widget.peerName}.',
          );
        }
        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          itemCount: messages.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final msg = messages[index];
            return _MessageBubble(
              message: msg,
              isMine: msg.senderId == currentUserId,
            );
          },
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMine});

  final ChatMessage message;
  final bool isMine;

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMine ? AppColors.primary : Colors.white;
    final textColor = isMine ? Colors.white : AppColors.text;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isMine
              ? null
              : [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.sentAt.toLocal()),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isMine
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.textMuted,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

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
