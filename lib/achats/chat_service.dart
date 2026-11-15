import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/backend/supabase/supabase.dart';

/// Structured metadata for modern rich chat messages (text, image, audio, reply).
class ChatMessagePayload {
  ChatMessagePayload({
    required this.text,
    this.imageUrl,
    this.imageCaption,
    this.replyToId,
    this.replyToSender,
    this.replyToText,
    this.audioUrl,
    this.audioDurationSeconds,
  });

  final String text;
  final String? imageUrl;
  final String? imageCaption;
  final int? replyToId;
  final String? replyToSender;
  final String? replyToText;
  final String? audioUrl;
  final int? audioDurationSeconds;

  bool get hasImage => imageUrl != null && imageUrl!.trim().isNotEmpty;
  bool get hasAudio => audioUrl != null && audioUrl!.trim().isNotEmpty;
  bool get isReply => replyToId != null;

  /// Serializes message with embedded metadata tags if rich features are present.
  String toEncodedString() {
    final buffer = StringBuffer();

    if (isReply) {
      final safeSender = (replyToSender ?? 'Parent').replaceAll('|', ' ');
      final safeText = (replyToText ?? '').replaceAll('|', ' ').replaceAll('\n', ' ');
      buffer.writeln('[reply:$replyToId|$safeSender|$safeText]');
    }

    if (hasImage) {
      final caption = imageCaption ?? '';
      buffer.writeln('[image:$imageUrl|$caption]');
      if (text.trim().isNotEmpty && text.trim() != caption.trim()) {
        buffer.writeln(text.trim());
      }
    } else if (hasAudio) {
      final duration = audioDurationSeconds ?? 0;
      buffer.writeln('[audio:$audioUrl|$duration]');
      if (text.trim().isNotEmpty) {
        buffer.writeln(text.trim());
      }
    } else {
      buffer.write(text);
    }

    return buffer.toString().trim();
  }

  /// Parses raw message text, extracting reply, image, or audio tags while keeping plain text intact.
  factory ChatMessagePayload.parse(String rawMessage) {
    if (rawMessage.isEmpty) {
      return ChatMessagePayload(text: '');
    }

    int? replyId;
    String? replySender;
    String? replyText;
    String? imgUrl;
    String? imgCaption;
    String? audUrl;
    int? audDuration;

    var cleaned = rawMessage;

    // Check for [reply:id|sender|text]
    final replyRegex = RegExp(r'\[reply:(\d+)\|([^\|]*)\|([^\]]*)\]\n?');
    final replyMatch = replyRegex.firstMatch(cleaned);
    if (replyMatch != null) {
      replyId = int.tryParse(replyMatch.group(1) ?? '');
      replySender = replyMatch.group(2)?.trim();
      replyText = replyMatch.group(3)?.trim();
      cleaned = cleaned.replaceFirst(replyMatch.group(0)!, '');
    }

    // Check for [image:url|caption]
    final imageRegex = RegExp(r'\[image:([^\|]+)\|?([^\]]*)\]\n?');
    final imageMatch = imageRegex.firstMatch(cleaned);
    if (imageMatch != null) {
      imgUrl = imageMatch.group(1)?.trim();
      imgCaption = imageMatch.group(2)?.trim();
      cleaned = cleaned.replaceFirst(imageMatch.group(0)!, '');
    }

    // Check for [audio:url|duration]
    final audioRegex = RegExp(r'\[audio:([^\|]+)\|?([^\]]*)\]\n?');
    final audioMatch = audioRegex.firstMatch(cleaned);
    if (audioMatch != null) {
      audUrl = audioMatch.group(1)?.trim();
      audDuration = int.tryParse(audioMatch.group(2) ?? '');
      cleaned = cleaned.replaceFirst(audioMatch.group(0)!, '');
    }

    final displayText = cleaned.trim().isNotEmpty
        ? cleaned.trim()
        : (imgCaption?.isNotEmpty == true ? imgCaption! : '');

    return ChatMessagePayload(
      text: displayText,
      imageUrl: imgUrl,
      imageCaption: imgCaption,
      replyToId: replyId,
      replyToSender: replySender,
      replyToText: replyText,
      audioUrl: audUrl,
      audioDurationSeconds: audDuration,
    );
  }

  /// Generates a friendly snippet for last-message previews in the inbox.
  String get previewSnippet {
    if (hasImage) {
      return (imageCaption != null && imageCaption!.trim().isNotEmpty)
          ? '📷 $imageCaption'
          : '📷 Photo';
    }
    if (hasAudio) {
      return '🎤 Voice message';
    }
    if (text.trim().isNotEmpty) {
      return text.trim();
    }
    return 'Message';
  }
}

/// Service managing chat state: unread tracking, pins, mutes, typing presence, and caching.
class ChatService {
  ChatService._();
  static final ChatService instance = ChatService._();

  static const String _lastReadPrefix = 'chat_last_read_';
  static const String _pinnedKey = 'chat_pinned_ids_';
  static const String _mutedKey = 'chat_muted_ids_';
  static const String _archivedKey = 'chat_archived_ids_';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _storage async =>
      _prefs ??= await SharedPreferences.getInstance();

