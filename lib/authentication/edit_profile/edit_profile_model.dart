import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'edit_profile_widget.dart' show EditProfileWidget;
import 'package:flutter/material.dart';

class EditProfileModel extends FlutterFlowModel<EditProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  bool isDataUploading_uploadDataZii = false;
  FFUploadedFile uploadedLocalFile_uploadDataZii =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataZii = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textFieldTextController;
  String? Function(BuildContext, String?)? textFieldTextControllerValidator;
  // State field(s) for Country widget.
  String? countryValue;
  FormFieldController<String>? countryValueController;
  // State field(s) for State widget.
  String? stateValue;
  FormFieldController<String>? stateValueController;
  // State field(s) for age widget.
  String? ageValue;
  FormFieldController<String>? ageValueController;
  // State field(s) for Gende widget.
  String? gendeValue;
  FormFieldController<String>? gendeValueController;
  // State field(s) for Bio widget.
  FocusNode? bioFocusNode;
  TextEditingController? bioTextController;
  String? Function(BuildContext, String?)? bioTextControllerValidator;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
    textFieldFocusNode?.dispose();
    textFieldTextController?.dispose();

    bioFocusNode?.dispose();
    bioTextController?.dispose();
  }
}
