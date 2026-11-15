import '/flutter_flow/flutter_flow_util.dart';
import 'f_qspage_widget.dart' show FQspageWidget;
import 'package:flutter/material.dart';

class FQspageModel extends FlutterFlowModel<FQspageWidget> {
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
