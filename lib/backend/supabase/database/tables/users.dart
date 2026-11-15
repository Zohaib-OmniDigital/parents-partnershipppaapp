import '../database.dart';

class UsersTable extends SupabaseTable<UsersRow> {
  @override
  String get tableName => 'users';

  @override
  UsersRow createRow(Map<String, dynamic> data) => UsersRow(data);
}

class UsersRow extends SupabaseDataRow {
  UsersRow(super.data);

  @override
  SupabaseTable get table => UsersTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get displayName => getField<String>('display_name');
  set displayName(String? value) => setField<String>('display_name', value);

  String? get photoUrl => getField<String>('photo_url');
  set photoUrl(String? value) => setField<String>('photo_url', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);

  String? get age => getField<String>('age');
  set age(String? value) => setField<String>('age', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  bool? get isVerified => getField<bool>('is_verified');
  set isVerified(bool? value) => setField<bool>('is_verified', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get verificationCode => getField<String>('verification_code');
  set verificationCode(String? value) =>
      setField<String>('verification_code', value);

  String? get phoneNumber => getField<String>('phone_number');
  set phoneNumber(String? value) => setField<String>('phone_number', value);

  String? get bio => getField<String>('bio');
  set bio(String? value) => setField<String>('bio', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get zipCode => getField<String>('zip_code');
  set zipCode(String? value) => setField<String>('zip_code', value);

  String? get gender => getField<String>('gender');
  set gender(String? value) => setField<String>('gender', value);

  DateTime? get birthDate => getField<DateTime>('birth_date');
  set birthDate(DateTime? value) => setField<DateTime>('birth_date', value);

  bool? get pushNotificationsEnabled =>
      getField<bool>('push_notifications_enabled');
  set pushNotificationsEnabled(bool? value) =>
      setField<bool>('push_notifications_enabled', value);

  DateTime? get lastActiveAt => getField<DateTime>('last_active_at');
  set lastActiveAt(DateTime? value) =>
      setField<DateTime>('last_active_at', value);

  int? get totalPosts => getField<int>('total_posts');
  set totalPosts(int? value) => setField<int>('total_posts', value);

  int? get totalComments => getField<int>('total_comments');
  set totalComments(int? value) => setField<int>('total_comments', value);

  int? get reputationScore => getField<int>('reputation_score');
  set reputationScore(int? value) => setField<int>('reputation_score', value);

  String? get accountStatus => getField<String>('account_status');
  set accountStatus(String? value) => setField<String>('account_status', value);

  String? get role => getField<String>('role');
  set role(String? value) => setField<String>('role', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get profilepicture => getField<String>('profilepicture');
  set profilepicture(String? value) =>
      setField<String>('profilepicture', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get verificationStatus => getField<String>('verification_status');
  set verificationStatus(String? value) =>
      setField<String>('verification_status', value);

  bool? get isAdmin => getField<bool>('is_admin');
  set isAdmin(bool? value) => setField<bool>('is_admin', value);

  String? get backgroundCheckPaymentStatus =>
      getField<String>('background_check_payment_status');
  set backgroundCheckPaymentStatus(String? value) =>
      setField<String>('background_check_payment_status', value);

  String? get stripeCheckoutSessionId =>
      getField<String>('stripe_checkout_session_id');
  set stripeCheckoutSessionId(String? value) =>
      setField<String>('stripe_checkout_session_id', value);

  DateTime? get backgroundCheckPaidAt =>
      getField<DateTime>('background_check_paid_at');
  set backgroundCheckPaidAt(DateTime? value) =>
      setField<DateTime>('background_check_paid_at', value);
}
