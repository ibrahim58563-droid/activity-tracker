/// Represents a student in the tracking system.
class Student {
  final String id;
  final String name;
  final String levelOfStudy;
  final String academicYear;
  final String notes;
  final String? avatarUrl;
  final DateTime createdAt;

  const Student({
    required this.id,
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
      name: name ?? this.name,
      levelOfStudy: levelOfStudy ?? this.levelOfStudy,
      academicYear: academicYear ?? this.academicYear,
      notes: notes ?? this.notes,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'levelOfStudy': levelOfStudy,
        'academicYear': academicYear,
        'notes': notes,
        'avatarUrl': avatarUrl,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Student.fromMap(Map<String, dynamic> map) => Student(
        id: map['id'] as String,
        name: map['name'] as String,
        levelOfStudy: (map['levelOfStudy'] as String?) ?? '',
        academicYear: (map['academicYear'] as String?) ?? '',
        notes: (map['notes'] as String?) ?? '',
        avatarUrl: map['avatarUrl'] as String?,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}
