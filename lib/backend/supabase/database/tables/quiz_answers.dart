import '../database.dart';

class QuizAnswersTable extends SupabaseTable<QuizAnswersRow> {
  @override
  String get tableName => 'quiz_answers';

  @override
  QuizAnswersRow createRow(Map<String, dynamic> data) => QuizAnswersRow(data);
}

class QuizAnswersRow extends SupabaseDataRow {
  QuizAnswersRow(super.data);

  @override
  SupabaseTable get table => QuizAnswersTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get q1Location => getField<String>('q1_location');
  set q1Location(String? value) => setField<String>('q1_location', value);

  String? get q2ChildrenAge => getField<String>('q2_children_age');
  set q2ChildrenAge(String? value) =>
      setField<String>('q2_children_age', value);

  String? get q3MaritalStatus => getField<String>('q3_marital_status');
  set q3MaritalStatus(String? value) =>
      setField<String>('q3_marital_status', value);

  String? get q4Religion => getField<String>('q4_religion');
  set q4Religion(String? value) => setField<String>('q4_religion', value);

  String? get q5Journeys => getField<String>('q5_journeys');
  set q5Journeys(String? value) => setField<String>('q5_journeys', value);

  String? get q6FamilyStructure => getField<String>('q6_family_structure');
  set q6FamilyStructure(String? value) =>
      setField<String>('q6_family_structure', value);

  String? get q7ParentingStyle => getField<String>('q7_parenting_style');
  set q7ParentingStyle(String? value) =>
      setField<String>('q7_parenting_style', value);

  String? get q8PrimaryGoal => getField<String>('q8_primary_goal');
  set q8PrimaryGoal(String? value) =>
      setField<String>('q8_primary_goal', value);
}
