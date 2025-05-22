import 'package:finbedu/models/course_access.dart';
import 'package:finbedu/models/user_model.dart';

class Course {
  final int? id;
  final int? categoryId;
  final String name;
  final String desc;
  final int? userId;
  final bool mediaFullAccess;
  final String level;
  final bool audioBook;
  final bool lifetimeAccess;
  final bool certificate;
  final String? image;
  final String price;
  final String? category;
  final UserModel? user;
  final String? accessStatus;
  final double? rating;
  final int? totalStudents;
  final int? totalLessons;
  final int? courseAccessId;

  Course({
    this.id,
    required this.categoryId,
    required this.name,
    required this.desc,
    this.userId,
    this.mediaFullAccess = false,
    required this.level,
    this.audioBook = false,
    this.lifetimeAccess = false,
    this.certificate = false,
    this.image,
    required this.price,
    this.category,
    this.user,
    this.accessStatus,
    this.rating,
    this.totalStudents,
    this.totalLessons,
    this.courseAccessId,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      desc: json['desc'],
      userId: json['user_id'],
      mediaFullAccess: json['media_full_access'] == 1,
      level: json['level'],
      audioBook: json['audio_book'] == 1,
      lifetimeAccess: json['lifetime_access'] == 1,
      certificate: json['certificate'] == 1,
      image: json['image'],
      price: json['price'],
      // Perbaiki bagian ini:
      category:
          json['category'] != null &&
                  json['category'] is Map &&
                  json['category']['name'] != null
              ? json['category']['name']
              : null,
      user:
          json['user'] != null && json['user'] is Map
              ? UserModel.fromJson(json['user'])
              : null,
      accessStatus: json['access_status'],
      rating:
          json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      totalStudents: json['total_students'],
      totalLessons: json['total_lessons'],
      courseAccessId: json['course_access_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'name': name,
      'desc': desc,
      'media_full_access': mediaFullAccess ? 1 : 0, // Konversi bool ke int
      'level': level,
      'audio_book': audioBook ? 1 : 0, // Konversi bool ke int
      'lifetime_access': lifetimeAccess ? 1 : 0, // Konversi bool ke int
      'certificate': certificate ? 1 : 0, // Konversi bool ke int
      'image': image,
      'price': price,
      'course_access_id': courseAccessId,
    };
  }
}
