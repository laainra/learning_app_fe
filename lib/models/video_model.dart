class Video {
  final int id;
  final String title;
  final String url;
  final String duration;
  final int sectionId;

  Video({
    required this.id,
    required this.title,
    required this.url,
    required this.duration,
    required this.sectionId,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      duration: json['duration'],
      sectionId: json['section_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'duration': duration,
      'section_id': sectionId,
    };
  }
}