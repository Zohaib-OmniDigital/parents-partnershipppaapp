import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'notifications_widget.dart' show NotificationsWidget;
import 'package:flutter/material.dart';

class NotificationsModel extends FlutterFlowModel<NotificationsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
  }
}
