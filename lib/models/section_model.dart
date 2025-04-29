import 'video_model.dart';

class Section {
  final int id;
  final String name;
  final int courseId;
  final List<Video> videos; // Tambahkan properti videos

  Section({
    required this.id,
    required this.name,
    required this.courseId,
    this.videos = const [], // Default kosong jika tidak ada video
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      name: json['name'],
      courseId: json['course_id'],
      videos: (json['videos'] as List<dynamic>?)
              ?.map((videoJson) => Video.fromJson(videoJson))
              .toList() ??
          [], // Parsing daftar video
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