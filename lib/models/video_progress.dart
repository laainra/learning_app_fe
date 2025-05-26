class VideoProgress {
  final int id;
  final int userId;
  final int videoId;
  final String? watchedAt;

  VideoProgress({
    required this.id,
    required this.userId,
    required this.videoId,
    this.watchedAt,
  });

  factory VideoProgress.fromJson(Map<String, dynamic> json) {
    return VideoProgress(
      id: json['id'],
      userId:
          json['user_id'] is String
              ? int.tryParse(json['user_id'])
              : json['user_id'],
      videoId:
          json['video_id'] is String
              ? int.tryParse(json['video_id'])
              : json['video_id'],
      watchedAt: json['watched_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'video_id': videoId,
      'watched_at': watchedAt,
    };
  }
}
