import '../database.dart';

class UserTable extends SupabaseTable<UserRow> {
  @override
  String get tableName => 'user';

  @override
  UserRow createRow(Map<String, dynamic> data) => UserRow(data);
}

class UserRow extends SupabaseDataRow {
  UserRow(super.data);

  @override
  SupabaseTable get table => UserTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get profilepicture => getField<String>('profilepicture');
  set profilepicture(String? value) =>
      setField<String>('profilepicture', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get age => getField<String>('age');
  set age(String? value) => setField<String>('age', value);

  String? get gender => getField<String>('gender');
  set gender(String? value) => setField<String>('gender', value);

  String? get bio => getField<String>('bio');
  set bio(String? value) => setField<String>('bio', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get lastActiveAt => getField<DateTime>('last_active_at');
  set lastActiveAt(DateTime? value) =>
      setField<DateTime>('last_active_at', value);

  String? get profilePicture => getField<String>('profile_picture');
  set profilePicture(String? value) =>
      setField<String>('profile_picture', value);

  bool? get isVerified => getField<bool>('is_verified');
  set isVerified(bool? value) => setField<bool>('is_verified', value);
}
