import '../database.dart';

class SupportTicketsTable extends SupabaseTable<SupportTicketsRow> {
  @override
  String get tableName => 'support_tickets';

  @override
  SupportTicketsRow createRow(Map<String, dynamic> data) =>
      SupportTicketsRow(data);
}

class SupportTicketsRow extends SupabaseDataRow {
  SupportTicketsRow(super.data);

  @override
  SupabaseTable get table => SupportTicketsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get message => getField<String>('message');
  set message(String? value) => setField<String>('message', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);
}
