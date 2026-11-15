// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String?> signUpWithEmail(
  String email,
  String password,
  String confirmPassword,
) async {
  final cleanEmail = email.trim();
  if (cleanEmail.isEmpty) {
    return 'Please enter a valid email address.';
  }

  final emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (!emailPattern.hasMatch(cleanEmail)) {
    return 'Enter a valid email address.';
  }

  if (password.length < 8) {
    return 'Password must contain at least 8 characters.';
  }

  if (password != confirmPassword) {
    return 'Passwords do not match.';
  }

  try {
    final supabase = SupaFlow.client;

    final AuthResponse res = await supabase.auth.signUp(
      email: cleanEmail,
      password: password,
    );

    // If Supabase has identity checking and returns empty identities, it means user exists
    if (res.user?.identities != null && res.user!.identities!.isEmpty) {
      return 'An account with this email already exists. Please log in or reset your password.';
    }

    return null;
  } on AuthException catch (e) {
    if (e.message.toLowerCase().contains('already registered')) {
      return 'An account with this email already exists.';
    }
    if (e.message.toLowerCase().contains('network')) {
      return 'Check your internet connection and try again.';
    }
    return 'We could not create your account. Please try again.';
  } catch (_) {
    return 'We could not create your account. Please try again.';
  }
}
