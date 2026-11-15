import '../database.dart';

class AChatSummaryTable extends SupabaseTable<AChatSummaryRow> {
  @override
  String get tableName => 'a_chat_summary';

  @override
  AChatSummaryRow createRow(Map<String, dynamic> data) => AChatSummaryRow(data);
}

class AChatSummaryRow extends SupabaseDataRow {
  AChatSummaryRow(super.data);

  @override
  SupabaseTable get table => AChatSummaryTable();

  int? get chatId => getField<int>('chat_id');
  set chatId(int? value) => setField<int>('chat_id', value);

  String? get lastMessage => getField<String>('last_message');
  set lastMessage(String? value) => setField<String>('last_message', value);

  List<int> get userIds => getListField<int>('user_ids');
  set userIds(List<int>? value) => setListField<int>('user_ids', value);

  List<String> get fullNames => getListField<String>('full_names');
  set fullNames(List<String>? value) =>
      setListField<String>('full_names', value);

  List<String> get profilePictures => getListField<String>('profile_pictures');
  set profilePictures(List<String>? value) =>
      setListField<String>('profile_pictures', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
