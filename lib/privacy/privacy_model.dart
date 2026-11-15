import '/flutter_flow/flutter_flow_util.dart';
import 'privacy_widget.dart' show PrivacyWidget;
import 'package:flutter/material.dart';

class PrivacyModel extends FlutterFlowModel<PrivacyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for Column widget.
  ScrollController? columnController2;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
  }

  @override
  void dispose() {
    columnController1?.dispose();
    columnController2?.dispose();
  }
}
