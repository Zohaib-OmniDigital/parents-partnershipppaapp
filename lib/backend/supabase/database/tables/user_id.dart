import '../database.dart';

class UserIdTable extends SupabaseTable<UserIdRow> {
  @override
  String get tableName => 'user_id';

  @override
  UserIdRow createRow(Map<String, dynamic> data) => UserIdRow(data);
}

class UserIdRow extends SupabaseDataRow {
  UserIdRow(super.data);

  @override
  SupabaseTable get table => UserIdTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);
}
