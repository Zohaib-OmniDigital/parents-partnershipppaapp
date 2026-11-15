import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'opt_verification_page_widget.dart' show OptVerificationPageWidget;
import 'package:flutter/material.dart';

class OptVerificationPageModel
    extends FlutterFlowModel<OptVerificationPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // Stores action output result for [Custom Action - verifyEmailWithToken] action in Button widget.
  bool? isVerified;

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();
  }
}
