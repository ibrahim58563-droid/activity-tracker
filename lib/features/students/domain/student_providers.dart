import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/local_student_repository.dart';
import '../domain/models/student.dart';
import '../domain/models/daily_record.dart';
import '../domain/repositories/student_repository.dart';

const _uuid = Uuid();

/// Student repository provider — swap implementation here.
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return LocalStudentRepository();
});

/// All students list.
final studentsProvider = FutureProvider<List<Student>>((ref) {
  return ref.watch(studentRepositoryProvider).getAllStudents();
});

/// Single student by ID.
final studentProvider =
    FutureProvider.family<Student?, String>((ref, id) {
  return ref.watch(studentRepositoryProvider).getStudent(id);
});

/// Today's daily record for a student.
final dailyRecordProvider =
    FutureProvider.family<DailyRecord, String>((ref, studentId) async {
  final repo = ref.watch(studentRepositoryProvider);
  final today = DateTime.now();
  final existing = await repo.getDailyRecord(studentId, today);
  if (existing != null) return existing;

  // Create default record for today
  final record = DailyRecord.defaultForStudent(studentId, _uuid.v4());
  await repo.saveDailyRecord(record);
  return record;
});

/// Recent records for streak/progress calculation.
final studentRecordsProvider =
    FutureProvider.family<List<DailyRecord>, String>((ref, studentId) {
  return ref.watch(studentRepositoryProvider).getRecordsForStudent(studentId);
});

/// Computed streak for a student.
final streakProvider = FutureProvider.family<int, String>((ref, studentId) async {
  final records = await ref.watch(studentRecordsProvider(studentId).future);
  if (records.isEmpty) return 0;

  // Sort by date descending
  final sorted = [...records]..sort((a, b) => b.date.compareTo(a.date));

  int streak = 0;
  DateTime expectedDate = DateTime.now();

  for (final record in sorted) {
    final recordDate = DateTime(record.date.year, record.date.month, record.date.day);
    final expected = DateTime(expectedDate.year, expectedDate.month, expectedDate.day);

    if (recordDate == expected || recordDate == expected.subtract(const Duration(days: 1))) {
      if (record.completionPercentage >= 0.5) {
        streak++;
        expectedDate = recordDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    } else {
      break;
    }
  }
  return streak;
});

/// Class-level insights computed from all students.
final classInsightsProvider = FutureProvider<ClassInsights>((ref) async {
  final students = await ref.watch(studentsProvider.future);
  if (students.isEmpty) {
    return const ClassInsights(averageProgress: 0, totalStudents: 0, activeToday: 0);
  }

  final repo = ref.watch(studentRepositoryProvider);
  final today = DateTime.now();
  double totalProgress = 0;
  int activeToday = 0;

  for (final student in students) {
    final record = await repo.getDailyRecord(student.id, today);
    if (record != null) {
      totalProgress += record.completionPercentage;
      if (record.completedItems > 0) activeToday++;
    }
  }

  return ClassInsights(
    averageProgress: students.isEmpty ? 0 : totalProgress / students.length,
    totalStudents: students.length,
    activeToday: activeToday,
  );
});

class ClassInsights {
  final double averageProgress;
  final int totalStudents;
  final int activeToday;

  const ClassInsights({
    required this.averageProgress,
    required this.totalStudents,
    required this.activeToday,
  });
}
