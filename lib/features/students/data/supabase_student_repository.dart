import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/student.dart';
import '../domain/models/daily_record.dart';
import '../domain/repositories/student_repository.dart';

/// Supabase implementation of [StudentRepository].
///
/// All queries are scoped to the current user via RLS policies.
class SupabaseStudentRepository implements StudentRepository {
  SupabaseClient get _client => Supabase.instance.client;

  // ── Students ────────────────────────────────────────

  @override
  Future<List<Student>> getAllStudents() async {
    final data = await _client
        .from('students')
        .select()
        .order('created_at', ascending: false);
    return (data as List).map((row) => Student.fromMap(row)).toList();
  }

  @override
  Future<Student?> getStudent(String id) async {
    final data = await _client
        .from('students')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (data == null) return null;
    return Student.fromMap(data);
  }

  @override
  Future<void> addStudent(Student student) async {
    await _client.from('students').insert(student.toMap());
  }

  @override
  Future<void> updateStudent(Student student) async {
    await _client
        .from('students')
        .update(student.toMap())
        .eq('id', student.id);
  }

  @override
  Future<void> deleteStudent(String id) async {
    // Daily records are cascade-deleted via FK in Supabase
    await _client.from('students').delete().eq('id', id);
  }

  // ── Daily Records ───────────────────────────────────

  @override
  Future<DailyRecord?> getDailyRecord(String studentId, DateTime date) async {
    final dateStr = DailyRecord.dateKey(date);
    final data = await _client
        .from('daily_records')
        .select()
        .eq('student_id', studentId)
        .eq('date', dateStr)
        .maybeSingle();
    if (data == null) return null;
    return DailyRecord.fromMap(data);
  }

  @override
  Future<void> saveDailyRecord(DailyRecord record) async {
    await _client.from('daily_records').upsert(
      record.toMap(),
      onConflict: 'student_id,date',
    );
  }

  @override
  Future<List<DailyRecord>> getRecordsForStudent(
    String studentId, {
    int limit = 30,
  }) async {
    final data = await _client
        .from('daily_records')
        .select()
        .eq('student_id', studentId)
        .order('date', ascending: false)
        .limit(limit);
    return (data as List).map((row) => DailyRecord.fromMap(row)).toList();
  }
}
