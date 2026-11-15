import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'profile_setup_widget.dart' show ProfileSetupWidget;
import 'package:flutter/material.dart';

class ProfileSetupModel extends FlutterFlowModel<ProfileSetupWidget> {
  /// State fields for stateful widgets in this page.
  final formKey = GlobalKey<FormState>();

  ScrollController? scrollController;

  // Image upload state
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl = '';

  // Name field
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;

  // Optional State & Bio fields
  String? stateValue;
  FormFieldController<String>? stateValueController;

  FocusNode? bioFocusNode;
  TextEditingController? bioTextController;

  @override
  void initState(BuildContext context) {
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    nameFocusNode?.dispose();
    nameTextController?.dispose();
    bioFocusNode?.dispose();
    bioTextController?.dispose();
  }
}
