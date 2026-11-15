// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Subscribes to a specified table in Supabase to receive real-time updates.

Future<void> subscribe(
    String table, Future Function() callbackAction, String sessionId) async {
  try {
    SupaFlow.client
        .channel('public:$table')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert, // Correct parameter
          schema: 'public',
          table: table,
          filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: "session_id",
              value: sessionId), // Correct filter type
          callback: (payload) async {
            await callbackAction();
          },
        )
        .subscribe();

    print('Subscribed to $table for session_id=$sessionId');
  } catch (e) {
    print('Error subscribing to $table: $e');
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
