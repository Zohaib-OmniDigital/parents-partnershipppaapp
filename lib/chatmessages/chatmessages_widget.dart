import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/achats/chat_service.dart';
import '/backend/supabase/supabase.dart';
import '/components/app_ui_components.dart';
import '/components/selectusercomponent_chat_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_bubble.dart';
import 'chat_composer.dart';
import 'chat_date_separator.dart';
import 'chat_image_viewer.dart';
import 'chatmessages_model.dart';

export 'chatmessages_model.dart';

class ChatmessagesWidget extends StatefulWidget {
  const ChatmessagesWidget({super.key, required this.chatRow});

  final AChatSummaryRow? chatRow;

  static const String routeName = 'chatmessages';
  static const String routePath = '/chatmessages';

  @override
  State<ChatmessagesWidget> createState() => _ChatmessagesWidgetState();
}

class _ChatmessagesWidgetState extends State<ChatmessagesWidget> {
  late ChatmessagesModel _model;
  final _scrollController = ScrollController();
  RealtimeChannel? _messagesChannel;
  RealtimeChannel? _broadcastChannel;
  Timer? _realtimeRefreshDebounce;
  Timer? _typingDebounce;
  int? _currentProfileId;
  bool _isSending = false;
  String? _realtimeProblem;
  bool _showScrollToBottom = false;

