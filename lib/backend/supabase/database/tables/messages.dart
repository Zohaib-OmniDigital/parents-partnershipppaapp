import '../database.dart';

class MessagesTable extends SupabaseTable<MessagesRow> {
  @override
  String get tableName => 'messages';

  @override
  MessagesRow createRow(Map<String, dynamic> data) => MessagesRow(data);
}

class MessagesRow extends SupabaseDataRow {
  MessagesRow(super.data);

  @override
  SupabaseTable get table => MessagesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get messageText => getField<String>('message_text');
  set messageText(String? value) => setField<String>('message_text', value);

  String? get senderId => getField<String>('sender_id');
  set senderId(String? value) => setField<String>('sender_id', value);

  int? get reciepientId => getField<int>('reciepient_id');
  set reciepientId(int? value) => setField<int>('reciepient_id', value);

  String? get imgPath => getField<String>('img_path');
  set imgPath(String? value) => setField<String>('img_path', value);

  bool? get isImg => getField<bool>('is_img');
  set isImg(bool? value) => setField<bool>('is_img', value);

  int? get chatId => getField<int>('chat_id');
  set chatId(int? value) => setField<int>('chat_id', value);

  int? get userId => getField<int>('user_id');
  set userId(int? value) => setField<int>('user_id', value);
}
