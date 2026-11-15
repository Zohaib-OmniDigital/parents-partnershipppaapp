import '../database.dart';

class BackgroundChecksTable extends SupabaseTable<BackgroundChecksRow> {
  @override
  String get tableName => 'background_checks';

  @override
  BackgroundChecksRow createRow(Map<String, dynamic> data) =>
      BackgroundChecksRow(data);
}

class BackgroundChecksRow extends SupabaseDataRow {
  BackgroundChecksRow(super.data);

  @override
  SupabaseTable get table => BackgroundChecksTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get fullLegalName => getField<String>('full_legal_name')!;
  set fullLegalName(String value) => setField<String>('full_legal_name', value);

  String get dateOfBirth => getField<String>('date_of_birth')!;
  set dateOfBirth(String value) => setField<String>('date_of_birth', value);

  String get currentAddress => getField<String>('current_address')!;
  set currentAddress(String value) =>
      setField<String>('current_address', value);

  String get contry => getField<String>('contry')!;
  set contry(String value) => setField<String>('contry', value);

  String get state => getField<String>('state')!;
  set state(String value) => setField<String>('state', value);

  String get zipCode => getField<String>('zip_code')!;
  set zipCode(String value) => setField<String>('zip_code', value);

  String? get previousAddress => getField<String>('previous_address');
  set previousAddress(String? value) =>
      setField<String>('previous_address', value);

  String? get previousEmployment => getField<String>('previous_employment');
  set previousEmployment(String? value) =>
      setField<String>('previous_employment', value);

  String? get formerNames => getField<String>('former_names');
  set formerNames(String? value) => setField<String>('former_names', value);

  String get idDocumentUrl => getField<String>('id_document_url')!;
  set idDocumentUrl(String value) => setField<String>('id_document_url', value);

  String get selfieUrl => getField<String>('selfie_url')!;
  set selfieUrl(String value) => setField<String>('selfie_url', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get policeClearancePath => getField<String>('police_clearance_path');
  set policeClearancePath(String? value) =>
      setField<String>('police_clearance_path', value);

  String? get policeClearanceFilename =>
      getField<String>('police_clearance_filename');
  set policeClearanceFilename(String? value) =>
      setField<String>('police_clearance_filename', value);

  DateTime? get submittedAt => getField<DateTime>('submitted_at');
  set submittedAt(DateTime? value) => setField<DateTime>('submitted_at', value);

  DateTime? get notificationSentAt =>
      getField<DateTime>('notification_sent_at');
  set notificationSentAt(DateTime? value) =>
      setField<DateTime>('notification_sent_at', value);
}
