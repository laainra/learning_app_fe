import 'package:flutter/material.dart';
import 'package:finbedu/models/video_model.dart';
import 'package:finbedu/services/video_service.dart';

class VideoProvider with ChangeNotifier {
  final VideoService _service = VideoService();
  List<Video> videos = [];

  Future<List<Video>> fetchVideos(int sectionId) async {
    try {
      // Memanggil service untuk mendapatkan daftar video berdasarkan sectionId
      videos = await _service.fetchVideos(sectionId);
      notifyListeners();
      return videos; // Mengembalikan daftar video yang diperoleh
    } catch (e) {
      print('Error fetching videos: $e');
      return []; // Jika ada error, mengembalikan daftar kosong
    }
  }

  Future<void> addVideo({
    required int sectionId,
    required String title,
    required String url,
    required String duration,
  }) async {
    try {
      await _service.addVideo(sectionId, title, url, duration);
      print('Video added successfully');
      notifyListeners();
    } catch (e) {
      print('Error adding video: $e');
    }
  }

  Future<void> updateVideo(
    int videoId,
    String title,
    String url,
    String duration,
  ) async {
    await _service.updateVideo(videoId, title, url, duration);
    notifyListeners();
  }

  Future<void> deleteVideo(int videoId) async {
    await _service.deleteVideo(videoId);
    notifyListeners();
  }
}
