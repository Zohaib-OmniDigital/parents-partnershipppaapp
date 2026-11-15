import '../database.dart';

class VerificationsTable extends SupabaseTable<VerificationsRow> {
  @override
  String get tableName => 'verifications';

  @override
  VerificationsRow createRow(Map<String, dynamic> data) =>
      VerificationsRow(data);
}

class VerificationsRow extends SupabaseDataRow {
  VerificationsRow(super.data);

  @override
  SupabaseTable get table => VerificationsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  bool? get isVerified => getField<bool>('is_verified');
  set isVerified(bool? value) => setField<bool>('is_verified', value);

  String? get verificationStatus => getField<String>('verification_status');
  set verificationStatus(String? value) =>
      setField<String>('verification_status', value);

  String? get rejectionReason => getField<String>('rejection_reason');
  set rejectionReason(String? value) =>
      setField<String>('rejection_reason', value);
}
