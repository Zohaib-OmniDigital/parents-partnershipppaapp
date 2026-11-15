import 'dart:async';

import 'package:flutter/material.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/keyboard_safe_form.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'signin_model.dart';

export 'signin_model.dart';

class SigninWidget extends StatefulWidget {
  const SigninWidget({super.key});

  static const String routeName = 'Signin';
  static const String routePath = '/signin';

  @override
  State<SigninWidget> createState() => _SigninWidgetState();
}

class _SigninWidgetState extends State<SigninWidget> {
  late SigninModel _model;
  final _formKey = GlobalKey<FormState>();
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SigninModel());
    _model.emailsigninTextController ??= TextEditingController();
    _model.emailsigninFocusNode ??= FocusNode();
    _model.passwordsigninTextController ??= TextEditingController();
    _model.passwordsigninFocusNode ??= FocusNode();

    _authSubscription = SupaFlow.client.auth.onAuthStateChange.listen((data) {
      if (mounted && data.session != null) {
        context.goNamed(HomeWidget.routeName);
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
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

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    GoRouter.of(context).prepareAuthEvent();
    try {
      final user = await authManager.signInWithEmail(
        context,
        _model.emailsigninTextController!.text.trim(),
        _model.passwordsigninTextController!.text,
      );
      if (user == null || !mounted) return;
      context.goNamedAuth(HomeWidget.routeName, mounted);
    } finally {
      // Re-enable router updates when validation, the request, or navigation
      // fails so a later attempt can still update the authenticated routes.
      AppStateNotifier.instance.updateNotifyOnAuthChange(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: AutofillGroup(
          child: KeyboardSafeScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              20.w,
              12.h,
              20.w,
              32.h,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (context.canPop()) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          tooltip: 'Back',
                          onPressed: context.pop,
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Image.asset(
                      'assets/images/PP_App-removebg-preview.png',
                      height: 82.h,
                      fit: BoxFit.contain,
                      semanticLabel: 'Parents Partnership',
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: theme.headlineMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Sign in to continue to your community.',
                      textAlign: TextAlign.center,
                      style: theme.bodyLarge.copyWith(
                        color: theme.secondaryText,
                        height: 1.45,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Container(
                      padding: EdgeInsets.all(20.w),
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
                              focusNode: _model.emailsigninFocusNode!,
                              child: TextFormField(
                              controller: _model.emailsigninTextController,
                              focusNode: _model.emailsigninFocusNode,
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
                            SizedBox(height: 16.h),
                            KeyboardSafeFormField(
                              focusNode: _model.passwordsigninFocusNode!,
                              child: TextFormField(
                              controller: _model.passwordsigninTextController,
                              focusNode: _model.passwordsigninFocusNode,
                              obscureText: !_model.passwordsigninVisibility,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              onFieldSubmitted: (_) => _signIn(),
                              validator: (value) => (value ?? '').isEmpty
                                  ? 'Password is required.'
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  tooltip: _model.passwordsigninVisibility
                                      ? 'Hide password'
                                      : 'Show password',
                                  onPressed: () => safeSetState(() =>
                                      _model.passwordsigninVisibility =
                                          !_model.passwordsigninVisibility),
                                  icon: Icon(_model.passwordsigninVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                ),
                              ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => context
                                    .pushNamed(ForgotPasswordWidget.routeName),
                                child: const Text('Forgot password?'),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            FFButtonWidget(
                              onPressed: _signIn,
                              text: 'Sign in',
                              options: FFButtonOptions(
                                height: 52.h,
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
                    SizedBox(height: 20.h),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          'New to Parents Partnership?',
                          style: theme.bodyMedium.copyWith(
                            color: theme.secondaryText,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.pushNamed(SignUpWidget.routeName),
                          child: const Text('Create account'),
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
    );
  }
}
