import 'package:finbedu/models/course_model.dart';
import 'package:finbedu/models/user_model.dart';

class Review {
  final int id;
  final double rating;
  final String review;
  final String createdAt;
  final Course? course;
  final int? courseId;
  final int? userId;
  final UserModel? user;

  Review({
    required this.id,
    required this.rating,
    required this.review,
    required this.createdAt,
    this.course,
    this.courseId,
    this.userId,
    this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    print('Parsing rating: ${json['rating']}');

    String reviewText =
        json['reviews'] ?? json['review'] ?? ''; // Handle kedua kemungkinan key
    String creationTime =
        json['datetime'] ??
        json['created_at'] ??
        DateTime.now().toIso8601String();

    return Review(
      id: json['id'],
      rating:
          json['rating'] is String
              ? double.tryParse(json['rating'])?.toDouble() ?? 0.0
              : (json['rating'] is int
                  ? (json['rating'] as int).toDouble()
                  : json['rating'].toDouble()),

      review: reviewText,
      createdAt: creationTime,
      course: json['course'] != null ? Course.fromJson(json['course']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      courseId:
          json['course_id'] is String
              ? int.tryParse(json['course_id'])
              : json['course_id'],
      userId:
          json['user_id'] is String
              ? int.tryParse(json['user_id'])
              : json['user_id'],
    );
  }
  Map<String, dynamic> toJson() {
    // Berguna untuk mengirim data saat POST atau PUT
    return {
      'reviews': review, // Sesuai dengan validasi backend 'reviews'
      'rating': rating,
      'course_id': courseId,
    };
  }
}
