// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> verifyEmailWithToken(
  String email,
  String? token,
) async {
  final cleanToken = token?.trim() ?? '';
  final cleanEmail = email.trim();

  if (cleanToken.isEmpty || cleanEmail.isEmpty) {
    return false;
  }

  final supabase = Supabase.instance.client;

  // Try OtpType.signup first (standard for email confirmation during registration)
  try {
    final AuthResponse res = await supabase.auth.verifyOTP(
      type: OtpType.signup,
      token: cleanToken,
      email: cleanEmail,
    );

    if (res.session != null || res.user != null) {
      return true;
    }
  } on AuthException catch (e) {
    debugPrint('OtpType.signup error: ${e.message}');
  } catch (error) {
    debugPrint('Error in verifyEmailWithToken (signup): $error');
  }

  // Fallback: try OtpType.email in case the OTP was issued as an email verification OTP
  try {
    final AuthResponse res = await supabase.auth.verifyOTP(
      type: OtpType.email,
      token: cleanToken,
      email: cleanEmail,
    );

    if (res.session != null || res.user != null) {
      return true;
    }
  } on AuthException catch (e) {
    debugPrint('OtpType.email error: ${e.message}');
  } catch (error) {
    debugPrint('Error in verifyEmailWithToken (email): $error');
  }

  return false;
}
