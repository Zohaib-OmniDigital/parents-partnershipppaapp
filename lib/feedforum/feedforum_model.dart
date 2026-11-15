import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import 'feedforum_widget.dart' show FeedforumWidget;
import 'package:flutter/material.dart';

class FeedforumModel extends FlutterFlowModel<FeedforumWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnScrollController;
  Completer<List<PostsRow>>? requestCompleter;

  @override
  void initState(BuildContext context) {
    columnScrollController = ScrollController();
  }

  @override
  void dispose() {
    columnScrollController?.dispose();
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
