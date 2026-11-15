import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'onboarding2_widget.dart' show Onboarding2Widget;
import 'package:flutter/material.dart';

class Onboarding2Model extends FlutterFlowModel<Onboarding2Widget> {
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
