import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/app_ui_components.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'optverificatio_model.dart';
export 'optverificatio_model.dart';

/// A clean and modern verification page for a mobile app.
///
/// The top section should have a 'Verification' title and a brief sub-text
/// about confirming the account email. Below that, include a 'User
/// Email' input field with a 'Send OTP' button. Once sent, show an 'Enter
/// 6-digit Code' input field with a 'Verify Email' button.
class OptverificatioWidget extends StatefulWidget {
  const OptverificatioWidget({super.key});

  static String routeName = 'Optverificatio';
  static String routePath = '/optverificatio';

  @override
  State<OptverificatioWidget> createState() => _OptverificatioWidgetState();
}

class _OptverificatioWidgetState extends State<OptverificatioWidget> {
  late OptverificatioModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OptverificatioModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.otpController ??= TextEditingController();
    _model.otpFocusNode ??= FocusNode();

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
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 22.0,
                borderWidth: 1.0,
                buttonSize: 44.0,
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  context.safePop();
                },
              ),
              title: Text(
                'Verification',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).headlineMediumFamily,
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                    ),
              ),
              actions: const [],
              centerTitle: true,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F0FE),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 16.0,
                                        color: Color(0x334285F4),
                                        offset: Offset(
                                          0.0,
                                          4.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(50.0),
                                    border: Border.all(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.verified_rounded,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 52.0,
                                  ),
                                ),
                              ),
                              Text(
                                'Verify Your Email',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .headlineMediumFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .headlineMediumIsCustom,
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F0FE),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x33000000),
                                        offset: Offset(
                                          0.0,
                                          2.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Confirm your account email by entering the one-time verification code. A Blue Checkmark is awarded separately after the paid background check is approved.',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: const Color(0xFF4A4A6A),
                                            letterSpacing: 0.0,
                                            lineHeight: 1.5,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ].divide(const SizedBox(height: 16.0)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F9FF),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 12.0,
                                    color: Color(0x1A4285F4),
                                    offset: Offset(
                                      0.0,
                                      4.0,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 4.0,
                                          height: 20.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        Text(
                                          !_model.otpSent
                                              ? 'Step 1 — Enter Your Email'
                                              : 'Step 2 — Enter 6-digit Code',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleMediumIsCustom,
                                              ),
                                        ),
                                      ].divide(const SizedBox(width: 8.0)),
                                    ),
                                    if (!_model.otpSent) ...[
                                      TextFormField(
                                        controller: _model.textController,
                                        focusNode: _model.textFieldFocusNode,
                                        autofocus: false,
                                        textInputAction: TextInputAction.done,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText: 'yourname@email.com',
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: const Color(0xFFA0AEC0),
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                  16.0, 16.0, 16.0, 16.0),
                                          prefixIcon: const Icon(
                                            Icons.email_outlined,
                                            color: Color(0xFF4285F4),
                                            size: 20.0,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: _model
                                            .textControllerValidator
                                            .asValidator(context),
                                      ),
                                      FFButtonWidget(
                                        onPressed: () async {
                                          final email =
                                              _model.textController.text.trim();
                                          if (email.isEmpty) {
                                            showSnackbar(context,
                                                'Please enter your email');
                                            return;
                                          }
                                          try {
                                            await actions.sendOTP(email);
                                            safeSetState(() {
                                              _model.otpSent = true;
                                            });
                                            if (context.mounted) {
                                              showSnackbar(
                                                context,
                                                'OTP sent to $email. Please check your inbox and spam folder.',
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              showSnackbar(
                                                context,
                                                'Failed to send OTP: $e',
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                              );
                                            }
                                          }
                                        },
                                        text: 'Send OTP',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 52.0,
                                          padding: const EdgeInsets.all(8.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmallFamily,
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmallIsCustom,
                                              ),
                                          elevation: 0.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                    ] else ...[
                                      TextFormField(
                                        controller: _model.otpController,
                                        focusNode: _model.otpFocusNode,
                                        autofocus: true,
                                        textInputAction: TextInputAction.done,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText: '000000',
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .headlineSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmallFamily,
                                                color: const Color(0xFFA0AEC0),
                                                letterSpacing: 8.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .headlineSmallIsCustom,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                  16.0, 16.0, 16.0, 16.0),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmallFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 8.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .headlineSmallIsCustom,
                                            ),
                                        textAlign: TextAlign.center,
                                        maxLength: 6,
                                        keyboardType: TextInputType.number,
                                        validator: _model.otpControllerValidator
                                            .asValidator(context),
                                      ),
                                      FFButtonWidget(
                                        onPressed: () async {
                                          _model.verifyOTP =
                                              await actions.verifyOTP(
                                            _model.textController.text
                                                    .isNotEmpty
                                                ? _model.textController.text
                                                : currentUserEmail,
                                            _model.otpController.text,
                                          );
                                          if (!context.mounted) return;
                                          if (_model.verifyOTP == true) {
                                            context.pushNamed(
                                                MyProfileWidget.routeName);
                                          } else {
                                            showSnackbar(
                                              context,
                                              'Wrong OTP',
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                            );
                                          }
                                          safeSetState(() {});
                                        },
                                        text: 'Verify Email',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 52.0,
                                          padding: const EdgeInsets.all(8.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmallFamily,
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmallIsCustom,
                                              ),
                                          elevation: 0.0,
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          safeSetState(() {
                                            _model.otpSent = false;
                                            _model.otpController?.clear();
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                          child: Text(
                                            'Change email or resend code',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ].divide(const SizedBox(height: 16.0)),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_outline_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 16.0,
                              ),
                              Flexible(
                                child: Text(
                                  'Your information is secure and encrypted.',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodySmallFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodySmallIsCustom,
                                      ),
                                ),
                              ),
                            ].divide(const SizedBox(width: 6.0)),
                          ),
                        ]
                            .addToStart(const SizedBox(height: 32.0))
                            .addToEnd(const SizedBox(height: 48.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
