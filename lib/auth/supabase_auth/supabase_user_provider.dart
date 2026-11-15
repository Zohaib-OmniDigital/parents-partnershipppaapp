import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '/backend/supabase/supabase.dart';
import '../base_auth_user_provider.dart';

export '../base_auth_user_provider.dart';

class ParentsPartnershipSupabaseUser extends BaseAuthUser {
  ParentsPartnershipSupabaseUser(this.user);
  User? user;
  @override
  bool get loggedIn => user != null;

  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(
        uid: user?.id,
        email: user?.email,
        displayName: user?.userMetadata?['full_name'] as String? ??
            user?.userMetadata?['name'] as String?,
        photoUrl: user?.userMetadata?['avatar_url'] as String? ??
            user?.userMetadata?['picture'] as String?,
        phoneNumber: user?.phone,
      );

  @override
  Future<void> delete() async {
    final session = SupaFlow.client.auth.currentSession;
    final userUuid = session?.user.id;
    if (userUuid == null) {
      throw const AuthException('Please sign in before deleting your account.');
    }

    // 1. Try PostgreSQL RPC 'delete_own_account' first.
    // This executes atomically with security definer permissions in PostgreSQL.
    Object? rpcError;
    try {
      await SupaFlow.client.rpc('delete_own_account');
      user = null;
      return;
    } catch (e) {
      rpcError = e;
      debugPrint('delete_own_account RPC attempt error: $e');
    }

    // 2. Fall back to Edge Function 'delete-account' with explicit auth header.
    try {
      final token = session?.accessToken ?? '';
      final response = await SupaFlow.client.functions.invoke(
        'delete-account',
        headers: token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null,
      );
      if (response.status >= 200 && response.status < 300) {
        user = null;
        return;
      }
    } catch (e) {
      debugPrint('delete-account Edge Function attempt error: $e');
    }

    // 3. Fallback: Clean up client-accessible public tables directly from Flutter
    try {
      int? profileId;
      try {
        final res = await SupaFlow.client
            .from('users')
            .select('id')
            .eq('user_id', userUuid)
            .maybeSingle();
        if (res != null && res['id'] != null) {
          profileId = res['id'] is int
              ? res['id'] as int
              : int.tryParse(res['id'].toString());
        }
      } catch (_) {}

      if (profileId != null) {
        try {
          await SupaFlow.client
              .from('forums_comments')
              .delete()
              .eq('user_id', profileId);
        } catch (_) {}
        try {
          await SupaFlow.client
              .from('forums_posts')
              .delete()
              .eq('user_id', profileId);
        } catch (_) {}
        try {
          await SupaFlow.client
              .from('a_chats_message')
              .delete()
              .eq('user_id', profileId);
        } catch (_) {}
        try {
          await SupaFlow.client
              .from('a_chats_users')
              .delete()
              .eq('users_id', profileId);
        } catch (_) {}
        try {
          await SupaFlow.client
              .from('messages')
              .delete()
              .eq('reciepient_id', profileId);
        } catch (_) {}
      }

      try {
        await SupaFlow.client
            .from('messages')
            .delete()
            .eq('sender_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client
            .from('chat_participants')
            .delete()
            .eq('user_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client
            .from('chat_participants')
            .delete()
            .eq('chat_user_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client
            .from('chat_settings')
            .delete()
            .eq('user_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client
            .from('connections')
            .delete()
            .eq('sender_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client
            .from('connections')
            .delete()
            .eq('receiver_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client.from('posts').delete().eq('user_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client
            .from('support_tickets')
            .delete()
            .eq('user_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client
            .from('quiz_answers')
            .delete()
            .eq('user_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client
            .from('verifications')
            .delete()
            .eq('user_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client
            .from('background_checks')
            .delete()
            .eq('user_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client
            .from('profile_picture')
            .delete()
            .eq('user_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client
            .from('user_profiles')
            .delete()
            .eq('user_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client.from('user').delete().eq('id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client
            .from('user_id')
            .delete()
            .eq('user_id', userUuid);
      } catch (_) {}
      try {
        await SupaFlow.client.from('users').delete().eq('user_id', userUuid);
      } catch (_) {}

      // Retry the RPC after child tables have been cleaned up
      try {
        await SupaFlow.client.rpc('delete_own_account');
        user = null;
        return;
      } catch (_) {}
    } catch (_) {}

    if (rpcError is PostgrestException) {
      final msg = rpcError.message.toLowerCase();
      if (rpcError.code == '42883' ||
          msg.contains('delete_own_account') ||
          msg.contains('not find')) {
        throw const AuthException(
          'Please run the delete_own_account SQL script in Supabase SQL Editor to enable account deletion.',
        );
      }
      throw AuthException(rpcError.message);
    }
    if (rpcError is AuthException) {
      throw rpcError;
    }
    throw const AuthException(
      'Account deletion failed. Please ensure the delete_own_account SQL script is run in Supabase SQL Editor.',
    );
  }

  @override
  Future? updateEmail(String email) async {
    final response =
        await SupaFlow.client.auth.updateUser(UserAttributes(email: email));
    if (response.user != null) {
      user = response.user;
    }
  }

  @override
  Future? updatePassword(String newPassword) async {
    final response = await SupaFlow.client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
    if (response.user != null) {
      user = response.user;
    }
  }

  @override
  Future? sendEmailVerification() => throw UnsupportedError(
      'The send email verification operation is not yet supported.');

  @override
  bool get emailVerified {
    // Reloads the user when checking in order to get the most up to date
    // email verified status.
    if (loggedIn && user!.emailConfirmedAt == null) {
      refreshUser();
    }
    return user?.emailConfirmedAt != null;
  }

  @override
  Future refreshUser() async {
    await SupaFlow.client.auth
        .refreshSession()
        .then((_) => user = SupaFlow.client.auth.currentUser);
  }
}

/// Generates a stream of the authenticated user.
/// [SupaFlow.client.auth.onAuthStateChange] does not yield any values until the
/// user is already authenticated. So we add a default null user to the stream,
/// if we need to interact with the [currentUser] before logging in.
Stream<BaseAuthUser> parentsPartnershipSupabaseUserStream() {
  final supabaseAuthStream = SupaFlow.client.auth.onAuthStateChange.debounce(
      (authState) => authState.event == AuthChangeEvent.tokenRefreshed
          ? TimerStream(authState, const Duration(seconds: 1))
          : Stream.value(authState));
  return (!loggedIn
          ? Stream<AuthState?>.value(null).concatWith([supabaseAuthStream])
          : supabaseAuthStream)
      .map<BaseAuthUser>(
    (authState) {
      currentUser = ParentsPartnershipSupabaseUser(authState?.session?.user);
      return currentUser!;
    },
  );
}
