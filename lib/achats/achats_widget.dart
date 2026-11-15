import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/app_ui_components.dart';
import '/components/selectusercomponent_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'achats_model.dart';
import 'chat_inbox_tile.dart';
import 'chat_service.dart';

export 'achats_model.dart';

class AchatsWidget extends StatefulWidget {
  const AchatsWidget({super.key});

  static String routeName = 'achats';
  static String routePath = '/achats';

  @override
  State<AchatsWidget> createState() => _AchatsWidgetState();
}

class _AchatsWidgetState extends State<AchatsWidget> {
  late AchatsModel _model;
  RealtimeChannel? _chatsChannel;
  Timer? _realtimeRefreshDebounce;
  int? _currentProfileId;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AchatsModel());
    _loadInitialData();
    _subscribeToChatChanges();
  }

  Future<void> _loadInitialData() async {
    final profile = await ensureCurrentUserProfile();
    if (!mounted) return;
    _currentProfileId = profile?.id;
    if (currentUserUid.isNotEmpty) {
      _model.pinnedChatIds = await ChatService.instance.getPinnedChats(currentUserUid);
      _model.mutedChatIds = await ChatService.instance.getMutedChats(currentUserUid);
      _model.archivedChatIds = await ChatService.instance.getArchivedChats(currentUserUid);
    }
    safeSetState(() {});
  }

  void _subscribeToChatChanges() {
    _chatsChannel = SupaFlow.client
        .channel('chat_list_${currentUserUid.isNotEmpty ? currentUserUid : 'guest'}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'a_chats',
          callback: (_) => _scheduleRealtimeRefresh(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'a_chats_users',
          callback: (_) => _scheduleRealtimeRefresh(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'a_chats_message',
          callback: (_) => _scheduleRealtimeRefresh(),
        )
      ..subscribe((status, error) {
        if (error != null) {
          debugPrint('Inbox realtime subscription error: $error');
        }
      });
  }

  void _scheduleRealtimeRefresh() {
    _realtimeRefreshDebounce?.cancel();
    _realtimeRefreshDebounce = Timer(
      const Duration(milliseconds: 200),
      () {
        if (mounted) _refreshChats();
      },
    );
  }

  Future<void> _refreshChats() async {
    final completer = Completer<List<AChatSummaryRow>>()
      ..complete(_loadCurrentUserChats());
    safeSetState(() => _model.requestCompleter = completer);
    await completer.future;
  }

  Future<List<AChatSummaryRow>> _loadCurrentUserChats() async {
    final userId = _currentProfileId ?? (await ensureCurrentUserProfile())?.id;
    if (userId == null) return [];
    _currentProfileId = userId;

    final chats = await AChatSummaryTable().queryRows(
      queryFn: (q) => q.containsOrNull('user_ids', [userId]),
    );

    // Compute unread counts for all chats
    final chatIds = chats.map((c) => c.chatId).whereType<int>().toList();
    if (currentUserUid.isNotEmpty) {
      _model.unreadCounts = await ChatService.instance.getUnreadCounts(
        userUuid: currentUserUid,
        currentProfileId: userId,
        chatIds: chatIds,
      );
      _model.pinnedChatIds = await ChatService.instance.getPinnedChats(currentUserUid);
      _model.mutedChatIds = await ChatService.instance.getMutedChats(currentUserUid);
      _model.archivedChatIds = await ChatService.instance.getArchivedChats(currentUserUid);
    }

    // Sort: Pinned first, then by most recent message timestamp descending
    chats.sort((a, b) {
      final aPinned = a.chatId != null && _model.pinnedChatIds.contains(a.chatId);
      final bPinned = b.chatId != null && _model.pinnedChatIds.contains(b.chatId);

      if (aPinned && !bPinned) return -1;
      if (!aPinned && bPinned) return 1;

      final aTime = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });

    return chats;
  }

  Future<void> _openStartChat() async {
    final created = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      context: context,
      builder: (context) => WebViewAware(
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const SelectusercomponentWidget(),
        ),
      ),
    );

    if (created == true && mounted) {
      await _refreshChats();
      if (mounted) showSnackbar(context, 'Conversation started.');
    }
  }

  void _showChatOptionsSheet(AChatSummaryRow chat) {
    final chatId = chat.chatId;
    if (chatId == null) return;

    final theme = FlutterFlowTheme.of(context);
    final isPinned = _model.pinnedChatIds.contains(chatId);
    final isMuted = _model.mutedChatIds.contains(chatId);
    final isArchived = _model.archivedChatIds.contains(chatId);
    final unreadCount = _model.unreadCounts[chatId] ?? 0;
    final title = chat.fullNames.firstOrNull ?? 'Conversation';

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.secondaryText.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: theme.titleSmall.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const Divider(height: 16),
                ListTile(
                  leading: Icon(
                    isPinned ? Icons.push_pin_outlined : Icons.push_pin_rounded,
                    color: theme.primaryText,
                  ),
                  title: Text(isPinned ? 'Unpin chat' : 'Pin chat', style: theme.bodyMedium),
                  onTap: () async {
                    Navigator.pop(context);
                    await ChatService.instance.togglePinChat(currentUserUid, chatId);
                    await _refreshChats();
                  },
                ),
                ListTile(
                  leading: Icon(
                    isMuted ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                    color: theme.primaryText,
                  ),
                  title: Text(isMuted ? 'Unmute notifications' : 'Mute notifications', style: theme.bodyMedium),
                  onTap: () async {
                    Navigator.pop(context);
                    await ChatService.instance.toggleMuteChat(currentUserUid, chatId);
                    await _refreshChats();
                  },
                ),
                ListTile(
                  leading: Icon(
                    unreadCount > 0 ? Icons.mark_chat_read_outlined : Icons.mark_chat_unread_outlined,
                    color: theme.primaryText,
                  ),
                  title: Text(
                    unreadCount > 0 ? 'Mark as read' : 'Mark as unread',
                    style: theme.bodyMedium,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    if (unreadCount > 0) {
                      await ChatService.instance.markAsRead(currentUserUid, chatId);
                    } else {
                      await ChatService.instance.markAsUnread(currentUserUid, chatId);
                    }
                    await _refreshChats();
                  },
                ),
                ListTile(
                  leading: Icon(
                    isArchived ? Icons.unarchive_outlined : Icons.archive_outlined,
                    color: theme.primaryText,
                  ),
                  title: Text(isArchived ? 'Unarchive chat' : 'Archive chat', style: theme.bodyMedium),
                  onTap: () async {
                    Navigator.pop(context);
                    await ChatService.instance.toggleArchiveChat(currentUserUid, chatId);
                    await _refreshChats();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_outline_rounded, color: theme.error),
                  title: Text('Delete conversation', style: theme.bodyMedium.copyWith(color: theme.error)),
                  onTap: () async {
                    Navigator.pop(context);
                    _confirmDeleteChat(chatId, title);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteChat(int chatId, String title) {
    final theme = FlutterFlowTheme.of(context);
    final scaffoldContext = context;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete conversation?'),
        content: Text(
          'Are you sure you want to delete your conversation with $title? This will remove it from your inbox.',
          style: theme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: theme.error),
            onPressed: () async {
              Navigator.pop(dialogContext);
              // Archive/hide locally
              await ChatService.instance.toggleArchiveChat(currentUserUid, chatId);
              await _refreshChats();
              if (scaffoldContext.mounted) showSnackbar(scaffoldContext, 'Conversation removed from inbox.');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _realtimeRefreshDebounce?.cancel();
    final channel = _chatsChannel;
    if (channel != null) SupaFlow.client.removeChannel(channel);
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.secondaryBackground,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          title: Text(
            'Messages',
            style: theme.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                tooltip: 'New Conversation',
                icon: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit_outlined, color: theme.primary, size: 20),
                ),
                onPressed: _openStartChat,
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              // Search Bar
              Container(
                color: theme.secondaryBackground,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.alternate, width: 0.8),
                  ),
                  child: TextField(
                    controller: _model.searchController,
                    focusNode: _model.searchFocusNode,
                    onChanged: (val) {
                      safeSetState(() => _model.searchQuery = val.trim().toLowerCase());
                    },
                    decoration: InputDecoration(
                      hintText: 'Search conversations or messages…',
                      hintStyle: theme.bodySmall.copyWith(
                        color: theme.secondaryText.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.secondaryText.withValues(alpha: 0.7),
                        size: 20,
                      ),
                      suffixIcon: _model.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              color: theme.secondaryText,
                              onPressed: () {
                                _model.searchController?.clear();
                                safeSetState(() => _model.searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),

              // Filter Chips (All, Unread, Archived)
              Container(
                color: theme.secondaryBackground,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Row(
                  children: [
                    _buildFilterChip('All', 'all', theme),
                    const SizedBox(width: 8),
                    _buildFilterChip('Unread', 'unread', theme),
                    const SizedBox(width: 8),
                    _buildFilterChip('Archived', 'archived', theme),
                  ],
                ),
              ),

              // Conversation List
              Expanded(
                child: FutureBuilder<List<AChatSummaryRow>>(
                  future: (_model.requestCompleter ??= Completer<List<AChatSummaryRow>>()
                        ..complete(_loadCurrentUserChats()))
                      .future,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return AppErrorState(onRetry: _refreshChats);
                    }
                    if (!snapshot.hasData) {
                      return const AppShimmerList(itemCount: 6);
                    }

                    final allChats = snapshot.data!;

                    // Filter based on active tab
                    final filteredByTab = allChats.where((chat) {
                      final chatId = chat.chatId;
                      final isArchived = chatId != null && _model.archivedChatIds.contains(chatId);
                      final unreadCount = chatId != null ? (_model.unreadCounts[chatId] ?? 0) : 0;

                      if (_model.activeFilter == 'archived') {
                        return isArchived;
                      }
                      if (isArchived) return false;

                      if (_model.activeFilter == 'unread') {
                        return unreadCount > 0;
                      }
                      return true;
                    }).toList();

                    // Filter by search query if typed
                    final displayChats = filteredByTab.where((chat) {
                      if (_model.searchQuery.isEmpty) return true;
                      final names = chat.fullNames.join(' ').toLowerCase();
                      final message = (chat.lastMessage ?? '').toLowerCase();
                      return names.contains(_model.searchQuery) || message.contains(_model.searchQuery);
                    }).toList();

                    if (displayChats.isEmpty) {
                      if (_model.searchQuery.isNotEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_off_rounded, size: 54, color: theme.secondaryText),
                                const SizedBox(height: 12),
                                Text(
                                  'No results found',
                                  style: theme.titleMedium.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'No conversations match "${_model.searchQuery}"',
                                  textAlign: TextAlign.center,
                                  style: theme.bodySmall.copyWith(color: theme.secondaryText),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (_model.activeFilter == 'archived') {
                        return const AppEmptyState(
                          icon: Icons.archive_outlined,
                          title: 'No archived conversations',
                          message: 'Conversations you archive will appear here.',
                        );
                      }

                      if (_model.activeFilter == 'unread') {
                        return const AppEmptyState(
                          icon: Icons.done_all_rounded,
                          title: 'All caught up!',
                          message: 'You have no unread messages right now.',
                        );
                      }

                      return AppEmptyState(
                        icon: Icons.forum_outlined,
                        title: 'No conversations yet',
                        message: 'Connect with fellow single parents, share experiences, and support each other.',
                        actionLabel: 'Start a conversation',
                        onAction: _openStartChat,
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _refreshChats,
                      color: theme.primary,
                      child: ListView.builder(
                        controller: _model.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: displayChats.length,
                        itemBuilder: (context, index) {
                          final chat = displayChats[index];
                          final chatId = chat.chatId;
                          final unreadCount = chatId != null ? (_model.unreadCounts[chatId] ?? 0) : 0;
                          final isPinned = chatId != null && _model.pinnedChatIds.contains(chatId);
                          final isMuted = chatId != null && _model.mutedChatIds.contains(chatId);

                          return ChatInboxTile(
                            chat: chat,
                            unreadCount: unreadCount,
                            isPinned: isPinned,
                            isMuted: isMuted,
                            isOnline: false,
                            onTap: () async {
                              if (chatId != null && currentUserUid.isNotEmpty) {
                                await ChatService.instance.markAsRead(currentUserUid, chatId);
                              }
                              if (!context.mounted) return;
                              await context.pushNamed(
                                ChatmessagesWidget.routeName,
                                queryParameters: {
                                  'chatRow': serializeParam(
                                    chat,
                                    ParamType.SupabaseRow,
                                  ),
                                }.withoutNulls,
                              );
                              if (mounted) await _refreshChats();
                            },
                            onLongPress: () => _showChatOptionsSheet(chat),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Start Conversation',
          backgroundColor: theme.primary,
          elevation: 3,
          onPressed: _openStartChat,
          child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String filterKey, FlutterFlowTheme theme) {
    final isSelected = _model.activeFilter == filterKey;
    return GestureDetector(
      onTap: () => safeSetState(() => _model.activeFilter = filterKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? theme.primary : theme.primaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.primary : theme.alternate,
            width: 0.8,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.secondaryText,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12.5,
          ),
        ),
      ),
    );
  }
}
