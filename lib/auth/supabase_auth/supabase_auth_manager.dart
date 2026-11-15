import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/auth/auth_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'email_auth.dart';

import 'supabase_user_provider.dart';

export '/auth/base_auth_user_provider.dart';

String _friendlyAuthError(AuthException error) {
  final message = error.message.toLowerCase();
  if (message.contains('invalid login credentials')) {
    return 'The email or password is incorrect.';
  }
  if (message.contains('email not confirmed')) {
    return 'Confirm your email before signing in.';
  }
  if (message.contains('already registered')) {
    return 'An account with this email already exists.';
  }
  if (message.contains('rate') || message.contains('too many')) {
    return 'Too many attempts. Please wait a moment and try again.';
  }
  if (message.contains('network') || message.contains('socket')) {
    return 'Check your internet connection and try again.';
  }
  return 'We could not complete that request. Please try again.';
}

class SupabaseAuthManager extends AuthManager
    with EmailSignInManager, GoogleSignInManager {
  @override
  Future signOut() {
    return SupaFlow.client.auth.signOut();
  }

  @override
  Future<bool> deleteUser(BuildContext context) async {
    try {
      if (!loggedIn) {
        if (context.mounted) {
          showSnackbar(context, 'Please sign in before deleting your account.');
        }
        return false;
      }
      await currentUser?.delete();
      try {
        await SupaFlow.client.auth.signOut(scope: SignOutScope.local);
      } catch (_) {
        // Sign out locally even if auth session is already revoked on server
      }

      // Clear local memory state and user-specific cached preferences
      FFAppState.reset();
      try {
        final prefs = await SharedPreferences.getInstance();
        final keys = prefs.getKeys().where((k) =>
            k.startsWith('chat_') ||
            k.startsWith('parentspartnership_') ||
            k.contains('unread') ||
            k.contains('pinned'));
        for (final k in keys.toList()) {
          await prefs.remove(k);
        }
      } catch (_) {}

      return true;
    } on AuthException catch (e) {
      debugPrint('Account deletion failed (AuthException): ${e.message}');
      if (context.mounted) {
        showSnackbar(context, e.message);
      }
      return false;
    } on PostgrestException catch (e) {
      debugPrint('Account deletion failed (PostgrestException): ${e.message}');
      if (context.mounted) {
        showSnackbar(context, e.message);
      }
      return false;
    } catch (error) {
      debugPrint('Account deletion failed: $error');
      if (context.mounted) {
        showSnackbar(
          context,
          'Account deletion failed: $error',
        );
      }
      return false;
    }
  }

  @override
  Future updateEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        print('Error: update email attempted with no logged in user!');
        return;
      }
      await currentUser?.updateEmail(email);
    } on AuthException catch (e) {
      if (!context.mounted) return;
      showSnackbar(context, _friendlyAuthError(e));
      return;
    }
    if (!context.mounted) return;
    showSnackbar(context, 'Email change confirmation email sent');
  }

  @override
  Future updatePassword({
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        print('Error: update password attempted with no logged in user!');
        return;
      }
      await currentUser?.updatePassword(newPassword);
    } on AuthException catch (e) {
      if (!context.mounted) return;
      showSnackbar(context, _friendlyAuthError(e));
      return;
    }
    if (!context.mounted) return;
    showSnackbar(context, 'Password updated successfully');
  }

  @override
  Future resetPassword({
    required String email,
    required BuildContext context,
    String? redirectTo,
  }) async {
    try {
      await SupaFlow.client.auth
          .resetPasswordForEmail(email, redirectTo: redirectTo);
    } on AuthException catch (e) {
      if (!context.mounted) return null;
      showSnackbar(context, _friendlyAuthError(e));
      return null;
    }
    if (!context.mounted) return;
    showSnackbar(context, 'Password reset email sent');
  }

  @override
  Future<BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _signInOrCreateAccount(
        context,
        () => emailSignInFunc(email, password),
      );

  @override
  Future<BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _signInOrCreateAccount(
        context,
        () => emailCreateAccountFunc(email, password),
      );

  @override
  Future<BaseAuthUser?> signInWithGoogle(BuildContext context) async {
    try {
      final launched = await SupaFlow.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo:
            kIsWeb ? null : 'parentspartnership://parentspartnership.com',
        authScreenLaunchMode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        showSnackbar(
            context, 'Unable to open Google sign-in. Please try again.');
      }

      // OAuth completes after Google redirects back to the app. The auth-state
      // stream updates currentUser and the router when that happens.
      return null;
    } on AuthException catch (e) {
      if (context.mounted) {
        showSnackbar(context, _friendlyAuthError(e));
      }
      return null;
    } catch (_) {
      if (context.mounted) {
        showSnackbar(context, 'Google sign-in failed. Please try again.');
      }
      return null;
    }
  }

  /// Tries to sign in or create an account using Supabase Auth.
  /// Returns the User object if sign in was successful.
  Future<BaseAuthUser?> _signInOrCreateAccount(
    BuildContext context,
    Future<User?> Function() signInFunc,
  ) async {
    try {
      final user = await signInFunc();
      final authUser =
          user == null ? null : ParentsPartnershipSupabaseUser(user);

      // Update currentUser here in case user info needs to be used immediately
      // after a user is signed in. This should be handled by the user stream,
      // but adding here too in case of a race condition where the user stream
      // doesn't assign the currentUser in time.
      if (authUser != null) {
        currentUser = authUser;
        AppStateNotifier.instance.update(authUser);
      }
      return authUser;
    } on AuthException catch (e) {
      if (!context.mounted) return null;
      showSnackbar(context, _friendlyAuthError(e));
      return null;
    } catch (error, stackTrace) {
      debugPrint('Authentication request failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (context.mounted) {
        showSnackbar(
          context,
          'Unable to sign in right now. Check your connection and try again.',
        );
      }
      return null;
    }
  }
}