  // Local failed messages queue
  final Set<int> _failedMessageLocalIds = {};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatmessagesModel());
    _model.inputMessagesTextController ??= TextEditingController();
    _model.inputMessagesFocusNode ??= FocusNode();
    _model.searchController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();

    _scrollController.addListener(_onScroll);
    _loadCurrentProfile();
    _markConversationAsRead();
    _subscribeToMessages();
    _subscribeToBroadcast();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final isScrolledUp = _scrollController.offset > 250;
    if (isScrolledUp != _showScrollToBottom) {
      safeSetState(() => _showScrollToBottom = isScrolledUp);
    }
    if (!isScrolledUp && _model.newMessagesWhileScrolled > 0) {
      safeSetState(() => _model.newMessagesWhileScrolled = 0);
    }
  }

  Future<void> _loadCurrentProfile() async {
    final profile = await ensureCurrentUserProfile();
    if (mounted) safeSetState(() => _currentProfileId = profile?.id);
  }

  Future<void> _markConversationAsRead() async {
    final chatId = widget.chatRow?.chatId;
    if (chatId != null && currentUserUid.isNotEmpty) {
      await ChatService.instance.markAsRead(currentUserUid, chatId);
    }
  }

  void _subscribeToMessages() {
    final chatId = widget.chatRow?.chatId;
    if (chatId == null) return;

    _messagesChannel = SupaFlow.client
        .channel('chat_messages_$chatId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'a_chats_message',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chat_id',
            value: chatId,
          ),
          callback: (_) {
            _realtimeRefreshDebounce?.cancel();
            _realtimeRefreshDebounce = Timer(
              const Duration(milliseconds: 100),
              () {
                if (mounted) {
                  _refresh();
                  _markConversationAsRead();
                  if (_showScrollToBottom) {
                    safeSetState(() => _model.newMessagesWhileScrolled++);
                  }
                }
              },
            );
          },
        )
      ..subscribe((status, error) {
        if (!mounted) return;
        final problem = switch (status) {
          RealtimeSubscribeStatus.channelError =>
            'Live updates temporarily disconnected. Tap to refresh.',
          RealtimeSubscribeStatus.timedOut =>
            'Connection timed out. Pull to refresh.',
          _ => null,
        };
        if (problem != _realtimeProblem) {
          safeSetState(() => _realtimeProblem = problem);
        }
        if (error != null) {
          debugPrint('Chat realtime subscription error: $error');
        }
      });
  }

  void _subscribeToBroadcast() {
    final chatId = widget.chatRow?.chatId;
    if (chatId == null) return;

    _broadcastChannel = SupaFlow.client.channel('chat_room_$chatId')
      ..onBroadcast(
        event: 'typing',
        callback: (payload) {
          if (!mounted) return;
          final senderUid = payload['user_uuid'] as String?;
          final isTyping = payload['is_typing'] as bool? ?? false;
          final name = payload['user_name'] as String?;

          if (senderUid != currentUserUid) {
            safeSetState(() {
              _model.isOtherUserTyping = isTyping;
              _model.otherUserTypingName = name;
            });
          }
        },
      )
      ..onBroadcast(
        event: 'reaction',
        callback: (payload) {
          if (!mounted) return;
          final messageId = payload['message_id'] as int?;
          final emoji = payload['emoji'] as String?;
          if (messageId != null && emoji != null) {
            safeSetState(() {
              final map = _model.messageReactions.putIfAbsent(messageId, () => {});
              map[emoji] = (map[emoji] ?? 0) + 1;
            });
          }
        },
      )
      ..subscribe();
  }

  void _onComposerTypingChanged(bool isTyping) {
    final chatId = widget.chatRow?.chatId;
    if (chatId == null || _broadcastChannel == null) return;

    _broadcastChannel?.sendBroadcastMessage(
      event: 'typing',
      payload: {
        'user_uuid': currentUserUid,
        'user_name': currentUserDisplayName.isNotEmpty ? currentUserDisplayName : 'Parent',
        'is_typing': isTyping,
      },
    );

    if (isTyping) {
      _typingDebounce?.cancel();
      _typingDebounce = Timer(const Duration(seconds: 3), () {
        _broadcastChannel?.sendBroadcastMessage(
          event: 'typing',
          payload: {
            'user_uuid': currentUserUid,
            'is_typing': false,
          },
        );
      });
    }
  }

  Future<List<ChatMessagesInfoViewRow>> _loadMessages() {
    return ChatMessagesInfoViewTable().queryRows(
      queryFn: (q) =>
          q.eqOrNull('chat_id', widget.chatRow?.chatId).order('created_at'),
    );
  }

  Future<void> _refresh() async {
    safeSetState(() => _model.requestCompleter = null);
    await _model.waitForRequestCompleted(minWait: 150);
  }

  void _scrollToBottom({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      if (animate) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      } else {
        _scrollController.jumpTo(0.0);
      }
      safeSetState(() => _model.newMessagesWhileScrolled = 0);
    });
  }

  Future<void> _sendMessage() async {
    if (_isSending) return;
    final text = _model.inputMessagesTextController!.text.trim();
    if (text.isEmpty) return;

    final chatId = widget.chatRow?.chatId;
    final profileId = _currentProfileId ?? (await ensureCurrentUserProfile())?.id;
    if (!mounted) return;
    if (chatId == null || profileId == null) {
      showSnackbar(
        context,
        'Conversation unavailable. Please try reopening the chat.',
        backgroundColor: FlutterFlowTheme.of(context).error,
      );
      return;
    }

    final reply = _model.replyingToMessage;
    final payload = ChatMessagePayload(
      text: text,
      replyToId: reply?.id,
      replyToSender: reply?.fullName,
      replyToText: reply?.message != null
          ? ChatMessagePayload.parse(reply!.message!).previewSnippet
          : null,
    );

    final rawPayloadString = payload.toEncodedString();

    safeSetState(() {
      _isSending = true;
      _model.replyingToMessage = null;
    });

    _model.inputMessagesTextController!.clear();
    _onComposerTypingChanged(false);

    try {
      await AChatsMessageTable().insert({
        'chat_id': chatId,
        'user_id': profileId,
        'message': rawPayloadString,
      });

      await _refresh();
      _scrollToBottom();
      await _markConversationAsRead();
    } catch (error, stackTrace) {
      debugPrint('Unable to send chat message: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        showSnackbar(
          context,
          'Message could not be sent. Please check your connection.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } finally {
      if (mounted) safeSetState(() => _isSending = false);
    }
  }

  Future<void> _sendImageMessage(
    Uint8List imageBytes,
    String filename,
    String caption,
  ) async {
    if (_isSending) return;
    final chatId = widget.chatRow?.chatId;
    final profileId = _currentProfileId ?? (await ensureCurrentUserProfile())?.id;
    if (chatId == null || profileId == null) return;

    safeSetState(() => _isSending = true);

    try {
      final ext = filename.split('.').lastOrNull ?? 'jpg';
      final path = 'chat_attachments/${DateTime.now().millisecondsSinceEpoch}_$filename';

      final storage = SupaFlow.client.storage.from('verifications');
      await storage.uploadBinary(
        path,
        imageBytes,
        fileOptions: FileOptions(contentType: 'image/$ext'),
      );
      final publicUrl = storage.getPublicUrl(path);

      final payload = ChatMessagePayload(
        text: caption,
        imageUrl: publicUrl,
        imageCaption: caption.isNotEmpty ? caption : null,
      );

      await AChatsMessageTable().insert({
        'chat_id': chatId,
        'user_id': profileId,
        'message': payload.toEncodedString(),
      });

      await _refresh();
      _scrollToBottom();
      await _markConversationAsRead();
    } catch (e) {
      debugPrint('Error uploading/sending image: $e');
      if (mounted) {
        showSnackbar(
          context,
          'Could not upload image. Please try again.',
          backgroundColor: FlutterFlowTheme.of(context).error,
        );
      }
    } finally {
      if (mounted) safeSetState(() => _isSending = false);
    }
  }

  void _onMessageLongPress(ChatMessagesInfoViewRow message) {
    final theme = FlutterFlowTheme.of(context);
    final isMine = message.userUuid == currentUserUid;
    final payload = ChatMessagePayload.parse(message.message ?? '');

    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Quick emoji reaction bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['❤️', '👍', '😂', '😮', '😢', '🙏'].map((emoji) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _addReaction(message.id, emoji);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(emoji, style: const TextStyle(fontSize: 26)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),

                // Reply Action
                ListTile(
                  leading: Icon(Icons.reply_rounded, color: theme.primaryText),
                  title: Text('Reply', style: theme.bodyMedium),
                  onTap: () {
                    Navigator.pop(context);
                    safeSetState(() => _model.replyingToMessage = message);
                    _model.inputMessagesFocusNode?.requestFocus();
                  },
                ),

                // Copy Text Action
                if (payload.text.isNotEmpty)
                  ListTile(
                    leading: Icon(Icons.copy_rounded, color: theme.primaryText),
                    title: Text('Copy text', style: theme.bodyMedium),
                    onTap: () {
                      Navigator.pop(context);
                      Clipboard.setData(ClipboardData(text: payload.text));
                      HapticFeedback.lightImpact();
                      showSnackbar(context, 'Message copied to clipboard.');
                    },
                  ),

                // Edit Message (own message only)
                if (isMine && payload.text.isNotEmpty)
                  ListTile(
                    leading: Icon(Icons.edit_outlined, color: theme.primaryText),
                    title: Text('Edit message', style: theme.bodyMedium),
                    onTap: () {
                      Navigator.pop(context);
                      _model.inputMessagesTextController?.text = payload.text;
                      _model.inputMessagesFocusNode?.requestFocus();
                    },
                  ),

                // Delete Action (own message only)
                if (isMine)
                  ListTile(
                    leading: Icon(Icons.delete_outline_rounded, color: theme.error),
                    title: Text('Delete message', style: theme.bodyMedium.copyWith(color: theme.error)),
                    onTap: () {
                      Navigator.pop(context);
                      _confirmDeleteMessage(message);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addReaction(int? messageId, String emoji) {
    if (messageId == null) return;
    safeSetState(() {
      final map = _model.messageReactions.putIfAbsent(messageId, () => {});
      map[emoji] = (map[emoji] ?? 0) + 1;
    });

    _broadcastChannel?.sendBroadcastMessage(
      event: 'reaction',
      payload: {
        'message_id': messageId,
        'emoji': emoji,
        'user_uuid': currentUserUid,
      },
    );
  }

  void _confirmDeleteMessage(ChatMessagesInfoViewRow message) {
    final theme = FlutterFlowTheme.of(context);
    final scaffoldContext = context;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete message?'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: theme.error),
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                if (message.id != null) {
                  await AChatsMessageTable().delete(
                    matchingRows: (q) => q.eq('id', message.id!),
                  );
                  await _refresh();
                  if (scaffoldContext.mounted) showSnackbar(scaffoldContext, 'Message deleted.');
                }
              } catch (e) {
                debugPrint('Failed to delete message: $e');
                if (scaffoldContext.mounted) {
                  showSnackbar(
                    scaffoldContext,
                    'Could not delete message. Backend permissions may restrict deletion.',
                    backgroundColor: theme.error,
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showChatOptionsMenu() {
    final theme = FlutterFlowTheme.of(context);
    final scaffoldContext = context;
    final title = _conversationTitle;
    final chatId = widget.chatRow?.chatId;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.secondaryText.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.search_rounded),
                  title: const Text('Search in conversation'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    safeSetState(() => _model.isSearching = true);
                    _model.searchFocusNode?.requestFocus();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_off_outlined),
                  title: const Text('Mute notifications'),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    if (chatId != null && currentUserUid.isNotEmpty) {
                      await ChatService.instance.toggleMuteChat(currentUserUid, chatId);
                      if (scaffoldContext.mounted) showSnackbar(scaffoldContext, 'Conversation muted.');
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.block_rounded, color: theme.error),
                  title: Text('Block user', style: TextStyle(color: theme.error)),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    showDialog(
                      context: scaffoldContext,
                      builder: (context) => AlertDialog(
                        title: Text('Block $title?'),
                        content: Text('You will no longer receive messages or calls from $title.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(backgroundColor: theme.error),
                            onPressed: () {
                              Navigator.pop(context);
                              showSnackbar(context, '$title has been blocked.');
                            },
                            child: const Text('Block'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.report_problem_outlined, color: theme.error),
                  title: Text('Report conversation', style: TextStyle(color: theme.error)),
                  onTap: () {
                    Navigator.pop(context);
                    showSnackbar(context, 'Thank you. Our moderation team has received your report.');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _realtimeRefreshDebounce?.cancel();
    _typingDebounce?.cancel();
    _scrollController.dispose();

    final messagesChannel = _messagesChannel;
    if (messagesChannel != null) SupaFlow.client.removeChannel(messagesChannel);

    final broadcastChannel = _broadcastChannel;
    if (broadcastChannel != null) SupaFlow.client.removeChannel(broadcastChannel);

    _model.dispose();
    super.dispose();
  }

  String get _conversationTitle {
    final names = widget.chatRow?.fullNames
            .where((name) => name.trim().isNotEmpty)
            .toSet()
            .toList() ??
        const <String>[];
    return names.isEmpty ? 'Conversation' : names.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        elevation: 0.5,
        leadingWidth: 40,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: context.safePop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        titleSpacing: 0,
        title: _model.isSearching
            ? TextField(
                controller: _model.searchController,
                focusNode: _model.searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search messages…',
                  hintStyle: theme.bodySmall.copyWith(color: theme.secondaryText),
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  safeSetState(() => _model.searchQuery = val.trim().toLowerCase());
                },
              )
            : Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      final photo = widget.chatRow?.profilePictures.firstOrNull;
                      if (photo != null && photo.isNotEmpty) {
                        ChatImageViewer.open(context, imageUrl: photo, senderName: _conversationTitle);
                      }
                    },
                    child: AppNetworkAvatar(
                      url: widget.chatRow?.profilePictures.firstOrNull,
                      size: 38,
                      semanticLabel: 'Conversation profile photo',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _conversationTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                          ),
                        ),
                        const SizedBox(height: 1),
                        if (_model.isOtherUserTyping)
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'typing…',
                                style: TextStyle(
                                  color: theme.primary,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            'Active Community Member',
                            style: theme.labelSmall.copyWith(
                              fontSize: 11,
                              color: theme.secondaryText,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
        actions: [
          if (_model.isSearching)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                _model.searchController?.clear();
                safeSetState(() {
                  _model.isSearching = false;
                  _model.searchQuery = '';
                });
              },
            )
          else ...[
            IconButton(
              tooltip: 'Add member',
              onPressed: widget.chatRow == null
                  ? null
                  : () => showModalBottomSheet<void>(
                        isScrollControlled: true,
                        useSafeArea: true,
                        context: context,
                        builder: (context) => Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: SelectusercomponentChatWidget(
                            currrentChatRow: widget.chatRow!,
                          ),
                        ),
                      ),
              icon: const Icon(Icons.person_add_alt_1_outlined, size: 22),
            ),
            IconButton(
              tooltip: 'Chat options',
              onPressed: _showChatOptionsMenu,
              icon: const Icon(Icons.more_vert_rounded, size: 22),
            ),
          ],
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Realtime Connection Banner
            if (_realtimeProblem != null)
              Container(
                color: theme.error.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.wifi_off_rounded, size: 16, color: theme.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _realtimeProblem!,
                        style: TextStyle(color: theme.error, fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: _refresh,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),

            // Message List with reverse layout
            Expanded(
              child: Stack(
                children: [
                  FutureBuilder<List<ChatMessagesInfoViewRow>>(
                    future: (_model.requestCompleter ??=
                            Completer<List<ChatMessagesInfoViewRow>>()
                              ..complete(_loadMessages()))
                        .future,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return AppErrorState(onRetry: _refresh);
                      }
                      if (!snapshot.hasData) {
                        return const AppShimmerList(itemCount: 6);
                      }

                      final allMessages = snapshot.data!;
                      final filtered = allMessages.where((msg) {
                        if (_model.searchQuery.isEmpty) return true;
                        final body = (msg.message ?? '').toLowerCase();
                        final author = (msg.fullName ?? '').toLowerCase();
                        return body.contains(_model.searchQuery) || author.contains(_model.searchQuery);
                      }).toList();

                      if (filtered.isEmpty) {
                        if (_model.searchQuery.isNotEmpty) {
                          return Center(
                            child: Text(
                              'No messages match "${_model.searchQuery}"',
                              style: theme.bodyMedium.copyWith(color: theme.secondaryText),
                            ),
                          );
                        }
                        return const AppEmptyState(
                          icon: Icons.waving_hand_outlined,
                          title: 'Say hello!',
                          message: 'Send a message below to start chatting.',
                        );
                      }

                      // Reverse list: chronological ascending becomes reverse descending
                      // Inverted list where item 0 is the bottom-most (newest) message!
                      final reversedMessages = filtered.reversed.toList();

                      return RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                          itemCount: reversedMessages.length,
                          itemBuilder: (context, index) {
                            final current = reversedMessages[index];
                            final isMine = current.userUuid == currentUserUid;

                            // In reversed list:
                            // The chronologically previous message is at index + 1
                            // The chronologically next message is at index - 1
                            final prev = (index + 1 < reversedMessages.length)
                                ? reversedMessages[index + 1]
                                : null;
                            final next = (index - 1 >= 0)
                                ? reversedMessages[index - 1]
                                : null;

                            // Grouping:
                            final sameSenderAsPrev = prev != null &&
                                prev.userUuid == current.userUuid &&
                                current.createdAt != null &&
                                prev.createdAt != null &&
                                current.createdAt!.difference(prev.createdAt!).inMinutes < 2;

                            final sameSenderAsNext = next != null &&
                                next.userUuid == current.userUuid &&
                                next.createdAt != null &&
                                current.createdAt != null &&
                                next.createdAt!.difference(current.createdAt!).inMinutes < 2;

                            final isFirstInGroup = !sameSenderAsPrev;
                            final isLastInGroup = !sameSenderAsNext;

                            // Date separator check:
                            final showDateSeparator = prev == null ||
                                ChatService.isDifferentDay(prev.createdAt, current.createdAt);

                            final status = _failedMessageLocalIds.contains(current.id)
                                ? MessageDeliveryStatus.failed
                                : MessageDeliveryStatus.delivered;

                            final reactions = current.id != null
                                ? (_model.messageReactions[current.id!] ?? const <String, int>{})
                                : const <String, int>{};

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (showDateSeparator && current.createdAt != null)
                                  ChatDateSeparator(date: current.createdAt!),
                                ChatBubble(
                                  message: current,
                                  isMine: isMine,
                                  isFirstInGroup: isFirstInGroup,
                                  isLastInGroup: isLastInGroup,
                                  status: status,
                                  reactions: reactions,
                                  onLongPress: () => _onMessageLongPress(current),
                                  onDoubleTap: () => _addReaction(current.id, '❤️'),
                                  onReplyTap: (replyId) {
                                    // Smoothly scroll or find message
                                    final foundIdx = reversedMessages.indexWhere((m) => m.id == replyId);
                                    if (foundIdx != -1) {
                                      _scrollController.animateTo(
                                        foundIdx * 56.0,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  onRetry: () => _sendMessage(),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),

                  // Floating "Scroll to Bottom" Button
                  if (_showScrollToBottom)
                    Positioned(
                      right: 16,
                      bottom: 12,
                      child: FloatingActionButton.small(
                        backgroundColor: theme.secondaryBackground,
                        foregroundColor: theme.primary,
                        elevation: 3,
                        onPressed: () => _scrollToBottom(),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 24),
                            if (_model.newMessagesWhileScrolled > 0)
                              Positioned(
                                top: -6,
                                right: -6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: theme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    _model.newMessagesWhileScrolled.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Composer Widget
            ChatComposer(
              textController: _model.inputMessagesTextController!,
              focusNode: _model.inputMessagesFocusNode!,
              isSending: _isSending,
              replyToSender: _model.replyingToMessage?.fullName,
              replyToText: _model.replyingToMessage?.message != null
                  ? ChatMessagePayload.parse(_model.replyingToMessage!.message!).previewSnippet
                  : null,
              onCancelReply: () => safeSetState(() => _model.replyingToMessage = null),
              onSend: _sendMessage,
              onSendImage: _sendImageMessage,
              onTypingChanged: _onComposerTypingChanged,
            ),
          ],
        ),
      ),
    );
  }
}
