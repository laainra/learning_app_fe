import 'package:finbedu/models/user_model.dart';

class CourseAccess {
  final int? id;
  final int courseId;
  final String accessStatus;
  final int? userId; // optional, karena tidak perlu dikirim saat create
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CourseAccess({
    this.id,
    required this.courseId,
    required this.accessStatus,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  // Convert from JSON (API response)
  factory CourseAccess.fromJson(Map<String, dynamic> json) {
    return CourseAccess(
      id: json['id'],
      courseId: json['course_id'] is String
          ? int.tryParse(json['course_id'])
          : json['course_id'],
      accessStatus: json['access_status'],
      userId: json['user_id'] is String
          ? int.tryParse(json['user_id'])
          : json['user_id'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }

  // Convert to JSON (API request)
  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'access_status': accessStatus,
      // 'user_id': userId, // tidak perlu dikirim, karena dari token user login
    };
  }
}
