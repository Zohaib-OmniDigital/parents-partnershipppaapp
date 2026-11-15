import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_checkbox_group.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'connected2_model.dart';
export 'connected2_model.dart';

class Connected2Widget extends StatefulWidget {
  const Connected2Widget({
    super.key,
    required this.connect,
  });

  final int? connect;

  static String routeName = 'CONNECTED2';
  static String routePath = '/CONNECTED2';

  @override
  State<Connected2Widget> createState() => _Connected2WidgetState();
}

class _Connected2WidgetState extends State<Connected2Widget>
    with TickerProviderStateMixin {
  late Connected2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Connected2Model());

    animationsMap.addAll({
      'checkboxGroupOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 70.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

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
          resizeToAvoidBottomInset: false,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
              icon: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
            title: Text(
              'Children\'s Age Group',
              style: FlutterFlowTheme.of(context).displaySmall.override(
                    fontFamily: FlutterFlowTheme.of(context).displaySmallFamily,
                    fontSize: 24.0,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).displaySmallIsCustom,
                  ),
            ),
            actions: [
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                child: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 50.0,
                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  icon: Icon(
                    Icons.close_rounded,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
            centerTitle: false,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Stack(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          24.0, 0.0, 24.0, 0.0),
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
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
                                  controller: _model.columnController,
                                  child: SingleChildScrollView(
                                    controller: _model.columnController,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              -1.0, 0.0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 12.0, 0.0, 0.0),
                                            child: Text(
                                              'Question 2/8',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8.0, 12.0, 8.0, 0.0),
                                          child: LinearPercentIndicator(
                                            percent: 0.25,
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.96,
                                            lineHeight: 12.0,
                                            animation: true,
                                            animateFromLastPercent: true,
                                            progressColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            barRadius:
                                                const Radius.circular(24.0),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 100.0, 0.0, 0.0),
                                          child: Text(
                                            'What age group(s) \nare your children in?',
                                            style: FlutterFlowTheme.of(context)
                                                .displaySmall
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .displaySmallFamily,
                                                  fontSize: 30.0,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .displaySmallIsCustom,
                                                ),
                                          ),
                                        ),
                                        Wrap(
                                          spacing: 0.0,
                                          runSpacing: 0.0,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          direction: Axis.horizontal,
                                          runAlignment: WrapAlignment.center,
                                          verticalDirection:
                                              VerticalDirection.down,
                                          clipBehavior: Clip.none,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 12.0, 16.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              12.0, 0.0, 12.0),
                                                      child:
                                                          FlutterFlowCheckboxGroup(
                                                        options: const [
                                                          'Expecting / Infants (0-1 year)',
                                                          'Toddlers (1-3 years)',
                                                          'Preschoolers (4-5 years)',
                                                          'School Age (6-12 years)',
                                                          'Teens (13+ years)'
                                                        ],
                                                        onChanged: (val) async {
                                                          safeSetState(() =>
                                                              _model.checkboxGroupValues =
                                                                  val);
                                                          FFAppState()
                                                                  .q2childrenage =
                                                              _model
                                                                  .checkboxGroupValues!
                                                                  .toList()
                                                                  .cast<
                                                                      String>();
                                                          safeSetState(() {});
                                                        },
                                                        controller: _model
                                                                .checkboxGroupValueController ??=
                                                            FormFieldController<
                                                                List<String>>(
                                                          [],
                                                        ),
                                                        activeColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        checkColor:
                                                            Colors.white,
                                                        checkboxBorderColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLargeFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLargeIsCustom,
                                                                ),
                                                        itemPadding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0.0,
                                                                0.0, 0.0, 12.0),
                                                        checkboxBorderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        initialized: _model
                                                                .checkboxGroupValues !=
                                                            null,
                                                      ).animateOnPageLoad(
                                                              animationsMap[
                                                                  'checkboxGroupOnPageLoadAnimation']!),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 32.0, 0.0, 32.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      context.pushNamed(
                                        Connected3Widget.routeName,
                                        queryParameters: {
                                          'connect': serializeParam(
                                            0,
                                            ParamType.int,
                                          ),
                                        }.withoutNulls,
                                      );
                                    },
                                    text: 'Next',
                                    options: FFButtonOptions(
                                      width: 300.w,
                                      height: 45.0,
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      iconPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmallFamily,
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .titleSmallIsCustom,
                                          ),
                                      elevation: 0.0,
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
