import '../database.dart';

class ChatSettingsTable extends SupabaseTable<ChatSettingsRow> {
  @override
  String get tableName => 'chat_settings';

  @override
  ChatSettingsRow createRow(Map<String, dynamic> data) => ChatSettingsRow(data);
}

class ChatSettingsRow extends SupabaseDataRow {
  ChatSettingsRow(super.data);

  @override
  SupabaseTable get table => ChatSettingsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  bool? get isOnline => getField<bool>('is_online');
  set isOnline(bool? value) => setField<bool>('is_online', value);

  String? get fcmToken => getField<String>('fcm_token');
  set fcmToken(String? value) => setField<String>('fcm_token', value);
}
