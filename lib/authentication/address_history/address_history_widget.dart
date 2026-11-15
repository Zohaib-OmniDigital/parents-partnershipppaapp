import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'address_history_model.dart';
export 'address_history_model.dart';

class AddressHistoryWidget extends StatefulWidget {
  const AddressHistoryWidget({super.key});

  static String routeName = 'AddressHistory';
  static String routePath = '/addressHistory';

  @override
  State<AddressHistoryWidget> createState() => _AddressHistoryWidgetState();
}

class _AddressHistoryWidgetState extends State<AddressHistoryWidget>
    with TickerProviderStateMixin {
  late AddressHistoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddressHistoryModel());

    _model.currentStreetAddressTextController ??=
        TextEditingController(text: FFAppState().stateAddress);
    _model.currentStreetAddressFocusNode ??= FocusNode();

    _model.zIPCodeTextController ??=
        TextEditingController(text: FFAppState().stateZip);
    _model.zIPCodeFocusNode ??= FocusNode();

    _model.previousAddressTextController ??= TextEditingController();
    _model.previousAddressFocusNode ??= FocusNode();

    _model.countryValue =
        FFAppState().stateCountry.isEmpty ? null : FFAppState().stateCountry;
    _model.stateValue =
        FFAppState().stateState.isEmpty ? null : FFAppState().stateState;

    animationsMap.addAll({
      'buttonOnPageLoadAnimation': AnimationInfo(
        loop: true,
        reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 600.0.ms,
            begin: 0.3,
            end: 1.0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).alternate,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).alternate,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
              child: FlutterFlowIconButton(
                borderColor: FlutterFlowTheme.of(context).alternate,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 50.0,
                fillColor: FlutterFlowTheme.of(context).alternate,
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  context.safePop();
                },
              ),
            ),
            actions: const [],
            centerTitle: false,
          ),
          body: SafeArea(
            top: true,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown,
                },
              ),
              child: Scrollbar(
                controller: _model.columnController,
                child: SingleChildScrollView(
                  controller: _model.columnController,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Stack(
                                children: [
                                  Stack(
                                    children: [
                                      Stack(
                                        children: [
                                          Stack(
                                            children: [
                                              Stack(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  Stack(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            24.0,
                                                                            0.0,
                                                                            24.0,
                                                                            0.0),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              const BoxDecoration(),
                                                                          child:
                                                                              Form(
                                                                            key:
                                                                                _model.formKey,
                                                                            autovalidateMode:
                                                                                AutovalidateMode.disabled,
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Container(
                                                                                  decoration: const BoxDecoration(),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).alternate,
                                                                                          boxShadow: [
                                                                                            BoxShadow(
                                                                                              blurRadius: 4.0,
                                                                                              color: FlutterFlowTheme.of(context).alternate,
                                                                                              offset: const Offset(
                                                                                                0.0,
                                                                                                2.0,
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Align(
                                                                                                alignment: const AlignmentDirectional(0.0, -1.0),
                                                                                                child: Text(
                                                                                                  'Address History',
                                                                                                  style: FlutterFlowTheme.of(context).displaySmall.override(
                                                                                                        fontFamily: FlutterFlowTheme.of(context).displaySmallFamily,
                                                                                                        fontSize: 20.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).displaySmallIsCustom,
                                                                                                      ),
                                                                                                ),
                                                                                              ),
                                                                                              Align(
                                                                                                alignment: const AlignmentDirectional(0.0, -1.0),
                                                                                                child: Text(
                                                                                                  'Please provide your current address and any previous address if you have lived at your current address for less than 5 years.',
                                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                        letterSpacing: 0.0,
                                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                      ),
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                'Current Street Address',
                                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                                                                      fontSize: 16.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                                                    ),
                                                                                              ),
                                                                                              Container(
                                                                                                width: double.infinity,
                                                                                                height: 48.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                                  border: Border.all(
                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                    width: 1.0,
                                                                                                  ),
                                                                                                ),
                                                                                                child: Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  children: [
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                                                                                      child: Icon(
                                                                                                        Icons.home,
                                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                                        size: 24.0,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                                                                                        child: SizedBox(
                                                                                                          width: 200.0,
                                                                                                          child: TextFormField(
                                                                                                            controller: _model.currentStreetAddressTextController,
                                                                                                            focusNode: _model.currentStreetAddressFocusNode,
                                                                                                            autofocus: false,
                                                                                                            enabled: true,
                                                                                                            obscureText: false,
                                                                                                            decoration: InputDecoration(
                                                                                                              isDense: true,
                                                                                                              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                                                  ),
                                                                                                              hintText: 'Enter current street address',
                                                                                                              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                                                  ),
                                                                                                              enabledBorder: OutlineInputBorder(
                                                                                                                borderSide: const BorderSide(
                                                                                                                  color: Color(0x00000000),
                                                                                                                  width: 1.0,
                                                                                                                ),
                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                              ),
                                                                                                              focusedBorder: OutlineInputBorder(
                                                                                                                borderSide: const BorderSide(
                                                                                                                  color: Color(0x00000000),
                                                                                                                  width: 1.0,
                                                                                                                ),
                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                              ),
                                                                                                              errorBorder: OutlineInputBorder(
                                                                                                                borderSide: BorderSide(
                                                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                                                  width: 1.0,
                                                                                                                ),
                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                              ),
                                                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                                                borderSide: BorderSide(
                                                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                                                  width: 1.0,
                                                                                                                ),
                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                              ),
                                                                                                              filled: true,
                                                                                                              fillColor: FlutterFlowTheme.of(context).alternate,
                                                                                                            ),
                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                  letterSpacing: 0.0,
                                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                ),
                                                                                                            cursorColor: FlutterFlowTheme.of(context).primaryText,
                                                                                                            enableInteractiveSelection: true,
                                                                                                            validator: _model.currentStreetAddressTextControllerValidator.asValidator(context),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Column(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    'Country',
                                                                                                    style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                                          fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                                                                          fontSize: 16.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FontWeight.bold,
                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                                                        ),
                                                                                                  ),
                                                                                                ].divide(const SizedBox(height: 6.0)),
                                                                                              ),
                                                                                              Container(
                                                                                                width: double.infinity,
                                                                                                height: 48.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                                  border: Border.all(
                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                    width: 1.0,
                                                                                                  ),
                                                                                                ),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 23.0, 0.0),
                                                                                                  child: Row(
                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                    children: [
                                                                                                      Padding(
                                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                                                                                        child: FaIcon(
                                                                                                          FontAwesomeIcons.flagUsa,
                                                                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                                                                          size: 24.0,
                                                                                                        ),
                                                                                                      ),
                                                                                                      Expanded(
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsetsDirectional.fromSTEB(10.0, 7.0, 0.0, 7.0),
                                                                                                          child: FlutterFlowDropDown<String>(
                                                                                                            controller: _model.countryValueController ??= FormFieldController<String>(null),
                                                                                                            options: const ['United States'],
                                                                                                            onChanged: (val) => safeSetState(() => _model.countryValue = val),
                                                                                                            width: double.infinity,
                                                                                                            height: 40.0,
                                                                                                            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                  letterSpacing: 0.0,
                                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                ),
                                                                                                            hintText: 'Select...',
                                                                                                            icon: Icon(
                                                                                                              Icons.arrow_drop_down_sharp,
                                                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                                                              size: 24.0,
                                                                                                            ),
                                                                                                            fillColor: FlutterFlowTheme.of(context).alternate,
                                                                                                            elevation: 2.0,
                                                                                                            borderColor: Colors.transparent,
                                                                                                            borderWidth: 0.0,
                                                                                                            borderRadius: 4.0,
                                                                                                            margin: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                                                                                            hidesUnderline: true,
                                                                                                            isOverButton: false,
                                                                                                            isSearchable: false,
                                                                                                            isMultiSelect: false,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Column(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Row(
                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        'State',
                                                                                                        style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                                              fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                                                                              fontSize: 16.0,
                                                                                                              letterSpacing: 0.0,
                                                                                                              fontWeight: FontWeight.bold,
                                                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                                                            ),
                                                                                                      ),
                                                                                                      Expanded(
                                                                                                        child: Text(
                                                                                                          '(Conditional USA)',
                                                                                                          overflow: TextOverflow.ellipsis,
                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                                fontSize: 12.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                              ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ].divide(const SizedBox(width: 8.0)),
                                                                                                  ),
                                                                                                ].divide(const SizedBox(height: 6.0)),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 1.0, 0.0),
                                                                                                child: Container(
                                                                                                  width: double.infinity,
                                                                                                  height: 48.0,
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: FlutterFlowTheme.of(context).alternate,
                                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                                    border: Border.all(
                                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                                      width: 1.0,
                                                                                                    ),
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 23.0, 0.0),
                                                                                                    child: Row(
                                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                                      children: [
                                                                                                        Padding(
                                                                                                          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                                                                                          child: Icon(
                                                                                                            Icons.location_on,
                                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                                            size: 24.0,
                                                                                                          ),
                                                                                                        ),
                                                                                                        Expanded(
                                                                                                          child: Padding(
                                                                                                            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 7.0, 0.0, 7.0),
                                                                                                            child: FlutterFlowDropDown<String>(
                                                                                                              controller: _model.stateValueController ??= FormFieldController<String>(null),
                                                                                                              options: const [
                                                                                                                'Alabama',
                                                                                                                'Alaska',
                                                                                                                'Arizona',
                                                                                                                'Arkansas',
                                                                                                                'California',
                                                                                                                'Colorado',
                                                                                                                'Connecticut',
                                                                                                                'Delaware',
                                                                                                                'District of Columbia',
                                                                                                                'Florida',
                                                                                                                'Georgia',
                                                                                                                'Hawaii',
                                                                                                                'Idaho',
                                                                                                                'Illinois',
                                                                                                                'Indiana',
                                                                                                                'Iowa',
                                                                                                                'Kansas',
                                                                                                                'Kentucky',
                                                                                                                'Louisiana',
                                                                                                                'Maine',
                                                                                                                'Maryland',
                                                                                                                'Massachusetts',
                                                                                                                'Michigan',
                                                                                                                'Minnesota',
                                                                                                                'Mississippi',
                                                                                                                'Missouri',
                                                                                                                'Montana',
                                                                                                                'Nebraska',
                                                                                                                'Nevada',
                                                                                                                'New Hampshire',
                                                                                                                'New Jersey',
                                                                                                                'New Mexico',
                                                                                                                'New York',
                                                                                                                'North Carolina',
                                                                                                                'North Dakota',
                                                                                                                'Ohio',
                                                                                                                'Oklahoma',
                                                                                                                'Oregon',
                                                                                                                'Pennsylvania',
                                                                                                                'Rhode Island',
                                                                                                                'South Carolina',
                                                                                                                'South Dakota',
                                                                                                                'Tennessee',
                                                                                                                'Texas',
                                                                                                                'Utah',
                                                                                                                'Vermont',
                                                                                                                'Virginia',
                                                                                                                'Washington',
                                                                                                                'West Virginia',
                                                                                                                'Wisconsin',
                                                                                                                'Wyoming'
                                                                                                              ],
                                                                                                              onChanged: (val) => safeSetState(() => _model.stateValue = val),
                                                                                                              width: double.infinity,
                                                                                                              height: 40.0,
                                                                                                              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                  ),
                                                                                                              hintText: 'Select...',
                                                                                                              icon: Icon(
                                                                                                                Icons.arrow_drop_down_sharp,
                                                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                                                size: 24.0,
                                                                                                              ),
                                                                                                              fillColor: FlutterFlowTheme.of(context).alternate,
                                                                                                              elevation: 2.0,
                                                                                                              borderColor: Colors.transparent,
                                                                                                              borderWidth: 0.0,
                                                                                                              borderRadius: 4.0,
                                                                                                              margin: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                                                                                              hidesUnderline: true,
                                                                                                              isOverButton: false,
                                                                                                              isSearchable: false,
                                                                                                              isMultiSelect: false,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                'ZIP Code',
                                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                                                                      fontSize: 16.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                                                    ),
                                                                                              ),
                                                                                              Container(
                                                                                                width: double.infinity,
                                                                                                height: 48.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                                  border: Border.all(
                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                    width: 1.0,
                                                                                                  ),
                                                                                                ),
                                                                                                child: Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  children: [
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                                                                                      child: Icon(
                                                                                                        Icons.view_compact_sharp,
                                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                                        size: 24.0,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                                                                                        child: SizedBox(
                                                                                                          width: 200.0,
                                                                                                          child: TextFormField(
                                                                                                            controller: _model.zIPCodeTextController,
                                                                                                            focusNode: _model.zIPCodeFocusNode,
                                                                                                            autofocus: false,
                                                                                                            enabled: true,
                                                                                                            obscureText: false,
                                                                                                            decoration: InputDecoration(
                                                                                                              isDense: true,
                                                                                                              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                                                  ),
                                                                                                              hintText: 'Enter 5-digit ZIP code',
                                                                                                              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                                                  ),
                                                                                                              enabledBorder: OutlineInputBorder(
                                                                                                                borderSide: const BorderSide(
                                                                                                                  color: Color(0x00000000),
                                                                                                                  width: 1.0,
                                                                                                                ),
                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                              ),
                                                                                                              focusedBorder: OutlineInputBorder(
                                                                                                                borderSide: const BorderSide(
                                                                                                                  color: Color(0x00000000),
                                                                                                                  width: 1.0,
                                                                                                                ),
                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                              ),
                                                                                                              errorBorder: OutlineInputBorder(
                                                                                                                borderSide: BorderSide(
                                                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                                                  width: 1.0,
                                                                                                                ),
                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                              ),
                                                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                                                borderSide: BorderSide(
                                                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                                                  width: 1.0,
                                                                                                                ),
                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                              ),
                                                                                                              filled: true,
                                                                                                              fillColor: FlutterFlowTheme.of(context).alternate,
                                                                                                            ),
                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                  letterSpacing: 0.0,
                                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                ),
                                                                                                            keyboardType: TextInputType.number,
                                                                                                            cursorColor: FlutterFlowTheme.of(context).primaryText,
                                                                                                            enableInteractiveSelection: true,
                                                                                                            validator: _model.zIPCodeTextControllerValidator.asValidator(context),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                'Previous Address',
                                                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                                      fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                                                                      fontSize: 16.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                                                    ),
                                                                                              ),
                                                                                              Container(
                                                                                                width: double.infinity,
                                                                                                height: 48.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                                                  borderRadius: BorderRadius.circular(12.0),
                                                                                                  border: Border.all(
                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                    width: 1.0,
                                                                                                  ),
                                                                                                ),
                                                                                                child: Row(
                                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                                  children: [
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                                                                                      child: Icon(
                                                                                                        Icons.home,
                                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                                        size: 24.0,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                                                                                        child: SizedBox(
                                                                                                          width: 200.0,
                                                                                                          child: TextFormField(
                                                                                                            controller: _model.previousAddressTextController,
                                                                                                            focusNode: _model.previousAddressFocusNode,
                                                                                                            autofocus: false,
                                                                                                            enabled: true,
                                                                                                            obscureText: false,
                                                                                                            decoration: InputDecoration(
                                                                                                              isDense: true,
                                                                                                              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                                                  ),
                                                                                                              hintText: 'Enter previous street address',
                                                                                                              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                                                    letterSpacing: 0.0,
                                                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                                                  ),
                                                                                                              enabledBorder: OutlineInputBorder(
                                                                                                                borderSide: const BorderSide(
                                                                                                                  color: Color(0x00000000),
                                                                                                                  width: 1.0,
                                                                                                                ),
                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                              ),
                                                                                                              focusedBorder: OutlineInputBorder(
                                                                                                                borderSide: const BorderSide(
                                                                                                                  color: Color(0x00000000),
                                                                                                                  width: 1.0,
                                                                                                                ),
                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                              ),
                                                                                                              errorBorder: OutlineInputBorder(
                                                                                                                borderSide: BorderSide(
                                                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                                                  width: 1.0,
                                                                                                                ),
                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                              ),
                                                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                                                borderSide: BorderSide(
                                                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                                                  width: 1.0,
                                                                                                                ),
                                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                              ),
                                                                                                              filled: true,
                                                                                                              fillColor: FlutterFlowTheme.of(context).alternate,
                                                                                                            ),
                                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                                  letterSpacing: 0.0,
                                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                                                ),
                                                                                                            cursorColor: FlutterFlowTheme.of(context).primaryText,
                                                                                                            enableInteractiveSelection: true,
                                                                                                            validator: _model.previousAddressTextControllerValidator.asValidator(context),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: const EdgeInsetsDirectional.fromSTEB(25.0, 5.0, 25.0, 5.0),
                                                                                                child: FFButtonWidget(
                                                                                                  onPressed: () async {
                                                                                                    final address = _model.currentStreetAddressTextController.text.trim();
                                                                                                    final zip = _model.zIPCodeTextController.text.trim();
                                                                                                    if (address.isEmpty || _model.countryValue == null || _model.stateValue == null || zip.length < 5) {
                                                                                                      showSnackbar(
                                                                                                        context,
                                                                                                        'Enter a complete address and valid ZIP code.',
                                                                                                        backgroundColor: FlutterFlowTheme.of(context).error,
                                                                                                      );
                                                                                                      return;
                                                                                                    }
                                                                                                    FFAppState().stateAddress = address;
                                                                                                    FFAppState().stateCountry = _model.countryValue!;
                                                                                                    FFAppState().stateState = _model.stateValue!;
                                                                                                    FFAppState().stateZip = zip;
                                                                                                    safeSetState(() {});
                                                                                                    showSnackbar(
                                                                                                      context,
                                                                                                      'Address saved successfully!',
                                                                                                      backgroundColor: FlutterFlowTheme.of(context).secondary,
                                                                                                    );
                                                                                                    context.safePop();
                                                                                                  },
                                                                                                  text: 'Save & Return',
                                                                                                  options: FFButtonOptions(
                                                                                                    width: double.infinity,
                                                                                                    height: 45.0,
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                                    textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                                          fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                                                                          color: Colors.white,
                                                                                                          fontSize: 16.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                                                        ),
                                                                                                    elevation: 2.0,
                                                                                                    borderRadius: BorderRadius.circular(12.0),
                                                                                                  ),
                                                                                                ).animateOnPageLoad(animationsMap['buttonOnPageLoadAnimation']!),
                                                                                              ),
                                                                                            ].divide(const SizedBox(height: 20.0)),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
