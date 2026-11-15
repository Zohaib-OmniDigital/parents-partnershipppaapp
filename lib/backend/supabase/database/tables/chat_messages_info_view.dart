import '../database.dart';

class ChatMessagesInfoViewTable extends SupabaseTable<ChatMessagesInfoViewRow> {
  @override
  String get tableName => 'chat_messages_info_view';

  @override
  ChatMessagesInfoViewRow createRow(Map<String, dynamic> data) =>
      ChatMessagesInfoViewRow(data);
}

class ChatMessagesInfoViewRow extends SupabaseDataRow {
  ChatMessagesInfoViewRow(super.data);

  @override
  SupabaseTable get table => ChatMessagesInfoViewTable();

  int? get chatId => getField<int>('chat_id');
  set chatId(int? value) => setField<int>('chat_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);

  String? get userUuid => getField<String>('user_uuid');
  set userUuid(String? value) => setField<String>('user_uuid', value);

  String? get message => getField<String>('message');
  set message(String? value) => setField<String>('message', value);

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  int? get userId => getField<int>('user_id');
  set userId(int? value) => setField<int>('user_id', value);

  String? get profilePicture => getField<String>('profile_picture');
  set profilePicture(String? value) => setField<String>('profile_picture', value);
}
