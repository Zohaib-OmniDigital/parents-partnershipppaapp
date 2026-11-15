import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'sign_up_widget.dart' show SignUpWidget;
import 'package:flutter/material.dart';

class SignUpModel extends FlutterFlowModel<SignUpWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for Emailsignup widget.
  FocusNode? emailsignupFocusNode;
  TextEditingController? emailsignupTextController;
  String? Function(BuildContext, String?)? emailsignupTextControllerValidator;
  // State field(s) for passwordsignup widget.
  FocusNode? passwordsignupFocusNode;
  TextEditingController? passwordsignupTextController;
  late bool passwordsignupVisibility;
  String? Function(BuildContext, String?)?
      passwordsignupTextControllerValidator;
  // State field(s) for ConfirmPasswordsignup widget.
  FocusNode? confirmPasswordsignupFocusNode;
  TextEditingController? confirmPasswordsignupTextController;
  late bool confirmPasswordsignupVisibility;
  String? Function(BuildContext, String?)?
      confirmPasswordsignupTextControllerValidator;
  // Stores action output result for [Custom Action - signUpWithEmail] action in Button widget.
  String? error;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    passwordsignupVisibility = false;
    confirmPasswordsignupVisibility = false;
  }

  @override
  void dispose() {
    columnController?.dispose();
    emailsignupFocusNode?.dispose();
    emailsignupTextController?.dispose();

    passwordsignupFocusNode?.dispose();
    passwordsignupTextController?.dispose();

    confirmPasswordsignupFocusNode?.dispose();
    confirmPasswordsignupTextController?.dispose();
  }
}
