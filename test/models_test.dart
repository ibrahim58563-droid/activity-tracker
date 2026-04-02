import 'package:flutter_test/flutter_test.dart';
import 'package:activity_tracker/features/students/domain/models/daily_record.dart';
import 'package:activity_tracker/features/students/domain/models/student.dart';

void main() {
  group('Student', () {
    test('toMap and fromMap roundtrip', () {
      final student = Student(
        id: 'abc-123',
        userId: 'user-456',
        name: 'Zaid Al-Farabi',
        levelOfStudy: 'Intermediate Grammar',
        academicYear: '1445 AH',
        notes: 'Excellent progress',
        createdAt: DateTime(2024, 1, 15),
      );

      final map = student.toMap();
      final restored = Student.fromMap(map);

      expect(restored.id, student.id);
      expect(restored.userId, student.userId);
      expect(restored.name, student.name);
      expect(restored.levelOfStudy, student.levelOfStudy);
      expect(restored.academicYear, student.academicYear);
      expect(restored.notes, student.notes);
    });

    test('toMap uses snake_case keys for Supabase', () {
      final student = Student(
        id: 'abc-123',
        userId: 'user-456',
        name: 'Test',
        createdAt: DateTime(2024, 1, 15),
      );

      final map = student.toMap();
      expect(map.containsKey('user_id'), true);
      expect(map.containsKey('level_of_study'), true);
      expect(map.containsKey('academic_year'), true);
      expect(map.containsKey('avatar_url'), true);
      expect(map.containsKey('created_at'), true);
    });

    test('copyWith preserves unchanged fields', () {
      final student = Student(
        id: 'abc-123',
        userId: 'user-456',
        name: 'Original',
        levelOfStudy: 'Advanced',
        academicYear: '1445 AH',
        notes: '',
        createdAt: DateTime(2024, 1, 15),
      );

      final updated = student.copyWith(name: 'Updated');
      expect(updated.name, 'Updated');
      expect(updated.id, student.id);
      expect(updated.userId, student.userId);
      expect(updated.levelOfStudy, student.levelOfStudy);
    });
  });

  group('DailyRecord', () {
    test('completionPercentage is computed correctly', () {
      final record = DailyRecord(
        id: 'rec-1',
        studentId: 'stu-1',
        date: DateTime.now(),
        ibadaat: {'Fajr': true, 'Dhuhr': false},
        quran: {'Tilawah': true},
        habits: {'Walk': false},
        study: {'Math': true},
      );

      // 3 completed out of 5 total = 0.6
      expect(record.totalItems, 5);
      expect(record.completedItems, 3);
      expect(record.completionPercentage, closeTo(0.6, 0.01));
    });

    test('default record has all items false', () {
      final record = DailyRecord.defaultForStudent('stu-1', 'rec-1');

      expect(record.completedItems, 0);
      expect(record.totalItems, greaterThan(0));
      expect(record.completionPercentage, 0.0);
    });

    test('toMap uses snake_case keys for Supabase', () {
      final record = DailyRecord(
        id: 'rec-1',
        studentId: 'stu-1',
        date: DateTime(2024, 3, 15),
        ibadaat: {'Fajr': true},
        quran: {},
        habits: {},
        study: {},
      );

      final map = record.toMap();
      expect(map.containsKey('student_id'), true);
      expect(map['student_id'], 'stu-1');
      expect(map['date'], '2024-03-15');
    });

    test('toMap and fromMap roundtrip', () {
      final record = DailyRecord(
        id: 'rec-1',
        studentId: 'stu-1',
        date: DateTime(2024, 3, 15),
        ibadaat: {'Fajr': true, 'Dhuhr': false},
        quran: {'Tilawah': true},
        habits: {},
        study: {},
      );

      final map = record.toMap();
      final restored = DailyRecord.fromMap(map);

      expect(restored.id, record.id);
      expect(restored.studentId, record.studentId);
      expect(restored.ibadaat, record.ibadaat);
      expect(restored.quran, record.quran);
      expect(restored.completionPercentage, record.completionPercentage);
    });

    test('copyWith updates specific category', () {
      final record = DailyRecord(
        id: 'rec-1',
        studentId: 'stu-1',
        date: DateTime.now(),
        ibadaat: {'Fajr': false},
        quran: {},
        habits: {},
        study: {},
      );

      final updated = record.copyWith(ibadaat: {'Fajr': true});
      expect(updated.ibadaat['Fajr'], true);
      expect(updated.id, record.id);
    });

    test('dateKey formats correctly', () {
      expect(DailyRecord.dateKey(DateTime(2024, 1, 5)), '2024-01-05');
      expect(DailyRecord.dateKey(DateTime(2024, 12, 25)), '2024-12-25');
    });
  });
}
