import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'selectusercomponent_widget.dart' show SelectusercomponentWidget;
import 'package:flutter/material.dart';

class SelectusercomponentModel
    extends FlutterFlowModel<SelectusercomponentWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // Stores action output result for [Backend Call - Insert Row] action in Container widget.
  AChatsRow? newChatRow;
  // State field(s) for CheckboxListTile widget.
  Map<UsersRow, bool> checkboxListTileValueMap1 = {};
  List<UsersRow> get checkboxListTileCheckedItems1 =>
      checkboxListTileValueMap1.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

  // State field(s) for CheckboxListTile widget.
  Map<UsersRow, bool> checkboxListTileValueMap2 = {};
  List<UsersRow> get checkboxListTileCheckedItems2 =>
      checkboxListTileValueMap2.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

  // State field(s) for CheckboxListTile widget.
  Map<UsersRow, bool> checkboxListTileValueMap3 = {};
  List<UsersRow> get checkboxListTileCheckedItems3 =>
      checkboxListTileValueMap3.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

  // State field(s) for CheckboxListTile widget.
  Map<UsersRow, bool> checkboxListTileValueMap4 = {};
  List<UsersRow> get checkboxListTileCheckedItems4 =>
      checkboxListTileValueMap4.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

  // State field(s) for CheckboxListTile widget.
  Map<UsersRow, bool> checkboxListTileValueMap5 = {};
  List<UsersRow> get checkboxListTileCheckedItems5 =>
      checkboxListTileValueMap5.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
  }
}
