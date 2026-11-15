import 'dart:async';
import 'package:flutter/material.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chatmessages_widget.dart' show ChatmessagesWidget;

class ChatmessagesModel extends FlutterFlowModel<ChatmessagesWidget> {
  /// State fields for stateful widgets in this page.
  FocusNode? inputMessagesFocusNode;
  TextEditingController? inputMessagesTextController;
  String? Function(BuildContext, String?)? inputMessagesTextControllerValidator;

  Completer<List<ChatMessagesInfoViewRow>>? requestCompleter;

  // Replying state
  ChatMessagesInfoViewRow? replyingToMessage;

  // In-chat search
  bool isSearching = false;
  TextEditingController? searchController;
  FocusNode? searchFocusNode;
  String searchQuery = '';

  // Typing status
  bool isOtherUserTyping = false;
  String? otherUserTypingName;

  // Scroll to bottom badge
  int newMessagesWhileScrolled = 0;

  // Reactions cache: messageId -> emoji -> count
  Map<int, Map<String, int>> messageReactions = {};

  // Optimistic pending messages queue
  List<ChatMessagesInfoViewRow> pendingMessages = [];

  @override
  void initState(BuildContext context) {
    inputMessagesFocusNode = FocusNode();
    inputMessagesTextController = TextEditingController();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    inputMessagesFocusNode?.dispose();
    inputMessagesTextController?.dispose();
    searchController?.dispose();
    searchFocusNode?.dispose();
  }

  /// Additional helper methods.
  Future waitForRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(const Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = requestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
