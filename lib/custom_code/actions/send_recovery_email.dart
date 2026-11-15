// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String?> sendRecoveryEmail(
  String email,
  String? redirectTo,
) async {
  final cleanEmail = email.trim();
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(cleanEmail)) {
    return 'Enter a valid email address.';
  }

  // Get a reference your Supabase client
  final supabase = SupaFlow.client;

  // Try to send password recovery email
  try {
    await supabase.auth
        .resetPasswordForEmail(cleanEmail, redirectTo: redirectTo);
    return null;
  } on AuthException catch (e) {
    if (e.message.toLowerCase().contains('rate')) {
      return 'Too many requests. Please wait a moment and try again.';
    }
    return 'We could not send the reset email. Please try again.';
  } catch (_) {
    return 'Check your internet connection and try again.';
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
