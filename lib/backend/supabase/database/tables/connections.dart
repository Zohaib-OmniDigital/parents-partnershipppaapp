import '../database.dart';

class ConnectionsTable extends SupabaseTable<ConnectionsRow> {
  @override
  String get tableName => 'connections';

  @override
  ConnectionsRow createRow(Map<String, dynamic> data) => ConnectionsRow(data);
}

class ConnectionsRow extends SupabaseDataRow {
  ConnectionsRow(super.data);

  @override
  SupabaseTable get table => ConnectionsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get senderId => getField<String>('sender_id');
  set senderId(String? value) => setField<String>('sender_id', value);

  String? get receiverId => getField<String>('receiver_id');
  set receiverId(String? value) => setField<String>('receiver_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  bool? get isRead => getField<bool>('is_read');
  set isRead(bool? value) => setField<bool>('is_read', value);

  String? get messageText => getField<String>('message_text');
  set messageText(String? value) => setField<String>('message_text', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  int? get connectionId => getField<int>('connection_id');
  set connectionId(int? value) => setField<int>('connection_id', value);

  bool? get isVerified => getField<bool>('is_verified');
  set isVerified(bool? value) => setField<bool>('is_verified', value);
}
