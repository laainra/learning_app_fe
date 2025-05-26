class Certificate {
  final int id;
  final int userId;
  final int courseId;
  final int courseAccessId;
  final String certificateId;
  final DateTime completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Certificate({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseAccessId,
    required this.certificateId,
    required this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'],
      userId: json['user_id'] is String
          ? int.tryParse(json['user_id'])
          : json['user_id'],
      courseId: json['course_id'] is String
          ? int.tryParse(json['course_id'])
          : json['course_id'],
      courseAccessId: json['course_access_id'] is String
          ? int.tryParse(json['course_access_id'])
          : json['course_access_id'],
      certificateId: json['certificate_id'] is String
          ? json['certificate_id']
          : json['certificate_id'].toString(),
      completedAt: DateTime.parse(json['completed_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'course_id': courseId,
      'course_access_id': courseAccessId,
      'certificate_id': certificateId,
      'completed_at': completedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
