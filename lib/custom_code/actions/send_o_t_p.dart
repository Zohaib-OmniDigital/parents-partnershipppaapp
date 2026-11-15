// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Create a custom action to send an OTP via email using Supabase Auth. It should take one argument 'email' (String). Use the 'Supabase.instance.client.auth.signInWithOtp' method and set 'shouldCreateUser' to false.
import 'package:supabase_flutter/supabase_flutter.dart';

Future sendOTP(String email) async {
  await Supabase.instance.client.auth.signInWithOtp(
    email: email,
    shouldCreateUser: false,
  );
}
