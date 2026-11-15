// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Create a Supabase verify OTP action using email and otpCode. Use type magiclink and return true if session is not null, otherwise return false.
import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> verifyOTP(
  String email,
  String? otpCode,
) async {
  final cleanCode = otpCode?.trim() ?? '';
  final cleanEmail = email.trim();

  if (cleanCode.isEmpty || cleanEmail.isEmpty) {
    return false;
  }

  final supabase = Supabase.instance.client;

  // Try magiclink OTP first
  try {
    final AuthResponse response = await supabase.auth.verifyOTP(
      email: cleanEmail,
      token: cleanCode,
      type: OtpType.magiclink,
    );

    if (response.session != null || response.user != null) {
      return true;
    }
  } catch (e) {
    debugPrint('Error verifying OTP with magiclink: $e');
  }

  // Fallback: try email OTP
  try {
    final AuthResponse response = await supabase.auth.verifyOTP(
      email: cleanEmail,
      token: cleanCode,
      type: OtpType.email,
    );

    if (response.session != null || response.user != null) {
      return true;
    }
  } catch (e) {
    debugPrint('Error verifying OTP with email: $e');
  }

  return false;
}
