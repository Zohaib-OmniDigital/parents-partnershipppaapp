import '/components/text_field2_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'post_bottom_sheet_widget.dart' show PostBottomSheetWidget;
import 'package:flutter/material.dart';

class PostBottomSheetModel extends FlutterFlowModel<PostBottomSheetWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for TextField.
  late TextField2Model textFieldModel1;
  // Model for TextField.
  late TextField2Model textFieldModel2;

  @override
  void initState(BuildContext context) {
    textFieldModel1 = createModel(context, () => TextField2Model());
    textFieldModel2 = createModel(context, () => TextField2Model());
  }

  @override
  void dispose() {
    textFieldModel1.dispose();
    textFieldModel2.dispose();
  }
}
