import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/app_ui_components.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'approved_model.dart';
export 'approved_model.dart';

class ApprovedWidget extends StatefulWidget {
  const ApprovedWidget({super.key});

  static String routeName = 'Approved';
  static String routePath = '/approved';

  @override
  State<ApprovedWidget> createState() => _ApprovedWidgetState();
}

class _ApprovedWidgetState extends State<ApprovedWidget> {
  late ApprovedModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ApprovedModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UsersRow>>(
      future: UsersTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'user_id',
          currentUserUid,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (snapshot.hasError) {
          return const Scaffold(body: AppErrorState());
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: AppShimmerList());
        }

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: PopScope(
            canPop: false,
            child: Scaffold(
              key: scaffoldKey,
              resizeToAvoidBottomInset: false,
              backgroundColor: const Color(0xFFF4F6FF),
              appBar: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).tertiary,
                automaticallyImplyLeading: false,
                title: Stack(
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        'Approved',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .headlineMediumFamily,
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .headlineMediumIsCustom,
                            ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(1.13, 0.0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 16.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderColor: FlutterFlowTheme.of(context).tertiary,
                          borderRadius: 30.0,
                          borderWidth: 1.0,
                          buttonSize: 50.0,
                          fillColor: FlutterFlowTheme.of(context).tertiary,
                          icon: Icon(
                            Icons.close_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 36.0,
                          ),
                          onPressed: () async {
                            context.goNamed(HomeWidget.routeName);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                actions: const [],
                centerTitle: false,
              ),
              body: SafeArea(
                top: true,
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                                child: ScrollConfiguration(
                                  behavior:
                                      ScrollConfiguration.of(context).copyWith(
                                    scrollbars: false,
                                    dragDevices: {
                                      PointerDeviceKind.mouse,
                                      PointerDeviceKind.touch,
                                      PointerDeviceKind.stylus,
                                      PointerDeviceKind.unknown,
                                    },
                                  ),
                                  child: Scrollbar(
                                    controller: _model.columnController1,
                                    child: SingleChildScrollView(
                                      controller: _model.columnController1,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                                32.0, 60.0, 32.0, 0.0),
                                            child: ScrollConfiguration(
                                              behavior: ScrollConfiguration.of(
                                                      context)
                                                  .copyWith(
                                                scrollbars: false,
                                                dragDevices: {
                                                  PointerDeviceKind.mouse,
                                                  PointerDeviceKind.touch,
                                                  PointerDeviceKind.stylus,
                                                  PointerDeviceKind.unknown,
                                                },
                                              ),
                                              child: Scrollbar(
                                                controller:
                                                    _model.columnController2,
                                                child: SingleChildScrollView(
                                                  primary: false,
                                                  controller:
                                                      _model.columnController2,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Congratulation Status!',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineMediumIsCustom,
                                                                ),
                                                          ),
                                                          Text(
                                                            'Your documents have been approved.',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLargeFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLargeIsCustom,
                                                                ),
                                                          ),
                                                        ].divide(const SizedBox(
                                                            height: 12.0)),
                                                      ),
                                                      Container(
                                                        width: 200.0,
                                                        height: 200.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  const AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child: Container(
                                                                width: 160.0,
                                                                height: 160.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child:
                                                                    const Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child: Icon(
                                                                    Icons
                                                                        .check_rounded,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 90.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        'Your profile is now verified and a blue tick has been added to your profile.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLargeFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLargeIsCustom,
                                                                ),
                                                      ),
                                                      Material(
                                                        color:
                                                            Colors.transparent,
                                                        elevation: 4.0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    24.0,
                                                                    24.0,
                                                                    24.0,
                                                                    24.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    context.pushNamed(
                                                                        MyProfileWidget
                                                                            .routeName);
                                                                  },
                                                                  text:
                                                                      'Go to Profile',
                                                                  options:
                                                                      FFButtonOptions(
                                                                    width: double
                                                                        .infinity,
                                                                    height:
                                                                        52.0,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    iconPadding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).titleMediumFamily,
                                                                          color:
                                                                              Colors.white,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                                        ),
                                                                    elevation:
                                                                        2.0,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                ),
                                                              ].divide(
                                                                  const SizedBox(
                                                                      height:
                                                                          16.0)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ].divide(const SizedBox(
                                                        height: 24.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
              ),
            ),
          ),
        );
      },
    );
  }
}
