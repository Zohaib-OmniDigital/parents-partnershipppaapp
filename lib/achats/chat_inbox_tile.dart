import 'package:flutter/material.dart';

import '/backend/supabase/supabase.dart';
import '/components/app_ui_components.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'chat_service.dart';

class ChatInboxTile extends StatelessWidget {
  const ChatInboxTile({
    super.key,
    required this.chat,
    required this.unreadCount,
    required this.isPinned,
    required this.isMuted,
    required this.isOnline,
    required this.onTap,
    required this.onLongPress,
  });

  final AChatSummaryRow chat;
  final int unreadCount;
  final bool isPinned;
  final bool isMuted;
  final bool isOnline;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  String get _displayName {
    final names = chat.fullNames
        .where((n) => n.trim().isNotEmpty)
        .toList();
    if (names.isEmpty) return 'Community Member';
    return names.join(', ');
  }

  String? get _avatarUrl => chat.profilePictures
      .where((p) => p.trim().isNotEmpty)
      .firstOrNull;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasUnread = unreadCount > 0;
    final payload = ChatMessagePayload.parse(chat.lastMessage ?? '');
    final timeStr = ChatService.formatInboxTimestamp(chat.updatedAt);

    return Material(
      color: isPinned
          ? theme.primary.withValues(alpha: 0.04)
          : theme.secondaryBackground,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        splashColor: theme.primary.withValues(alpha: 0.08),
        highlightColor: theme.primary.withValues(alpha: 0.04),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.alternate.withValues(alpha: 0.6),
                width: 0.8,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with online status
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AppNetworkAvatar(
                    url: _avatarUrl,
                    size: 52,
                    semanticLabel: '$_displayName profile photo',
                  ),
                  if (isOnline)
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.secondaryBackground,
                            width: 2.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // Title, preview, time, and badges
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Name, Pin icon, Mute icon, Timestamp
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.bodyLarge.copyWith(
                              fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                              color: theme.primaryText,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (isMuted) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.volume_off_rounded,
                            size: 15,
                            color: theme.secondaryText.withValues(alpha: 0.6),
                          ),
                        ],
                        if (isPinned) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.push_pin_rounded,
                            size: 15,
                            color: theme.primary.withValues(alpha: 0.7),
                          ),
                        ],
                        if (timeStr.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            timeStr,
                            style: theme.labelSmall.copyWith(
                              color: hasUnread ? theme.primary : theme.secondaryText,
                              fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Bottom row: Last message preview & unread badge
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              if (payload.hasImage)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Icon(
                                    Icons.photo_camera_rounded,
                                    size: 15,
                                    color: hasUnread ? theme.primary : theme.secondaryText,
                                  ),
                                )
                              else if (payload.hasAudio)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Icon(
                                    Icons.mic_rounded,
                                    size: 15,
                                    color: hasUnread ? theme.primary : theme.secondaryText,
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  payload.previewSnippet,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.bodyMedium.copyWith(
                                    color: hasUnread ? theme.primaryText : theme.secondaryText,
                                    fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (hasUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                            decoration: BoxDecoration(
                              color: isMuted
                                  ? theme.secondaryText.withValues(alpha: 0.5)
                                  : theme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                unreadCount > 99 ? '99+' : unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                            ),
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
    );
  }
}