  /// Gets the last read timestamp for a specific conversation.
  Future<DateTime?> getLastReadTime(String userUuid, int chatId) async {
    final prefs = await _storage;
    final value = prefs.getString('$_lastReadPrefix${userUuid}_$chatId');
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  /// Marks a conversation as read right now.
  Future<void> markAsRead(String userUuid, int chatId) async {
    final prefs = await _storage;
    await prefs.setString(
      '$_lastReadPrefix${userUuid}_$chatId',
      DateTime.now().toUtc().toIso8601String(),
    );
  }

  /// Marks a conversation as unread by removing the stored read timestamp.
  Future<void> markAsUnread(String userUuid, int chatId) async {
    final prefs = await _storage;
    await prefs.remove('$_lastReadPrefix${userUuid}_$chatId');
  }

  /// Computes unread counts for all conversations in one batch.
  Future<Map<int, int>> getUnreadCounts({
    required String userUuid,
    required int currentProfileId,
    required List<int> chatIds,
  }) async {
    if (chatIds.isEmpty) return {};

    final prefs = await _storage;
    final Map<int, int> counts = {};

    try {
      // Query recent messages for these chats from sender != current user
      final response = await SupaFlow.client
          .from('a_chats_message')
          .select('id, chat_id, created_at, user_id')
          .inFilter('chat_id', chatIds)
          .neq('user_id', currentProfileId)
          .order('created_at', ascending: false)
          .limit(300);

      final List<dynamic> rows = response as List<dynamic>;

      for (final chatId in chatIds) {
        final lastReadStr = prefs.getString('$_lastReadPrefix${userUuid}_$chatId');
        final lastRead = lastReadStr != null ? DateTime.tryParse(lastReadStr) : null;

        int unread = 0;
        for (final row in rows) {
          final rowChatId = row['chat_id'] as int?;
          if (rowChatId != chatId) continue;

          final createdAtStr = row['created_at'] as String?;
          final createdAt = createdAtStr != null ? DateTime.tryParse(createdAtStr) : null;

          if (createdAt != null) {
            if (lastRead == null || createdAt.isAfter(lastRead)) {
              unread++;
            }
          }
        }
        counts[chatId] = unread;
      }
    } catch (e) {
      debugPrint('Error calculating unread counts: $e');
    }

    return counts;
  }

  /// Pinned chat IDs for the given user.
  Future<Set<int>> getPinnedChats(String userUuid) async {
    final prefs = await _storage;
    final list = prefs.getStringList('$_pinnedKey$userUuid') ?? [];
    return list.map((e) => int.tryParse(e)).whereType<int>().toSet();
  }

  Future<void> togglePinChat(String userUuid, int chatId) async {
    final prefs = await _storage;
    final set = await getPinnedChats(userUuid);
    if (set.contains(chatId)) {
      set.remove(chatId);
    } else {
      set.add(chatId);
    }
    await prefs.setStringList(
      '$_pinnedKey$userUuid',
      set.map((e) => e.toString()).toList(),
    );
  }

  /// Muted chat IDs for the given user.
  Future<Set<int>> getMutedChats(String userUuid) async {
    final prefs = await _storage;
    final list = prefs.getStringList('$_mutedKey$userUuid') ?? [];
    return list.map((e) => int.tryParse(e)).whereType<int>().toSet();
  }

  Future<void> toggleMuteChat(String userUuid, int chatId) async {
    final prefs = await _storage;
    final set = await getMutedChats(userUuid);
    if (set.contains(chatId)) {
      set.remove(chatId);
    } else {
      set.add(chatId);
    }
    await prefs.setStringList(
      '$_mutedKey$userUuid',
      set.map((e) => e.toString()).toList(),
    );
  }

  /// Archived chat IDs for the given user.
  Future<Set<int>> getArchivedChats(String userUuid) async {
    final prefs = await _storage;
    final list = prefs.getStringList('$_archivedKey$userUuid') ?? [];
    return list.map((e) => int.tryParse(e)).whereType<int>().toSet();
  }

  Future<void> toggleArchiveChat(String userUuid, int chatId) async {
    final prefs = await _storage;
    final set = await getArchivedChats(userUuid);
    if (set.contains(chatId)) {
      set.remove(chatId);
    } else {
      set.add(chatId);
    }
    await prefs.setStringList(
      '$_archivedKey$userUuid',
      set.map((e) => e.toString()).toList(),
    );
  }

  /// Formats date for conversation inbox list (e.g., "10:45 AM", "Yesterday", "Monday", "Oct 12").
  static String formatInboxTimestamp(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final local = dateTime.toLocal();
    final difference = now.difference(local);

    if (difference.inDays == 0 && now.day == local.day) {
      return DateFormat('h:mm a').format(local);
    }

    final yesterday = now.subtract(const Duration(days: 1));
    if (yesterday.year == local.year &&
        yesterday.month == local.month &&
        yesterday.day == local.day) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      return DateFormat('EEEE').format(local);
    }

    if (now.year == local.year) {
      return DateFormat('MMM d').format(local);
    }

    return DateFormat('MM/dd/yy').format(local);
  }

  /// Formats date divider in chat screen ("Today", "Yesterday", "Wednesday, Oct 14", etc.).
  static String formatDateDivider(DateTime dateTime) {
    final now = DateTime.now();
    final local = dateTime.toLocal();

    if (now.year == local.year && now.month == local.month && now.day == local.day) {
      return 'Today';
    }

    final yesterday = now.subtract(const Duration(days: 1));
    if (yesterday.year == local.year &&
        yesterday.month == local.month &&
        yesterday.day == local.day) {
      return 'Yesterday';
    }

    if (now.year == local.year) {
      return DateFormat('EEEE, MMMM d').format(local);
    }

    return DateFormat('MMMM d, y').format(local);
  }

  /// Formats bubble timestamp ("10:45 AM").
  static String formatBubbleTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('h:mm a').format(dateTime.toLocal());
  }

  /// Checks if two timestamps fall on different calendar days.
  static bool isDifferentDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return true;
    final localA = a.toLocal();
    final localB = b.toLocal();
    return localA.year != localB.year ||
        localA.month != localB.month ||
        localA.day != localB.day;
  }
}

