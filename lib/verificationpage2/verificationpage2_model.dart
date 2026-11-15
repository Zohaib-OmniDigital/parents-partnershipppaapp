import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'verificationpage2_widget.dart' show Verificationpage2Widget;
import 'package:flutter/material.dart';

class Verificationpage2Model extends FlutterFlowModel<Verificationpage2Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnScrollController;

  @override
  void initState(BuildContext context) {
    columnScrollController = ScrollController();
  }

  @override
  void dispose() {
    columnScrollController?.dispose();
  }
}
