import '../models/student.dart';
import '../models/daily_record.dart';

/// Abstract repository — swap implementations (local ↔ Firestore) without touching UI.
abstract class StudentRepository {
  Future<List<Student>> getAllStudents();
  Future<Student?> getStudent(String id);
  Future<void> addStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(String id);

  Future<DailyRecord?> getDailyRecord(String studentId, DateTime date);
  Future<void> saveDailyRecord(DailyRecord record);
  Future<List<DailyRecord>> getRecordsForStudent(String studentId, {int limit = 30});
}
