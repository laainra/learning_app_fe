import 'video_model.dart';

class Section {
  final int id;
  final String name;
  final int courseId;
  final List<Video> videos; // Tambahkan properti videos
  final int? quizId; // bisa null jika tidak ada quiz

  Section({
    required this.id,
    required this.name,
    required this.courseId,
    this.videos = const [], // Default kosong jika tidak ada video
    this.quizId,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      name: json['name'],
      courseId: json['course_id'],
      videos:
          (json['videos'] as List<dynamic>?)
              ?.map((videoJson) => Video.fromJson(videoJson))
              .toList() ??
          [], // Parsing daftar video
      quizId: json['quiz_id'], // pastikan key ini sesuai dengan API-mu
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'course_id': courseId,
      'videos': videos.map((video) => video.toJson()).toList(),
    };
  }
}
