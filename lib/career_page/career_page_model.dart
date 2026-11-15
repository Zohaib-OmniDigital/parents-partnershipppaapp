import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'career_page_widget.dart' show CareerPageWidget;
import 'package:flutter/material.dart';

class CareerPageModel extends FlutterFlowModel<CareerPageWidget> {
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
