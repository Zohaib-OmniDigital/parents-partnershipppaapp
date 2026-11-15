import '../database.dart';

class UserProfilesTable extends SupabaseTable<UserProfilesRow> {
  @override
  String get tableName => 'user_profiles';

  @override
  UserProfilesRow createRow(Map<String, dynamic> data) => UserProfilesRow(data);
}

class UserProfilesRow extends SupabaseDataRow {
  UserProfilesRow(super.data);

  @override
  SupabaseTable get table => UserProfilesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get zipCode => getField<String>('zip_code');
  set zipCode(String? value) => setField<String>('zip_code', value);

  String? get age => getField<String>('age');
  set age(String? value) => setField<String>('age', value);

  String? get gender => getField<String>('gender');
  set gender(String? value) => setField<String>('gender', value);

  String? get profilePicture => getField<String>('profile_picture');
  set profilePicture(String? value) =>
      setField<String>('profile_picture', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);

  String? get userProfiles => getField<String>('user_profiles');
  set userProfiles(String? value) => setField<String>('user_profiles', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);
}
