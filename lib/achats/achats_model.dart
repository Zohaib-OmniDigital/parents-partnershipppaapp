import 'dart:async';
import 'package:flutter/material.dart';

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'achats_widget.dart' show AchatsWidget;

class AchatsModel extends FlutterFlowModel<AchatsWidget> {
  /// State fields for stateful widgets in this page.
  ScrollController? scrollController;
  Completer<List<AChatSummaryRow>>? requestCompleter;

  // Search filter
  TextEditingController? searchController;
  FocusNode? searchFocusNode;
  String searchQuery = '';

  // Tab filter: 'all', 'unread', 'archived'
  String activeFilter = 'all';

  // Cached metadata for responsive UI
  Map<int, int> unreadCounts = {};
  Set<int> pinnedChatIds = {};
  Set<int> mutedChatIds = {};
  Set<int> archivedChatIds = {};

  @override
  void initState(BuildContext context) {
    scrollController = ScrollController();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    scrollController?.dispose();
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
