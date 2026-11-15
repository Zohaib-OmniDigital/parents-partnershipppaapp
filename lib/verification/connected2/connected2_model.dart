import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'connected2_widget.dart' show Connected2Widget;
import 'package:flutter/material.dart';

class Connected2Model extends FlutterFlowModel<Connected2Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for CheckboxGroup widget.
  FormFieldController<List<String>>? checkboxGroupValueController;
  List<String>? get checkboxGroupValues => checkboxGroupValueController?.value;
  set checkboxGroupValues(List<String>? v) =>
      checkboxGroupValueController?.value = v;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
  }
}
