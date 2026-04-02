/// A single day's tracking record for a student.
class DailyRecord {
  final String id;
  final String studentId;
  final DateTime date;

  /// Worship items: keys are item names, values are completion status.
  final Map<String, bool> ibadaat;

  /// Quran tracking: completion status + optional metadata.
  final Map<String, bool> quran;

  /// Habit items.
  final Map<String, bool> habits;

  /// Study items.
  final Map<String, bool> study;

  const DailyRecord({
    required this.id,
    required this.studentId,
    required this.date,
    this.ibadaat = const {},
    this.quran = const {},
    this.habits = const {},
    this.study = const {},
  });

  /// Total items across all categories.
  int get totalItems =>
      ibadaat.length + quran.length + habits.length + study.length;

  /// Number of completed items.
  int get completedItems =>
      ibadaat.values.where((v) => v).length +
      quran.values.where((v) => v).length +
      habits.values.where((v) => v).length +
      study.values.where((v) => v).length;

  /// Completion percentage (0.0 – 1.0).
  double get completionPercentage =>
      totalItems == 0 ? 0.0 : completedItems / totalItems;

  DailyRecord copyWith({
    Map<String, bool>? ibadaat,
    Map<String, bool>? quran,
    Map<String, bool>? habits,
    Map<String, bool>? study,
  }) {
    return DailyRecord(
      id: id,
      studentId: studentId,
      date: date,
      ibadaat: ibadaat ?? this.ibadaat,
      quran: quran ?? this.quran,
      habits: habits ?? this.habits,
      study: study ?? this.study,
    );
  }

  /// Convert to Supabase row (snake_case columns, JSONB for maps).
  Map<String, dynamic> toMap() => {
        'id': id,
        'student_id': studentId,
        'date': dateKey(date),
        'ibadaat': ibadaat,
        'quran': quran,
        'habits': habits,
        'study': study,
      };

  /// Create from Supabase row (snake_case columns).
  factory DailyRecord.fromMap(Map<String, dynamic> map) => DailyRecord(
        id: map['id'] as String,
        studentId: map['student_id'] as String,
        date: DateTime.parse(map['date'] as String),
        ibadaat: _castBoolMap(map['ibadaat']),
        quran: _castBoolMap(map['quran']),
        habits: _castBoolMap(map['habits']),
        study: _castBoolMap(map['study']),
      );

  /// Creates a fresh record for today with default tracking items.
  factory DailyRecord.defaultForStudent(String studentId, String recordId) {
    return DailyRecord(
      id: recordId,
      studentId: studentId,
      date: DateTime.now(),
      ibadaat: {
        'Fajr Prayer': false,
        'Morning Adhkar': false,
        'Dhuhr Prayer': false,
        'Asr Prayer': false,
        'Maghrib Prayer': false,
        'Isha Prayer': false,
        'Evening Adhkar': false,
      },
      quran: {
        'Hifz Revision': false,
        'Tafsir Study': false,
        'Daily Tilawah': false,
      },
      habits: {
        'Hydration': false,
        'Daily Walk': false,
        'Digital Detox': false,
        'Early Bedtime': false,
      },
      study: {
        'Arabic Grammar': false,
        'Islamic Studies': false,
        'Mathematics': false,
      },
    );
  }

  static String dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static Map<String, bool> _castBoolMap(dynamic raw) {
    if (raw == null) return {};
    if (raw is Map) {
      return raw.map((k, v) => MapEntry(k.toString(), v == true));
    }
    return {};
  }
}
