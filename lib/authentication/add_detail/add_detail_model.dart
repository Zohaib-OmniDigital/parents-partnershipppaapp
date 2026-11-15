import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'add_detail_widget.dart' show AddDetailWidget;
import 'package:flutter/material.dart';

class AddDetailModel extends FlutterFlowModel<AddDetailWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Column widget.
  ScrollController? columnController;
  bool isDataUploading_uploadDataC19 = false;
  FFUploadedFile uploadedLocalFile_uploadDataC19 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataC19 = '';

  // State field(s) for FullName widget.
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;
  String? Function(BuildContext, String?)? fullNameTextControllerValidator;
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

  String? _fullNameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? _bioTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Please enter a short bio';
    }
    return null;
  }

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    fullNameTextControllerValidator = _fullNameTextControllerValidator;
    bioTextControllerValidator = _bioTextControllerValidator;
  }

  @override
  void dispose() {
    columnController?.dispose();
    fullNameFocusNode?.dispose();
    fullNameTextController?.dispose();

    bioFocusNode?.dispose();
    bioTextController?.dispose();
  }
}
