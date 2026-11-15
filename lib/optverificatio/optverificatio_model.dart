import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'optverificatio_widget.dart' show OptverificatioWidget;
import 'package:flutter/material.dart';

class OptverificatioModel extends FlutterFlowModel<OptverificatioWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - checkUserVerification] action in Optverificatio widget.
  bool? isVerified;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for Email TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  // State field(s) for OTP verification step.
  bool otpSent = false;
  FocusNode? otpFocusNode;
  TextEditingController? otpController;
  String? Function(BuildContext, String?)? otpControllerValidator;
  bool? verifyOTP;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
    otpFocusNode?.dispose();
    otpController?.dispose();
  }
}
