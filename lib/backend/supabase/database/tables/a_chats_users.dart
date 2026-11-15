import '../database.dart';

class AChatsUsersTable extends SupabaseTable<AChatsUsersRow> {
  @override
  String get tableName => 'a_chats_users';

  @override
  AChatsUsersRow createRow(Map<String, dynamic> data) => AChatsUsersRow(data);
}

class AChatsUsersRow extends SupabaseDataRow {
  AChatsUsersRow(super.data);

  @override
  SupabaseTable get table => AChatsUsersTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  int? get chatId => getField<int>('chat_id');
  set chatId(int? value) => setField<int>('chat_id', value);

  int? get usersId => getField<int>('users_id');
  set usersId(int? value) => setField<int>('users_id', value);
}
