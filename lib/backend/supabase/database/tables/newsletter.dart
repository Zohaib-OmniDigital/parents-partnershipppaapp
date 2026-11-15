import '../database.dart';

class NewsletterTable extends SupabaseTable<NewsletterRow> {
  @override
  String get tableName => 'newsletter';

  @override
  NewsletterRow createRow(Map<String, dynamic> data) => NewsletterRow(data);
}

class NewsletterRow extends SupabaseDataRow {
  NewsletterRow(super.data);

  @override
  SupabaseTable get table => NewsletterTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);
}
