import '/flutter_flow/flutter_flow_util.dart';
import 'personal_identification_widget.dart' show PersonalIdentificationWidget;
import 'package:flutter/material.dart';

class PersonalIdentificationModel
    extends FlutterFlowModel<PersonalIdentificationWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnScrollController;
  // State field(s) for FullLegalName widget.
  FocusNode? fullLegalNameFocusNode;
  TextEditingController? fullLegalNameTextController;
  String? Function(BuildContext, String?)? fullLegalNameTextControllerValidator;
  // State field(s) for DateofBirth widget.
  FocusNode? dateofBirthFocusNode;
  TextEditingController? dateofBirthTextController;
  String? Function(BuildContext, String?)? dateofBirthTextControllerValidator;

  @override
  void initState(BuildContext context) {
    columnScrollController = ScrollController();
  }

  @override
  void dispose() {
    columnScrollController?.dispose();
    fullLegalNameFocusNode?.dispose();
    fullLegalNameTextController?.dispose();

    dateofBirthFocusNode?.dispose();
    dateofBirthTextController?.dispose();
  }
}
