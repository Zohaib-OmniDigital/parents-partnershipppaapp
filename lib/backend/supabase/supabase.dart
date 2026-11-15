import 'package:supabase_flutter/supabase_flutter.dart';

export 'database/database.dart';
export 'storage/storage.dart';

String _kSupabaseUrl = 'https://etdtsmjisbxyefwjcczw.supabase.co';
String _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV0ZHRzbWppc2J4eWVmd2pjY3p3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU5MzkwMjgsImV4cCI6MjA5MTUxNTAyOH0.k00xmonliKyuM3EY2IPRD01Mp3r1u813iWRmPGBN-Wk';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        headers: {
          'X-Client-Info': 'flutterflow',
        },
        anonKey: _kSupabaseAnonKey,
        debug: false,
        authOptions:
            const FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
      );
}
