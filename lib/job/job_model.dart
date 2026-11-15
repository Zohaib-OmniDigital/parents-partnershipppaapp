import '/flutter_flow/flutter_flow_util.dart';
import 'job_widget.dart' show JobWidget;
import 'package:flutter/material.dart';

class JobModel extends FlutterFlowModel<JobWidget> {
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
