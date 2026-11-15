import '../database.dart';

class ChatSummaryTableTable extends SupabaseTable<ChatSummaryTableRow> {
  @override
  String get tableName => 'chat_summary_table';

  @override
  ChatSummaryTableRow createRow(Map<String, dynamic> data) =>
      ChatSummaryTableRow(data);
}

class ChatSummaryTableRow extends SupabaseDataRow {
  ChatSummaryTableRow(super.data);

  @override
  SupabaseTable get table => ChatSummaryTableTable();

  int get chatId => getField<int>('chat_id')!;
  set chatId(int value) => setField<int>('chat_id', value);

  String? get senderId => getField<String>('sender_id');
  set senderId(String? value) => setField<String>('sender_id', value);

  String? get lastMessage => getField<String>('last_message');
  set lastMessage(String? value) => setField<String>('last_message', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
