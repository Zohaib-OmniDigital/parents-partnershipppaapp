import '../database.dart';

class ProfilePictureTable extends SupabaseTable<ProfilePictureRow> {
  @override
  String get tableName => 'profile_picture';

  @override
  ProfilePictureRow createRow(Map<String, dynamic> data) =>
      ProfilePictureRow(data);
}

class ProfilePictureRow extends SupabaseDataRow {
  ProfilePictureRow(super.data);

  @override
  SupabaseTable get table => ProfilePictureTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get profilePicture => getField<String>('profile_picture');
  set profilePicture(String? value) =>
      setField<String>('profile_picture', value);
}
