import 'package:flutter/material.dart';

import '/custom_code/actions/index.dart' as actions;
import '/components/keyboard_safe_form.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'sign_up_model.dart';

export 'sign_up_model.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  static const String routeName = 'SignUp';
  static const String routePath = '/signUp';

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  late SignUpModel _model;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignUpModel());
    _model.emailsignupTextController ??= TextEditingController();
    _model.emailsignupFocusNode ??= FocusNode();
    _model.passwordsignupTextController ??= TextEditingController();
    _model.passwordsignupFocusNode ??= FocusNode();
    _model.confirmPasswordsignupTextController ??= TextEditingController();
    _model.confirmPasswordsignupFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required.';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').length < 8) {
      return 'Use at least 8 characters.';
    }
    return null;
  }

  Future<void> _submitEmailSignUp() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final email = _model.emailsignupTextController!.text.trim();
    final password = _model.passwordsignupTextController!.text;
    final confirmPassword = _model.confirmPasswordsignupTextController!.text;
    final error = await actions.signUpWithEmail(
      email,
      password,
      confirmPassword,
    );
    if (!mounted) return;

    if (error != null && error.isNotEmpty) {
      showSnackbar(
        context,
        error,
        backgroundColor: FlutterFlowTheme.of(context).error,
      );
      return;
    }

    context.pushNamed(
      OptVerificationPageWidget.routeName,
      queryParameters: {
        'email': serializeParam(email, ParamType.String),
        'password': serializeParam(password, ParamType.String),
        'confirmPassword': serializeParam(confirmPassword, ParamType.String),
      }.withoutNulls,
    );
  }

  void _returnToSignIn() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(SigninWidget.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return PopScope(
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _returnToSignIn();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: AutofillGroup(
            child: KeyboardSafeScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          tooltip: 'Back',
                          onPressed: _returnToSignIn,
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Image.asset(
                        'assets/images/PP_App-removebg-preview.png',
                        height: 82,
                        fit: BoxFit.contain,
                        semanticLabel: 'Parents Partnership',
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Create your account',
                        textAlign: TextAlign.center,
                        style: theme.headlineMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join a trusted community built to support parents.',
                        textAlign: TextAlign.center,
                        style: theme.bodyLarge.copyWith(
                          color: theme.secondaryText,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE5E9F0)),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              KeyboardSafeFormField(
                                focusNode: _model.emailsignupFocusNode!,
                                child: TextFormField(
                                controller: _model.emailsignupTextController,
                                focusNode: _model.emailsignupFocusNode,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                autocorrect: false,
                                validator: _validateEmail,
                                decoration: const InputDecoration(
                                  labelText: 'Email address',
                                  hintText: 'name@example.com',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              KeyboardSafeFormField(
                                focusNode: _model.passwordsignupFocusNode!,
                                child: TextFormField(
                                controller: _model.passwordsignupTextController,
                                focusNode: _model.passwordsignupFocusNode,
                                obscureText: !_model.passwordsignupVisibility,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [
                                  AutofillHints.newPassword
                                ],
                                validator: _validatePassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  helperText: 'At least 8 characters',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    tooltip: _model.passwordsignupVisibility
                                        ? 'Hide password'
                                        : 'Show password',
                                    onPressed: () => safeSetState(() =>
                                        _model.passwordsignupVisibility =
                                            !_model.passwordsignupVisibility),
                                    icon: Icon(_model.passwordsignupVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined),
                                  ),
                                ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              KeyboardSafeFormField(
                                focusNode:
                                    _model.confirmPasswordsignupFocusNode!,
                                child: TextFormField(
                                controller:
                                    _model.confirmPasswordsignupTextController,
                                focusNode:
                                    _model.confirmPasswordsignupFocusNode,
                                obscureText:
                                    !_model.confirmPasswordsignupVisibility,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [
                                  AutofillHints.newPassword
                                ],
                                onFieldSubmitted: (_) => _submitEmailSignUp(),
                                validator: (value) {
                                  final passwordError =
                                      _validatePassword(value);
                                  if (passwordError != null) {
                                    return passwordError;
                                  }
                                  if (value !=
                                      _model
                                          .passwordsignupTextController!.text) {
                                    return 'Passwords do not match.';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Confirm password',
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    tooltip:
                                        _model.confirmPasswordsignupVisibility
                                            ? 'Hide password'
                                            : 'Show password',
                                    onPressed: () => safeSetState(() => _model
                                            .confirmPasswordsignupVisibility =
                                        !_model
                                            .confirmPasswordsignupVisibility),
                                    icon: Icon(
                                        _model.confirmPasswordsignupVisibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined),
                                  ),
                                ),
                              ),
                              ),
                              const SizedBox(height: 20),
                              FFButtonWidget(
                                onPressed: _submitEmailSignUp,
                                text: 'Create account',
                                options: FFButtonOptions(
                                  height: 52,
                                  color: theme.primary,
                                  textStyle: theme.titleSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: theme.bodyMedium.copyWith(
                              color: theme.secondaryText,
                            ),
                          ),
                          TextButton(
                            onPressed: _returnToSignIn,
                            child: const Text('Sign in'),
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
