import 'package:flutter/material.dart';
import 'package:finbedu/models/video_model.dart';
import 'package:finbedu/services/video_service.dart';

class VideoProvider with ChangeNotifier {
  final VideoService _service = VideoService();
  List<Video> videos = [];

  Future<void> fetchVideos(int sectionId) async {
    videos = await _service.fetchVideos(sectionId);
    notifyListeners();
  }

  Future<void> addVideo({
    required int sectionId,
    required String title,
    required String url,
    required String duration,
  }) async {
    await _service.addVideo(sectionId, title, url, duration);
    await fetchVideos(sectionId);
  }
}