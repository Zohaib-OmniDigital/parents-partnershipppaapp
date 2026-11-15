import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/components/keyboard_safe_form.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'forgot_password_model.dart';
export 'forgot_password_model.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  static String routeName = 'ForgotPassword';
  static String routePath = '/resetPasswordPage';

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  late ForgotPasswordModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ForgotPasswordModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

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
        canPop: context.canPop(),
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) context.goNamed(SigninWidget.routeName);
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
              icon: FaIcon(
                FontAwesomeIcons.angleLeft,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed(SigninWidget.routeName);
                }
              },
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(),
                  child: ListView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
                    ),
                    shrinkWrap: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    32.0, 48.0, 32.0, 48.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              0.0, 0.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/PP_App-removebg-preview.png',
                                              width: 200.0,
                                              height: 100.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              0.0, 0.0),
                                          child: Text(
                                            'Trouble Logging In?',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineMediumFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .headlineMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              0.0, 0.0),
                                          child: Text(
                                            'Enter your email and we will send you a link to reset your password.',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 12.0)),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        KeyboardSafeFormField(
                                          focusNode:
                                              _model.textFieldFocusNode!,
                                          child: TextFormField(
                                          controller: _model.textController,
                                          focusNode: _model.textFieldFocusNode,
                                          onFieldSubmitted: (_) async {
                                            safeSetState(() {
                                              _model.textController?.clear();
                                            });
                                          },
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                            hintText: 'someone@thisemail.com',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
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
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                            contentPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    16.0, 16.0, 16.0, 16.0),
                                            hoverColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: _model
                                              .textControllerValidator
                                              .asValidator(context),
                                          ),
                                        ),
                                        FFButtonWidget(
                                          onPressed: () async {
                                            _model.error =
                                                await actions.sendRecoveryEmail(
                                              _model.textController.text,
                                              kIsWeb
                                                  ? Uri.base.origin
                                                  : 'parentspartnership://parentspartnership.com',
                                            );
                                            if (!context.mounted) return;
                                            if (_model.error == null ||
                                                _model.error == '') {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return WebViewAware(
                                                    child: AlertDialog(
                                                      title: const Text(
                                                          'Email Successfully Sent'),
                                                      content: const Text(
                                                          'A recovery email been sent. Please check your yunk folder as well.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext),
                                                          child:
                                                              const Text('Ok'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return WebViewAware(
                                                    child: AlertDialog(
                                                      title:
                                                          const Text('Error'),
                                                      content:
                                                          Text(_model.error!),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext),
                                                          child:
                                                              const Text('Ok'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            }

                                            safeSetState(() {});
                                          },
                                          text: 'Send Recovery Email',
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 45.0,
                                            padding: const EdgeInsets.all(8.0),
                                            iconPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: const Color(0xFF1A3399),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMediumFamily,
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMediumIsCustom,
                                                    ),
                                            elevation: 1.0,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1.0,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                        ),
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              0.0, 0.0),
                                          child: Text(
                                            'Did not receive an email?',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              _model.errorCopy = await actions
                                                  .sendRecoveryEmail(
                                                _model.textController.text,
                                                kIsWeb
                                                    ? Uri.base.origin
                                                    : 'parentspartnership://parentspartnership.com',
                                              );
                                              if (!context.mounted) return;
                                              if (_model.errorCopy == null ||
                                                  _model.errorCopy == '') {
                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return WebViewAware(
                                                      child: AlertDialog(
                                                        title: const Text(
                                                            'Email Successfully Sent'),
                                                        content: const Text(
                                                            'A recovery email been sent. Please check your yunk folder as well.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    alertDialogContext),
                                                            child: const Text(
                                                                'Ok'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return WebViewAware(
                                                      child: AlertDialog(
                                                        title:
                                                            const Text('Error'),
                                                        content: Text(
                                                            _model.errorCopy!),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    alertDialogContext),
                                                            child: const Text(
                                                                'Ok'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }

                                              safeSetState(() {});
                                            },
                                            child: Text(
                                              'Resend Recovery Email',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ].divide(const SizedBox(height: 16.0)),
                                    ),
                                  ].divide(const SizedBox(height: 32.0)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
