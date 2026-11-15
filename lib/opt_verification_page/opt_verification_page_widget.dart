import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'opt_verification_page_model.dart';
export 'opt_verification_page_model.dart';

/// OPT verification page for confirming account via 6-digit OTP code
class OptVerificationPageWidget extends StatefulWidget {
  const OptVerificationPageWidget({
    super.key,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String? email;
  final String? password;
  final String? confirmPassword;

  static String routeName = 'OptVerificationPage';
  static String routePath = '/optVerificationPage';

  @override
  State<OptVerificationPageWidget> createState() =>
      _OptVerificationPageWidgetState();
}

class _OptVerificationPageWidgetState extends State<OptVerificationPageWidget> {
  late OptVerificationPageModel _model;
  bool _isResending = false;
  bool _isVerifying = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OptVerificationPageModel());

    _model.pinCodeFocusNode ??= FocusNode();

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
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          bottom: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FlutterFlowIconButton(
                                borderRadius: 8.0,
                                buttonSize: 40.0,
                                fillColor: Colors.transparent,
                                icon: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                onPressed: context.safePop,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: Container(
                                  width: 80.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primary
                                        .withValues(alpha: .10),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.mark_email_read_outlined,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 40.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                'Verification Code',
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
                                      lineHeight: 1.25,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .headlineMediumIsCustom,
                                    ),
                              ),
                              const SizedBox(height: 8.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'We have sent a 6-digit verification code to ${widget.email ?? 'your email'}. Please enter it below to confirm your account.',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyLargeFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        lineHeight: 1.5,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyLargeIsCustom,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: PinCodeTextField(
                              autoDisposeControllers: false,
                              appContext: context,
                              length: 6,
                              textStyle: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .headlineSmallFamily,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .headlineSmallIsCustom,
                                  ),
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              enableActiveFill: false,
                              autoFocus: false,
                              focusNode: _model.pinCodeFocusNode,
                              enablePinAutofill: true,
                              errorTextSpace: 16.0,
                              showCursor: true,
                              cursorColor: FlutterFlowTheme.of(context).primary,
                              obscureText: false,
                              hintCharacter: '●',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              pinTheme: PinTheme(
                                fieldHeight: 48.0,
                                fieldWidth: 42.0,
                                borderWidth: 2.0,
                                borderRadius: BorderRadius.circular(10.0),
                                shape: PinCodeFieldShape.box,
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                inactiveColor:
                                    FlutterFlowTheme.of(context).alternate,
                                selectedColor:
                                    FlutterFlowTheme.of(context).primary,
                              ),
                              controller: _model.pinCodeController,
                              onChanged: (_) {},
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: _model.pinCodeControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: FFButtonWidget(
                              onPressed: _isVerifying
                                  ? null
                                  : () async {
                                      final code = _model
                                              .pinCodeController?.text
                                              .trim() ??
                                          '';
                                      if (code.isEmpty || code.length < 6) {
                                        showSnackbar(
                                          context,
                                          'Please enter the full 6-digit verification code.',
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .error,
                                        );
                                        return;
                                      }

                                      safeSetState(() => _isVerifying = true);
                                      try {
                                        _model.isVerified =
                                            await actions.verifyEmailWithToken(
                                          widget.email ?? '',
                                          code,
                                        );
                                        if (!context.mounted) return;
                                        if (_model.isVerified == true) {
                                          context.goNamed(
                                              ProfileSetupWidget.routeName);
                                        } else {
                                          showSnackbar(
                                            context,
                                            'That code is incorrect or has expired. Request a new code and try again.',
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .error,
                                          );
                                          _model.pinCodeController?.clear();
                                        }
                                      } finally {
                                        if (mounted) {
                                          safeSetState(
                                              () => _isVerifying = false);
                                        }
                                      }
                                    },
                              text: _isVerifying
                                  ? 'Checking code…'
                                  : 'Confirm code',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 48.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.zero,
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleSmallFamily,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .titleSmallIsCustom,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).tertiary,
                                ),
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Didn't receive the code? ",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                    TextSpan(
                                      text: _isResending
                                          ? 'Sending...'
                                          : 'Resend Code',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                      mouseCursor: SystemMouseCursors.click,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          if (_isResending) return;
                                          final email =
                                              widget.email?.trim() ?? '';
                                          if (email.isEmpty) {
                                            showSnackbar(
                                              context,
                                              'Email address not found.',
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                            );
                                            return;
                                          }

                                          safeSetState(() {
                                            _isResending = true;
                                          });

                                          try {
                                            final supabase =
                                                Supabase.instance.client;
                                            await supabase.auth.resend(
                                              type: OtpType.signup,
                                              email: email,
                                            );
                                            if (context.mounted) {
                                              showSnackbar(
                                                context,
                                                'A new verification code was sent to $email. Please check your inbox and spam folder.',
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                              );
                                            }
                                          } on AuthException {
                                            try {
                                              final supabase =
                                                  Supabase.instance.client;
                                              await supabase.auth.resend(
                                                type: OtpType.email,
                                                email: email,
                                              );
                                              if (context.mounted) {
                                                showSnackbar(
                                                  context,
                                                  'A new verification code was sent to $email. Please check your inbox and spam folder.',
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                );
                                                safeSetState(() {
                                                  _isResending = false;
                                                });
                                                return;
                                              }
                                            } catch (_) {}

                                            if (context.mounted) {
                                              showSnackbar(
                                                context,
                                                'Could not resend the code. Please wait a moment and try again.',
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                              );
                                            }
                                          } catch (_) {
                                            if (context.mounted) {
                                              showSnackbar(
                                                context,
                                                'Could not resend the code. Check your connection and try again.',
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                              );
                                            }
                                          } finally {
                                            if (mounted) {
                                              safeSetState(() {
                                                _isResending = false;
                                              });
                                            }
                                          }
                                        },
                                    ),
                                  ],
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 16.0),
                          Center(
                            child: Text(
                              'Parents Partnership',
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelLargeFamily,
                                    color: const Color(0x6614181B),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    lineHeight: 1.33,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelLargeIsCustom,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
