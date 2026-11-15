import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'signin_widget.dart' show SigninWidget;
import 'package:flutter/material.dart';

class SigninModel extends FlutterFlowModel<SigninWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // State field(s) for Emailsignin widget.
  FocusNode? emailsigninFocusNode;
  TextEditingController? emailsigninTextController;
  String? Function(BuildContext, String?)? emailsigninTextControllerValidator;
  // State field(s) for Passwordsignin widget.
  FocusNode? passwordsigninFocusNode;
  TextEditingController? passwordsigninTextController;
  late bool passwordsigninVisibility;
  String? Function(BuildContext, String?)?
      passwordsigninTextControllerValidator;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    passwordsigninVisibility = false;
  }

  @override
  void dispose() {
    columnController1?.dispose();
    columnController2?.dispose();
    emailsigninFocusNode?.dispose();
    emailsigninTextController?.dispose();

    passwordsigninFocusNode?.dispose();
    passwordsigninTextController?.dispose();
  }
}
