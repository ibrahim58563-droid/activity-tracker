/// Represents a student in the tracking system.
class Student {
  final String id;
  final String userId;
  final String name;
  final String levelOfStudy;
  final String academicYear;
  final String notes;
  final String? avatarUrl;
  final DateTime createdAt;

  const Student({
    required this.id,
    required this.userId,
    required this.name,
    this.levelOfStudy = '',
    this.academicYear = '',
    this.notes = '',
    this.avatarUrl,
    required this.createdAt,
  });

  Student copyWith({
    String? name,
    String? levelOfStudy,
    String? academicYear,
    String? notes,
    String? avatarUrl,
  }) {
    return Student(
      id: id,
      userId: userId,
      name: name ?? this.name,
      levelOfStudy: levelOfStudy ?? this.levelOfStudy,
      academicYear: academicYear ?? this.academicYear,
      notes: notes ?? this.notes,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
    );
  }

  /// Convert to Supabase row (snake_case columns).
  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'level_of_study': levelOfStudy,
        'academic_year': academicYear,
        'notes': notes,
        'avatar_url': avatarUrl,
        'created_at': createdAt.toIso8601String(),
      };

  /// Create from Supabase row (snake_case columns).
  factory Student.fromMap(Map<String, dynamic> map) => Student(
        id: map['id'] as String,
        userId: (map['user_id'] as String?) ?? '',
        name: map['name'] as String,
        levelOfStudy: (map['level_of_study'] as String?) ?? '',
        academicYear: (map['academic_year'] as String?) ?? '',
        notes: (map['notes'] as String?) ?? '',
        avatarUrl: map['avatar_url'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}
