import '../database.dart';

class ForumsPostsTable extends SupabaseTable<ForumsPostsRow> {
  @override
  String get tableName => 'forums_posts';

  @override
  ForumsPostsRow createRow(Map<String, dynamic> data) => ForumsPostsRow(data);
}

class ForumsPostsRow extends SupabaseDataRow {
  ForumsPostsRow(super.data);

  @override
  SupabaseTable get table => ForumsPostsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  int get userId => getField<int>('user_id')!;
  set userId(int value) => setField<int>('user_id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get content => getField<String>('content')!;
  set content(String value) => setField<String>('content', value);

  int? get likesCount => getField<int>('likes_count');
  set likesCount(int? value) => setField<int>('likes_count', value);
}
