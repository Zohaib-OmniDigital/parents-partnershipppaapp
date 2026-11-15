import '/flutter_flow/flutter_flow_util.dart';
import 'menucomponent_widget.dart' show MenucomponentWidget;
import 'package:flutter/material.dart';

class MenucomponentModel extends FlutterFlowModel<MenucomponentWidget> {
  ///  State fields for stateful widgets in this component.

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
