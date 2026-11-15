import '../database.dart';

class ChatParticipantsTable extends SupabaseTable<ChatParticipantsRow> {
  @override
  String get tableName => 'chat_participants';

  @override
  ChatParticipantsRow createRow(Map<String, dynamic> data) =>
      ChatParticipantsRow(data);
}

class ChatParticipantsRow extends SupabaseDataRow {
  ChatParticipantsRow(super.data);

  @override
  SupabaseTable get table => ChatParticipantsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get chatId => getField<int>('chat_id');
  set chatId(int? value) => setField<int>('chat_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);

  String? get chatUserId => getField<String>('chat_user_id');
  set chatUserId(String? value) => setField<String>('chat_user_id', value);

  String? get profilePicture => getField<String>('profile_picture');
  set profilePicture(String? value) =>
      setField<String>('profile_picture', value);

  DateTime? get time => getField<DateTime>('time');
  set time(DateTime? value) => setField<DateTime>('time', value);

  bool? get isVerified => getField<bool>('is_verified');
  set isVerified(bool? value) => setField<bool>('is_verified', value);
}
