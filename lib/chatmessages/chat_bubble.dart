import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/achats/chat_service.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'chat_image_viewer.dart';

enum MessageDeliveryStatus { sending, sent, delivered, read, failed }

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.isFirstInGroup,
    required this.isLastInGroup,
    this.status = MessageDeliveryStatus.delivered,
    this.reactions = const <String, int>{},
    this.onLongPress,
    this.onDoubleTap,
    this.onReplyTap,
    this.onRetry,
  });

  final ChatMessagesInfoViewRow message;
  final bool isMine;
  final bool isFirstInGroup;
  final bool isLastInGroup;
  final MessageDeliveryStatus status;
  final Map<String, int> reactions;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final void Function(int replyId)? onReplyTap;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final payload = ChatMessagePayload.parse(message.message ?? '');
    final timeStr = ChatService.formatBubbleTime(message.createdAt);

    // Dynamic border radii based on sender and grouping
    final bubbleRadius = BorderRadius.only(
      topLeft: Radius.circular(isMine ? 18 : (isFirstInGroup ? 18 : 6)),
      topRight: Radius.circular(isMine ? (isFirstInGroup ? 18 : 6) : 18),
      bottomLeft: Radius.circular(isMine ? 18 : (isLastInGroup ? 4 : 6)),
      bottomRight: Radius.circular(isMine ? (isLastInGroup ? 4 : 6) : 18),
    );

    final bubbleColor = isMine ? theme.primary : theme.secondaryBackground;
    final textColor = isMine ? Colors.white : theme.primaryText;
    final secondaryTextColor = isMine ? Colors.white.withValues(alpha: 0.75) : theme.secondaryText;

    return Padding(
      padding: EdgeInsets.only(
        top: isFirstInGroup ? 6 : 2,
        bottom: isLastInGroup ? 6 : 2,
        left: isMine ? 48 : 8,
        right: isMine ? 8 : 48,
      ),
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * 0.76,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: bubbleRadius,
                  border: isMine
                      ? null
                      : Border.all(color: theme.alternate.withValues(alpha: 0.8), width: 0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: bubbleRadius,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment:
                          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Incoming sender name on first message of group
                        if (!isMine && isFirstInGroup)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              message.fullName ?? 'Parent',
                              style: theme.labelSmall.copyWith(
                                color: theme.secondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),

                        // Quoted reply preview if this message replies to another
                        if (payload.isReply)
                          GestureDetector(
                            onTap: payload.replyToId != null
                                ? () => onReplyTap?.call(payload.replyToId!)
                                : null,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                              decoration: BoxDecoration(
                                color: isMine
                                    ? Colors.black.withValues(alpha: 0.15)
                                    : theme.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border(
                                  left: BorderSide(
                                    color: isMine ? Colors.white : theme.primary,
                                    width: 3.5,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    payload.replyToSender ?? 'Message',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11.5,
                                      color: isMine ? Colors.white : theme.primary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    payload.replyToText ?? '',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: secondaryTextColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Image attachment if present
                        if (payload.hasImage)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GestureDetector(
                                onTap: () => ChatImageViewer.open(
                                  context,
                                  imageUrl: payload.imageUrl!,
                                  caption: payload.imageCaption,
                                  senderName: isMine ? 'You' : message.fullName,
                                ),
                                child: Hero(
                                  tag: 'chat_img_${message.id}_${payload.imageUrl}',
                                  child: CachedNetworkImage(
                                    imageUrl: payload.imageUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      height: 180,
                                      color: Colors.black12,
                                      child: const Center(
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      height: 120,
                                      color: Colors.black12,
                                      child: const Center(
                                        child: Icon(Icons.broken_image_rounded, size: 36),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Voice message preview if present
                        if (payload.hasAudio)
                          Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: isMine
                                  ? Colors.black.withValues(alpha: 0.12)
                                  : theme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: isMine ? Colors.white : theme.primary,
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: isMine ? theme.primary : Colors.white,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: isMine
                                              ? Colors.white.withValues(alpha: 0.5)
                                              : theme.primary.withValues(alpha: 0.3),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        payload.audioDurationSeconds != null
                                            ? '0:${payload.audioDurationSeconds!.toString().padLeft(2, '0')}'
                                            : 'Voice note',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: secondaryTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Text Message Content
                        if (payload.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              payload.text,
                              style: theme.bodyMedium.copyWith(
                                color: textColor,
                                fontSize: 14.5,
                                height: 1.35,
                              ),
                            ),
                          ),

                        // Timestamp & Status Receipts row
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                timeStr,
                                style: theme.labelSmall.copyWith(
                                  color: secondaryTextColor,
                                  fontSize: 10.5,
                                ),
                              ),
                              if (isMine) ...[
                                const SizedBox(width: 4),
                                _buildStatusIcon(theme),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Floating Reactions Pill at bottom edge
              if (reactions.isNotEmpty)
                Positioned(
                  bottom: -10,
                  right: isMine ? 4 : null,
                  left: isMine ? null : 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.alternate, width: 0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: reactions.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            entry.value > 1 ? '${entry.key} ${entry.value}' : entry.key,
                            style: const TextStyle(fontSize: 11),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(FlutterFlowTheme theme) {
    switch (status) {
      case MessageDeliveryStatus.sending:
        return const Icon(Icons.access_time_rounded, size: 12, color: Colors.white70);
      case MessageDeliveryStatus.sent:
        return const Icon(Icons.check_rounded, size: 13, color: Colors.white70);
      case MessageDeliveryStatus.delivered:
        return const Icon(Icons.done_all_rounded, size: 14, color: Colors.white70);
      case MessageDeliveryStatus.read:
        return const Icon(Icons.done_all_rounded, size: 14, color: Color(0xFF64B5F6));
      case MessageDeliveryStatus.failed:
        return GestureDetector(
          onTap: onRetry,
          child: Icon(Icons.error_outline_rounded, size: 14, color: theme.error),
        );
    }
  }
}
