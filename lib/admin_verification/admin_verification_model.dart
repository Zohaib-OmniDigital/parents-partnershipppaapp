import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'admin_verification_widget.dart' show AdminVerificationWidget;
import 'dart:async';
import 'package:flutter/material.dart';

class AdminVerificationModel extends FlutterFlowModel<AdminVerificationWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in AdminVerification widget.
  List<UsersRow>? currentUser;
  // State field(s) for Column widget.
  ScrollController? columnScrollController;
  // State field(s) for Row widget.
  ScrollController? rowScrollController;
  Completer<List<UsersRow>>? requestCompleter;

  @override
  void initState(BuildContext context) {
    columnScrollController = ScrollController();
    rowScrollController = ScrollController();
  }

  @override
  void dispose() {
    columnScrollController?.dispose();
    rowScrollController?.dispose();
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
