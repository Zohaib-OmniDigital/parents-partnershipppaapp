import '/components/info_banner_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'i_d_verification_widget.dart' show IDVerificationWidget;
import 'package:flutter/material.dart';

class IDVerificationModel extends FlutterFlowModel<IDVerificationWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnScrollController;
  // Model for InfoBanner.
  late InfoBannerModel infoBannerModel;
  bool isDataUploading_uploadDataVya = false;
  FFUploadedFile uploadedLocalFile_uploadDataVya =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataVya = '';

  @override
  void initState(BuildContext context) {
    columnScrollController = ScrollController();
    infoBannerModel = createModel(context, () => InfoBannerModel());
  }

  @override
  void dispose() {
    columnScrollController?.dispose();
    infoBannerModel.dispose();
  }
}
