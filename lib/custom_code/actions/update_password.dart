// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String?> updatePassword(
  String newPassword,
  String confirmNewPassword,
) async {
  final supabase = SupaFlow.client;

  if (newPassword.length < 8) {
    return 'Password must contain at least 8 characters.';
  }

  if (newPassword != confirmNewPassword) {
    return 'Passwords do not match.';
  }

  try {
    await supabase.auth.updateUser(UserAttributes(password: newPassword));

    return null;
  } on AuthException catch (e) {
    if (e.message.toLowerCase().contains('same password')) {
      return 'Choose a password different from your current password.';
    }
    return 'We could not update your password. Please try again.';
  } catch (_) {
    return 'Check your internet connection and try again.';
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
