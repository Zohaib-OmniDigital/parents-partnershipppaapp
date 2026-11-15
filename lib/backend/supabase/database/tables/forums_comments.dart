import '../database.dart';

class ForumsCommentsTable extends SupabaseTable<ForumsCommentsRow> {
  @override
  String get tableName => 'forums_comments';

  @override
  ForumsCommentsRow createRow(Map<String, dynamic> data) =>
      ForumsCommentsRow(data);
}

class ForumsCommentsRow extends SupabaseDataRow {
  ForumsCommentsRow(super.data);

  @override
  SupabaseTable get table => ForumsCommentsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  int get postId => getField<int>('post_id')!;
  set postId(int value) => setField<int>('post_id', value);

  int get userId => getField<int>('user_id')!;
  set userId(int value) => setField<int>('user_id', value);

  String get commentText => getField<String>('comment_text')!;
  set commentText(String value) => setField<String>('comment_text', value);
}
