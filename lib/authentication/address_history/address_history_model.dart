import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'address_history_widget.dart' show AddressHistoryWidget;
import 'package:flutter/material.dart';

class AddressHistoryModel extends FlutterFlowModel<AddressHistoryWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for CurrentStreetAddress widget.
  FocusNode? currentStreetAddressFocusNode;
  TextEditingController? currentStreetAddressTextController;
  String? Function(BuildContext, String?)?
      currentStreetAddressTextControllerValidator;
  // State field(s) for Country widget.
  String? countryValue;
  FormFieldController<String>? countryValueController;
  // State field(s) for State widget.
  String? stateValue;
  FormFieldController<String>? stateValueController;
  // State field(s) for ZIPCode widget.
  FocusNode? zIPCodeFocusNode;
  TextEditingController? zIPCodeTextController;
  String? Function(BuildContext, String?)? zIPCodeTextControllerValidator;
  String? _zIPCodeTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Enter 5-digit ZIP code is required';
    }

    if (val.length < 5) {
      return '5';
    }

    return null;
  }

  // State field(s) for PreviousAddress widget.
  FocusNode? previousAddressFocusNode;
  TextEditingController? previousAddressTextController;
  String? Function(BuildContext, String?)?
      previousAddressTextControllerValidator;
  String? _previousAddressTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Enter previous street address is required';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    zIPCodeTextControllerValidator = _zIPCodeTextControllerValidator;
    previousAddressTextControllerValidator =
        _previousAddressTextControllerValidator;
  }

  @override
  void dispose() {
    columnController?.dispose();
    currentStreetAddressFocusNode?.dispose();
    currentStreetAddressTextController?.dispose();

    zIPCodeFocusNode?.dispose();
    zIPCodeTextController?.dispose();

    previousAddressFocusNode?.dispose();
    previousAddressTextController?.dispose();
  }
}
