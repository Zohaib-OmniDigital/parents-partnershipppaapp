import '/components/section_header_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'additional_details_widget.dart' show AdditionalDetailsWidget;
import 'package:flutter/material.dart';

class AdditionalDetailsModel extends FlutterFlowModel<AdditionalDetailsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnScrollController;
  // Model for SectionHeader.
  late SectionHeaderModel sectionHeaderModel;
  bool isDataUploading_uploadedSelfie = false;
  FFUploadedFile uploadedLocalFile_uploadedSelfie =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadedSelfie = '';

  @override
  void initState(BuildContext context) {
    columnScrollController = ScrollController();
    sectionHeaderModel = createModel(context, () => SectionHeaderModel());
  }

  @override
  void dispose() {
    columnScrollController?.dispose();
    sectionHeaderModel.dispose();
  }
}
