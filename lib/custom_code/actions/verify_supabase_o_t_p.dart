// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> verifySupabaseOTP(String email, String token) async {
  try {
    final response = await Supabase.instance.client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    );
    return response.session != null;
  } catch (e) {
    return false;
  }
}
