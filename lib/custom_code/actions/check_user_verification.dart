// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> checkUserVerification(String userID) async {
  try {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('users')
        .select('is_verified')
        .eq('user_id', userID)
        .maybeSingle();

    if (response != null && response['is_verified'] != null) {
      return response['is_verified'] as bool;
    }
    return false;
  } catch (e) {
    return false;
  }
}
