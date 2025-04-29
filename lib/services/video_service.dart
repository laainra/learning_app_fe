import 'dart:convert';
import 'package:finbedu/models/video_model.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VideoService {
  final storage = const FlutterSecureStorage();
  Future<List<Video>> fetchVideos(int sectionId) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/videos?section_id=$sectionId',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Video.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch videos');
    }
  }

  Future<void> addVideo(
    int sectionId,
    String title,
    String url,
    String duration,
  ) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token is null. Please log in again.');
      }

      final apiUrl = Uri.parse(
        '${ApiConstants.baseUrl}/videos',
      );
      print('Sending request to: $apiUrl');
      print('Token: $token');
      print('Title: $title');
      print('URL: $url'); 
      print('Duration: $duration');

      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
          body: jsonEncode({
        'title': title,
        'url': url,
        'duration': duration,
        'section_id': sectionId, // Kirim section_id di body
      }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 201) {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Failed to add video';
        throw Exception('Failed to add video: $errorMessage');
      }
    } catch (e) {
      print('Error adding video: $e');
      rethrow; // Rethrow the error to be handled by the caller
    }
  }
}
