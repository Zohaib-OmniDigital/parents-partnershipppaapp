import '../database.dart';

class AChatsMessageTable extends SupabaseTable<AChatsMessageRow> {
  @override
  String get tableName => 'a_chats_message';

  @override
  AChatsMessageRow createRow(Map<String, dynamic> data) =>
      AChatsMessageRow(data);
}

class AChatsMessageRow extends SupabaseDataRow {
  AChatsMessageRow(super.data);

  @override
  SupabaseTable get table => AChatsMessageTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  int? get chatId => getField<int>('chat_id');
  set chatId(int? value) => setField<int>('chat_id', value);

  int? get userId => getField<int>('user_id');
  set userId(int? value) => setField<int>('user_id', value);

  String? get message => getField<String>('message');
  set message(String? value) => setField<String>('message', value);
}
