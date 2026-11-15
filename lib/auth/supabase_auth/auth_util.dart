import '/backend/supabase/supabase.dart';
import 'supabase_auth_manager.dart';

export 'supabase_auth_manager.dart';

final _authManager = SupabaseAuthManager();
SupabaseAuthManager get authManager => _authManager;

String get currentUserEmail => currentUser?.email ?? '';

String get currentUserUid => currentUser?.uid ?? '';

String get currentUserDisplayName => currentUser?.displayName ?? '';

String get currentUserPhoto => currentUser?.photoUrl ?? '';

String get currentPhoneNumber => currentUser?.phoneNumber ?? '';

String get currentJwtToken => _currentJwtToken ?? '';

bool get currentUserEmailVerified => currentUser?.emailVerified ?? false;

/// Returns the database profile for the signed-in user, creating a minimal
/// one when an older account reached the app before profile setup completed.
Future<UsersRow?> ensureCurrentUserProfile() async {
  if (currentUserUid.isEmpty) return null;

  final existing = await UsersTable().querySingleRow(
    queryFn: (q) => q.eq('user_id', currentUserUid),
  );
  if (existing.isNotEmpty) return existing.first;

  final fallbackName = currentUserDisplayName.trim().isNotEmpty
      ? currentUserDisplayName.trim()
      : currentUserEmail.split('@').first;
  try {
    return await UsersTable().insert({
      'user_id': currentUserUid,
      'email': currentUserEmail,
      'full_name': fallbackName.isEmpty ? 'Community member' : fallbackName,
      if (currentUserPhoto.trim().isNotEmpty)
        'profilepicture': currentUserPhoto.trim(),
    });
  } catch (_) {
    // A concurrent request may have created the row after our first lookup.
    final retry = await UsersTable().querySingleRow(
      queryFn: (q) => q.eq('user_id', currentUserUid),
    );
    return retry.firstOrNull;
  }
}

/// Create a Stream that listens to the current user's JWT Token.
String? _currentJwtToken;
final jwtTokenStream = SupaFlow.client.auth.onAuthStateChange
    .map(
      (authState) => _currentJwtToken = authState.session?.accessToken,
    )
    .asBroadcastStream();
