import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/student.dart';
import '../domain/models/daily_record.dart';
import '../domain/repositories/student_repository.dart';

/// Local SharedPreferences implementation of [StudentRepository].
/// Easy to swap for Firestore later without touching any UI code.
class LocalStudentRepository implements StudentRepository {
  static const _studentsKey = 'students';
  static const _recordsPrefix = 'records_';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _storage async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ── Students ────────────────────────────────────────

  @override
  Future<List<Student>> getAllStudents() async {
    final prefs = await _storage;
    final raw = prefs.getStringList(_studentsKey) ?? [];
    return raw
        .map((json) => Student.fromMap(jsonDecode(json) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Student?> getStudent(String id) async {
    final all = await getAllStudents();
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addStudent(Student student) async {
    final prefs = await _storage;
    final raw = prefs.getStringList(_studentsKey) ?? [];
    raw.add(jsonEncode(student.toMap()));
    await prefs.setStringList(_studentsKey, raw);
  }

  @override
  Future<void> updateStudent(Student student) async {
    final prefs = await _storage;
    final raw = prefs.getStringList(_studentsKey) ?? [];
    final updated = raw.map((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      if (map['id'] == student.id) return jsonEncode(student.toMap());
      return json;
    }).toList();
    await prefs.setStringList(_studentsKey, updated);
  }

  @override
  Future<void> deleteStudent(String id) async {
    final prefs = await _storage;
    final raw = prefs.getStringList(_studentsKey) ?? [];
    raw.removeWhere((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return map['id'] == id;
    });
    await prefs.setStringList(_studentsKey, raw);
    // Clean up records
    final keys = prefs.getKeys().where((k) => k.startsWith('$_recordsPrefix$id'));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  // ── Daily Records ───────────────────────────────────

  String _recordKey(String studentId, DateTime date) =>
      '$_recordsPrefix${studentId}_${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Future<DailyRecord?> getDailyRecord(String studentId, DateTime date) async {
    final prefs = await _storage;
    final json = prefs.getString(_recordKey(studentId, date));
    if (json == null) return null;
    return DailyRecord.fromMap(jsonDecode(json) as Map<String, dynamic>);
  }

  @override
  Future<void> saveDailyRecord(DailyRecord record) async {
    final prefs = await _storage;
    await prefs.setString(
      _recordKey(record.studentId, record.date),
      jsonEncode(record.toMap()),
    );
  }

  @override
  Future<List<DailyRecord>> getRecordsForStudent(String studentId, {int limit = 30}) async {
    final prefs = await _storage;
    final prefix = '$_recordsPrefix$studentId';
    final keys = prefs.getKeys().where((k) => k.startsWith(prefix)).toList()
      ..sort((a, b) => b.compareTo(a)); // newest first

    final records = <DailyRecord>[];
    for (final key in keys.take(limit)) {
      final json = prefs.getString(key);
      if (json != null) {
        records.add(DailyRecord.fromMap(jsonDecode(json) as Map<String, dynamic>));
      }
    }
    return records;
  }
}
