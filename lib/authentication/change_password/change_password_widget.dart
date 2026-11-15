import 'package:flutter/material.dart';

import '/custom_code/actions/index.dart' as actions;
import '/components/keyboard_safe_form.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'change_password_model.dart';

export 'change_password_model.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({super.key});

  static const String routeName = 'ChangePassword';
  static const String routePath = '/changePassword';

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  late ChangePasswordModel _model;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChangePasswordModel());
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').length < 8) return 'Use at least 8 characters.';
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final error = await actions.updatePassword(
      _model.textController2!.text,
      _model.textController3!.text,
    );
    if (!mounted) return;
    if (error != null) {
      showSnackbar(
        context,
        error,
        backgroundColor: FlutterFlowTheme.of(context).error,
      );
      return;
    }
    showSnackbar(
      context,
      'Password updated successfully.',
      backgroundColor: FlutterFlowTheme.of(context).success,
    );
    context.goNamed(HomeWidget.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: context.safePop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: const Text('Change password'),
      ),
      body: SafeArea(
        top: false,
        child: KeyboardSafeScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            24,
            20,
            32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset_rounded,
                        color: theme.primary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Set a secure password',
                      textAlign: TextAlign.center,
                      style: theme.headlineSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Use at least 8 characters and avoid passwords you use elsewhere.',
                      textAlign: TextAlign.center,
                      style: theme.bodyMedium.copyWith(
                        color: theme.secondaryText,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 28),
                    KeyboardSafeFormField(
                      focusNode: _model.textFieldFocusNode2!,
                      child: TextFormField(
                      controller: _model.textController2,
                      focusNode: _model.textFieldFocusNode2,
                      obscureText: !_model.passwordVisibility2,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        labelText: 'New password',
                        helperText: 'At least 8 characters',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _model.passwordVisibility2
                              ? 'Hide password'
                              : 'Show password',
                          onPressed: () => safeSetState(() =>
                              _model.passwordVisibility2 =
                                  !_model.passwordVisibility2),
                          icon: Icon(_model.passwordVisibility2
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    KeyboardSafeFormField(
                      focusNode: _model.textFieldFocusNode3!,
                      child: TextFormField(
                      controller: _model.textController3,
                      focusNode: _model.textFieldFocusNode3,
                      obscureText: !_model.passwordVisibility3,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      onFieldSubmitted: (_) => _submit(),
                      validator: (value) {
                        final error = _validatePassword(value);
                        if (error != null) return error;
                        if (value != _model.textController2!.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Confirm new password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _model.passwordVisibility3
                              ? 'Hide password'
                              : 'Show password',
                          onPressed: () => safeSetState(() =>
                              _model.passwordVisibility3 =
                                  !_model.passwordVisibility3),
                          icon: Icon(_model.passwordVisibility3
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FFButtonWidget(
                      onPressed: _submit,
                      text: 'Update password',
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
          ),
        ),
      ),
    );
  }
}
